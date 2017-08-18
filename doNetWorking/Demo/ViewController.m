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
#import "doTestAPIManager.h"

@interface ViewController ()<doAPIManagerCallBackDelegate,doAPIManagerParamSource>
{
    doSlideView *_slideView;
}
@property (nonatomic,strong) doTestAPIManager *testMgr;
- (IBAction)loadRequest:(id)sender;

@end
// vc中
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _slideView = [doSlideView new];
}

#pragma mark - doAPIManagerParamSource
- (NSDictionary *)paramsForApi:(doBaseAPIManager *)manager
{
    NSDictionary *params = @{};
    return params;
}
#pragma mark - doAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(doBaseAPIManager *)manager
{
    //_slideView.reformer 是一个具体的对象，负责数据转化逻辑
    [_slideView renderViewWithData:[manager fetchDataWithReformer:_slideView.reformer]];
}

- (void)managerCallAPIDidFailed:(doBaseAPIManager *)manager
{
    
}
#pragma mark - getter
- (doTestAPIManager *)testMgr
{
    if (_testMgr == nil) {
        _testMgr = [[doTestAPIManager alloc]init];
        _testMgr.delegate = self;
        _testMgr.paramSource = self;
    }
    return _testMgr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loadRequest:(id)sender {
    [self.testMgr loadData];
}
@end
