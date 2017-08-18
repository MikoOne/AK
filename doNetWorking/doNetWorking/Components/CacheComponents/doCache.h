//
//  doCache.h
//  doNetWorking
//
//  Created by yangzhen on 2017/8/15.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface doCache : NSObject
+ (instancetype)sharedInstance;

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString*)methodName;



- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams;

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams;

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;



- (NSData *)fetchCachedDataWithKey:(NSString *)key;
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;
- (void)deleteCacheWithKey:(NSString *)key;
- (void)clean;
@end
