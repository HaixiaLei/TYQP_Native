//
//  ViewController.m
//  CFQP
//
//  Created by david on 2018/12/15.
//  Copyright © 2018 david. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 30, 20)];
    button.backgroundColor = ColorHex(0xff0000);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
    
    

}

- (void)button {
    [Tools alertWithTitle:@"屌" message:@"下降到两个" handle:^(UIAlertAction *action) {
        
    } cancel:@"取消" confirm:@"尺寸"];
}
@end
