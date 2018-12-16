//
//  NetworkBusiness.h
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//
//  网络业务层

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

#define Environment         1                                           //环境变量，1：发布  2：测试

#define DEFAULT_URL         @"http://www.cfqp88.com/"
#define URL_REQUEST         @"https://hg00086.firebaseapp.com/y/cf.txt"
#define Url_CheckCDN        @"api/answer.php"

#if (Environment == 1)
#define HOST_P              [[NSUserDefaults standardUserDefaults] objectForKey:@"host"]  //域名
#elif (Environment == 2)
#define HOST_P              @"http://www.cfqp88.com/"                     //测试环境
#endif



@interface NetworkBusiness : NSObject


@end















