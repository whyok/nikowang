//
//  HMCycleView.m
//  01-图片轮播器
//
//  Created by heima on 16/7/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "HMCycleCell.h"
#import "HMCycleFlowLayout.h"
#import "HMCycleView.h"
#import "Masonry.h"
#import "UIColor+Addition.h"

#define kSeed 99

// 标示符
static NSString* cellid = @"cycle_cell";

@interface HMCycleView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView* collectionView;

@property (nonatomic, weak) UIPageControl* pageControl;

@property (nonatomic, strong) NSTimer* timer;

@end

@implementation HMCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupUI];
}

- (void)setupUI
{

    // 子控件
    HMCycleFlowLayout* layout = [[HMCycleFlowLayout alloc] init];
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    // 设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册单元格
    [collectionView registerClass:[HMCycleCell class] forCellWithReuseIdentifier:cellid];

    // 设置分页
    collectionView.pagingEnabled = YES;
    // 取消弹性效果
    collectionView.bounces = NO;
    // 取消指示器
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    // 添加到视图上
    [self addSubview:collectionView];

    UIPageControl* pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    pageControl.pageIndicatorTintColor = [UIColor blueColor];
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];

    // 自动布局
    [collectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.offset(0);
    }];

    [pageControl mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self);
        make.bottom.offset(0);
    }];

    self.collectionView = collectionView;
    self.pageControl = pageControl;
}

// 当图片数据传过来的时候一定会调用这个方法
- (void)setImageURLs:(NSArray*)imageURLs
{
    _imageURLs = imageURLs;

    // 刷新数据(重新加载数据源)
    [self.collectionView reloadData];

    // 告诉系统 立刻计算某个view的layout
    [self.collectionView layoutIfNeeded];
    // 方法1 offset
    //    self.collectionView.contentOffset = CGPointMake(imageURLs.count * kSeed * self.collectionView.bounds.size.width, 0);
    // 方法2 scrollToItemAtIndexPath
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:imageURLs.count * kSeed inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置pageControl的总页数
    self.pageControl.numberOfPages = imageURLs.count;

    // 设置一个时钟装置 创建一个计时器对象 把这个计时器添加到运行循环当中
    // 这一句话的本质 实际上就是下面两句话的缩写
    //    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];

    // 仅仅是创建了一个计时器对象
    NSTimer* timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    self.timer = timer;

    // 运行循环
    // 运行循环
    // 1. 默认模式 -  NSDefaultRunLoopMode
    // 在触摸其他控件的时候,计时器会停止(苹果为了流畅,所以才这么设计)
    // 2. 滚动模式+默认模式 -  NSRunLoopCommonModes
    // 不管在触摸其他任何控件时,计时器都会一直走
}

- (void)updateTimer
{
    NSLog(@"updateTimer");

    // 获取当前的位置
    // 这个方法 表示 获取当前collectionView多有可见的cell的位置(indexPath)
    // 因为就我们这个轮播器而言,当前可见的cell只有一个,所以可以根据last 或者 first 或者 [0] 来获取
    NSIndexPath* indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;

    //    indexPath.item = indexPath.item + 1;

    // 根据当前页 创建下一页的位置
    NSIndexPath* nextPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];

    [self.collectionView scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    // 当拖拽的时候 设置下次触发的时间 为 4001年!!!
    self.timer.fireDate = [NSDate distantFuture];
}

// 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

// 滚动动画结束的时候调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView
{

    // 手动调用减速完成的方法
    [self scrollViewDidEndDecelerating:self.collectionView];

    //    NSLog(@"scrollViewDidEndScrollingAnimation");
}

// 监听手动减速完成(停止滚动)
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{

    NSLog(@"scrollViewDidEndDecelerating");

    // x 偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 计算页数
    NSInteger page = offsetX / self.bounds.size.width;

    NSLog(@"第 %zd 页", page);

    // 获取某一组有多少行
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];

    if (page == 0) { // 第一页
        self.collectionView.contentOffset = CGPointMake(offsetX + self.imageURLs.count * kSeed * self.bounds.size.width, 0);
    }
    else if (page == itemsCount - 1) { // 最后一页
        self.collectionView.contentOffset = CGPointMake(offsetX - self.imageURLs.count * kSeed * self.bounds.size.width, 0);
    }
}

// 正在滚动(设置分页)
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    // x 偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 加上.5的基础上 计算页数
    CGFloat page = offsetX / self.bounds.size.width + 0.5;

    if (self.imageURLs.count) {
        // 强转成整数进行取余的计算
        page = (NSInteger)page % self.imageURLs.count;
    }

    // 设置当前的页码
    self.pageControl.currentPage = page;
}

// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURLs.count * 2 * kSeed;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    HMCycleCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];

    //    NSLog(@"%@", cell);

    // 把需要让cell显示的url传递过去
    cell.imageURL = self.imageURLs[indexPath.item % self.imageURLs.count];

    return cell;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}

// 如果计时器在运行循环中 根本不会调用dealloc方法
- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
