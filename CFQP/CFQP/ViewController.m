//
//  ViewController.m
//  CFQP
//
//  Created by david on 2018/12/15.
//  Copyright © 2018 david. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteScrollView.h"

@interface ViewController ()

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

    
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
    
    
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenX?(0.2):(0.09))*loginButton.width, 0.095*loginButton.height, 0.76*loginButton.height, 0.76*topImageView.height)];
    head.image = [UIImage imageNamed:@"home_head"];
    [loginButton addSubview:head];
    head.layer.cornerRadius = 0.5*head.height;
    head.layer.masksToBounds = YES;
    
    UILabel *plslogin = [[UILabel alloc] initWithFrame:CGRectMake(head.right+heightTo4_7(13), 0, 100, loginButton.height*0.93)];
    plslogin.text = @"请先登录";
    plslogin.textColor = ColorHex(0xffffff);
    plslogin.font = SystemFontBy4(14.0);
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
    infiniteView = [[InfiniteScrollView alloc] initWithFrame:CGRectMake(heightTo4_7(90), heightTo4_7(170), heightTo4_7(300), heightTo4_7(390))];
    [infiniteView setupWithPageUrls:lunboArray shiftInterval:3.0 shiftDuration:0.5 callBack:^(NSInteger index) {
        
    }];
    [infiniteView setShiftEnable:YES];
    [self.view addSubview:infiniteView];
    
    UIImage *cf = [UIImage imageNamed:@"home_cf"];
    UIImage *vg = [UIImage imageNamed:@"home_vg"];
    UIImage *ky = [UIImage imageNamed:@"home_ky"];
    UIImage *qm = [UIImage imageNamed:@"home_qm"];
    
    CGFloat width_cf = heightTo4_7(200);
    image_cf = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(80), heightTo4_7(220), width_cf, cf.size.height/cf.size.width*width_cf)];
    image_cf.image = cf;
    [self.view addSubview:image_cf];
    
    CGFloat width_vg = 356.0/306*width_cf;
    image_vg = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(220), heightTo4_7(120), width_vg, vg.size.height/vg.size.width*width_vg)];
    image_vg.image = vg;
    [self.view addSubview:image_vg];
    
    CGFloat width_ky = 644.0/306*width_cf;
    image_ky = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(300), heightTo4_7(150), width_ky, ky.size.height/ky.size.width*width_ky)];
    image_ky.image = ky;
    [self.view addSubview:image_ky];
    
    CGFloat width_qm = 448.0/306*width_cf;
    image_qm = [[UIImageView alloc] initWithFrame:CGRectMake(infiniteView.right+heightTo4_7(180), heightTo4_7(280), width_qm, qm.size.height/qm.size.width*width_qm)];
    image_qm.image = qm;
    [self.view addSubview:image_qm];
}

- (void)onLoginButton {
    
}

- (void)onRefresh {
    
}

- (void)onExchange {
    
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
@end
