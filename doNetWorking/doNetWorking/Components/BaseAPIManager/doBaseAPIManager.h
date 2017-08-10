//
//  doBaseAPIManager.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doReformerProtocol.h"

typedef NS_ENUM (NSUInteger, doHttpRequestType){
    doHttpRequestTypeGet,
    doHttpRequestTypePost,
    doHttpRequestTypePut,
    doHttpRequestTypeDelete
};
@class doBaseAPIManager;
//api回调
@protocol doAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(doBaseAPIManager *)manager;
- (void)managerCallAPIDidFailed:(doBaseAPIManager *)manager;

@end
//调用API所需要的数据
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

@interface doBaseAPIManager : NSObject
@property (nonatomic,weak) id<doAPIManagerCallBackDelegate> delegate;
@property (nonatomic,weak) id<doAPIManagerParamSource> paramSource;
@property (nonatomic,weak) id<doAPIManagerValidator> validator;
@property (nonatomic,weak) id<doAPIManager> child;


- (NSDictionary *)fetchDataWithReformer:(id<doReformerProtocol>)reformer;
@end
