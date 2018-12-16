//
//  ScrollingNoticeView.h
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//

#import "BasicView.h"

@interface ScrollingNoticeView : BasicView

@property(nonatomic, assign) CGFloat speed;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIView *scrollView; 

- (void)scrollWithMessages:(NSArray *)messages;
- (void)restart;

@end
