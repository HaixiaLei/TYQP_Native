//
//  Define_Notification.h
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//

#ifndef Define_Notification_h
#define Define_Notification_h

/*通知定义*/
#define Noti_Application_Did_Become_Active    @"Noti_Application_Did_Become_Active"
#define Noti_Timer_1second                    @"Noti_Timer_1second"
#define Noti_Network_state_changed            @"Noti_Network_state_changed"
//#define Noti_SuccessLogin                     @"Noti_SuccessLogin" //成功登录
//#define Noti_Success_Register                 @"Noti_Success_Register"
//#define Noti_Status_Update                    @"Noti_Status_Update"
//#define Noti_Got_DepositeList                 @"Noti_Got_DepositeList"
//#define Noti_BottomBar_Show                   @"Noti_BottomBar_Show"
//#define Noti_BottomBar_Hide                   @"Noti_BottomBar_Hide"
//#define Noti_TapOnStatusBar                   @"Noti_TapOnStatusBar"
//#define Noti_JumpGame                         @"Noti_JumpGame"  //跳转  真人荷官1  老虎机5  彩票2 皇冠棋牌3 开元棋牌4
//#define Noti_ReLogin                          @"Noti_ReLogin"  //重新登录
//#define Noti_GoToRecord                       @"Noti_GoToRecord" //前往交易记录
//#define Noti_SuccessSetInfo                   @"Noti_SuccessSetInfo" //提款信息设置成功
//
///*定义Key*/
//#define Key_Lunbotu                           @"Key_Lunbotu"
//#define Key_LunboGongGao                      @"Key_LunboGongGao"
//#define Key_RememberPass                      @"Key_RememberPass"









#endif /* Define_Notification_h */



/**
 
  *  完美解决Xcode NSLog打印不全的宏 亲测目前支持到8.2bate版
 
  */

#ifdef DEBUG

//#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else

#define NSLog(format, ...)

#endif
