//
//  EnlargeButton.h
//  DemonProject
//
//  Created by david on 2018/7/17.
//  Copyright © 2018年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlargeButton : UIButton

/**
 *  扩大点击区域距离
 */
@property (assign, nonatomic) CGFloat expandSpecs;
@property (assign, nonatomic) CGFloat expandTop;
@property (assign, nonatomic) CGFloat expandLeft;
@property (assign, nonatomic) CGFloat expandRight;

@property(nonatomic, assign) BOOL isBan;//是否半场  是否上半场
@property(nonatomic, strong) NSString *gid;
@property(nonatomic, strong) NSString *order_method;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *wtype;
@property(nonatomic, strong) NSString *rtype;
@property(nonatomic, strong) NSString *betName;//投注的名字
@property(nonatomic, assign) BOOL isMinorBonus;//计算赔率时是否-1
@property(nonatomic, strong) NSString *teamH;//主队名字，用来检查以免重复


/* @param  order_method FT_rm 滚球独赢，FT_re 滚球让球，FT_rou 滚球大小，FT_rt 滚球单双，FT_hrm 滚球半场独赢，FT_hre 滚球半场让球，FT_hrou 滚球半场大小，FT_m 独赢，FT_r 让球，FT_ou 大小，FT_t 单双，FT_hm 半场独赢，FT_hr 半场让球，FT_hou 半场大小，BK_re 滚球让球，BK_rou 滚球大小，BK_m 独赢，BK_r 让球，BK_ou 大小，BK_t 单双，BK_ouhc 球队得分大小
* @param  type  H 主队 C 客队  N 和
* @param  wtype  M 独赢，R 让球，大小 OU，单双 EO，半场独赢 HM，半场让球 HR，半场大小 HOU
* @param  rtype  ODD 单 EVEN 双
 */
@end
