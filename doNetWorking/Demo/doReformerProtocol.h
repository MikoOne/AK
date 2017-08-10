//
//  doReformerProtocol.h
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/5.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#ifndef doReformerProtocol_h
#define doReformerProtocol_h

@class doBaseAPIManager;
@protocol doReformerProtocol <NSObject>

@optional

- (NSDictionary *)reformDataWithManager:(doBaseAPIManager *)manager;
@end
#endif /* doReformerProtocol_h */
