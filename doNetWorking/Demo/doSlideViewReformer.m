//
//  doSlideViewReformer.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doSlideViewReformer.h"
#import <UIKit/UIKit.h>

NSString * const kPropertyListDataKeyID = @"kPropertyListDataKeyID";
NSString * const kPropertyListDataKeyName = @"kPropertyListDataKeyName";
NSString * const kPropertyListDataKeyTitle = @"kPropertyListDataKeyTitle";
NSString * const kPropertyListDataKeyImage = @"kPropertyListDataKeyImage";

@implementation doSlideViewReformer
-(id)manager:(doBaseAPIManager *)manager reformData:(NSDictionary *)data
{
    NSDictionary *resultData;
    resultData = @{
                   kPropertyListDataKeyID:data[@"id"],
                   kPropertyListDataKeyName:data[@"name"],
                   kPropertyListDataKeyTitle:data[@"title"],
                   kPropertyListDataKeyImage:[UIImage imageNamed:data[@"imageUrl"]]
                   };
    return resultData;
}
- (id)manager:(doBaseAPIManager *)manager failedReform:(NSDictionary *)data
{
    return nil;
}
//具体view对应的reformer
- (NSDictionary *)reformDataWithManager:(doBaseAPIManager *)manager
{
    //需要什么数据过滤什么数据
    return @{@"title":@"test",@"icon":@"one.png"};
}
@end
