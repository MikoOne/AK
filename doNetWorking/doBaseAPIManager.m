//
//  doBaseAPIManager.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doBaseAPIManager.h"

@implementation doBaseAPIManager

- (NSDictionary *)fetchDataWithReformer:(id<doSlideViewReformerProtocol>)reformer
{
    NSDictionary *allDataDict = @{};;
    if ([reformer respondsToSelector:@selector(reformDataWithManager:)]) {
        return  [reformer reformDataWithManager:self];
    }
    else{
        return allDataDict;
    }
}
@end
