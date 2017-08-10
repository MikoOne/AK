//
//  doHttpEngine.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doHttpEngine.h"
#import <AFNetworking.h>
#import "doRequestGenerator.h"

@interface doHttpEngine ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic,strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation doHttpEngine
+ (instancetype)sharedInstance
{
    static doHttpEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[doHttpEngine alloc]init];
    });
    return engine;
}
- (NSInteger)getWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;
{
    NSURLRequest *request = [[doRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self apiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}
- (NSInteger)postWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;

{
    NSURLRequest *request = [[doRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self apiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}


- (NSInteger)deleteWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;
{
    NSURLRequest *request = [[doRequestGenerator sharedInstance] generateDeleteRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self apiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)putWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;
{
    NSURLRequest *request = [[doRequestGenerator sharedInstance] generatePutRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self apiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}
@end
