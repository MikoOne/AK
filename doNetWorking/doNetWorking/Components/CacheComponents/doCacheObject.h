//
//  doCacheObject.h
//  doNetWorking
//
//  Created by yangzhen on 2017/8/15.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface doCacheObject : NSObject
@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;
@end
