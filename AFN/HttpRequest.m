//
//  HttpRequest.m
//  项目框架封装
//
//  Created by 王涛 on 16/3/6.
//  Copyright © 2016年 304. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import "NSObject+JSONCategories.h"
#import "Cache.h"
#import "NSFileManager+PathSize.h"
#import "LoadingView.h"
@implementation HttpRequest
-(void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finsihedBlock isCache:(BOOL)isCache
{
    [self PostWithUrlString:urlString isBoody:NO parms:dict finished:finsihedBlock isCache:isCache];
}
-(void)PostWithUrlString:(NSString *)urlString isBoody:(BOOL)need parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock isCache:(BOOL)isCache
{
    //以防万一,处理非法的字符
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#warning 不确定这个方法用的对不对
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    if (isCache) {
        NSString *path = [self appendCacheUrlStringPath:urlString WithDict:dict];
        if ([[Cache cache] cacheIsExistAndIsNoOutTimeWithPath:path time:60*60] == NO) {
            //超过了时间,要重新请求,NO不需要请求数据
            
            [[Cache cache] getFileWithPath:path isSuccess:^(BOOL success, id requestObjc) {
                if (success) {
                    
                    [[LoadingView shareLoadingView] stopAnimation];
                    
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:requestObjc options:NSJSONReadingMutableContainers error:nil];
                    finishedBlock(requestObjc,dataDict,nil);
                }else{
                    [[LoadingView shareLoadingView] stopAnimation];
                }
                application.networkActivityIndicatorVisible = NO;
                
            }];
            
            return;
            
        }
        
    }
    
    //超过时间,重新请求
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://test.rest.parteam.cn/"]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    sessionManager.securityPolicy = securityPolicy;
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 10*4;
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    
    [sessionManager POST:urlString parameters:dict isBody:need success:^(NSURLSessionDataTask *task, id responseObject) {
        
        application.networkActivityIndicatorVisible = NO;
//        [[LoadingView shareLoadingView] stopAnimation];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            finishedBlock(responseObject,responseObject,nil);
        }else{//不是字典
            NSError *error = nil;
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            finishedBlock(responseObject,dataDict,nil);
        }
        
        //需要储存数据,就存到本地
        if (isCache) {
            NSString *path = [self appendCacheUrlStringPath:urlString WithDict:dict];
            [[Cache cache] writeFile:responseObject toPath:path];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [[LoadingView shareLoadingView] stopAnimation];
        finishedBlock(nil,nil,error);
        application.networkActivityIndicatorVisible = NO;
    }];
    
    
}
-(void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock isCache:(BOOL)isCach
{
    //以防万一,处理非法的字符
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    if (isCach) {
        NSString *path = [self appendCacheUrlStringPath:urlString WithDict:dict];
        if ([[Cache cache] cacheIsExistAndIsNoOutTimeWithPath:path time:60*60] == NO) {
            [[Cache cache] getFileWithPath:path isSuccess:^(BOOL success, id requestObjc) {
                
                if (success) {
                    [[LoadingView shareLoadingView] stopAnimation];
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:requestObjc options:NSJSONReadingMutableContainers error:nil];
                    //把取出数据传出去
                    finishedBlock(requestObjc,dataDict,nil);
                }else{
                    //结束动画
                    [[LoadingView shareLoadingView] stopAnimation];
                }
                application.networkActivityIndicatorVisible = NO;
            }];
            return;
        }
    }
    
    //缓存不可用或者没有进行本地,重新请求
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://test.cn/"]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.requestSerializer.timeoutInterval = 60*4;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:urlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        application.networkActivityIndicatorVisible = NO;
        
        [[LoadingView shareLoadingView] stopAnimation];
        
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        finishedBlock(responseObject,dataDict,nil);
        if (isCach) {
            NSString *path = [self appendCacheUrlStringPath:urlString WithDict:dict];
            [[Cache cache] writeFile:responseObject toPath:path];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        //结束动画
        [[LoadingView shareLoadingView] stopAnimation];
        finishedBlock(nil,nil,error);
        application.networkActivityIndicatorVisible = NO;
        
    }];
    
    
}
-(void)PostDataWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict withImages:(NSArray *)images finished:(DownloadFinishedBlock)finishdeBlock
{
    //以防万一,处理非法的字符
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://test.rest.parteam.cn/"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60*4;
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;

    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (images.count != 0) {
            for (NSInteger i = 0; i<images.count; i++) {
                NSData *imageData = images[i];
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%ld",i] fileName:[NSString stringWithFormat:@"image%ld.%@",i,returnImagesType([images objectAtIndex:i])] mimeType:[NSString stringWithFormat:@"file/%@",returnImagesType([images objectAtIndex:i])]];
            }
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        finishdeBlock(responseObject,dataDict,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        finishdeBlock(nil,nil,error);
    }];
    
}
-(NSString *)appendCacheUrlStringPath:(NSString *)urlString WithDict:(NSDictionary *)dict
{
    NSRange range = [urlString rangeOfString:@"?"];
    NSMutableString *muStr = [[NSMutableString alloc] init];
    if (range.location == NSNotFound) {
        [muStr appendString:@"?"];
    }else{
        [muStr appendString:@"&"];
    }
    NSArray *allKeys = dict.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = [dict objectForKey:key];
        NSString *ssss = [NSString stringWithFormat:@"%@=%@",key,value];
        [muStr appendString:ssss];
        NSString *lastKey = [allKeys lastObject];
        if ([lastKey isEqualToString:key] == NO) {
            [muStr appendString:@"&"];
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",urlString,muStr];
    return path;
}
@end
