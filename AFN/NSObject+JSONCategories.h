//
//  NSObject+JSONCategories.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/6.
//  Copyright © 2016年 304. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONCategories)
/**
 *  将NSDictionary或NSArray转化为JSON串
 *
 *  @param theObject NSDictionary或NSArray
 *
 *  @return json字符串  JSONString
 */
-(NSString *)toJsonString;
@end
