//
//  NSObject+JSONCategories.m
//  项目框架封装
//
//  Created by 王涛 on 16/3/6.
//  Copyright © 2016年 304. All rights reserved.
//

#import "NSObject+JSONCategories.h"

@implementation NSObject (JSONCategories)
-(NSString *)toJsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if ([jsonData length] > 0 && error == nil) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return jsonString;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
@end
