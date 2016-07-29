//
//  HMCycleCell.m
//  01-图片轮播器
//
//  Created by heima on 16/7/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "HMCycleCell.h"
#import "Masonry.h"

@interface HMCycleCell ()

@property (nonatomic, weak) UIImageView* imageView;

@end

@implementation HMCycleCell

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

// set数据的方法
- (void)setImageURL:(NSURL*)imageURL
{
    _imageURL = imageURL;

    // --------把url转成iamge
    // url ->  data
    NSData* data = [NSData dataWithContentsOfURL:imageURL];
    // data -> image
    UIImage* image = [UIImage imageWithData:data];
    // --------把url转成iamge

    // 把数据放在空间上
    self.imageView.image = image;
}

- (void)setupUI
{
    // 创建imageView显示图片
    UIImageView* imageView = [[UIImageView alloc] init];
    // 填充模式
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    // 把多余的部分剪切掉
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];

    // 自动布局
    [imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.offset(0);
    }];

    self.imageView = imageView;
}

@end
