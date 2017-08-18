//
//  doBaseAPIManager.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doReformerProtocol.h"
#import "doURLResponse.h"

static NSString * const kdoAPIBaseManagerRequestID = @"kdoAPIBaseManagerRequestID";

typedef NS_ENUM (NSUInteger, doHttpRequestType){
    doHttpRequestTypeGet,
    doHttpRequestTypePost,
    doHttpRequestTypePut,
    doHttpRequestTypeDelete
};

typedef NS_ENUM (NSUInteger, doAPIManagerErrorType){
    doAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    doAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    doAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    doAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    doAPIManagerErrorTypeTimeout,       //请求超时。doHttpEngine设置的是20秒超时，具体超时时间的设置请自己去看doHttpEngine的相关代码。
    doAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

@class doBaseAPIManager;
//api回调
@protocol doAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(doBaseAPIManager *)manager;
- (void)managerCallAPIDidFailed:(doBaseAPIManager *)manager;

@end
//调用API所需要的参数
@protocol doAPIManagerParamSource <NSObject>

@required
- (NSDictionary *)paramsForApi:(doBaseAPIManager *)manager;
@end

//验证器，用于API返回数据或者请求参数验证是否正确
@protocol doAPIManagerValidator <NSObject>

@required
- (BOOL)manager:(doBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(doBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end
//派生类需要遵守的协议
@protocol doAPIManager <NSObject>
@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (doHttpRequestType)requestType;
- (BOOL)shouldCache;
@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;
@end
//拦截器
@protocol doAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(doBaseAPIManager *)manager willPerformSuccessWithResponse:(doURLResponse *)response;
- (void)manager:(doBaseAPIManager *)manager didPerformSuccessWithResponse:(doURLResponse *)response;

- (BOOL)manager:(doBaseAPIManager *)manager willPerformFailWithResponse:(doURLResponse *)response;
- (void)manager:(doBaseAPIManager *)manager didPerformFailWithResponse:(doURLResponse *)response;

- (BOOL)manager:(doBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(doBaseAPIManager *)manager didCallAPIWithParams:(NSDictionary *)params;
@end



@interface doBaseAPIManager : NSObject
@property (nonatomic,weak) id<doAPIManagerCallBackDelegate> delegate;
@property (nonatomic,weak) id<doAPIManagerParamSource> paramSource;
@property (nonatomic,weak) id<doAPIManagerValidator> validator;
@property (nonatomic,weak) NSObject<doAPIManager> *child;
@property (nonatomic,weak) id<doAPIManagerInterceptor> interceptor;
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) doAPIManagerErrorType errorType;
@property (nonatomic, strong) doURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id)fetchDataWithReformer:(id<doAPIManagerDataReformer>)reformer;

//来取从服务器获得的错误信息
- (id)fetchFailedRequstMsg:(id<doAPIManagerDataReformer>)reformer;

- (NSInteger)loadData;//返回requestID;

- (void)cancelAllRequest;
- (void)calcelRequestWithRequestId:(NSInteger)requestID;

- (BOOL)willPerformSuccessWithResponse:(doURLResponse *)response;
- (void)didPerformSuccessWithResponse:(doURLResponse *)response;

- (BOOL)willPerformFailWithResponse:(doURLResponse *)response;
- (void)didPerformFailWithResponse:(doURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)didCallAPIWithParams:(NSDictionary *)params;

- (void)successOnCallingAPI:(doURLResponse *)response;
- (void)failedOnCallingAPI:(doURLResponse *)response withErrorType:(doAPIManagerErrorType)errorType;
@end
