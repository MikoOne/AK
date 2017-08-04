//
//  ViewController.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/4.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "ViewController.h"
#import "doBaseAPIManager.h"
#import "doSlideView.h"

@interface ViewController ()<doAPIManagerCallBackDelegate>
{
    doSlideView *_slideView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _slideView = [doSlideView new];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)managerCallAPIDidSuccess:(doBaseAPIManager *)manager
{
    [_slideView renderViewWithData:[manager fetchDataWithReformer:_slideView.reformer]];
}

- (void)managerCallAPIDidFailed:(doBaseAPIManager *)manager
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
