//
//  doHttpEngine.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doURLResponse.h"

typedef void (^APICallback)(doURLResponse *response);

@interface doHttpEngine : NSObject
+ (instancetype)sharedInstance;
- (NSInteger)getWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;

- (NSInteger)postWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;


- (NSInteger)deleteWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;

- (NSInteger)putWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(APICallback)success fail:(APICallback) fail;

- (NSNumber *)apiWithRequest:(NSURLRequest *)request success:(APICallback)success fail:(APICallback) fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end
