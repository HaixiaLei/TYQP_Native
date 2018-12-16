//
//  NetworkManager.h
//  DemonProject
//
//  Created by david on 2018/7/9.
//  Copyright © 2018年 david. All rights reserved.
//
//  网络请求层
//dispatch_async(dispatch_get_global_queue(0, 0),^{
//    //进入另一个线程
//    dispatch_async(dispatch_get_main_queue(),^{
//        //返回主线程
//    });
//});

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

/*请求超时时间*/
static CGFloat NetworkRequestTimeout = 21.f;

@interface NetworkManager : NSObject

#pragma mark Http Post请求
+(void)httpPostForUrl:(NSString *)url Params:(NSDictionary *)params block:(Callback)block;
+(void)httpPostForUrl:(NSString *)url showHud:(BOOL)showHud showError:(BOOL)showError checkNet:(BOOL)checkNet Params:(NSDictionary *)params isJson:(BOOL)isJson
                block:(void (^)(NSError *error, int code, id response))block;


#pragma mark Http Get请求
+ (void)httpGetForUrl:(NSString *)url Params:(NSDictionary *)params show:(BOOL)show block:(Callback)block;
@end

