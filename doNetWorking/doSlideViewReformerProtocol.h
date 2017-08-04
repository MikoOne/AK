//
//  doSlideViewReformerProtocol.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#ifndef doSlideViewReformerProtocol_h
#define doSlideViewReformerProtocol_h
@class doBaseAPIManager;
@protocol doSlideViewReformerProtocol <NSObject>

@optional
- (NSDictionary *)reformDataWithManager:(doBaseAPIManager *)manager;
@end

#endif /* doSlideViewReformerProtocol_h */
