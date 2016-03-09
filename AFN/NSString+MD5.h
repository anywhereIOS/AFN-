//
//  NSString+MD5.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/7.
//  Copyright © 2016年 304. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;
- (NSString *) stringFromMD5;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;
@end
