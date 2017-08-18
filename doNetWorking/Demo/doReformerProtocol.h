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
@protocol doAPIManagerDataReformer <NSObject>
@required
- (id)manager:(doBaseAPIManager *)manager reformData:(NSDictionary *)data;
//用于获取服务器返回的错误信息
@optional
-(id)manager:(doBaseAPIManager *)manager failedReform:(NSDictionary *)data;
@end
#endif /* doReformerProtocol_h */
