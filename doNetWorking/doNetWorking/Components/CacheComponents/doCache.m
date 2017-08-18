//
//  doCache.m
//  doNetWorking
//
//  Created by yangzhen on 2017/8/15.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doCache.h"
#import "doCacheObject.h"
#import "doNetworkingConfigurationManager.h"

@interface doCache()
@property (nonatomic,strong) NSCache *cache;
@end

@implementation doCache

- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc]init];
        _cache.countLimit = [doNetworkingConfigurationManager sharedInstance].cacheCountLimit;
    }
    return _cache;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t oncetoken;
    static doCache *sharedInstance;
    dispatch_once(&oncetoken, ^{
        sharedInstance = [[doCache alloc]init];
    });
    return sharedInstance;
}
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName]];
}
- (void)saveCacheWithData:(NSData *)cachedData serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName]];
}
- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key
{
    doCacheObject *cachedObj = [self.cache objectForKey:key];
    if (cachedObj.isEmpty || cachedObj.isEmpty) {
        return nil;
    }else{
        return cachedObj.content;
    }
}
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    doCacheObject *cachedObj = [self.cache objectForKey:key];
    if (cachedObj == nil) {
        cachedObj = [[doCacheObject alloc]init];
    }
    [cachedObj updateContent:cachedData];
    [self.cache setObject:cachedObj forKey:key];
}
- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}
- (void)clean
{
    [self.cache removeAllObjects];
}
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString*)methodName
{
    return [NSString stringWithFormat:@"%@%@", serviceIdentifier, methodName];
}
@end




