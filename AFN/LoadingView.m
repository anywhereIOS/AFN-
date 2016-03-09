//
//  LoadingView.m
//  项目框架封装
//
//  Created by 王涛 on 16/3/9.
//  Copyright © 2016年 304. All rights reserved.
//

#import "LoadingView.h"
@interface LoadingView()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *nowView;
@property (nonatomic,strong) UIImageView *bottomImageView;
@end
@implementation LoadingView
+(LoadingView *)shareLoadingView
{
    static LoadingView *loadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadView = [[LoadingView alloc] init];
    });
    return loadView;
}
-(instancetype)init
{
    if (self = [super init]) {
        [self creatImageAnimation];
    }
    return self;
}
-(void)creatImageAnimation
{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight - 64)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.alpha = 1;
    
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.bounds = CGRectMake(0, 0, 250, 250);
//    self.bgImageView.backgroundColor = [UIColor redColor];
    self.bgImageView.userInteractionEnabled = YES;
    self.bgImageView.center = self.bgView.center;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i<= 39; i++) {
        NSString *name = [NSString stringWithFormat:@"page_loading_%d",i];
        UIImage *image = [UIImage imageNamed:name];
        [imageArray addObject:image];
    }
    
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CurrentScreenWidth-257.0/2)/2.0, self.bgImageView.frame.origin.y+self.bgImageView.frame.size.height - 5, 257/2.0, 23/2.0)];
    self.bottomImageView.image = [UIImage imageNamed:@"bottomProgress"];
//    self.bottomImageView.backgroundColor = [UIColor redColor];
    self.bgImageView.animationImages = imageArray;
    self.bgImageView.animationDuration = 4.5;
    self.bgImageView.animationRepeatCount = 99999;
    [self.bgView addSubview:self.bgImageView];
    if ([self.bgImageView isAnimating]) {
        [self.bgImageView stopAnimating];
    }
}
-(void)starAnimationInView:(UIView *)view
{
    if ([self.bgImageView isAnimating]) {
        [self.bgImageView stopAnimating];
    }
    self.nowView = view;
    [self.bgImageView startAnimating];
    [self.nowView addSubview:self.bgView];
    [self.nowView bringSubviewToFront:self.bgView];
    [self.nowView addSubview:self.bottomImageView];
}
-(void)stopAnimation
{
    [self.bottomImageView removeFromSuperview];
    [self.bgImageView stopAnimating];
    [self.bgView removeFromSuperview];
    [self.nowView sendSubviewToBack:self.bgView];
}
@end
