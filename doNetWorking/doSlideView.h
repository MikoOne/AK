//
//  doSlideView.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doSlideViewReformerProtocol.h"

@interface doSlideView : UIView
@property (nonatomic,strong) id<doSlideViewReformerProtocol> reformer;
- (void)renderViewWithData:(NSDictionary *)data;
@end
