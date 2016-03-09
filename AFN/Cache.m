//
//  Cache.m
//  项目框架封装
//
//  Created by 王涛 on 16/3/7.
//  Copyright © 2016年 304. All rights reserved.
//

#import "Cache.h"
#import "NSFileManager+PathSize.h"
#import "NSString+MD5.h"
@implementation Cache
+(Cache *)cache
{
    static Cache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //线程安全
        cache = [[Cache alloc] init];
        
        //获得沙盒目录(当前应用的安装目录)
        NSString *homePath = NSHomeDirectory();
        homePath = [homePath stringByAppendingPathComponent:@"Documents/wangCache"];
        cache.homePath = homePath;
    });
    return cache;
}
//写文件
-(void)writeFile:(id)object toPath:(NSString *)path
{
    if (object != nil) {
#warning 为什么要进行加密?
        NSString *cachePath = [self getPath:[path stringFromMD5]];
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:path];
        [archiver finishEncoding];
        [data writeToFile:cachePath atomically:YES];
    }
}
//读出文件
-(void)getFileWithPath:(NSString *)path isSuccess:(isGetCacheSuccess)success
{
    NSString *cachePath = [self getPath:[path stringFromMD5]];
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:cachePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unarchiver decodeObjectForKey:path];
    [unarchiver finishDecoding];
    success(YES,object);
}
//拼接文件路径
-(NSString *)getPath:(NSString *)path
{
    //获得沙盒目录(当前应用的安装目录)
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents/wangCache"];
    self.homePath = homePath;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //如果缓存路径不存在
    if ([fm fileExistsAtPath:homePath] == NO) {
        //创建指定路径
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (path && [path length] != 0) {
        homePath = [homePath stringByAppendingPathComponent:path];
    }else{
        
    }
    return homePath;
}
-(BOOL)cacheIsExistAndIsNoOutTimeWithPath:(NSString *)path time:(NSTimeInterval)time
{
    NSString *fullPath = [self getPath:[path stringFromMD5]];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //缓存文件是否存在
    if ([fm fileExistsAtPath:fullPath]) {//没有超时
        if (![NSFileManager isTimeout:fullPath time:time]) {
            return NO;
        }else{
            //删除超时的缓存文件
            [fm removeItemAtPath:fullPath error:nil];
            return YES;
        }
    }else{
        return YES;
    }
}
-(void)cleanCacheWithPathStr:(NSString *)path
{
    NSString *fullPath = [self getPath:[path stringFromMD5]];
    NSFileManager *fm = [NSFileManager defaultManager];
    //缓存文件是否存在
    if ([fm fileExistsAtPath:fullPath]) {
        
        //缓存文件是否超时,这里设置超时时间time
        
        //删除超时的缓存文件
        [fm removeItemAtPath:fullPath error:nil];
    }else{
        
    }
}
-(void)cleanCacheWithSuccess:(isCleanCacheSuccess)success
{
    //清除自定义目录下的文件
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *array = [fm contentsOfDirectoryAtPath:self.homePath error:nil];
    for (NSString *fileName in array) {
        NSString *file = [self.homePath stringByAppendingPathComponent:fileName];
        
        if ([fm fileExistsAtPath:file]) {
            [fm removeItemAtPath:file error:nil];
        }
    }
    
    NSArray *arrays = [fm contentsOfDirectoryAtPath:[self getCachesPath] error:nil];
    for (NSString *fileName in arrays) {
        NSString *file = [[self getCachesPath] stringByAppendingPathComponent:fileName];
        if ([fm fileExistsAtPath:file]) {
            [fm removeItemAtPath:file error:nil];
        }
    }
    success(YES);
}
//获取缓存路径
-(NSString *)getCachesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachesDir = [paths objectAtIndex:0];
    
    return cachesDir;
}
-(double)fileSizeForDir:(NSString *)path
{
    double fileSize = [NSFileManager fileSizeForDir:[self getPath:[path stringFromMD5]]];
    
    return fileSize;
}
-(double)allFileSizeWithCache
{
    double fileSize = [NSFileManager fileSizeForDir:self.homePath];
    
    double cachesPathSize = [NSFileManager fileSizeForDir:[self getCachesPath]];
    
    return (fileSize + cachesPathSize)/(1024*1024);
}
@end
