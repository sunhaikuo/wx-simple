//
//  ViewController.m
//  WXmoment
//
//  Created by 孙海阔 on 18/2/14.
//  Copyright © 2018年 DW. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface ViewController ()
    //WXSDKInstance 属性
    @property(nonatomic, strong) WXSDKInstance *instance;
    // weex 视图
    @property(nonatomic, strong)UIView *weexView;
    // URL属性(用于指定加载js的URL, 一般申明在接口中)
    @property (nonatomic, strong) NSURL *url;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建WXSDKInstance对象
    _instance = [[WXSDKInstance alloc] init];
    // 设置weexInstance所在的控制器
    _instance.viewController = self;
    //设置weexInstance的frame
    _instance.frame = self.view.frame;
    //设置weexInstance用于渲染的`js`的URL路径(后面说明)
    [_instance renderWithURL:self.url options:@{@"bundleUrl":[self.url absoluteString]} data:nil];
    //为了避免循环引用声明一个弱指针的`self`
    __weak typeof(self) weakSelf = self;
    //设置weexInstance创建完毕回调
    _instance.onCreate = ^(UIView *view) {
        weakSelf.weexView = view;
        [weakSelf.weexView removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    // 设置`weexInstance`出错的回调
    _instance.onFailed = ^(NSError *error) {
        //process failure
        NSLog(@"处理失败:%@",error);
    };
    //设置渲染完成的回调
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        NSLog(@"渲染完成");
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //  销毁WXSDKInstance实例
    [self.instance destroyInstance];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
