//
//  doTestAPIManager.m
//  doNetWorking
//
//  Created by yangzhen on 2017/8/18.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doTestAPIManager.h"

@interface doTestAPIManager()<doAPIManagerValidator>


@end

@implementation doTestAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}
#pragma mark - doAPIManager 子类遵守协议
- (NSString *)methodName
{
    return @"";
}
- (doHttpRequestType)requestType
{
    return doHttpRequestTypeGet;
}
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    return @{@"":@""};
}
- (BOOL)shouldCache
{
    return YES;
}

#pragma mark - doAPIManagerValidator
//参数验证
- (BOOL)manager:(doBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}
//返回值验证,脏数据处理
- (BOOL)manager:(doBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}
@end
