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
    
    UIButton *button_cf;
    UIButton *button_vg;
    UIButton *button_ky;
    UIButton *button_qm;
    
    NSArray *annouceArray;
    UIView *gonggaoBg;
    ScrollingNoticeView *scrollingNoticeView;
    
    UIImageView *foot;
    ScrollingNoticeView *scrollingNoticeViewVVV;//偶然弹出的xxx获得100万
    NSInteger countdownVVV;
}

//判断和选择最佳域名
- (void)getYuming {
    if (Environment != 1) { //不是线上环境不管
        [self requests];
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.24*topImageView.width, topImageView.height)];
    [topImageView addSubview:loginButton];
    [loginButton addTarget:self action:@selector(onLoginButton) forControlEvents:UIControlEventTouchUpInside];
    
    
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
        [[Singleton shared] playBackgroundSound];
    }
    
    qiandaoButton = [[UIButton alloc] initWithFrame:CGRectMake(soundButton.right+heightTo4_7(38), soundButton.top, soundButton.width, soundButton.height)];
    [qiandaoButton setBackgroundImage:[UIImage imageNamed:@"home_qiandao"] forState:0];
    [qiandaoButton addTarget:self action:@selector(onQiandao) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:qiandaoButton];
    
    dailiButton = [[UIButton alloc] initWithFrame:CGRectMake(qiandaoButton.right+heightTo4_7(38), soundButton.top, soundButton.width, soundButton.height)];
    [dailiButton setBackgroundImage:[UIImage imageNamed:@"home_daili"] forState:0];
    [dailiButton addTarget:self action:@selector(onDaili) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:dailiButton];
    
    gonggaoButton = [[UIButton alloc] initWithFrame:CGRectMake(dailiButton.right+heightTo4_7(38), soundButton.top, soundButton.width, soundButton.height)];
    [gonggaoButton setBackgroundImage:[UIImage imageNamed:@"home_notice"] forState:0];
    [gonggaoButton addTarget:self action:@selector(onGonggao) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:gonggaoButton];
    
    lunboArray = [[NSMutableArray alloc] init];
    [lunboArray addObjectsFromArray:@[@"https://hg668888.firebaseapp.com/test/banner.png",
                                      @"https://hg668888.firebaseapp.com/test/banner.png",
                                      @"https://hg668888.firebaseapp.com/test/banner.png",
                                      @"https://hg668888.firebaseapp.com/test/banner.png",]];
    infiniteView = [[InfiniteScrollView alloc] initWithFrame:CGRectMake(heightTo4_7(86), heightTo4_7(176), heightTo4_7(302), heightTo4_7(380))];
    [infiniteView setupWithPageUrls:lunboArray shiftInterval:3.0 shiftDuration:0.5 callBack:^(NSInteger index) {
        
    }];
    [infiniteView setShiftEnable:YES];
    [self.view addSubview:infiniteView];
    
    UIImage *cf = [UIImage imageNamed:@"home_cf"];
    UIImage *vg = [UIImage imageNamed:@"home_vg"];
    UIImage *ky = [UIImage imageNamed:@"home_ky"];
    UIImage *qm = [UIImage imageNamed:@"home_qm"];
    
    CGFloat width_cf = heightTo4_7(200);
    image_cf = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(71), heightTo4_7(226), width_cf, cf.size.height/cf.size.width*width_cf)];
    image_cf.image = cf;
    [self.view addSubview:image_cf];
    
    CGFloat width_vg = 356.0/306*width_cf;
    image_vg = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(203), heightTo4_7(112), width_vg, vg.size.height/vg.size.width*width_vg)];
    image_vg.image = vg;
    [self.view addSubview:image_vg];
    
    CGFloat width_ky = 644.0/306*width_cf;
    image_ky = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(346), heightTo4_7(115), width_ky, ky.size.height/ky.size.width*width_ky)];
    image_ky.image = ky;
    [self.view addSubview:image_ky];
    
    CGFloat width_qm = 448.0/306*width_cf;
    image_qm = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(168), heightTo4_7(330), width_qm, qm.size.height/qm.size.width*width_qm)];
    image_qm.image = qm;
    [self.view addSubview:image_qm];
    
    image_cf.userInteractionEnabled = YES;
    image_vg.userInteractionEnabled = YES;
    image_ky.userInteractionEnabled = YES;
    image_qm.userInteractionEnabled = YES;
    button_cf = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.1*image_cf.height, 0.8*image_cf.width, 0.8*image_cf.height)];
    [button_cf addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [image_cf addSubview:button_cf];
    button_cf.tag = 0;
    
    button_vg = [[UIButton alloc] initWithFrame:CGRectMake(0.08*image_vg.width, 0, 0.8*image_vg.width, 0.9*image_vg.height)];
    [button_vg addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [image_vg addSubview:button_vg];
    button_vg.tag = 1;
    
    button_ky = [[UIButton alloc] initWithFrame:CGRectMake(0.15*image_ky.width, 0.06*image_ky.height, 0.72*image_ky.width, 0.84*image_ky.height)];
    [button_ky addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [image_ky addSubview:button_ky];
    button_ky.tag = 2;
    
    button_qm = [[UIButton alloc] initWithFrame:CGRectMake(0.15*image_qm.width, 0, 0.7*image_qm.width, image_qm.height)];
    [button_qm addTarget:self action:@selector(onGame:) forControlEvents:UIControlEventTouchUpInside];
    [image_qm addSubview:button_qm];
    button_qm.tag = 3;
    
    gonggaoBg = [[UIView alloc] initWithFrame:CGRectMake(-heightTo4_7(20), 0.914*self.view.height, heightTo4_7(360), heightTo4_7(46))];
    gonggaoBg.backgroundColor = ColorHexWithAlpha(0x000000, 0.3);
    gonggaoBg.layer.cornerRadius = heightTo4_7(10);
    gonggaoBg.layer.masksToBounds = YES;
    [self.view addSubview:gonggaoBg];
    UIImageView *loo = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7(28), heightTo4_7(7), heightTo4_7(40), heightTo4_7(34))];
    loo.image = [UIImage imageNamed:@"home_noicon"];
    [gonggaoBg addSubview:loo];
    annouceArray = @[@"环亚",@"公告个了算了关联了",@"关联送给你了",@"喂喂喂翁无多所多",];
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
        bg.backgroundColor = ColorHexWithAlpha(0x000000, 0.6);
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

#pragma mark
- (void)onPlayerCenterBank {
    UIImage *img = [UIImage imageNamed:@"login_bg"];
    CGFloat wid = heightTo4_7(650);
    CGFloat hig = img.size.height/img.size.width*wid;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    bg.userInteractionEnabled = YES;
    bg.center = CGPointMake(self.view.width/2, 0.45*self.view.height);
    bg.image = img;
    
    CGFloat closesize = 0.09*bg.width;
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(bg.width-closesize*0.6, -0.1*closesize, closesize, closesize)];
    [close setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [bg addSubview:close];
    [close handleCallBack:^(UIButton *button) {
        [bg.superview removeFromSuperview];
    } forEvent:UIControlEventTouchUpInside];
    
    
    
    
    [Tools popView:bg inView:self.view];
}
- (void)onPlayerCenterSecurity {
    
}
- (void)onPlayerCenterZhangbian {
    
}
- (void)onPlayerCenterKefu {
    
}

- (void)updateGonggao {
    [scrollingNoticeView removeFromSuperview];
    scrollingNoticeView = nil;
    scrollingNoticeView = [[ScrollingNoticeView alloc] initWithFrame:CGRectMake(heightTo4_7(74), 0, gonggaoBg.width-heightTo4_7(74), gonggaoBg.height)];
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
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(bg.width-closesize*0.6, -0.1*closesize, closesize, closesize)];
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
        [[Singleton shared] playBackgroundSound];
    }
}

- (void)onQiandao {
    
}

- (void)onDaili {
    
}

- (void)onGonggao {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_Application_Did_Become_Active object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_Timer_1second object:nil];
}
@end
