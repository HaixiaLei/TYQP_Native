//
//  TouchID_FaceID.h
//  DemonProject
//
//  Created by david on 2018/10/6.
//  Copyright © 2018年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchID_FaceID : NSObject

@property(nonatomic, strong) LAContext *content;
@property(nonatomic, assign) BOOL supportTouchID;
@property(nonatomic, assign) BOOL supportFaceID;







+ (TouchID_FaceID *)shared;

//验证指纹
- (void)evaluateTouchId:(void(^)(BOOL success, NSError * __nullable error))reply;

//保存账号和密码
- (void)setAccount:(NSString *)account withPassword:(NSString *)password;

//通过账号获取密码
- (NSString *)getPasswordForAccount:(NSString *)account;
@end
