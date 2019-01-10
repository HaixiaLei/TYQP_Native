//
//  NetworkBusiness.m
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//

#import "NetworkBusiness.h"

@implementation NetworkBusiness

+ (void)validatecodeBlock:(Callback)block {
    long integer = arc4random()%100000000;
    NSString *url = [NSString stringWithFormat:@"%@%@?0.%li%li",HOST_P,Url_validatecode,integer,integer];
    long ram = arc4random()%100000;
    NSString *name = [NSString stringWithFormat:@"yzm_%li.php",ram];
    [NetworkManager downloadFileFor:url name:name block:block];
}

+ (void)registerReference:(NSString *)reference username:(NSString *)username password:(NSString *)password verifycode:(NSString *)verifycode Block:(Callback)block {
    NSDictionary *para = @{@"action":@"register",
                           @"reference":reference,
                           @"username":username,
                           @"password":password,
                           @"password2":password,
                           @"verifycode":verifycode,
                           };
    NSString *url = [HOST_P stringByAppendingString:Url_register];
    [NetworkManager httpPostForUrl:url Params:para block:block];
}

+ (void)loginUsername:(NSString *)username passwd:(NSString *)passwd sign:(NSString *)sign Block:(Callback)block; {
    NSDictionary *para = @{@"username":username,
                           @"passwd":passwd,
                           @"sign":(sign?:@""),
                           };
    NSString *url = [HOST_P stringByAppendingString:Url_login];
    [NetworkManager httpPostForUrl:url Params:para block:block];
}

+ (void)forget_pwd:(NSString *)username realname:(NSString *)realname withdraw_password:(NSString *)withdraw_password new_password:(NSString *)new_password Block:(Callback)block {
    NSDictionary *para = @{@"action_type":@"reset",
                           @"username":username,
                           @"realname":realname,
                           @"withdraw_password":withdraw_password,
                           @"new_password":new_password,
                           @"password_confirmation":new_password,
                           };
    NSString *url = [HOST_P stringByAppendingString:Url_forget_pwd];
    [NetworkManager httpPostForUrl:url Params:para block:block];
}

+ (void)winningnewsBlock:(Callback)block {
    long integer = arc4random()%100000000;
    NSString *url = [NSString stringWithFormat:@"%@%@?0.%li%li",HOST_P,Url_winningnews,integer,integer];
    [NetworkManager httpPostForUrl:url showHud:NO showError:NO checkNet:NO Params:nil isJson:YES block:block];
}

+ (void)balanceBlock:(Callback)block {
    long integer = arc4random()%100000000;
    NSString *url = [NSString stringWithFormat:@"%@%@?0.%li%li",HOST_P,Url_ag_api,integer,integer];
    NSDictionary *para = @{@"action":@"b",
                           };
    [NetworkManager httpPostForUrl:url showHud:YES showError:YES checkNet:YES Params:para isJson:YES block:block];
}

+ (void)bank_listBlock:(Callback)block {
    NSString *url = [HOST_P stringByAppendingString:Url_bank_list];
    [NetworkManager httpPostForUrl:url showHud:NO showError:NO checkNet:NO Params:nil isJson:YES block:block];
}

+ (void)add_carkName:(NSString *)name bid:(NSString *)bid account:(NSString *)account address:(NSString *)address Block:(Callback)block {
    NSDictionary *para = @{@"real_name":name,
                           @"bank_Id":bid,
                           @"bank_Account":account,
                           @"bank_Address":address,
                           };
    NSString *url = [HOST_P stringByAppendingString:Url_add_card];
    [NetworkManager httpPostForUrl:url Params:para block:block];
}

//(1:滚动公告；2：公告列表；3：站内信)
+ (void)noticeForTyep:(NSString *)type Block:(Callback)block {
    NSDictionary *para = @{@"type":type,
                           };
    NSString *url = [HOST_P stringByAppendingString:Url_notice];
    [NetworkManager httpPostForUrl:url showHud:NO showError:NO checkNet:NO Params:para isJson:YES block:block];
}

+ (void)bannerBlock:(Callback)block {
    NSString *url = [HOST_P stringByAppendingString:Url_banner];
    [NetworkManager httpPostForUrl:url showHud:NO showError:NO checkNet:NO Params:nil isJson:YES block:block];
}

+ (void)signinBlock:(Callback)block {
    NSDictionary *para = @{@"action":@"sign_days",
                           };
    NSString *url = [HOST_P stringByAppendingString:Url_signin];
    [NetworkManager httpPostForUrl:url Params:para block:block];
}
@end































