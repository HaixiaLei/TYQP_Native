//
//  NetworkManager.m
//  DemonProject
//
//  Created by david on 2018/7/9.
//  Copyright © 2018年 david. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

#pragma mark Http Post请求
+(void)httpPostForUrl:(NSString *)url Params:(NSDictionary *)params block:(Callback)block {
    [NetworkManager httpPostForUrl:url showHud:YES showError:YES checkNet:YES Params:params isJson:YES block:block];
}

+(void)httpPostForUrl:(NSString *)url showHud:(BOOL)showHud showError:(BOOL)showError checkNet:(BOOL)checkNet Params:(NSDictionary *)params isJson:(BOOL)isJson
                block:(void (^)(NSError *error, int code, id response))block
{
    if (checkNet) {
        if (![Tools checkNetWork]) {
            block(nil,-1,nil);
            return;
        }
    }
    
    if (showHud) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [MBProgressHUD showHUDAddedTo:window animated:YES];
        });
    }
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer.timeoutInterval = NetworkRequestTimeout;
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"script/html",@"htm",@"html", nil];
    [manage.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //设置cookie
    NSString *cookie = [Singleton shared].cookie;
    if (cookie && cookie.length) {
        NSString *value = [NSString stringWithFormat:@"member_money=%@; ag_balance=%@; %@",[Singleton shared].Money?:@"0",[Singleton shared].ag_balance?:@"0",cookie];
        [manage.requestSerializer setValue:value forHTTPHeaderField:@"Cookie"];
    }
    
    NSLog(@"请求头:%@",manage.requestSerializer.HTTPRequestHeaders);
    
    
    [manage POST:url parameters:params progress:nil success:^(NSURLSessionTask *task,id responseObject){
        
        //打印返回头
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSLog(@"POST返回头====>%@",allHeaders);
        }

        
        //获取cookie
        if (![Singleton shared].cookie || ![Singleton shared].cookie.length) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
            NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [Singleton shared].cookie = [Request objectForKey:@"Cookie"];
        }
        
        if (showHud) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD hideHUDForView:window animated:YES];
            });
        }
        

        
        NSLog(@"\n*********接口请求成功！*************\n地址:%@\n参数:%@\n返回:%@\n******************************\n\n",url,params,responseObject);
        if (block) {
            block(NULL,200,responseObject);
        }
    }failure:^(NSURLSessionTask *operation,NSError *error){
        if (showHud) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD hideHUDForView:window animated:YES];
            });
        }
        
        NSLog(@"\n*********接口请求失败! *************\n地址:%@\n参数:%@\nerror:\n%@\n******************************\n\n",url,params,error);
        
        if (showError) {
            if ([Singleton shared].netStatus <= 0) {
                [Tools showText:@"您已断开网络连接,您检查您的网络。"];
            } else if (error.code == -1001) {
                [Tools showText:@"请求超时,请稍后再试。"];
            } else {
                [Tools showText:@"请求超时,请稍后再试。"];
            }
        }
        
        NSDictionary *errorDataDict = nil;
        
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
//        NSInteger statusCode = response.statusCode;
        //如果响应头http状态码是400了则进一步查下原因
        
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (errorData) {
            errorDataDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"http请求错误后进一步查询响应体:%@",errorDataDict);
            NSArray *allKeys = [errorDataDict allKeys];
            if ([allKeys containsObject:@"errorCode"]) {
//                NSInteger errorCode = [errorDataDict[@"errorCode"] integerValue];
                //此处写根据errorCode对用户提醒弹窗(如果你用hud记得回调回主线程)或者回调.......
            }
        }
        
        
        if (block) {
            block(error,-1,errorDataDict);
        }
    }];
}

















#pragma mark Http Get请求
+ (void)httpGetForUrl:(NSString *)url Params:(NSDictionary *)params show:(BOOL)show block:(Callback)block; {
    if (show) {
        if (![Tools checkNetWork]) {
            block(nil,-1,nil);
            return;
        }
    }
    
    if (show) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [MBProgressHUD showHUDAddedTo:window animated:YES];
        });
    }
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer.timeoutInterval = NetworkRequestTimeout;
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"script/html",@"htm",@"html", nil];
    [manage.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    

    
    
    [manage GET:url parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (show) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD hideHUDForView:window animated:YES];
            });
        }
        
//        //打印返回头
//        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//            NSDictionary *allHeaders = response.allHeaderFields;
//            NSLog(@"GET返回头====>%@",allHeaders);
//        }
        

        
        NSLog(@"\n*********接口请求成功！*************\n地址:%@\n参数:%@\n返回:%@\n******************************\n\n",url,params,responseObject);
        if (block) {
            block(NULL,200,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (show) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD hideHUDForView:window animated:YES];
            });
        }
        
        NSLog(@"\n*********接口请求失败! *************\n地址:%@\n参数:%@\nerror:%@\n******************************\n\n",url,params,error);
        
        if (show) {
            if ([Singleton shared].netStatus <= 0) {
                [Tools showText:@"您已断开网络连接,您检查您的网络。"];
            } else if (error.code == -1001) {
                [Tools showText:@"请求超时,请稍后再试。"];
            } else {
                [Tools showText:@"请求超时,请稍后再试。"];
            }
        }
        if (block) {
            block(error,-1,nil);
        }
    }];
}

#pragma mark http 下载文件
+(void)downloadFileFor:(NSString *)url name:(NSString *)name block:(Callback)block {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    
    //设置cookie
    NSString *cookie = [Singleton shared].cookie;
    if (cookie && cookie.length) {
        NSString *value = [NSString stringWithFormat:@"member_money=%@; ag_balance=%@; %@",[Singleton shared].Money?:@"0",[Singleton shared].ag_balance?:@"0",cookie];
        [request setValue:value forHTTPHeaderField:@"Cookie"];
    }
    NSLog(@"DOWNLOAD请求头====>%@",request.allHTTPHeaderFields);
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL*documentsDirectoryURL = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:name];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"文件下载到:%@", filePath);
        block(error,200,filePath);
        
        //获取cookie
        if (![Singleton shared].cookie || ![Singleton shared].cookie.length) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:URL];
            NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [Singleton shared].cookie = [Request objectForKey:@"Cookie"];
        }
    }];
    [downloadTask resume];
}
@end
