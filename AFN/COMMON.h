//
//  COMMON.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/8.
//  Copyright © 2016年 304. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**获取屏幕的宽度NSInteger*/
#define CurrentScreenWidth [UIScreen mainScreen].bounds.size.width
/**获取屏幕的高度NSInteger*/
#define CurrentScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 *  数据NSUserDefaults保存到本地
 */
static inline void saveValueForKey(NSString *value,NSString *key){
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    
    //强行保存
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  数据根据科研值NSUserDefaults从本地取出
 */
static inline id restoreValueForKey(NSString *key){
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
/**
 *  返回当前图片的类型字符串
 *
 *  @param img 当前的图片
 *
 *  @return 返回值
 */
static inline NSString *returnImagesType(id img){
    NSData *d = nil;
    if ([img isKindOfClass:[UIImage class]]) {
        d = UIImagePNGRepresentation(img);
    }
    if ([img isKindOfClass:[NSData class]]) {
        d = UIImagePNGRepresentation(img);
    }
    if (d != nil) {
        return @"png";
    }
    return @"ipg";
}