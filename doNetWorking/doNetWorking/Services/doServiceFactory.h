//
//  doServiceFactory.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/7.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doService.h"

@protocol doServiceFactoryDataSource <NSObject>
/*
 * key为service的Identifier
 * value为service的Class的字符串
 */
- (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory;
@end

@interface doServiceFactory : NSObject

@property (nonatomic,weak) id<doServiceFactoryDataSource> dataSource;
+ (instancetype)sharedInstance;
- (doService<doServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;
@end
