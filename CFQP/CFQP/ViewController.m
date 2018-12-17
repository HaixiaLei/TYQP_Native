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

@interface ViewController ()

@property(nonatomic, strong)UIImageView *vvv;//偶然弹出的xxx获得100万

@end

@implementation ViewController {
    UIImageView *bgImageView;
    UIImageView *topImageView;
    UIButton *loginButton;//请先登录
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
    NSArray *annouceArrayVVV;
    NSInteger countdownVVV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateGonggao];
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
    
    
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenX?(0.2):(0.09))*loginButton.width, 0.125*loginButton.height, 0.70*loginButton.height, 0.7*topImageView.height)];
    head.image = [UIImage imageNamed:@"home_head"];
    [loginButton addSubview:head];
    head.layer.cornerRadius = 0.5*head.height;
    head.layer.masksToBounds = YES;
    
    UILabel *plslogin = [[UILabel alloc] initWithFrame:CGRectMake(head.right+heightTo4_7(15), 0, 100, loginButton.height*0.93)];
    plslogin.text = @"请先登录";
    plslogin.textColor = ColorHex(0xffffff);
    plslogin.font = SystemFontBy4(13.2);
    [loginButton addSubview:plslogin];
    
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
    
    exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.53*topImageView.width, (ScreenX?(0.13):(0.18))*topImageView.height, 0.1177*topImageView.width, (ScreenX?(0.68):(0.64))*topImageView.height)];
    [topImageView addSubview:exchangeButton];
    [exchangeButton setBackgroundImage:[UIImage imageNamed:@"home_exchange"] forState:0];
    [exchangeButton addTarget:self action:@selector(onExchange) forControlEvents:UIControlEventTouchUpInside];
    
    soundButton = [[UIButton alloc] initWithFrame:CGRectMake(0.708*topImageView.width, 0.05*topImageView.height, heightTo4_7(50), heightTo4_7(56.25))];
    [soundButton setBackgroundImage:[UIImage imageNamed:@"home_sound1"] forState:0];
    [soundButton setBackgroundImage:[UIImage imageNamed:@"home_sound0"] forState:UIControlStateSelected];
    [soundButton addTarget:self action:@selector(onSound) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:soundButton];
    
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
    
    annouceArrayVVV = @[@"恭喜XXX获得10万元！ 真TMD太神了！！！",];
    _vvv = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7(280), heightTo4_7(70), self.view.width-heightTo4_7(560), heightTo4_7(60))];
    _vvv.image = [UIImage imageNamed:@"home_vvv"];
    [self.view addSubview:_vvv];
    _vvv.hidden = YES;
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNotiApplicationDidBecomeActive:) name:Noti_Application_Did_Become_Active object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(on1SecondCountDown:) name:Noti_Timer_1second object:nil];
}

#pragma mark 接收到通知
- (void)onReceiveNotiApplicationDidBecomeActive:(NSNotification *)notification {
    NSLog(@"ViewController: ApplicationDidBecomeActive");
    
    [self updateGonggao];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
}

- (void)on1SecondCountDown:(NSNotification *)notification {
    ++countdownVVV;
    if (countdownVVV >= 10) {
        countdownVVV = -100;
        [self updateGonggaoVVV];
    }
}

- (void)onFootButton:(UIButton *)button {
    NSLog(@"on foot button: %li",button.tag);
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
    _vvv.hidden = NO;
    [scrollingNoticeViewVVV removeFromSuperview];
    scrollingNoticeViewVVV = nil;
    scrollingNoticeViewVVV = [[ScrollingNoticeView alloc] initWithFrame:CGRectMake(heightTo4_7(15), 0, _vvv.width-heightTo4_7(30), _vvv.height)];
    scrollingNoticeViewVVV.speed = 50.0;
    [_vvv addSubview:scrollingNoticeViewVVV];
    [scrollingNoticeViewVVV scrollWithMessages:annouceArrayVVV];
    [self performSelector:@selector(removeVVV) withObject:nil afterDelay:13];
}

- (void)removeVVV {
    [scrollingNoticeViewVVV removeFromSuperview];
    scrollingNoticeViewVVV = nil;
    _vvv.hidden = YES;
    countdownVVV = 0;
}

- (void)onLoginButton {
    
}

- (void)onRefresh {
    
}

- (void)onExchange {
    
}

- (void)onGame:(UIButton *)button {
    NSLog(@"button:%li",button.tag);
}

- (void)onSound {
    soundButton.selected = !soundButton.selected;
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
