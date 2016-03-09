//
//  Cache.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/7.
//  Copyright © 2016年 304. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^isCleanCacheSuccess) (BOOL success);
typedef void (^isGetCacheSuccess) (BOOL success,id requestObjc);
@interface Cache : NSObject
@property (nonatomic,strong) NSString *homePath;

+(Cache *)cache;
-(void)writeFile:(id)object toPath:(NSString *)path;
-(void)getFileWithPath:(NSString *)path isSuccess:(isGetCacheSuccess)success;
-(NSString *)getPath:(NSString *)path;

/**判断缓存是否存在是否超时,正常情况下返回yes说明需要重新请求数据*/
-(BOOL)cacheIsExistAndIsNoOutTimeWithPath:(NSString *)path time:(NSTimeInterval)time;

/**清理所有缓存*/
-(void)cleanCacheWithSuccess:(isCleanCacheSuccess)success;

/**计算path文件下文件的总大小*/
-(double)fileSizeForDir:(NSString *)path;

/**计算所有的缓存文件的大小*/
-(double)allFileSizeWithCache;

/**缓存的目录*/
-(NSString *)getCachesPath;

-(void)cleanCacheWithPathStr:(NSString *)path;

@end
