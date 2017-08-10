//
//  doService.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/7.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doURLResponse.h"

@protocol doServiceProtocol <NSObject>
@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

//@property (nonatomic, readonly) NSString *onlinePublicKey;
//@property (nonatomic, readonly) NSString *offlinePublicKey;
//
//@property (nonatomic, readonly) NSString *onlinePrivateKey;
//@property (nonatomic, readonly) NSString *offlinePrivateKey;
@optional
//为某些Service需要拼凑额外字段到URL处
- (NSDictionary *)extraParmas;

//为某些Service需要拼凑额外的HTTPToken，如accessToken
- (NSDictionary *)extraHttpHeadParmasWithMethodName:(NSString *)method;

- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method;

//- (void)successedOnCallingAPI:(CTURLResponse *)response;

//提供拦截器集中处理Service错误问题，比如token失效要抛通知等
- (BOOL)shouldCallBackByFailedOnCallingAPI:(doURLResponse *)response;

@end


@interface doService : NSObject
@property (nonatomic, weak, readonly) id<doServiceProtocol> child;

/*
 * 因为考虑到每家公司的拼凑逻辑都有或多或少不同，
 * 如有的公司为http://abc.com/v2/api/login或者http://v2.abc.com/api/login
 * 所以将默认的方式，有versioin时，则为http://abc.com/v2/api/login
 * 否则，则为http://abc.com/v2/api/login
 */
- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method;

@end
