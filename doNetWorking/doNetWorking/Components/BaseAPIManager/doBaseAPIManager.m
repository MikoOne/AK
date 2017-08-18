//
//  doBaseAPIManager.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doBaseAPIManager.h"
#import "doCache.h"
#import "doHttpEngine.h"
#import "doServiceFactory.h"
#import "doNetworkingConfigurationManager.h"


#define AXCallAPI(METHOD_TYPE,REQUEST_ID)\
{\
__weak typeof(self) weakSelf = self;\
REQUEST_ID = [[doHttpEngine sharedInstance] METHOD_TYPE##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(doURLResponse *response) {\
__strong typeof(weakSelf) strongSelf = weakSelf;                                        \
[strongSelf successedOnCallingAPI:response];\
} fail:^(doURLResponse *response) {\
__strong typeof(weakSelf) strongSelf = weakSelf;\
[strongSelf failedOnCallingAPI:response withErrorType:doAPIManagerErrorTypeDefault];\
}];\
[self.requestIdList addObject:@(REQUEST_ID)];        \
}

@interface doBaseAPIManager()
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) doAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) doCache *cache;

@end


@implementation doBaseAPIManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = doAPIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(doAPIManager)]) {
            self.child = (id <doAPIManager>)self;
        } else {
            self.child = (id <doAPIManager>)self;
            NSException *exception = [[NSException alloc] initWithName:@"doAPIBaseManager提示" reason:[NSString stringWithFormat:@"%@没有遵循doAPIManager协议",self.child] userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[doHttpEngine sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
//    [self removeRequestIdWithRequestID:requestID];
    [[doHttpEngine sharedInstance] cancelRequestWithRequestID:@(requestID)];
}


//APImanager中实现方法
- (id)fetchDataWithReformer:(id<doAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}
- (id)fetchFailedRequstMsg:(id<doAPIManagerDataReformer>)reformer {
    
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:failedReform:)]) {
        
        resultData = [reformer manager:self failedReform:self.fetchedRawData];
    } else
        resultData = [self.fetchedRawData mutableCopy];
    return resultData;
}

#pragma mark - calling api
- (NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}
- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            if ([self.child shouldLoadFromNative]) {
                [self loadDataFromNative];
            }
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                self.isLoading = YES;
                switch (self.child.requestType)
                {
                    case doHttpRequestTypeGet:
                        AXCallAPI(get, requestId);
                        break;
                    case doHttpRequestTypePost:
                        AXCallAPI(post, requestId);
                        break;
                    case doHttpRequestTypePut:
                        AXCallAPI(put, requestId);
                        break;
                    case doHttpRequestTypeDelete:
                        AXCallAPI(delete, requestId);
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kdoAPIBaseManagerRequestID] = @(requestId);
                [self didCallAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:doAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:doAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(doURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    
    if ([self.child shouldLoadFromNative]) {
        if (response.isCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
        }
    }
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        
        if ([self willPerformSuccessWithResponse:response]) {
            if ([self.child shouldLoadFromNative]) {
                if (response.isCache == YES) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
            } else {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        [self didPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:doAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(doURLResponse *)response withErrorType:(doAPIManagerErrorType)errorType
{
    NSString *serviceIdentifier = self.child.serviceType;
    doService *service = [[doServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    self.isLoading = NO;
    self.response = response;
    BOOL needCallBack = YES;
    
    if ([service.child respondsToSelector:@selector(shouldCallBackByFailedOnCallingAPI:)]) {
        needCallBack = [service.child shouldCallBackByFailedOnCallingAPI:response];
    }
    
    //由service决定是否结束回调
    if (!needCallBack) {
        return;
    }
    
    //继续错误的处理
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    if ([self willPerformFailWithResponse:response]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    [self didPerformFailWithResponse:response];
}

- (BOOL)willPerformSuccessWithResponse:(doURLResponse *)response
{
    BOOL result = YES;
    self.errorType = doAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:willPerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self willPerformSuccessWithResponse:response];
    }
    return result;
}
- (void)didPerformSuccessWithResponse:(doURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:didPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self didPerformSuccessWithResponse:response];
    }
}

- (BOOL)willPerformFailWithResponse:(doURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:willPerformFailWithResponse:)]) {
        result = [self.interceptor manager:self willPerformFailWithResponse:response];
    }
    return result;
}
- (void)didPerformFailWithResponse:(doURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:didPerformFailWithResponse:)]) {
        [self.interceptor manager:self didPerformFailWithResponse:response];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}
- (void)didCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:didCallAPIWithParams:)]) {
        [self.interceptor manager:self didCallAPIWithParams:params];
    }
}
#pragma mark - method for child
- (void)cleanData
{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = doAPIManagerErrorTypeDefault;
}
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}
- (BOOL)shouldCache
{
    return [doNetworkingConfigurationManager sharedInstance].shouldCache;
}
#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        doURLResponse *response = [[doURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [strongSelf successedOnCallingAPI:response];
    });
    return YES;
}
- (void)loadDataFromNative
{
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:self.child.methodName] options:0 error:NULL];
    
    if (result) {
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            doURLResponse *response = [[doURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL]];
            [strongSelf successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}
#pragma mark - getters and setters
- (doCache *)cache
{
    if (_cache == nil) {
        _cache = [doCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [doNetworkingConfigurationManager sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = doAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}
@end


















