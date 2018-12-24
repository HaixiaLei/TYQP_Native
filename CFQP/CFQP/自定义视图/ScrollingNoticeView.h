//
//  ScrollingNoticeView.h
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//

#import "BasicView.h"

//typedef void(^ScrollingNoticeFinished)(NSInteger count);

@interface ScrollingNoticeView : BasicView

@property(nonatomic, assign) CGFloat speed;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIView *scrollView;
//@property(nonatomic, copy) ScrollingNoticeFinished finishBlock;
@property(nonatomic, assign) NSInteger finishCount;

- (void)scrollWithMessages:(NSArray *)messages;
- (void)restart;

@end
