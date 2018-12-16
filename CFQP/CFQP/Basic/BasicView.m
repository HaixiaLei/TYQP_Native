//
//  BasicView.m
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//

#import "BasicView.h"

@implementation BasicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
}

- (void)dealloc {
//    NSLog(@"---- 执行Dealloc方法 --- %@",NSStringFromClass([self class]));
}
@end
