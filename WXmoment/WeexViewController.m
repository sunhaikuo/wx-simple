
#import "WeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface WeexViewController ()<UITableViewDataSource,UITableViewDelegate>
//WXSDKInstance 属性
@property(nonatomic, strong) WXSDKInstance *instance;
// weex 视图
@property(nonatomic, strong) UIView *weexView;
// URL属性(用于指定加载js的URL, 一般申明在接口中)
@property(nonatomic, strong) NSURL *url;


// header 部分
@property(nonatomic,weak)UITableView * tab;
@property(nonatomic, strong) UITableView *TableView;

@end

@implementation WeexViewController {
    NSURL *jsUrl;
}

- (instancetype)initWithJs:(NSString *)name {
    self = [super init];
    if (self) {
        NSString *filePath = [name stringByAppendingString:@".js"];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        NSString *path = [documentPath stringByAppendingPathComponent:filePath];
        path = [NSString stringWithFormat:@"file://%@", path];

//        NSString *path=[NSString stringWithFormat:@"file://%@//%@",[NSBundle mainBundle].bundlePath,filePath];
        NSLog(@"-----path:%@", path);
        jsUrl = [NSURL URLWithString:path];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Weex";
//    [self addTabelView];

    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
//    适配有tabbar的情况
//    _instance.frame = CGRectMake(
//            self.view.frame.origin.x,
//            self.view.frame.origin.y + 64,
//            self.view.frame.size.width,
//            self.view.frame.size.height - 64);
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    _instance.onFailed = ^(NSError *error) {
        NSLog(@"加载错误");
    };

    _instance.renderFinish = ^(UIView *view) {
        NSLog(@"加载完成");
    };
    if (!jsUrl) {
        return;
    }
    [_instance renderWithURL:jsUrl];
    self.view.backgroundColor = [UIColor blackColor];
}

// 创建tableView
//- (void)addTabelView {
//// UITableViewStyleGrouped 表示viewForHeaderInSection 头部跟随一起滚动, UITableViewStylePlain 则固定
//    self.TableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.TableView.delegate = self;
//    self.TableView.dataSource = self;
//    [self.view addSubview:self.TableView];
//    [self.TableView registerClass:[WXmomentCell class] forCellReuseIdentifier:IDD];
//    self.TableView.backgroundView = nil;
//    self.TableView.backgroundColor = [UIColor whiteColor];
//    self.tab = self.TableView;
//}

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
