//
//  TouchID_FaceID.m
//  DemonProject
//
//  Created by david on 2018/10/6.
//  Copyright © 2018年 david. All rights reserved.
//

#import "TouchID_FaceID.h"

#define k_Account_And_Password @"k_Account_And_Password"
#define k_Account_Prefix @"k_Account_Prefix"
@implementation TouchID_FaceID



+ (TouchID_FaceID *)shared{
    static TouchID_FaceID * object = nil ;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        if (object == nil) {
            object = [[TouchID_FaceID alloc] init];
            LAContext *content = [[LAContext alloc] init];
            object.supportTouchID = [content canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
            if ([content respondsToSelector:@selector(biometryType)]) {
                if ([content biometryType] == LABiometryTypeFaceID) {
                    object.supportFaceID = YES;
                }
            }
        }
    });
    return object;
}

#pragma mark 验证指纹
- (void)evaluateTouchId:(void (^)(BOOL, NSError * _Nullable))reply {
    self.content = [[LAContext alloc] init];
    [_content evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"确认您的身份来登录" reply:^(BOOL success, NSError * _Nullable error) {
        reply(success,error);
        
//        if (success) {
//            //验证成功，主线程处理UI
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                NSLog(@"指纹验证成功");
//            }];
//        } else {
//            NSLog(@"验证失败 == %@", error.localizedDescription);
//            switch (error.code) {
//                case LAErrorSystemCancel:{
//                    NSLog(@"系统取消授权，如其他APP切入");
//                }
//                    break;
//                case LAErrorUserCancel:{
//                    NSLog(@"用户取消验证，点击了取消按钮");
//                }
//                    break;
//                case LAErrorUserFallback:{
//                    NSLog(@"用户取消验证，点击了输入密码按钮");
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        //用户选择输入密码，切换主线程处理
//
//                    }];
//                }
//                    break;
//                case LAErrorAuthenticationFailed:{
//                    NSLog(@"连续三次指纹验证失败，可能指纹模糊或用错手指");
//                }
//                    break;
//                case LAErrorTouchIDLockout:{
//                    NSLog(@"设备TouchID被锁定，因为失败的次数太多了");
//                }
//                    break;
//                default:{
//                    NSLog(@"设备TouchID不可用。。。");
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        //其他情况，切换主线程处理
//                    }];
//                }
//                    break;
//            }
//        }
    }];
}











- (void)setAccount:(NSString *)account withPassword:(NSString *)password {
    NSDictionary *dic = [self getDic];
    if (!dic) {
        dic = [NSDictionary dictionary];
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mDic setObject:password forKey:[self getKey:account]];
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:k_Account_And_Password];
}
- (NSString *)getPasswordForAccount:(NSString *)account {
    NSDictionary *dic = [self getDic];
    if (!dic) {
        return nil;
    }
    return [dic objectForKey:[self getKey:account]];
}

//返回本地保存的账号密码字典
- (NSDictionary *)getDic {
    return [[NSUserDefaults standardUserDefaults] objectForKey:k_Account_And_Password];
}
//返回以账号作为存储的key
- (NSString *)getKey:(NSString *)account {
    return [k_Account_Prefix stringByAppendingString:account];
}

@end
