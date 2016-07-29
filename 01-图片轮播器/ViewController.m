//
//  ViewController.m
//  01-图片轮播器
//
//  Created by heima on 16/7/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "HMCycleView.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) HMCycleView* cycleView;
@property (weak, nonatomic) IBOutlet HMCycleView* cycle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 这句话的含义, 不在导航控制器的环境下 增加 inset
    self.automaticallyAdjustsScrollViewInsets = NO;

    HMCycleView* cycleView = [[HMCycleView alloc] initWithFrame:CGRectMake(0, 20, 375, 200)];
    cycleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:cycleView];
    self.cycleView = cycleView;

    self.cycleView.imageURLs = [self loadImageURLs];

    // btn
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [self.view addSubview:btn];

    [btn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, 150, 300) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tableView];
}

// 显示数据
- (void)show
{
}

- (NSArray*)loadImageURLs
{
    NSMutableArray* array = [NSMutableArray array];

    for (int i = 0; i < 3; i++) {
        NSString* imageName = [NSString stringWithFormat:@"Home_Scroll_0%d.jpg", i + 1];

        // 获取图片的url
        NSURL* url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];

        [array addObject:url];
    }

    return array.copy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
