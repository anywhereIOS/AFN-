//
//  LoadingView.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/9.
//  Copyright © 2016年 304. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingView : NSObject
+(LoadingView *)shareLoadingView;
-(void)starAnimationInView:(UIView *)view;
-(void)stopAnimation;
@end
