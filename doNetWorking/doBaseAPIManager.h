//
//  doBaseAPIManager.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doSlideViewReformerProtocol.h"


@class doBaseAPIManager;
//api回调
@protocol doAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(doBaseAPIManager *)manager;
- (void)managerCallAPIDidFailed:(doBaseAPIManager *)manager;

@end

@interface doBaseAPIManager : NSObject
- (NSDictionary *)fetchDataWithReformer:(id<doSlideViewReformerProtocol>)reformer;
@end
