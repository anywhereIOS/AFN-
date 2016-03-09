//
//  NSFileManager+PathSize.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/7.
//  Copyright © 2016年 304. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (PathSize)

/**计算文件下文件的总大小*/
+(double)fileSizeForDir:(NSString *)path;

/**判断是否文件的缓存是否超时*/
+(BOOL)isTimeout:(NSString *)path time:(NSTimeInterval)timeout;
@end
