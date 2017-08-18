//
//  doCacheObject.m
//  doNetWorking
//
//  Created by yangzhen on 2017/8/15.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doCacheObject.h"
#import "doNetworkingConfigurationManager.h"

@interface doCacheObject()
@property (nonatomic,copy,readwrite) NSData * content;
@property (nonatomic,copy,readwrite) NSDate *lastUpdateTime;
@end

@implementation doCacheObject
- (BOOL)isEmpty
{
    return self.content == nil;
}

- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > [doNetworkingConfigurationManager sharedInstance].cacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content
{
    _content = content;
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}
- (instancetype)initWithContent:(NSData *)content
{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}
- (void)updateContent:(NSData *)content
{
    self.content = content;
}
@end
