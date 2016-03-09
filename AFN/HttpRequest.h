//
//  HttpRequest.h
//  项目框架封装
//
//  Created by 王涛 on 16/3/6.
//  Copyright © 2016年 304. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DownloadFinishedBlock)(NSData *requestData,NSDictionary *requestDict,NSError *error);
@interface HttpRequest : NSObject
/**
 *  post请求
 *
 *  @param urlString     网址
 *  @param dict          字典
 *  @param finsihedBlock 返回数据
 *  @param isCache       是否缓存
 */
-(void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finsihedBlock isCache:(BOOL)isCache;
- (void)PostWithUrlString:(NSString *)urlString isBoody:(BOOL)need parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock isCache:(BOOL)isCache;
/**
 *  Get请求
 *
 *  @param urlString     网址
 *  @param dict          字典
 *  @param finishedBlock 返回数据
 *  @param isCach        是否缓存
 */
- (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock isCache:(BOOL)isCach;
/**
 *  上传image
 *
 *  @param urlString     网址
 *  @param dict          其他普通数据的字典
 *  @param images        images的数组
 *  @param finishdeBlock 返回结果
 */
-(void)PostDataWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict withImages:(NSArray *)images finished:(DownloadFinishedBlock)finishdeBlock;
@end
