//
//  doSlideView.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doReformerProtocol.h"

@interface doSlideView : UIView
@property (nonatomic,strong) id<doAPIManagerDataReformer> reformer;
- (void)renderViewWithData:(NSDictionary *)data;
@end
