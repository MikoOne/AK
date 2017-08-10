//
//  doService.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/7.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doService.h"

@interface doService()
@property (nonatomic, weak, readwrite) id<doServiceProtocol> child;
@end

@implementation doService
- (instancetype)init
{
    self = [super init];
    if (self) {
        if ( [self conformsToProtocol:@protocol(doServiceProtocol)]) {
            self.child = (id<doServiceProtocol>)self;
        }
    }
    return self;
}
- (NSString *)urlGeneratingRuleByMethodName:(NSString *)method
{
    NSString *urlString = nil;
    if (self.apiVersion.length != 0) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@", self.apiBaseUrl, self.apiVersion, method];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@", self.apiBaseUrl, method];
    }
    return urlString;
}
- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}
- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}
@end
