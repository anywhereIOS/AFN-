//
//  ViewController.m
//  AFN框架封装
//
//  Created by 王涛 on 16/3/9.
//  Copyright © 2016年 304. All rights reserved.
//

#import "ViewController.h"
#import "HttpRequest.h"
#import "LoadingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HttpRequest *requreset = [[HttpRequest alloc] init];
    NSDictionary *dict = [NSDictionary dictionary];
    [[LoadingView shareLoadingView] starAnimationInView:self.view];
    
    [requreset PostWithUrlString:@"www.baidu.com" parms:dict finished:^(NSData *requestData, NSDictionary *requestDict, NSError *error) {
        
        NSLog(@"%@",requestDict);
        
    } isCache:YES];
    
}
@end
