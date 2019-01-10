//
//  ViewController.m
//  CFQP
//
//  Created by david on 2018/12/15.
//  Copyright © 2018 david. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteScrollView.h"
#import "ScrollingNoticeView.h"
#import "LoginViewController.h"
#import "WSDatePickerView.h"
#import "BasicScrollView.h"
#import "GameButton.h"

@interface ViewController ()

@property(nonatomic, strong)UIImageView *vvv;//偶然弹出的xxx获得100万

@end

@implementation ViewController {
    UIImageView *bgImageView;
    UIImageView *topImageView;
    UIButton *loginButton;//请先登录
    UIImageView *userHeadIv;
    UILabel *usernameLabel;
    UILabel *moneyLabel;
    UIButton *exchangeButton;//额度转换按钮
    UIButton *soundButton;
    UIButton *qiandaoButton;
    UIButton *dailiButton;
    UIButton *gonggaoButton;
    InfiniteScrollView *infiniteView;
    NSMutableArray *lunboArray;
    
    UIImageView *image_cf;
    UIImageView *image_vg;
    UIImageView *image_ky;
    UIImageView *image_qm;
    
    GameButton *button_cf;
    GameButton *button_vg;
    GameButton *button_ky;
    GameButton *button_qm;
    
    NSMutableArray *annouceArray;
    UIView *gonggaoBg;
    ScrollingNoticeView *scrollingNoticeView;
    
    UIImageView *foot;
    ScrollingNoticeView *scrollingNoticeViewVVV;//偶然弹出的xxx获得100万
    NSInteger countdownVVV;
    
    UIImageView *leftYinHangBg;
    IQPreviousNextView *yinhangView;//玩家中心->银行 的右边视图
    UIImageView *userCenterShowView;
}

/*让iPhone X 的底部只是bar隐藏*/
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

//判断和选择最佳域名
- (void)getYuming {
    if (Environment != 1) { //不是线上环境不管
        [self performSelector:@selector(requests) withObject:nil afterDelay:0.2];
        return;
    }
    
    NSString *host = HOST_P;
    if (!host || !host.length) {
        [[NSUserDefaults standardUserDefaults] setObject:DEFAULT_URL forKey:@"host"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block BOOL isReach = NO;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL_REQUEST]];
        if (!data) {
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self requests];
            });
            return;
        }
        NSDictionary *hostDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的域名列表是:%@",hostDic);
        if (!hostDic) {
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self requests];
            });
            return;
        }
        NSArray *list = [hostDic objectForKey:@"list"];
        __block NSInteger requestCount = 0;//用来统计请求了多少个，如果个数等于总数，还是不行
        for (NSDictionary *dic in list) {
            __block NSString *url = [dic stringForKey:@"url"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *str = [url stringByAppendingString:Url_CheckCDN];
                NSLog(@"请求:%@",str);
                NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:NULL];
                ++requestCount;
                if (!isReach) {
                    if ([response containString:@"status"] && [response containString:@"200"]) {
                        isReach = YES;
                        NSLog(@"最快返回的域名是:%@",url);
                        dispatch_async(dispatch_get_main_queue(),^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"host"];
                            [self requests];
                        });
                    }
                }
                if ((requestCount == list.count) && !isReach) {
                    NSLog(@"====>域名列表一个都不通");
                    dispatch_async(dispatch_get_main_queue(),^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [Tools alertWithTitle:@"网络缓慢，请切换网络或联系客服" message:nil handle:^(UIAlertAction *action) {
                            [self getYuming];
                        } cancel:nil confirm:@"重试"];
                    });
                }
            });
        }
    });
}

- (void)requests {
    [NetworkBusiness noticeForTyep:@"1" Block:^(NSError *error, int code, id response) {//滚动公告
        if (code == 200) {
            if ([response integerForKey:@"status"] == 200) {
                [annouceArray removeAllObjects];
                NSArray *data = [response objectForKey:@"data"];
                for (int i = 0; i < data.count; i++) {
                    NSDictionary *dict = data[i];
                    NSString *content = [dict stringForKey:@"content"];
                    [annouceArray addObject:content];
                }
                [self updateGonggao];
            }
        }
    }];
    
    [NetworkBusiness noticeForTyep:@"2" Block:^(NSError *error, int code, id response) {//公告列表
        if (code == 200) {
            if ([response integerForKey:@"status"] == 200) {
                [Singleton shared].gonggao = [response objectForKey:@"data"];
            }
        }
    }];
    
    [NetworkBusiness bannerBlock:^(NSError *error, int code, id response) {
        if (code == 200) {
            if ([response integerForKey:@"status"] == 200) {
                CGRect rect = infiniteView.frame;
                NSArray *data = [response objectForKey:@"data"];
                [lunboArray removeAllObjects];
                for (int i = 0; i < data.count; i++) {
                    NSDictionary *dic = data[i];
                    NSString *path = [dic stringForKey:@"img_path"];
                    [lunboArray addObject:path];
                }
                [infiniteView removeFromSuperview];
                infiniteView = [[InfiniteScrollView alloc] initWithFrame:rect];
                [infiniteView setupWithPageUrls:lunboArray shiftInterval:3.0 shiftDuration:0.5 callBack:^(NSInteger index) {
                    
                }];
                [infiniteView setShiftEnable:YES];
                [self.view insertSubview:infiniteView aboveSubview:bgImageView];
            }
        }
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    annouceArray = [[NSMutableArray alloc] init];
    [self getYuming];
    [self setupView];
    [self setNotifications];
}

- (void)setNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotiApplicationDidBecomeActive:) name:Noti_Application_Did_Become_Active object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(on1SecondCountDown:) name:Noti_Timer_1second object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeVVV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateGonggao];
    [self removeVVV];
    [self updateInfo];
}

- (void)updateInfo {
    if ([Singleton shared].isLogin) {
        userHeadIv.image = [UIImage imageNamed:@"userhead"];
        moneyLabel.text = [Singleton shared].Money;
        if ([Singleton shared].isShiwan) {
            usernameLabel.text = @"试玩玩家";
        } else {
            usernameLabel.text = [Singleton shared].UserName;
        }
    } else {
        userHeadIv.image = [UIImage imageNamed:@"home_head"];
        usernameLabel.text = @"请先登录";
        moneyLabel.text = @"0";
    }
}

- (void)pushLogin {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromRight;
//    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    LoginViewController *logo = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:logo animated:NO];
}

- (void)setupView {
    //背景
    bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bgImageView];
    
    //顶部栏
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 67.0/682*self.view.height)];
    topImageView.image = [UIImage imageNamed:@"home_top"];
    [self.view addSubview:topImageView];
    topImageView.userInteractionEnabled = YES;
    
    //登录按钮
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.24*topImageView.width, topImageView.height)];
    [topImageView addSubview:loginButton];
    [loginButton addTarget:self action:@selector(onLoginButton) forControlEvents:UIControlEventTouchUpInside];
    
    //用户头像
    userHeadIv = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenX?(0.2):(0.09))*loginButton.width, 0.125*loginButton.height, 0.70*loginButton.height, 0.7*topImageView.height)];
    userHeadIv.image = [UIImage imageNamed:@"home_head"];
    [loginButton addSubview:userHeadIv];
    userHeadIv.layer.cornerRadius = 0.5*userHeadIv.height;
    userHeadIv.layer.masksToBounds = YES;
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userHeadIv.right+heightTo4_7(15), 0, 100, loginButton.height*0.93)];
    usernameLabel.text = @"请先登录";
    usernameLabel.textColor = ColorHex(0xffffff);
    usernameLabel.font = SystemFontBy4(13.2);
    [loginButton addSubview:usernameLabel];
    
    //金额金钱money
    UIImageView *money= [[UIImageView alloc] initWithFrame:CGRectMake(0.26*topImageView.width, 0.09*topImageView.height, 0.197*topImageView.width, 0.78*topImageView.height)];
    [topImageView addSubview:money];
    money.image = [UIImage imageNamed:@"home_m0"];
    UIImageView *money1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, money.height, money.height)];
    money1.frame = CGRectInset(money1.frame, 0.07*money1.height, 0.07*money1.height);
    [money addSubview:money1];
    money1.image = [UIImage imageNamed:@"home_m1"];
    UIImageView *money2 = [[UIImageView alloc] initWithFrame:CGRectMake(money.width-money.height, 0, money.height, money.height)];
    money2.frame = CGRectInset(money2.frame, 0.07*money2.height, 0.07*money2.height);
    [money addSubview:money2];
    money2.image = [UIImage imageNamed:@"home_m2"];
    moneyLabel = [[UILabel alloc] initWithFrame:money.frame];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = SystemFontBy4(14.0);
    moneyLabel.textColor = ColorHex(0xe1b947);
    moneyLabel.text = @"0";
    [topImageView addSubview:moneyLabel];
    
    UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(0.474*topImageView.width, 0.175*topImageView.height, topImageView.height*0.64, topImageView.height*0.64)];
    [refresh setBackgroundImage:[UIImage imageNamed:@"home_refresh"] forState:0];
    [topImageView addSubview:refresh];
    [refresh addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventTouchUpInside];
    
//    exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.53*topImageView.width, (ScreenX?(0.13):(0.18))*topImageView.height, 0.1177*topImageView.width, (ScreenX?(0.68):(0.64))*topImageView.height)];
//    [topImageView addSubview:exchangeButton];
//    [exchangeButton setBackgroundImage:[UIImage imageNamed:@"home_exchange"] forState:0];
//    [exchangeButton addTarget:self action:@selector(onExchange) forControlEvents:UIControlEventTouchUpInside];
    
    soundButton = [[UIButton alloc] initWithFrame:CGRectMake(0.708*topImageView.width, 0.05*topImageView.height, heightTo4_7(50), heightTo4_7(56.25))];
    [soundButton setBackgroundImage:[UIImage imageNamed:@"home_sound1"] forState:0];
    [soundButton setBackgroundImage:[UIImage imageNamed:@"home_sound0"] forState:UIControlStateSelected];
    [soundButton addTarget:self action:@selector(onSound) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:soundButton];
    if ([Singleton shared].userSetSoundOff) {
        soundButton.selected = YES;
    } else {
        [Singleton shared].currentSoundIndex = ([Singleton shared].currentSoundIndex==0?1:0);
        [[Singleton shared] playBackgroundSound];
    }
    
    //签到按钮
    qiandaoButton = [[UIButton alloc] initWithFrame:CGRectMake(soundButton.right+heightTo4_7(38), soundButton.top, soundButton.width, soundButton.height)];
    [qiandaoButton setBackgroundImage:[UIImage imageNamed:@"home_qiandao"] forState:0];
    [qiandaoButton addTarget:self action:@selector(onQiandao) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:qiandaoButton];
    
    //代理按钮
    dailiButton = [[UIButton alloc] initWithFrame:CGRectMake(qiandaoButton.right+heightTo4_7(38), soundButton.top, soundButton.width, soundButton.height)];
    [dailiButton setBackgroundImage:[UIImage imageNamed:@"home_daili"] forState:0];
    [dailiButton addTarget:self action:@selector(onDaili) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:dailiButton];
    
    //公告按钮
    gonggaoButton = [[UIButton alloc] initWithFrame:CGRectMake(dailiButton.right+heightTo4_7(38), soundButton.top, soundButton.width, soundButton.height)];
    [gonggaoButton setBackgroundImage:[UIImage imageNamed:@"home_notice"] forState:0];
    [gonggaoButton addTarget:self action:@selector(onGonggao) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:gonggaoButton];
    
    lunboArray = [[NSMutableArray alloc] init];
    [lunboArray addObjectsFromArray:@[@"https://hg668888.firebaseapp.com/test/banner.png",
                                      @"https://hg668888.firebaseapp.com/test/banner.png",
                                      @"https://hg668888.firebaseapp.com/test/banner.png",
                                      @"https://hg668888.firebaseapp.com/test/banner.png",]];
    infiniteView = [[InfiniteScrollView alloc] initWithFrame:CGRectMake(heightTo4_7((ScreenX?170:86)), heightTo4_7(176), heightTo4_7(302), heightTo4_7(380))];
    [infiniteView setupWithPageUrls:lunboArray shiftInterval:3.0 shiftDuration:0.5 callBack:^(NSInteger index) {
        
    }];
    [infiniteView setShiftEnable:YES];
    [self.view addSubview:infiniteView];
    
    UIImage *cf = [UIImage imageNamed:@"home_cf"];
    UIImage *vg = [UIImage imageNamed:@"home_vg"];
    UIImage *ky = [UIImage imageNamed:@"home_ky"];
    UIImage *qm = [UIImage imageNamed:@"home_qm"];
    
    //创富棋牌
    CGFloat width_cf = heightTo4_7(200);
    image_cf = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+(ScreenX?heightTo4_7(60):0)+heightTo4_7(71), heightTo4_7(226), width_cf, cf.size.height/cf.size.width*width_cf)];
    image_cf.image = cf;
    [self.view addSubview:image_cf];
    
    //VG棋牌
    CGFloat width_vg = 356.0/306*width_cf;
    image_vg = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+(ScreenX?heightTo4_7(60):0)+heightTo4_7(203), heightTo4_7(112), width_vg, vg.size.height/vg.size.width*width_vg)];
    image_vg.image = vg;
    [self.view addSubview:image_vg];
    
    //开元棋牌
    CGFloat width_ky = 644.0/306*width_cf;
    image_ky = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+(ScreenX?heightTo4_7(60):0)+heightTo4_7(346), heightTo4_7(115), width_ky, ky.size.height/ky.size.width*width_ky)];
    image_ky.image = ky;
    [self.view addSubview:image_ky];
    
    //全民捕鱼
    CGFloat width_qm = 448.0/306*width_cf;
    image_qm = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+(ScreenX?heightTo4_7(60):0)+heightTo4_7(168), heightTo4_7(330), width_qm, qm.size.height/qm.size.width*width_qm)];
    image_qm.image = qm;
    [self.view addSubview:image_qm];
    
//    image_cf.userInteractionEnabled = YES;
//    image_vg.userInteractionEnabled = YES;
//    image_ky.userInteractionEnabled = YES;
//    image_qm.userInteractionEnabled = YES;
    button_cf = [[GameButton alloc] initWithFrame:CGRectMake(image_cf.left, image_cf.top+0.1*image_cf.height, 0.8*image_cf.width, 0.8*image_cf.height)];
    [button_cf addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_cf];
    button_cf.myImageView = image_cf;
    button_cf.tag = 0;
    
    button_vg = [[GameButton alloc] initWithFrame:CGRectMake(image_vg.left+0.08*image_vg.width, image_vg.top, 0.8*image_vg.width, 0.9*image_vg.height)];
    [button_vg addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_vg];
    button_vg.myImageView = image_vg;
    button_vg.tag = 1;
    
    button_ky = [[GameButton alloc] initWithFrame:CGRectMake(image_ky.left+0.15*image_ky.width, image_ky.top+0.06*image_ky.height, 0.72*image_ky.width, 0.84*image_ky.height)];
    [button_ky addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_ky];
    button_ky.myImageView = image_ky;
    button_ky.tag = 2;
    
    button_qm = [[GameButton alloc] initWithFrame:CGRectMake(image_qm.left+0.15*image_qm.width, image_qm.top, 0.7*image_qm.width, image_qm.height)];
    [button_qm addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_qm];
    button_qm.myImageView = image_qm;
    button_qm.tag = 3;
    
//    button_cf.backgroundColor = ColorHex(0xff0000);
//    button_vg.backgroundColor = ColorHex(0x00ff00);
//    button_ky.backgroundColor = ColorHex(0x0000ff);
//    button_qm.backgroundColor = ColorHex(0x555555);
    
    
    
    gonggaoBg = [[UIView alloc] initWithFrame:CGRectMake(-heightTo4_7(20), 0.914*self.view.height, heightTo4_7((ScreenX?500:360)), heightTo4_7(46))];
    gonggaoBg.backgroundColor = ColorHexWithAlpha(0x000000, 0.3);
    gonggaoBg.layer.cornerRadius = heightTo4_7(10);
    gonggaoBg.layer.masksToBounds = YES;
    [self.view addSubview:gonggaoBg];
    UIImageView *loo = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7((ScreenX?54:28)), heightTo4_7(7), heightTo4_7(40), heightTo4_7(34))];
    loo.image = [UIImage imageNamed:@"home_noicon"];
    [gonggaoBg addSubview:loo];
    [annouceArray addObject:@"祝君好运连连！         祝君好运连连！"];;
    [self updateGonggao];
    
    foot = [[UIImageView alloc] initWithFrame:CGRectMake(gonggaoBg.right+heightTo4_7(20), gonggaoBg.top, self.view.width-(gonggaoBg.right+heightTo4_7(20)), self.view.height-gonggaoBg.top)];
    foot.image = [UIImage imageNamed:@"home_foot"];
    [self.view addSubview:foot];
    foot.userInteractionEnabled = YES;
    
    UIImage *home_foot0 = [UIImage imageNamed:@"home_foot0"];
    UIImage *home_foot1 = [UIImage imageNamed:@"home_foot1"];
    UIImage *home_foot2 = [UIImage imageNamed:@"home_foot2"];
    UIImage *home_foot3 = [UIImage imageNamed:@"home_foot3"];
    UIImage *home_foot4 = [UIImage imageNamed:@"home_foot4"];
    CGFloat top = heightTo4_7(10);
    CGFloat height = foot.height - top - heightTo4_7(5);
    CGFloat gap = heightTo4_7(20);
    UIButton *foot0 = [[UIButton alloc] initWithFrame:CGRectMake(heightTo4_7(35), top, home_foot0.size.width/home_foot0.size.height*height, height)];
    [foot0 setBackgroundImage:home_foot0 forState:0];
    [foot addSubview:foot0];
    foot0.tag = 0;
    [foot0 addTarget:self action:@selector(onFootButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *foot1 = [[UIButton alloc] initWithFrame:CGRectMake(foot0.right+gap, top, home_foot1.size.width/home_foot1.size.height*height, height)];
    [foot1 setBackgroundImage:home_foot1 forState:0];
    [foot addSubview:foot1];
    foot1.tag = 1;
    [foot1 addTarget:self action:@selector(onFootButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *foot2 = [[UIButton alloc] initWithFrame:CGRectMake(foot1.right+gap, top, home_foot2.size.width/home_foot2.size.height*height, height)];
    [foot2 setBackgroundImage:home_foot2 forState:0];
    [foot addSubview:foot2];
    foot2.tag = 2;
    [foot2 addTarget:self action:@selector(onFootButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *foot3 = [[UIButton alloc] initWithFrame:CGRectMake(foot2.right+gap, top, home_foot3.size.width/home_foot3.size.height*height, height)];
    [foot3 setBackgroundImage:home_foot3 forState:0];
    [foot addSubview:foot3];
    foot3.tag = 3;
    [foot3 addTarget:self action:@selector(onFootButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *foot4 = [[UIButton alloc] initWithFrame:CGRectMake(foot3.right+gap, top, home_foot4.size.width/home_foot4.size.height*height, height)];
    [foot4 setBackgroundImage:home_foot4 forState:0];
    [foot addSubview:foot4];
    foot4.tag = 4;
    [foot4 addTarget:self action:@selector(onFootButton:) forControlEvents:UIControlEventTouchUpInside];
    
    foot0.frame = CGRectInset(foot0.frame, -0.02*foot0.width, -0.04*foot0.height);
    foot1.frame = CGRectInset(foot1.frame, 0.08*foot1.width, 0.08*foot1.height);
    foot2.frame = CGRectInset(foot2.frame, 0.025*foot2.width, 0.025*foot2.height);
    foot2.top -= 0.042*foot2.height;
    foot4.frame = CGRectInset(foot4.frame, 0.06*foot4.width, 0.06*foot4.height);
    
    _vvv = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7(280), heightTo4_7(65), self.view.width-heightTo4_7(560), heightTo4_7(60))];
    _vvv.image = [UIImage imageNamed:@"home_vvv"];
    [self.view addSubview:_vvv];
    _vvv.hidden = YES;
}

#pragma mark 接收到通知
- (void)onReceiveNotiApplicationDidBecomeActive:(NSNotification *)notification {
    NSLog(@"ViewController: ApplicationDidBecomeActive");
    [scrollingNoticeViewVVV removeFromSuperview];
    scrollingNoticeViewVVV = nil;
    _vvv.hidden = YES;
    
    [self updateGonggao];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
}

- (void)on1SecondCountDown:(NSNotification *)notification {
    ++countdownVVV;
    if (countdownVVV >= 25) {
        countdownVVV = -100;
        [self updateGonggaoVVV];
    }
}

- (void)onFootButton:(UIButton *)button {
    NSLog(@"on foot button: %li",button.tag);
    if (![Singleton shared].isLogin) {
        [self pushLogin];
        return;
    }
    
    if (button.tag == 1) {//玩家中心
        UIButton *bg = [[UIButton alloc] initWithFrame:self.view.bounds];
        bg.backgroundColor = ColorHexWithAlpha(0x000000, 0.76);
        [self.view addSubview:bg];
        
        UIImageView *vvv = [[UIImageView alloc] initWithFrame:CGRectMake(bg.width, 0, heightTo4_7(280), bg.height)];
        vvv.image = [UIImage imageNamed:@"opti0nbg"];
        [bg addSubview:vvv];
        vvv.userInteractionEnabled = YES;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, vvv.width, 0.24*vvv.height)];
        name.text = [Singleton shared].isShiwan?@"试玩玩家":[Singleton shared].UserName;
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = ColorHex(0xffffff);
        name.font = BoldSystemFontBy4(14.0);
        [vvv addSubview:name];
        
        UILabel *huanying = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, vvv.width, 0.4*vvv.height)];
        huanying.text = @"欢迎光临!";
        huanying.textAlignment = NSTextAlignmentCenter;
        huanying.textColor = ColorHex(0xffffff);
        huanying.font = BoldSystemFontBy4(14.0);
        [vvv addSubview:huanying];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.135*vvv.width, 0.30*vvv.height, vvv.width*0.737, heightTo4_7(4.8))];
        line.backgroundColor = ColorHexWithAlpha(0xf6cf5f, 0.5);
        [vvv addSubview:line];
        
        UIImage *image = [UIImage imageNamed:@"button1"];
        CGFloat w = vvv.width*0.8;
        CGFloat h = image.size.height/image.size.width*w;
        CGFloat t = vvv.height*0.38;
        CGFloat gap = 0.05*vvv.height;
        CGFloat left = (vvv.width-w)/2;
        UIButton *yinhang = [[UIButton alloc] initWithFrame:CGRectMake(left, t, w, h)];
        [yinhang setBackgroundImage:image forState:0];
        [yinhang setTitle:@"银行" forState:0];
        [yinhang setTitleColor:ColorHex(0xffffff) forState:0];
        yinhang.titleLabel.font = BoldSystemFontBy4(12.4);
        [vvv addSubview:yinhang];
        [yinhang handleCallBack:^(UIButton *button) {
            [self onPlayerCenterBank];
            [UIView animateWithDuration:0.16 animations:^{
                vvv.left = bg.right;
            } completion:^(BOOL finished) {
                [vvv removeFromSuperview];
                [bg removeFromSuperview];
            }];
        } forEvent:UIControlEventTouchUpInside];
        t = yinhang.bottom+gap;
        
        UIButton *anquan = [[UIButton alloc] initWithFrame:CGRectMake(left, t, w, h)];
        [anquan setBackgroundImage:image forState:0];
        [anquan setTitle:@"安全中心" forState:0];
        [anquan setTitleColor:ColorHex(0xffffff) forState:0];
        anquan.titleLabel.font = BoldSystemFontBy4(12.4);
        [vvv addSubview:anquan];
        [anquan handleCallBack:^(UIButton *button) {
            [self onPlayerCenterSecurity];
            [UIView animateWithDuration:0.16 animations:^{
                vvv.left = bg.right;
            } completion:^(BOOL finished) {
                [vvv removeFromSuperview];
                [bg removeFromSuperview];
            }];
        } forEvent:UIControlEventTouchUpInside];
        t = anquan.bottom+gap;
        
        UIButton *wode = [[UIButton alloc] initWithFrame:CGRectMake(left, t, w, h)];
        [wode setBackgroundImage:image forState:0];
        [wode setTitle:@"我的账变" forState:0];
        [wode setTitleColor:ColorHex(0xffffff) forState:0];
        wode.titleLabel.font = BoldSystemFontBy4(12.4);
        [vvv addSubview:wode];
        [wode handleCallBack:^(UIButton *button) {
            [self onPlayerCenterZhangbian];
            [UIView animateWithDuration:0.16 animations:^{
                vvv.left = bg.right;
            } completion:^(BOOL finished) {
                [vvv removeFromSuperview];
                [bg removeFromSuperview];
            }];
        } forEvent:UIControlEventTouchUpInside];
        t = wode.bottom+gap;
        
        UIButton *lianxi = [[UIButton alloc] initWithFrame:CGRectMake(left, t, w, h)];
        [lianxi setBackgroundImage:image forState:0];
        [lianxi setTitle:@"联系客服" forState:0];
        [lianxi setTitleColor:ColorHex(0xffffff) forState:0];
        lianxi.titleLabel.font = BoldSystemFontBy4(12.4);
        [vvv addSubview:lianxi];
        [lianxi handleCallBack:^(UIButton *button) {
            [self onPlayerCenterKefu];
            [UIView animateWithDuration:0.16 animations:^{
                vvv.left = bg.right;
            } completion:^(BOOL finished) {
                [vvv removeFromSuperview];
                [bg removeFromSuperview];
            }];
        } forEvent:UIControlEventTouchUpInside];
        t = lianxi.bottom+gap;
        
        yinhang.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.1*yinhang.height, 0);
        anquan.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.1*anquan.height, 0);
        wode.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.1*wode.height, 0);
        lianxi.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.1*lianxi.height, 0);
        [UIView animateWithDuration:0.16 animations:^{
            vvv.right = bg.right;
        }];
        
        [bg handleCallBack:^(UIButton *button) {
            [UIView animateWithDuration:0.16 animations:^{
                vvv.left = bg.right;
            } completion:^(BOOL finished) {
                [vvv removeFromSuperview];
                [bg removeFromSuperview];
            }];
        } forEvent:UIControlEventTouchUpInside];
    }
    
    
    
    
    
}

#pragma mark 玩家中心按钮事件
/*银行*/
- (void)onPlayerCenterBank {
    UIImage *img = [UIImage imageNamed:@"login_bg"];
    CGFloat hig = 0.84*self.view.height;
    CGFloat wid = hig*1.66;
    userCenterShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    userCenterShowView.userInteractionEnabled = YES;
    userCenterShowView.center = CGPointMake(self.view.width/2, 0.45*self.view.height);
    userCenterShowView.image = img;
    
    CGFloat closesize = 0.11*userCenterShowView.height;
    EnlargeButton *close = [[EnlargeButton alloc] initWithFrame:CGRectMake(userCenterShowView.width-closesize*0.6, -0.1*closesize, closesize, closesize)];
    close.expandSpecs = 0.3*close.width;
    [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [userCenterShowView addSubview:close];
    [close handleCallBack:^(UIButton *button) {
        [userCenterShowView.superview removeFromSuperview];
    } forEvent:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, userCenterShowView.width, 0.146*userCenterShowView.height)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"银行";
    title.font = BoldSystemFontBy4(15.6);
    title.textColor = ColorHex(0xffffff);
    [userCenterShowView addSubview:title];
    
    leftYinHangBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.16*userCenterShowView.height, 0.27*userCenterShowView.width, 0.82*userCenterShowView.height)];
    leftYinHangBg.userInteractionEnabled = YES;
    leftYinHangBg.image = [UIImage imageNamed:@"opti0nbg"];
    [userCenterShowView addSubview:leftYinHangBg];
    
    yinhangView = [[IQPreviousNextView alloc] initWithFrame:CGRectMake(leftYinHangBg.right+0.02*userCenterShowView.height, leftYinHangBg.top, userCenterShowView.width-(leftYinHangBg.right+0.04*userCenterShowView.height), leftYinHangBg.height)];
    yinhangView.layer.borderColor = ColorHex(0x6724c3).CGColor;
    yinhangView.layer.borderWidth = heightTo4_7(2.6);
    yinhangView.layer.cornerRadius = heightTo4_7(10.0);
    yinhangView.layer.masksToBounds = YES;
    [userCenterShowView addSubview:yinhangView];
    
    NSArray *names = @[@"账号注册",@"银行卡",@"提现",@"福利转换",];
    for (int i = 0; i < names.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.09*leftYinHangBg.width, 0.11*leftYinHangBg.height+0.22*leftYinHangBg.height*i, 0.82*leftYinHangBg.width, 0.14*leftYinHangBg.height)];
        [btn setBackgroundImage:[UIImage imageNamed:@"button1"] forState:0];
        [btn setTitle:names[i] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.font = SystemFontBy4(13.0);
        [leftYinHangBg addSubview:btn];
        [btn addTarget:self action:@selector(onYinhangLeft:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, btn.height*0.08, 0);
        
        if (i == 1) {
            [self onYinhangLeft:btn];
        }
    }


    [Tools popView:userCenterShowView inView:self.view];
}
- (void)onPlayerCenterSecurity {
    
}
- (void)onPlayerCenterZhangbian {
    
}
- (void)onPlayerCenterKefu {
    
}

- (void)onYinhangLeft:(UIButton *)btn {
    for (UIButton *button in leftYinHangBg.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setBackgroundImage:[UIImage imageNamed:@"button1"] forState:0];
        }
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"button2"] forState:0];
    
    [yinhangView removeAllSubviews];
    UIFont *font = SystemFontBy4(13.0);
    if (btn.tag == 0) {
//        UILabel *shoujihao = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.09*yinhangView.height, 0.3*yinhangView.width, 0.122*yinhangView.height)];
//        shoujihao.text = @"手机号:";
//        shoujihao.textAlignment = NSTextAlignmentRight;
//        shoujihao.textColor = [UIColor whiteColor];
//        shoujihao.font = font;
//        [yinhangView addSubview:shoujihao];
//        
//        UITextField *tfshoujihao = [[UITextField alloc] initWithFrame:CGRectMake(shoujihao.right+heightTo4_7(10), shoujihao.top, 0.58*yinhangView.width, shoujihao.height)];
//        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
//        attrs[NSFontAttributeName] = font; // 设置font
//        attrs[NSForegroundColorAttributeName] = ColorHex(0xf3aa17); // 设置颜色
//        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"用于取款,设置后不可修改" attributes:attrs];
//        tfname.attributedPlaceholder = attStr;
//        tfname.textColor = [UIColor whiteColor];
//        tfname.font = font;
//        [yinhangView addSubview:tfname];
//        tfname.layer.borderColor = ColorHex(0x6724c3).CGColor;
//        tfname.layer.borderWidth = heightTo4_7(2.6);
//        tfname.layer.cornerRadius = heightTo4_7(10.0);
//        tfname.layer.masksToBounds = YES;
//        UIView *paddingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, heightTo4_7(10), tfname.height)];
//        tfname.leftView = paddingview;
//        tfname.leftViewMode = UITextFieldViewModeAlways;
//        tfname.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    if (btn.tag == 1) {
        UILabel *zhenshixingming = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.09*yinhangView.height, 0.3*yinhangView.width, 0.122*yinhangView.height)];
        zhenshixingming.text = @"真实姓名:";
        zhenshixingming.textAlignment = NSTextAlignmentRight;
        zhenshixingming.textColor = [UIColor whiteColor];
        zhenshixingming.font = font;
        [yinhangView addSubview:zhenshixingming];
        
        UITextField *tfname = [[UITextField alloc] initWithFrame:CGRectMake(zhenshixingming.right+heightTo4_7(10), zhenshixingming.top, 0.58*yinhangView.width, zhenshixingming.height)];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = font; // 设置font
        attrs[NSForegroundColorAttributeName] = ColorHex(0xf3aa17); // 设置颜色
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"用于取款,设置后不可修改" attributes:attrs];
        tfname.attributedPlaceholder = attStr;
        tfname.textColor = [UIColor whiteColor];
        tfname.font = font;
        [yinhangView addSubview:tfname];
        tfname.layer.borderColor = ColorHex(0x6724c3).CGColor;
        tfname.layer.borderWidth = heightTo4_7(2.6);
        tfname.layer.cornerRadius = heightTo4_7(10.0);
        tfname.layer.masksToBounds = YES;
        UIView *paddingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, heightTo4_7(10), tfname.height)];
        tfname.leftView = paddingview;
        tfname.leftViewMode = UITextFieldViewModeAlways;
        tfname.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UILabel *yinhang = [[UILabel alloc] initWithFrame:CGRectMake(0, zhenshixingming.bottom+heightTo4_7(20), zhenshixingming.width, zhenshixingming.height)];
        yinhang.text = @"银行:";
        yinhang.textAlignment = NSTextAlignmentRight;
        yinhang.textColor = [UIColor whiteColor];
        yinhang.font = font;
        [yinhangView addSubview:yinhang];
        
        UIButton *bank = [[UIButton alloc] initWithFrame:CGRectMake(tfname.left, yinhang.top, tfname.width, tfname.height)];
        [yinhangView addSubview:bank];
        bank.layer.borderColor = ColorHex(0x6724c3).CGColor;
        bank.layer.borderWidth = heightTo4_7(2.6);
        bank.layer.cornerRadius = heightTo4_7(10.0);
        bank.layer.masksToBounds = YES;
        __block UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, bank.width, bank.height)];
        bankLabel.text = @"中国工商银行";
        bankLabel.textColor = [UIColor whiteColor];
        bankLabel.font = font;
        [bank addSubview:bankLabel];
        //            bankLabel.tag = 1234;
        [bank handleCallBack:^(UIButton *button) {
            if (!_bankNames) {
                _bankNames = [[NSMutableArray alloc] init];
                for (int i = 0; i < [Singleton shared].bankList.count; i++) {
                    NSDictionary *dict = [Singleton shared].bankList[i];
                    NSString *bankname = [dict stringForKey:@"bankname"];
                    [_bankNames addObject:bankname];
                }
            }
            
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowBank data:_bankNames scrollToIndex:0 CompleteBlock:^(NSInteger tag, BOOL cancel) {
                if (cancel) {
                    NSLog(@"CANCEL.....");
                } else {
                    NSString *title = _bankNames[tag];
                    bankLabel.text = title;
                }
            }];
            
            datepicker.dateLabelColor = ColorHex(0xff5733);//年-月-日-时-分 颜色
            datepicker.datePickerColor = ColorHex(0x286be8);//滚轮日期颜色
            datepicker.doneButtonColor = ColorHex(0x16BF30);//确定按钮的颜色
            [datepicker setHideBackgroundYearLabel:YES];
            [datepicker show];
        } forEvent:UIControlEventTouchUpInside];
        UIImageView *updown = [[UIImageView alloc] initWithFrame:CGRectMake(0.9*bank.width, 0.3*bank.height, 0.4*bank.height, 0.4*bank.height)];
        updown.image = [UIImage imageNamed:@"updown"];
        updown.alpha = 0.9;
        [bank addSubview:updown];
        
        UILabel *kahao = [[UILabel alloc] initWithFrame:CGRectMake(0, yinhang.bottom+heightTo4_7(20), zhenshixingming.width, zhenshixingming.height)];
        kahao.text = @"卡号:";
        kahao.textAlignment = NSTextAlignmentRight;
        kahao.textColor = [UIColor whiteColor];
        kahao.font = font;
        [yinhangView addSubview:kahao];
        
        UITextField *tfkahao = [[UITextField alloc] initWithFrame:CGRectMake(tfname.left, kahao.top, tfname.width, tfname.height)];
        attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = font; // 设置font
        attrs[NSForegroundColorAttributeName] = ColorHex(0xf3aa17); // 设置颜色
        attStr = [[NSAttributedString alloc] initWithString:@"请输入卡号" attributes:attrs];
        tfkahao.attributedPlaceholder = attStr;
        tfkahao.textColor = [UIColor whiteColor];
        tfkahao.font = font;
        [yinhangView addSubview:tfkahao];
        tfkahao.layer.borderColor = ColorHex(0x6724c3).CGColor;
        tfkahao.layer.borderWidth = heightTo4_7(2.6);
        tfkahao.layer.cornerRadius = heightTo4_7(10.0);
        tfkahao.layer.masksToBounds = YES;
        paddingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, heightTo4_7(10), tfkahao.height)];
        tfkahao.leftView = paddingview;
        tfkahao.leftViewMode = UITextFieldViewModeAlways;
        tfkahao.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
        UILabel *kaihu = [[UILabel alloc] initWithFrame:CGRectMake(0, kahao.bottom+heightTo4_7(20), zhenshixingming.width, zhenshixingming.height)];
        kaihu.text = @"开户银行:";
        kaihu.textAlignment = NSTextAlignmentRight;
        kaihu.textColor = [UIColor whiteColor];
        kaihu.font = font;
        [yinhangView addSubview:kaihu];
        
        UITextField *tfkaihu = [[UITextField alloc] initWithFrame:CGRectMake(tfname.left, kaihu.top, tfname.width, tfname.height)];
        attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = font; // 设置font
        attrs[NSForegroundColorAttributeName] = ColorHex(0xf3aa17); // 设置颜色
        attStr = [[NSAttributedString alloc] initWithString:@"如:河北唐山建设银行" attributes:attrs];
        tfkaihu.attributedPlaceholder = attStr;
        tfkaihu.textColor = [UIColor whiteColor];
        tfkaihu.font = font;
        [yinhangView addSubview:tfkaihu];
        tfkaihu.layer.borderColor = ColorHex(0x6724c3).CGColor;
        tfkaihu.layer.borderWidth = heightTo4_7(2.6);
        tfkaihu.layer.cornerRadius = heightTo4_7(10.0);
        tfkaihu.layer.masksToBounds = YES;
        paddingview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, heightTo4_7(10), tfkaihu.height)];
        tfkaihu.leftView = paddingview;
        tfkaihu.leftViewMode = UITextFieldViewModeAlways;
        tfkaihu.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.33*yinhangView.width, 0.13*yinhangView.height)];
        [submit setBackgroundImage:[UIImage imageNamed:@"button1"] forState:0];
        [yinhangView addSubview:submit];
        [submit setTitle:@"确认提交" forState:0];
        submit.titleLabel.font = SystemFontBy4(13.4);
        [submit setTitleColor:[UIColor whiteColor] forState:0];
        [yinhangView addSubview:submit];
        [submit handleCallBack:^(UIButton *button) {
            if (!tfname.text.length) {
                [Tools showText:@"请输入真实姓名"];
                return ;
            }
            if (!tfkahao.text.length) {
                [Tools showText:@"请输入卡号"];
                return ;
            }
            if (!tfkaihu.text.length) {
                [Tools showText:@"请输入开户银行地址"];
                return ;
            }
            NSString *bid = @"";
            for (NSDictionary *dict in [Singleton shared].bankList) {
                NSString *name = [dict stringForKey:@"bankname"];
                if ([name isEqualToString:bankLabel.text]) {
                    bid = [dict stringForKey:@"id"];
                    break;
                }
            }
            
            [NetworkBusiness add_carkName:tfname.text bid:bid account:tfkahao.text address:tfkaihu.text Block:^(NSError *error, int code, id response) {
                if (code == 200) {
                    [Tools alertWithTitle:[response stringForKey:@"describe"] message:nil handle:NULL cancel:nil confirm:@"确定"];
                    if ([response integerForKey:@"status"] == 200) {
                        [Singleton shared].isBindCard = @"1";
                        NSDictionary *data = [response objectForKey:@"data"];
                        [Singleton shared].Bank_Name = [data stringForKey:@"Bank_Name"];
                        [Singleton shared].Bank_Account = [data stringForKey:@"Bank_Account"];
                        [Singleton shared].Bank_Address = [data stringForKey:@"Bank_Address"];
                        [Singleton shared].Alias = tfname.text;
                        tfname.userInteractionEnabled = NO;
                        tfname.layer.borderWidth = 0.0f;
                    }
                }
            }];
            
        } forEvent:UIControlEventTouchUpInside];
        submit.titleEdgeInsets = UIEdgeInsetsMake(0, 0, submit.height*0.08, 0);
        submit.center = CGPointMake(0.5*yinhangView.width, 0.85*yinhangView.height);
        if ([Singleton shared].isBindCard.boolValue) {
            tfname.userInteractionEnabled = NO;
            tfname.layer.borderWidth = 0.0f;
            tfname.text = [Singleton shared].Alias;
            bankLabel.text = [Singleton shared].Bank_Name;
            tfkahao.text = [Singleton shared].Bank_Account;
            tfkaihu.text = [Singleton shared].Bank_Address;
        }
    }
    if (btn.tag == 2) {
        
    }
    if (btn.tag == 3) {
        
    }
}

- (void)updateGonggao {
    [scrollingNoticeView removeFromSuperview];
    scrollingNoticeView = nil;
    scrollingNoticeView = [[ScrollingNoticeView alloc] initWithFrame:CGRectMake(heightTo4_7((ScreenX?100:74)), 0, gonggaoBg.width-heightTo4_7(74), gonggaoBg.height)];
    scrollingNoticeView.speed = 72.0;
    [gonggaoBg addSubview:scrollingNoticeView];
    [scrollingNoticeView scrollWithMessages:annouceArray];
}

- (void)updateGonggaoVVV {
    [NetworkBusiness winningnewsBlock:^(NSError *error, int code, id response) {
        if (code == 200) {
            NSString *mess = [response stringForKey:@"data"];
            _vvv.hidden = NO;
            [scrollingNoticeViewVVV removeFromSuperview];
            scrollingNoticeViewVVV = nil;
            scrollingNoticeViewVVV = [[ScrollingNoticeView alloc] initWithFrame:CGRectMake(heightTo4_7(15), 0, _vvv.width-heightTo4_7(30), _vvv.height)];
            scrollingNoticeViewVVV.speed = 50.0;
            [_vvv addSubview:scrollingNoticeViewVVV];
            [scrollingNoticeViewVVV scrollWithMessages:@[mess]];
            [self performSelector:@selector(removeVVV) withObject:nil afterDelay:16];
        }
    }];
    
    
    

}

- (void)removeVVV {
    [scrollingNoticeViewVVV removeFromSuperview];
    scrollingNoticeViewVVV = nil;
    _vvv.hidden = YES;
    countdownVVV = 0;
}

- (void)onLoginButton {
    if ([Singleton shared].isLogin) {
        [self showPersonInfo];
    } else {
        [self pushLogin];
    }
}

/*展示个人信息*/
- (void)showPersonInfo {
    UIImage *img = [UIImage imageNamed:@"login_bg"];
    CGFloat wid = heightTo4_7(650);
    CGFloat hig = img.size.height/img.size.width*wid;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    bg.userInteractionEnabled = YES;
    bg.center = CGPointMake(self.view.width/2, 0.45*self.view.height);
    bg.image = img;
    
    CGFloat closesize = 0.09*bg.width;
    EnlargeButton *close = [[EnlargeButton alloc] initWithFrame:CGRectMake(bg.width-closesize*0.6, -0.1*closesize, closesize, closesize)];
    close.expandSpecs = 0.3*close.width;
    [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [bg addSubview:close];
    [close handleCallBack:^(UIButton *button) {
        [bg.superview removeFromSuperview];
    } forEvent:UIControlEventTouchUpInside];
    
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(heightTo4_7(16), 0.16*bg.height, bg.width-heightTo4_7(32), 0.56*bg.height)];
    content.backgroundColor = ColorHex(0x5d4192);
    content.layer.borderColor = ColorHex(0x6724c3).CGColor;
    content.layer.borderWidth = heightTo4_7(3.0);
    content.layer.masksToBounds = YES;
    content.layer.cornerRadius = heightTo4_7(12);
    [bg addSubview:content];
    
    UIButton *headicon = [[UIButton alloc] initWithFrame:CGRectMake(heightTo4_7(18), heightTo4_7(22), heightTo4_7(88), heightTo4_7(88))];
    headicon.layer.cornerRadius = 0.5*headicon.height;
    headicon.layer.borderWidth = heightTo4_7(4.0);
    headicon.layer.borderColor = ColorHex(0xa67f2a).CGColor;
    headicon.layer.masksToBounds = YES;
    headicon.backgroundColor = ColorHex(0xffffff);
    [content addSubview:headicon];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(headicon.right+heightTo4_7(22), headicon.top, content.width-(headicon.right+heightTo4_7(36)),heightTo4_7(51))];
    name.text = [@"   " stringByAppendingString:[Singleton shared].UserName];
    name.textColor = ColorHex(0xffffff);
    name.font = SystemFontBy4(13.6);
    name.layer.cornerRadius = 0.5*name.height;
    name.layer.masksToBounds = YES;
    name.backgroundColor = ColorHex(0x48227e);
    [content addSubview:name];
    
    UILabel *lasttime = [[UILabel alloc] initWithFrame:CGRectMake(name.left, name.bottom+heightTo4_7(12), name.width, heightTo4_7(42))];
    lasttime.text = [@"   上次登录时间: " stringByAppendingString:[Singleton shared].lastLoginTime];
    lasttime.textColor = ColorHex(0xffffff);
    lasttime.font = SystemFontBy4(12);
    lasttime.layer.cornerRadius = 0.5*lasttime.height;
    lasttime.layer.masksToBounds = YES;
    lasttime.backgroundColor = ColorHex(0x48227e);
    [content addSubview:lasttime];
    
    UILabel *suishen = [[UILabel alloc] initWithFrame:CGRectMake(name.left, lasttime.bottom+heightTo4_7(12), name.width, heightTo4_7(42))];
    suishen.text = @"   随身福利: 0.00 ";
    suishen.textColor = ColorHex(0xebd957);
    suishen.font = SystemFontBy4(12);
    suishen.layer.cornerRadius = 0.5*suishen.height;
    suishen.layer.masksToBounds = YES;
    suishen.backgroundColor = ColorHex(0x48227e);
    [content addSubview:suishen];
    
    UILabel *cangku = [[UILabel alloc] initWithFrame:CGRectMake(name.left, suishen.bottom+heightTo4_7(12), name.width, heightTo4_7(42))];
    cangku.text = @"   仓库福利: 0.00 ";
    cangku.textColor = ColorHex(0xebd957);
    cangku.font = SystemFontBy4(12);
    cangku.layer.cornerRadius = 0.5*cangku.height;
    cangku.layer.masksToBounds = YES;
    cangku.backgroundColor = ColorHex(0x48227e);
    [content addSubview:cangku];
    
    UIImage *qi = [UIImage imageNamed:@"button"];
    CGFloat gap = heightTo4_7(42);
    CGFloat width = (bg.width-gap*3)/2;
    UIButton *quit = [[UIButton alloc] initWithFrame:CGRectMake(gap, content.bottom+gap*0.76, width, qi.size.height/qi.size.width*width)];
    quit.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.1*quit.height, 0);
    [quit setBackgroundImage:qi forState:0];
    [quit setTitle:@"退出" forState:0];
    [quit setTitleColor:ColorHex(0xffffff) forState:0];
    quit.titleLabel.font = SystemFontBy4(13.6);
    [bg addSubview:quit];
    [quit handleCallBack:^(UIButton *button) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        runBlockAfter(0.3, ^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [bg.superview removeFromSuperview];
            [Singleton shared].isLogin = NO;
            [self updateInfo];
            [Tools showText:@"退出成功"];
        });
    } forEvent:UIControlEventTouchUpInside];
    
    UIButton *shezhi = [[UIButton alloc] initWithFrame:CGRectMake(quit.right+gap, content.bottom+gap*0.74, width, qi.size.height/qi.size.width*width)];
    shezhi.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0.1*shezhi.height, 0);
    [shezhi setBackgroundImage:qi forState:0];
    [shezhi setTitle:@"设置" forState:0];
    [shezhi setTitleColor:ColorHex(0xffffff) forState:0];
    shezhi.titleLabel.font = SystemFontBy4(13.6);
    [bg addSubview:shezhi];
    [shezhi handleCallBack:^(UIButton *button) {
        [bg.superview removeFromSuperview];
    } forEvent:UIControlEventTouchUpInside];
    
    [Tools popView:bg inView:self.view];
}

- (void)onRefresh {
    [self requestBalance];
}


- (void)requestBalance {
    [NetworkBusiness balanceBlock:^(NSError *error, int code, id response) {
        if (code == 200) {
            if ([response integerForKey:@"status"] == 200) {
                NSArray *data = [response objectForKey:@"data"];
                if (data.count) {
                    NSDictionary *dict = data[0];
                    [Singleton shared].Money = [dict stringForKey:@"balance_hg"];
                    [Singleton shared].ag_balance = [dict stringForKey:@"balance_ag"];
                    moneyLabel.text = [Singleton shared].Money;
                }
            } else {
                [Tools showText:[response stringForKey:@"describe"]];
            }
        }
    }];
}

- (void)onExchange {
    
}

- (void)onGame:(UIButton *)button {
    NSLog(@"button:%li",button.tag);
}

- (void)onSound {
    soundButton.selected = !soundButton.selected;
    [Singleton shared].userSetSoundOff = soundButton.selected;
    if (soundButton.selected) {
        [[Singleton shared] stopBackgourndSound];
    } else {
        [Singleton shared].currentSoundIndex = ([Singleton shared].currentSoundIndex==0?1:0);
        [[Singleton shared] playBackgroundSound];
    }
}

/*点击签到按钮*/
- (void)onQiandao {
    UIImage *img = [UIImage imageNamed:@"login_bg"];
    CGFloat hig = 0.9*self.view.height;
    CGFloat wid = hig*1.5;
    userCenterShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    userCenterShowView.userInteractionEnabled = YES;
    userCenterShowView.center = CGPointMake(self.view.width/2, 0.45*self.view.height);
    userCenterShowView.image = img;
    
    CGFloat closesize = 0.11*userCenterShowView.height;
    EnlargeButton *close = [[EnlargeButton alloc] initWithFrame:CGRectMake(userCenterShowView.width-closesize*0.6, -0.1*closesize, closesize, closesize)];
    [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    close.expandSpecs = 0.3*close.width;
    [userCenterShowView addSubview:close];
    [close handleCallBack:^(UIButton *button) {
        [userCenterShowView.superview removeFromSuperview];
    } forEvent:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, userCenterShowView.width, 0.146*userCenterShowView.height)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"公告";
    title.font = BoldSystemFontBy4(15.6);
    title.textColor = ColorHex(0xffffff);
    [userCenterShowView addSubview:title];
    
    leftYinHangBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.16*userCenterShowView.height, 0.27*userCenterShowView.width, 0.82*userCenterShowView.height)];
    leftYinHangBg.userInteractionEnabled = YES;
    leftYinHangBg.image = [UIImage imageNamed:@"opti0nbg"];
    [userCenterShowView addSubview:leftYinHangBg];
    
    yinhangView = [[IQPreviousNextView alloc] initWithFrame:CGRectMake(leftYinHangBg.right+0.02*userCenterShowView.height, leftYinHangBg.top, userCenterShowView.width-(leftYinHangBg.right+0.04*userCenterShowView.height), leftYinHangBg.height)];
    yinhangView.layer.borderColor = ColorHex(0x6724c3).CGColor;
    yinhangView.layer.borderWidth = heightTo4_7(2.6);
    yinhangView.layer.cornerRadius = heightTo4_7(10.0);
    yinhangView.layer.masksToBounds = YES;
    [userCenterShowView addSubview:yinhangView];
    
    NSArray *names = @[@"公告",@"邮件",];
    for (int i = 0; i < names.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.09*leftYinHangBg.width, 0.11*leftYinHangBg.height+0.22*leftYinHangBg.height*i, 0.82*leftYinHangBg.width, 0.14*leftYinHangBg.height)];
        [btn setBackgroundImage:[UIImage imageNamed:@"button1"] forState:0];
        [btn setTitle:names[i] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.font = SystemFontBy4(13.0);
        [leftYinHangBg addSubview:btn];
        [btn addTarget:self action:@selector(onGonggaoLeft:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        if (i == 0) {
            [self onGonggaoLeft:btn];
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.15*btn.width, 0.15*btn.height, 0.52*btn.height, 0.52*btn.height)];
            [btn addSubview:leftImg];
            leftImg.image = [UIImage imageNamed:@"gg_gg"];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0.24*btn.width, btn.height*0.13, 0);
        }
        if (i == 1) {
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.15*btn.width, 0.182*btn.height, 0.50*btn.height, 0.50*btn.height)];
            [btn addSubview:leftImg];
            leftImg.image = [UIImage imageNamed:@"gg_yj"];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0.24*btn.width, btn.height*0.125, 0);
        }
    }
    
    [Tools popView:userCenterShowView inView:self.view];
}

/*点击代理按钮*/
- (void)onDaili {
    
}

/*点击公告按钮*/
- (void)onGonggao {
    UIImage *img = [UIImage imageNamed:@"login_bg"];
    CGFloat hig = 0.9*self.view.height;
    CGFloat wid = hig*1.5;
    userCenterShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    userCenterShowView.userInteractionEnabled = YES;
    userCenterShowView.center = CGPointMake(self.view.width/2, 0.45*self.view.height);
    userCenterShowView.image = img;
    
    CGFloat closesize = 0.10*userCenterShowView.height;
    EnlargeButton *close = [[EnlargeButton alloc] initWithFrame:CGRectMake(userCenterShowView.width-closesize*0.6, -0.1*closesize, closesize, closesize)];
    [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    close.expandSpecs = 0.3*close.width;
    [userCenterShowView addSubview:close];
    [close handleCallBack:^(UIButton *button) {
        [userCenterShowView.superview removeFromSuperview];
    } forEvent:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, userCenterShowView.width, 0.146*userCenterShowView.height)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"公告";
    title.font = BoldSystemFontBy4(15.6);
    title.textColor = ColorHex(0xffffff);
    [userCenterShowView addSubview:title];
    
    leftYinHangBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.16*userCenterShowView.height, 0.27*userCenterShowView.width, 0.82*userCenterShowView.height)];
    leftYinHangBg.userInteractionEnabled = YES;
    leftYinHangBg.image = [UIImage imageNamed:@"opti0nbg"];
    [userCenterShowView addSubview:leftYinHangBg];
    
    yinhangView = [[IQPreviousNextView alloc] initWithFrame:CGRectMake(leftYinHangBg.right+0.02*userCenterShowView.height, leftYinHangBg.top, userCenterShowView.width-(leftYinHangBg.right+0.04*userCenterShowView.height), leftYinHangBg.height)];
    yinhangView.layer.borderColor = ColorHex(0x6724c3).CGColor;
    yinhangView.layer.borderWidth = heightTo4_7(2.6);
    yinhangView.layer.cornerRadius = heightTo4_7(10.0);
    yinhangView.layer.masksToBounds = YES;
    [userCenterShowView addSubview:yinhangView];
    
    NSArray *names = @[@"公告",@"邮件",];
    for (int i = 0; i < names.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.09*leftYinHangBg.width, 0.11*leftYinHangBg.height+0.22*leftYinHangBg.height*i, 0.82*leftYinHangBg.width, 0.14*leftYinHangBg.height)];
        [btn setBackgroundImage:[UIImage imageNamed:@"button1"] forState:0];
        [btn setTitle:names[i] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.font = SystemFontBy4(13.0);
        [leftYinHangBg addSubview:btn];
        [btn addTarget:self action:@selector(onGonggaoLeft:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        if (i == 0) {
            [self onGonggaoLeft:btn];
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.15*btn.width, 0.15*btn.height, 0.52*btn.height, 0.52*btn.height)];
            [btn addSubview:leftImg];
            leftImg.image = [UIImage imageNamed:@"gg_gg"];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0.24*btn.width, btn.height*0.13, 0);
        }
        if (i == 1) {
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.15*btn.width, 0.182*btn.height, 0.50*btn.height, 0.50*btn.height)];
            [btn addSubview:leftImg];
            leftImg.image = [UIImage imageNamed:@"gg_yj"];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0.24*btn.width, btn.height*0.125, 0);
        }
    }
    
    [Tools popView:userCenterShowView inView:self.view];
}

- (void)onGonggaoLeft:(UIButton *)btn {
    for (UIButton *button in leftYinHangBg.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setBackgroundImage:[UIImage imageNamed:@"button1"] forState:0];
        }
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"button2"] forState:0];
    
    [yinhangView removeAllSubviews];
    if (btn.tag == 0) {
        BasicScrollView *scroll = [[BasicScrollView alloc] initWithFrame:yinhangView.bounds];
        [yinhangView addSubview:scroll];
        for (int i = 0; i < [Singleton shared].gonggao.count; i++) {
            NSDictionary *dataDict = [Singleton shared].gonggao[i];
            UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(0.05*scroll.width, heightTo4_7(16)+heightTo4_7(100)*i, 0.9*scroll.width, heightTo4_7(84))];
            [aButton setBackgroundImage:[UIImage imageNamed:@"gg_frame"] forState:0];
            [scroll addSubview:aButton];
            
            UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7(40), 0.15*aButton.height, 0.7*aButton.height, 0.7*aButton.height)];
            logo.image = [UIImage imageNamed:@"gg_yj2"];
            [aButton addSubview:logo];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(logo.right+heightTo4_7(20), 0, aButton.width-(logo.right+heightTo4_7(30)), 0.6*aButton.height)];
            label.font = SystemFontBy4(12.0);
            label.textColor = [UIColor whiteColor];
            label.text = [dataDict stringForKey:@"title"];
            [aButton addSubview:label];
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(label.left, 0.6*aButton.height, label.width, 0.3*aButton.height)];
            time.textColor = ColorHex(0x999999);
            time.font = SystemFontBy4(10);
            time.text = [dataDict stringForKey:@"created_at"];
            [aButton addSubview:time];
            UILabel *chakan = [[UILabel alloc] initWithFrame:CGRectMake(0.75*aButton.width, 0.6*aButton.height, 0.25*aButton.width, 0.3*aButton.height)];
            chakan.text = @"点击查看";
            chakan.textColor = ColorHex(0xe8c042);
            chakan.font = time.font;
            [aButton addSubview:chakan];
            chakan.tag = 3456;
            aButton.tag = i;
            scroll.contentSize = CGSizeMake(scroll.width, aButton.bottom);
            
            [aButton handleCallBack:^(UIButton *button) {
                if (button.tag == 1234) {
                    for (UIButton *nnn in leftYinHangBg.subviews) {
                        if ([nnn isKindOfClass:[UIButton class]] && nnn.tag == 0) {
                            [self onGonggaoLeft:nnn];
                        }
                    }
                    return ;
                }
                
                UIView *temp = [button viewWithTag:3456];
                [temp removeFromSuperview];
                
                for (UIButton *theB in scroll.subviews) {
                    if ([theB isKindOfClass:[UIButton class]]) {
                        if (theB != button) {
                            [theB removeFromSuperview];
                        }
                    }
                }
                button.top = heightTo4_7(16);
                scroll.contentSize = CGSizeMake(scroll.width, scroll.height);
                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7(10), heightTo4_7(44), heightTo4_7(50), heightTo4_7(31))];
                arrow.image = [UIImage imageNamed:@"gg_arrow"];
                [yinhangView addSubview:arrow];
                
                UIView *vvvv = [[UIView alloc] initWithFrame:CGRectMake(button.left, button.bottom+heightTo4_7(16), button.width, scroll.height-(button.bottom+heightTo4_7(30)))];
                [scroll addSubview:vvvv];
                vvvv.clipsToBounds = YES;
                UIImageView *bg = [[UIImageView alloc] initWithFrame:vvvv.bounds];
                bg.image = [UIImage imageNamed:@"gg_bg"];
                [vvvv addSubview:bg];
                
                NSDictionary *dataDict = [Singleton shared].gonggao[button.tag];
                UILabel *neirong = [[UILabel alloc] initWithFrame:CGRectMake(heightTo4_7(15), heightTo4_7(60), bg.width-heightTo4_7(30), bg.height-heightTo4_7(70))];
                NSString *content = [dataDict stringForKey:@"content"];
                neirong.text = content;
                neirong.textColor = ColorHex(0xffffff);
                neirong.font = SystemFontBy4(12.6);
                neirong.numberOfLines = 0;
                [bg addSubview:neirong];
                CGSize size = [content getContentSizeWithFont:neirong.font andWidth:neirong.width andHeight:20000];
                neirong.height = size.height;
                CGFloat orH = vvvv.height;
                vvvv.height = 0;
                [UIView animateWithDuration:0.28 animations:^{
                    vvvv.height = orH;
                } completion:^(BOOL finished) {
                    EnlargeButton *close = [[EnlargeButton alloc] initWithFrame:CGRectMake(vvvv.right-heightTo4_7(24), vvvv.top-heightTo4_7(24), heightTo4_7(48), heightTo4_7(48))];
                    close.expandSpecs = 0.3*close.width;
                    [scroll addSubview:close];
                    [close setBackgroundImage:[UIImage imageNamed:@"gg_close"] forState:0];
                    [close handleCallBack:^(UIButton *button) {
                        for (UIButton *nnn in leftYinHangBg.subviews) {
                            if ([nnn isKindOfClass:[UIButton class]] && nnn.tag == 0) {
                                [self onGonggaoLeft:nnn];
                            }
                        }
                    } forEvent:UIControlEventTouchUpInside];
                }];
                button.tag = 1234;
            } forEvent:UIControlEventTouchUpInside];
            
            
        }
    }
    if (btn.tag == 1) {
        
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_Application_Did_Become_Active object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_Timer_1second object:nil];
}
@end
