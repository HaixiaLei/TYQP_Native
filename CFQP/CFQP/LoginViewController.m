//
//  LoginViewController.m
//  CFQP
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import "LoginViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TouchID_FaceID.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController {
    UIImageView *zhuceView;
    UIImageView *zhanghaoView;
    UIImageView *mimazhaohuiView;
    NSInteger currentView;
    
    IQPreviousNextView *IQview;
    UITextField *tf_tuijian;
    UITextField *tf_zhanghao;
    UITextField *tf_mima;
    UITextField *tf_mima2;
    UITextField *tf_yanzhengma;
    
    UITextField *tf_denglu0;
    UITextField *tf_denglu1;
    UIButton *jizhuButton;
    UIButton *wangjiButton;
    UIImageView *checkbox;
    
    UIButton *buttonYanzhengma;
    
    
    UITextField *tfzh0;
    UITextField *tfzh1;
    UITextField *tfzh2;
    UITextField *tfzh3;
    UITextField *tfzh4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackground];
    [self setupButtons];
}

- (void)setupBackground {
    UIButton *bg = [[UIButton alloc] initWithFrame:self.view.bounds];
    [bg setBackgroundImage:[UIImage imageNamed:@"log_bg"] forState:0];
    [bg setBackgroundImage:[UIImage imageNamed:@"log_bg"] forState:UIControlStateHighlighted];
    [bg addTarget:self action:@selector(onBackground) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bg];
    
    UIImage *logo = [UIImage imageNamed:@"log_logo"];
    CGFloat logoW = heightTo4_7(240);
    CGFloat logoH = logo.size.height/logo.size.width*logoW;
    UIImageView *logov = [[UIImageView alloc] initWithFrame:CGRectMake(heightTo4_7(20), heightTo4_7(30), logoW, logoH)];
    logov.image = logo;
    [self.view addSubview:logov];
    
    UIImage *girl = [UIImage imageNamed:@"log_girl"];
    CGFloat girlw = heightTo4_7(800);
    CGFloat girlh = girl.size.height/girl.size.width*girlw;
    UIImageView *girlv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, girlw, girlh)];
    girlv.image = girl;
    [self.view addSubview:girlv];
    girlv.center = self.view.center;
}

- (void)setupButtons {
    UIImage *zc = [UIImage imageNamed:@"log_zc"];
    UIImage *zh = [UIImage imageNamed:@"log_zh"];
    UIImage *yk = [UIImage imageNamed:@"log_yk"];
    CGFloat left = heightTo4_7(230);
    CGFloat top = heightTo4_7(580);
    CGFloat bw = heightTo4_7(190);
    CGFloat bh = zc.size.height/zc.size.width*bw;
    CGFloat gap = (self.view.width-bw*3-left*2)/2;
    
    UIButton *buttonzc = [[UIButton alloc] initWithFrame:CGRectMake(left, top, bw, bh)];
    [buttonzc setBackgroundImage:zc forState:0];
    [buttonzc addTarget:self action:@selector(onZhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonzc];
    
    UIButton *buttonzh = [[UIButton alloc] initWithFrame:CGRectMake(left+bw+gap, top, bw, bh)];
    [buttonzh setBackgroundImage:zh forState:0];
    [buttonzh addTarget:self action:@selector(onZhanghao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonzh];
    
    UIButton *buttonyk = [[UIButton alloc] initWithFrame:CGRectMake(left+(bw+gap)*2, top, bw, bh)];
    [buttonyk setBackgroundImage:yk forState:0];
    [buttonyk addTarget:self action:@selector(onYouke) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonyk];
    
    //关闭
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(0.93*self.view.width, 0.03*self.view.height, heightTo4_7(50), heightTo4_7(50))];
    [close setBackgroundImage:[UIImage imageNamed:@"log_close"] forState:0];
    close.alpha = 0.36;
    [close addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tf_denglu0 ) {//如果删除了账号，账号不在记住
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *password = [[TouchID_FaceID shared] getPasswordForAccount:text];
        if (password) {
            tf_denglu1.text = password;
        }
    }
    return YES;
}

- (void)onBackground {
    [self.view resignKeyBoard];
}

- (void)closeView {
    [self.view resignKeyBoard];
    
    [zhanghaoView removeFromSuperview];
    zhanghaoView = nil;
    
    [zhuceView removeFromSuperview];
    zhuceView = nil;
    
    [mimazhaohuiView removeFromSuperview];
    mimazhaohuiView = nil;
    
    currentView = 0;
}

- (void)onZhuce {
    NSLog(@"注册按钮");
    if (currentView == 1) {
        return;
    }
    [self closeView];
    currentView = 1;
    
    UIImage *zhuce = [UIImage imageNamed:@"zhuce_bg"];
    CGFloat width = heightTo4_7(560);
    CGFloat height = zhuce.size.height/zhuce.size.width*width;
    zhuceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    zhuceView.userInteractionEnabled = YES;
    zhuceView.image = zhuce;
    zhuceView.center = CGPointMake(0.5*self.view.width, 0.438*self.view.height);
    [self.view addSubview:zhuceView];
    
    IQview = [[IQPreviousNextView alloc] initWithFrame:zhuceView.bounds];
    [zhuceView addSubview:IQview];
    
    UIImage *close = [UIImage imageNamed:@"zhuce_close"];
    CGFloat cw = 0.16*zhuceView.width;
    CGFloat ch = close.size.height/close.size.width*cw;
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(zhuceView.width-cw, 0, cw, ch)];
    [closeButton setBackgroundImage:close forState:0];
    [zhuceView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttontop = heightTo4_7(90);
    CGFloat buttonh = heightTo4_7(50);
    CGFloat buttongap = heightTo4_7(19);
    UIColor *color = ColorHex(0xa62e11);
    UIFont *font = SystemFontBy4(12.4);
    CGFloat leftWidth = 0.28*zhuceView.width;
    CGFloat rightWidth = 0.54*zhuceView.width;
    UILabel *zhucema = [[UILabel alloc] initWithFrame:CGRectMake(0, buttontop, leftWidth, buttonh)];
    zhucema.textAlignment = NSTextAlignmentRight;
    zhucema.textColor = color;
    zhucema.font = font;
    zhucema.text = @"推荐码";
    [IQview addSubview:zhucema];
    UIImageView *image0 = [[UIImageView alloc] initWithFrame:CGRectMake(zhucema.right+heightTo4_7(10), zhucema.top, rightWidth, zhucema.height)];
    image0.image = [UIImage imageNamed:@"zhuce_frame0"];
    image0.userInteractionEnabled = YES;
    [IQview addSubview:image0];
    tf_tuijian = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image0.width-heightTo4_7(15), image0.height)];
    tf_tuijian.placeholder = @"选填";
    tf_tuijian.textColor = ColorHex(0xffffff);
    tf_tuijian.font = font;
    tf_tuijian.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image0 addSubview:tf_tuijian];
    
    UILabel *zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(0, zhucema.bottom+buttongap, leftWidth, buttonh)];
    zhanghao.textAlignment = NSTextAlignmentRight;
    zhanghao.textColor = color;
    zhanghao.font = font;
    zhanghao.text = @"账号";
    [IQview addSubview:zhanghao];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(zhanghao.right+heightTo4_7(10), zhanghao.top, rightWidth, zhanghao.height)];
    image1.image = [UIImage imageNamed:@"zhuce_frame0"];
    image1.userInteractionEnabled = YES;
    [IQview addSubview:image1];
    tf_zhanghao = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image1.width-heightTo4_7(15), image1.height)];
    tf_zhanghao.placeholder = @"输入账号";
    tf_zhanghao.textColor = ColorHex(0xffffff);
    tf_zhanghao.font = font;
    tf_zhanghao.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image1 addSubview:tf_zhanghao];
    
    UILabel *sehzhi = [[UILabel alloc] initWithFrame:CGRectMake(0, zhanghao.bottom+buttongap, leftWidth, buttonh)];
    sehzhi.textAlignment = NSTextAlignmentRight;
    sehzhi.textColor = color;
    sehzhi.font = font;
    sehzhi.text = @"设置密码";
    [IQview addSubview:sehzhi];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(sehzhi.right+heightTo4_7(10), sehzhi.top, rightWidth, sehzhi.height)];
    image2.image = [UIImage imageNamed:@"zhuce_frame0"];
    image2.userInteractionEnabled = YES;
    [IQview addSubview:image2];
    tf_mima = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image2.width-heightTo4_7(15), image2.height)];
    tf_mima.placeholder = @"6-12个字母或数字";
    tf_mima.textColor = ColorHex(0xffffff);
    tf_mima.font = font;
    tf_mima.secureTextEntry = YES;
    tf_mima.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image2 addSubview:tf_mima];
    
    UILabel *sehzhi2 = [[UILabel alloc] initWithFrame:CGRectMake(0, sehzhi.bottom+buttongap, leftWidth, buttonh)];
    sehzhi2.textAlignment = NSTextAlignmentRight;
    sehzhi2.textColor = color;
    sehzhi2.font = font;
    sehzhi2.text = @"确认密码";
    [IQview addSubview:sehzhi2];
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(sehzhi2.right+heightTo4_7(10), sehzhi2.top, rightWidth, sehzhi2.height)];
    image3.image = [UIImage imageNamed:@"zhuce_frame0"];
    image3.userInteractionEnabled = YES;
    [IQview addSubview:image3];
    tf_mima2 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image3.width-heightTo4_7(15), image3.height)];
    tf_mima2.placeholder = @"再次输入密码";
    tf_mima2.textColor = ColorHex(0xffffff);
    tf_mima2.font = font;
    tf_mima2.secureTextEntry = YES;
    tf_mima2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image3 addSubview:tf_mima2];
    
    
    UILabel *yanzheng = [[UILabel alloc] initWithFrame:CGRectMake(0, sehzhi2.bottom+buttongap, leftWidth, buttonh)];
    yanzheng.textAlignment = NSTextAlignmentRight;
    yanzheng.textColor = color;
    yanzheng.font = font;
    yanzheng.text = @"验证码";
    [IQview addSubview:yanzheng];
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(yanzheng.right+heightTo4_7(10), yanzheng.top, rightWidth*0.52, yanzheng.height)];
    image4.image = [UIImage imageNamed:@"zhuce_frame1"];
    image4.userInteractionEnabled = YES;
    [IQview addSubview:image4];
    tf_yanzhengma = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image4.width-heightTo4_7(15), image4.height)];
    tf_yanzhengma.placeholder = @"输入验证码";
    tf_yanzhengma.textColor = ColorHex(0xffffff);
    tf_yanzhengma.font = font;
    tf_yanzhengma.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image4 addSubview:tf_yanzhengma];
    
    buttonYanzhengma = [[UIButton alloc] initWithFrame:CGRectMake(image4.right+heightTo4_7(15), image4.top, image3.right-(image4.right+heightTo4_7(15)), image4.height)];
    [IQview addSubview:buttonYanzhengma];
    [buttonYanzhengma addTarget:self action:@selector(onYanzhengma) forControlEvents:UIControlEventTouchUpInside];
    [self onYanzhengma];
    
    UIImage *conf = [UIImage imageNamed:@"zhuce_button"];
    CGFloat www = heightTo4_7(170);
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake((zhuceView.width-www)/2, yanzheng.bottom+buttongap*1.66, www, conf.size.height/conf.size.width*www)];
    [confirm addTarget:self action:@selector(onZhuceConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirm setBackgroundImage:conf forState:0];
    [zhuceView addSubview:confirm];
}

- (void)onYanzhengma {
    [NetworkBusiness validatecodeBlock:^(NSError *error, int code, id response) {
        if (!error) {
            if ([response isKindOfClass:[NSURL class]]) {
                NSURL *url = response;
                [buttonYanzhengma sd_setImageWithURL:url forState:0 placeholderImage:[UIImage imageNamed:@"findpass2"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                }];
            }
        }
    }];
}

- (void)onZhanghao {
    NSLog(@"账号按钮");
    if (currentView == 2) {
        return;
    }
    [self closeView];
    currentView = 2;
    
    UIImage *zhuce = [UIImage imageNamed:@"deng_bg"];
    CGFloat width = heightTo4_7(580);
    CGFloat height = zhuce.size.height/zhuce.size.width*width;
    zhanghaoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    zhanghaoView.userInteractionEnabled = YES;
    zhanghaoView.image = zhuce;
    zhanghaoView.center = CGPointMake(0.5*self.view.width, 0.438*self.view.height);
    [self.view addSubview:zhanghaoView];
    
    IQview = [[IQPreviousNextView alloc] initWithFrame:zhanghaoView.bounds];
    [zhanghaoView addSubview:IQview];
    
    UIImage *close = [UIImage imageNamed:@"zhuce_close"];
    CGFloat cw = 0.16*zhanghaoView.width;
    CGFloat ch = close.size.height/close.size.width*cw;
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(zhanghaoView.width-cw, 0, cw, ch)];
    [closeButton setBackgroundImage:close forState:0];
    [zhanghaoView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttontop = heightTo4_7(96);
    CGFloat buttonh = heightTo4_7(54);
    CGFloat buttongap = heightTo4_7(26);
    UIColor *color = ColorHex(0xa62e11);
    UIFont *font = SystemFontBy4(13.6);
    CGFloat leftWidth = 0.28*zhanghaoView.width;
    CGFloat rightWidth = 0.48*zhanghaoView.width;
    UILabel *zhucema = [[UILabel alloc] initWithFrame:CGRectMake(0, buttontop, leftWidth, buttonh)];
    zhucema.textAlignment = NSTextAlignmentRight;
    zhucema.textColor = color;
    zhucema.font = font;
    zhucema.text = @"账号";
    [IQview addSubview:zhucema];
    UIImageView *image0 = [[UIImageView alloc] initWithFrame:CGRectMake(zhucema.right+heightTo4_7(12), zhucema.top, rightWidth, zhucema.height)];
    image0.image = [UIImage imageNamed:@"zhuce_frame0"];
    image0.userInteractionEnabled = YES;
    [IQview addSubview:image0];
    tf_denglu0 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image0.width-heightTo4_7(15), image0.height)];
    tf_denglu0.placeholder = @"请输入账号";
    tf_denglu0.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf_denglu0.textColor = ColorHex(0xffffff);
    tf_denglu0.font = font;
    tf_denglu0.delegate = self;
    tf_denglu0.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image0 addSubview:tf_denglu0];
    
    UILabel *zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(0, zhucema.bottom+buttongap, leftWidth, buttonh)];
    zhanghao.textAlignment = NSTextAlignmentRight;
    zhanghao.textColor = color;
    zhanghao.font = font;
    zhanghao.text = @"密码";
    [IQview addSubview:zhanghao];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(zhanghao.right+heightTo4_7(12), zhanghao.top, rightWidth, zhanghao.height)];
    image1.image = [UIImage imageNamed:@"zhuce_frame0"];
    image1.userInteractionEnabled = YES;
    [IQview addSubview:image1];
    tf_denglu1 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image1.width-heightTo4_7(15), image1.height)];
    tf_denglu1.placeholder = @"请输入密码";
    tf_denglu1.secureTextEntry = YES;
    tf_denglu1.textColor = ColorHex(0xffffff);
    tf_denglu1.font = font;
    tf_denglu1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image1 addSubview:tf_denglu1];
    
    jizhuButton = [[UIButton alloc] initWithFrame:CGRectMake(image1.left, zhanghao.bottom, 0.4*image1.width, zhanghao.height)];
    [jizhuButton addTarget:self action:@selector(onJizhu:) forControlEvents:UIControlEventTouchUpInside];
    [IQview addSubview:jizhuButton];
    jizhuButton.selected = YES;
    checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(0, (jizhuButton.height-heightTo4_7(24))/2, heightTo4_7(24), heightTo4_7(24))];
    checkbox.image = [UIImage imageNamed:@"deng_check1"];
    [jizhuButton addSubview:checkbox];
    UILabel *jizl = [[UILabel alloc] initWithFrame:CGRectMake(checkbox.right+heightTo4_7(8), 0, 80, jizhuButton.height)];
    jizl.text = @"记住密码";
    jizl.textColor = color;
    jizl.font = SystemFontBy4(12.0);
    [jizhuButton addSubview:jizl];
    
    wangjiButton = [[UIButton alloc] initWithFrame:CGRectMake(jizhuButton.right+0.2*image1.width, jizhuButton.top, jizhuButton.width, jizhuButton.height)];
    [wangjiButton addTarget:self action:@selector(onWangji) forControlEvents:UIControlEventTouchUpInside];
    [IQview addSubview:wangjiButton];
    UILabel *wwj = [[UILabel alloc] initWithFrame:wangjiButton.bounds];
    wwj.textAlignment = NSTextAlignmentRight;
    wwj.text = @"忘记密码";
    wwj.textColor = color;
    wwj.font = SystemFontBy4(12.0);
    [wangjiButton addSubview:wwj];
    
    UIImage *conf = [UIImage imageNamed:@"deng_button"];
    CGFloat www = heightTo4_7(170);
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake((zhanghaoView.width-www)/2, 0.76*zhanghaoView.height, www, conf.size.height/conf.size.width*www)];
    [confirm addTarget:self action:@selector(onZhangHaoConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirm setBackgroundImage:conf forState:0];
    [zhanghaoView addSubview:confirm];
    
    UIImage *jiaru = [UIImage imageNamed:@"deng_jia"];
    CGFloat jw = heightTo4_7(146);
    CGFloat jh = jiaru.size.height/jiaru.size.width*jw;
    UIImageView *jiaruyx = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, jw, jh)];
    jiaruyx.image = jiaru;
    [zhanghaoView addSubview:jiaruyx];
    jiaruyx.center = CGPointMake(0.15*zhanghaoView.width, 0.76*zhanghaoView.height);
    
    //设置上次登录的账号密码
    NSString *lastAccout = [Singleton shared].UserName;
    if (lastAccout.length) {
        NSString *lastPass = [[TouchID_FaceID shared] getPasswordForAccount:lastAccout];
        if (lastPass.length) {
            tf_denglu0.text = lastAccout;
            tf_denglu1.text = lastPass;
        }
    }
}

- (void)onJizhu:(UIButton *)button {
    jizhuButton.selected = !jizhuButton.selected;
    if (jizhuButton.selected) {
        checkbox.image = [UIImage imageNamed:@"deng_check1"];
    } else {
        checkbox.image = [UIImage imageNamed:@"deng_check0"];
    }
}

- (void)onWangji {
    NSLog(@"密码找回");
    if (currentView == 3) {
        return;
    }
    [self closeView];
    currentView = 3;
    
    UIImage *zhuce = [UIImage imageNamed:@"findpass0"];
    CGFloat width = heightTo4_7(560);
    CGFloat height = zhuce.size.height/zhuce.size.width*width;
    mimazhaohuiView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    mimazhaohuiView.userInteractionEnabled = YES;
    mimazhaohuiView.image = zhuce;
    mimazhaohuiView.center = CGPointMake(0.5*self.view.width, 0.438*self.view.height);
    [self.view addSubview:mimazhaohuiView];
    
    IQview = [[IQPreviousNextView alloc] initWithFrame:mimazhaohuiView.bounds];
    [mimazhaohuiView addSubview:IQview];
    
    UIImage *close = [UIImage imageNamed:@"zhuce_close"];
    CGFloat cw = 0.16*mimazhaohuiView.width;
    CGFloat ch = close.size.height/close.size.width*cw;
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(mimazhaohuiView.width-cw, 0, cw, ch)];
    [closeButton setBackgroundImage:close forState:0];
    [mimazhaohuiView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttontop = heightTo4_7(90);
    CGFloat buttonh = heightTo4_7(50);
    CGFloat buttongap = heightTo4_7(19);
    UIColor *color = ColorHex(0xa62e11);
    UIFont *font = SystemFontBy4(12.4);
    CGFloat leftWidth = 0.28*mimazhaohuiView.width;
    CGFloat rightWidth = 0.54*mimazhaohuiView.width;
    UILabel *zhucema = [[UILabel alloc] initWithFrame:CGRectMake(0, buttontop, leftWidth, buttonh)];
    zhucema.textAlignment = NSTextAlignmentRight;
    zhucema.textColor = color;
    zhucema.font = font;
    zhucema.text = @"账号";
    [IQview addSubview:zhucema];
    UIImageView *image0 = [[UIImageView alloc] initWithFrame:CGRectMake(zhucema.right+heightTo4_7(10), zhucema.top, rightWidth, zhucema.height)];
    image0.image = [UIImage imageNamed:@"zhuce_frame0"];
    image0.userInteractionEnabled = YES;
    [IQview addSubview:image0];
    tfzh0 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image0.width-heightTo4_7(15), image0.height)];
    tfzh0.placeholder = @"输入会员账号";
    tfzh0.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tfzh0.textColor = ColorHex(0xffffff);
    tfzh0.font = font;
    tfzh0.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image0 addSubview:tfzh0];
    
    UILabel *zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(0, zhucema.bottom+buttongap, leftWidth, buttonh)];
    zhanghao.textAlignment = NSTextAlignmentRight;
    zhanghao.textColor = color;
    zhanghao.font = font;
    zhanghao.text = @"真实姓名";
    [IQview addSubview:zhanghao];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(zhanghao.right+heightTo4_7(10), zhanghao.top, rightWidth, zhanghao.height)];
    image1.image = [UIImage imageNamed:@"zhuce_frame0"];
    image1.userInteractionEnabled = YES;
    [IQview addSubview:image1];
    tfzh1 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image1.width-heightTo4_7(15), image1.height)];
    tfzh1.placeholder = @"请输入真实姓名";
    tfzh1.textColor = ColorHex(0xffffff);
    tfzh1.font = font;
    tfzh1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image1 addSubview:tfzh1];
    
    UILabel *sehzhi = [[UILabel alloc] initWithFrame:CGRectMake(0, zhanghao.bottom+buttongap, leftWidth, buttonh)];
    sehzhi.textAlignment = NSTextAlignmentRight;
    sehzhi.textColor = color;
    sehzhi.font = font;
    sehzhi.text = @"提款密码";
    [IQview addSubview:sehzhi];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(sehzhi.right+heightTo4_7(10), sehzhi.top, rightWidth, sehzhi.height)];
    image2.image = [UIImage imageNamed:@"zhuce_frame0"];
    image2.userInteractionEnabled = YES;
    [IQview addSubview:image2];
    tfzh2 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image2.width-heightTo4_7(15), image2.height)];
    tfzh2.placeholder = @"4-6个纯数字";
    tfzh2.textColor = ColorHex(0xffffff);
    tfzh2.font = font;
    tfzh2.secureTextEntry = YES;
    tfzh2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image2 addSubview:tfzh2];
    
    UILabel *sehzhi2 = [[UILabel alloc] initWithFrame:CGRectMake(0, sehzhi.bottom+buttongap, leftWidth, buttonh)];
    sehzhi2.textAlignment = NSTextAlignmentRight;
    sehzhi2.textColor = color;
    sehzhi2.font = font;
    sehzhi2.text = @"新密码";
    [IQview addSubview:sehzhi2];
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(sehzhi2.right+heightTo4_7(10), sehzhi2.top, rightWidth, sehzhi2.height)];
    image3.image = [UIImage imageNamed:@"zhuce_frame0"];
    image3.userInteractionEnabled = YES;
    [IQview addSubview:image3];
    tfzh3 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image3.width-heightTo4_7(15), image3.height)];
    tfzh3.placeholder = @"4-12个字母或数字";
    tfzh3.textColor = ColorHex(0xffffff);
    tfzh3.font = font;
    tfzh3.secureTextEntry = YES;
    tfzh3.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image3 addSubview:tfzh3];
    
    
    UILabel *yanzheng = [[UILabel alloc] initWithFrame:CGRectMake(0, sehzhi2.bottom+buttongap, leftWidth, buttonh)];
    yanzheng.textAlignment = NSTextAlignmentRight;
    yanzheng.textColor = color;
    yanzheng.font = font;
    yanzheng.text = @"确认密码";
    [IQview addSubview:yanzheng];
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(yanzheng.right+heightTo4_7(10), yanzheng.top, rightWidth, yanzheng.height)];
    image4.image = [UIImage imageNamed:@"zhuce_frame1"];
    image4.userInteractionEnabled = YES;
    [IQview addSubview:image4];
    tfzh4 = [[UITextField alloc] initWithFrame:CGRectMake(heightTo4_7(10), 0, image4.width-heightTo4_7(15), image4.height)];
    tfzh4.placeholder = @"再次输入新密码";
    tfzh4.textColor = ColorHex(0xffffff);
    tfzh4.font = font;
    tfzh4.clearButtonMode = UITextFieldViewModeWhileEditing;
    [image4 addSubview:tfzh4];
    
    UIImage *conf = [UIImage imageNamed:@"findpass1"];
    CGFloat www = heightTo4_7(170);
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake((mimazhaohuiView.width-www)/2, yanzheng.bottom+buttongap*1.66, www, conf.size.height/conf.size.width*www)];
    [confirm addTarget:self action:@selector(onMimaZhaohuiConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirm setBackgroundImage:conf forState:0];
    [mimazhaohuiView addSubview:confirm];
}

/*找回密码*/
- (void)onMimaZhaohuiConfirm {
    if (!tfzh0.text.length) {
        [Tools showText:@"请输入账号"];
        return;
    }
    
    if (!tfzh1.text.length) {
        [Tools showText:@"请输入真实姓名"];
        return;
    }
    
    if (!tfzh2.text.length) {
        [Tools showText:@"请输入提款密码"];
        return;
    }
    
    if (!tfzh3.text.length) {
        [Tools showText:@"请输入新密码"];
        return;
    }
    
    if (!tfzh4.text.length) {
        [Tools showText:@"请再次输入新密码"];
        return;
    }
    
    if (![tfzh3.text isEqualToString:tfzh4.text]) {
        [Tools showText:@"两次输入的密码不一致"];
        return;
    }
    
    [NetworkBusiness forget_pwd:tfzh0.text realname:tfzh1.text withdraw_password:tfzh2.text new_password:tfzh3.text Block:^(NSError *error, int code, id response) {
        if (code == 200) {
            NSString *descripe = [response stringForKey:@"describe"];
            [Tools showText:descripe];
            NSInteger status = [response integerForKey:@"status"];
            if (status == 200) { //登录成功
                [Singleton shared].isShiwan = NO;
                [Singleton shared].isLogin = YES;
                if (jizhuButton.selected) {
                    [[TouchID_FaceID shared] setAccount:tfzh0.text withPassword:tfzh3.text];
                } else {
                    [[TouchID_FaceID shared] setAccount:tfzh0.text withPassword:@""];
                }
                [self setValuesWithDict:[response objectForKey:@"data"]];
                [self quit];
            }
        }
    }];
}

/*账号登录*/
- (void)onZhangHaoConfirm {
    if (!tf_denglu0.text.length) {
        [Tools showText:@"请输入账号"];
        return;
    }
    
    if (!tf_denglu1.text.length) {
        [Tools showText:@"请输入密码"];
        return;
    }
    [NetworkBusiness loginUsername:tf_denglu0.text passwd:tf_denglu1.text sign:nil Block:^(NSError *error, int code, id response) {
        if (code == 200) {
            NSString *descripe = [response stringForKey:@"describe"];
            [Tools showText:descripe];
            NSInteger status = [response integerForKey:@"status"];
            if (status == 200) { //登录成功
                [Singleton shared].isShiwan = NO;
                [Singleton shared].isLogin = YES;
                if (jizhuButton.selected) {
                    [[TouchID_FaceID shared] setAccount:tf_denglu0.text withPassword:tf_denglu1.text];
                } else {
                    [[TouchID_FaceID shared] setAccount:tf_denglu0.text withPassword:@""];
                }
                [self setValuesWithDict:[response objectForKey:@"data"]];
                [self quit];
            }
        }
    }];
}

- (void)setValuesWithDict:(NSDictionary *)dict {
    [Singleton shared].Agents = [dict stringForKey:@"Agents"];
    [Singleton shared].isTest = [dict stringForKey:@"isTest"];
    [Singleton shared].Money = [dict stringForKey:@"Money"];
    [Singleton shared].lastLoginTime = [dict stringForKey:@"lastLoginTime"];
    [Singleton shared].Oid = [dict stringForKey:@"Oid"];
    [Singleton shared].Alias = [dict stringForKey:@"Alias"];
    [Singleton shared].isBindCard = [dict stringForKey:@"isBindCard"];
    [Singleton shared].UserName = [dict stringForKey:@"UserName"];
    [Singleton shared].LoginTime = [dict stringForKey:@"LoginTime"];
}

/*注册*/
- (void)onZhuceConfirm {
    NSLog(@"游客按钮");
    
    if (!tf_tuijian.text.length) {
        [Tools showText:@"请输入推荐人"];
        return;
    }
    
    if (!tf_zhanghao.text.length) {
        [Tools showText:@"请输入账号"];
        return;
    }
    
    if (!tf_mima.text.length) {
        [Tools showText:@"请输入密码"];
        return;
    }
    
    if (!tf_mima2.text.length) {
        [Tools showText:@"请再次输入密码"];
        return;
    }
    
    if (![tf_mima.text isEqualToString:tf_mima2.text]) {
        [Tools showText:@"两次输入的密码不一致"];
        return;
    }
    
    if (!tf_yanzhengma.text.length) {
        [Tools showText:@"请再次输入验证码"];
        return;
    }
    
    [NetworkBusiness registerReference:tf_tuijian.text username:tf_zhanghao.text password:tf_mima.text verifycode:tf_yanzhengma.text Block:^(NSError *error, int code, id response) {
        if (code == 200) {
            NSString *descripe = [response stringForKey:@"describe"];
            [Tools showText:descripe];
            
            NSInteger status = [response integerForKey:@"status"];
            if (status == 200) { //登录成功
                [Singleton shared].isShiwan = NO;
                [Singleton shared].isLogin = YES;
                if (jizhuButton.selected) {
                    [[TouchID_FaceID shared] setAccount:tf_zhanghao.text withPassword:tf_mima.text];
                } else {
                    [[TouchID_FaceID shared] setAccount:tf_zhanghao.text withPassword:@""];
                }
                [self setValuesWithDict:[response objectForKey:@"data"]];
                [self quit];
            }
        }
    }];
}

/*游客登录*/
- (void)onYouke {
    NSLog(@"游客按钮");
    [NetworkBusiness loginUsername:@"travelVIP" passwd:@"____" sign:@"posthasteTry" Block:^(NSError *error, int code, id response) {
        if (code == 200) {
            NSString *descripe = [response stringForKey:@"describe"];
            [Tools showText:descripe];
            NSInteger status = [response integerForKey:@"status"];
            if (status == 200) { //登录成功
                [Singleton shared].isShiwan = YES;
                [Singleton shared].isLogin = YES;
                [self setValuesWithDict:[response objectForKey:@"data"]];
                [self quit];
            }
        }
    }];
}

- (void)onClose {
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.8f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    transition.type = @"kCATransitionReveal";
//    transition.subtype = kCATransitionFromRight;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    if (currentView > 0) {
        [self closeView];
    } else {
        [self quit];
    }
}

- (void)quit {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
