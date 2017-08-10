//
//  doServiceFactory.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/7.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doServiceFactory.h"
@interface doServiceFactory ()
@property (nonatomic, strong) NSMutableDictionary *serviceStorage;
@end

@implementation doServiceFactory
#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}
+ (instancetype)sharedInstance
{
    static doServiceFactory *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[doServiceFactory alloc]init];
    });
    return service;
}
- (doService<doServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    NSAssert(self.dataSource, @"必须提供dataSource绑定并实现servicesKindsOfServiceFactory方法，否则无法正常使用Service模块");
    
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}
#pragma mark - private methods
- (doService<doServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    NSAssert([self.dataSource respondsToSelector:@selector(servicesKindsOfServiceFactory)], @"请实现doServiceFactoryDataSource的servicesKindsOfServiceFactory方法");
    
    if ([[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier]) {
        NSString *classStr = [[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier];
        id service = [[NSClassFromString(classStr) alloc]init];
        NSAssert(service, [NSString stringWithFormat:@"无法创建service，请检查servicesKindsOfServiceFactory提供的数据是否正确"],service);
        NSAssert([service conformsToProtocol:@protocol(doServiceProtocol)], @"你提供的Service没有遵循doServiceProtocol");
        return service;
    }else {
        NSAssert(NO, @"servicesKindsOfServiceFactory中无法找不到相匹配identifier");
    }
    
    return nil;
}
@end
