//
//  ScrollingNoticeView.m
//  DemonProject
//
//  Created by david on 2018/7/10.
//  Copyright © 2018年 david. All rights reserved.
//

#import "ScrollingNoticeView.h"

@implementation ScrollingNoticeView {
    NSMutableArray *messageArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)scrollWithMessages:(NSArray *)messages {
    if (!messageArray) {
        messageArray = [[NSMutableArray alloc] init];
    }
    [messageArray removeAllObjects];
    [messageArray addObjectsFromArray:messages];
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    _scrollView = [[UIView alloc] initWithFrame:self.bounds];
    _scrollView.clipsToBounds = NO;
    [self addSubview:_scrollView];
    
    CGFloat left = 0;
    UIFont *font = SystemFontBy4(13);
    if (_font) {
        font = _font;
    }
    for (int i = 0; i < messageArray.count; i++) {
        NSString *mes = messageArray[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 100, self.height)];
        label.font = font;
        label.text = mes;
        [label sizeToFit];
        CGFloat realWidth = label.width;
        label.frame = CGRectMake(left, 0, realWidth+self.width*((i == (messageArray.count-1))?(0.2):(0.6)), self.height);

        label.textColor = ColorHex(0x444444);
        [_scrollView addSubview:label];
        _scrollView.width = label.right;
        left = label.right;
        
//        NSLog(@"左边:%f,,,label宽:%f,,,,scroll:%f",label.left,label.width,_scrollView.width);
        
    }
    
    //调节滚动的速度 快慢
    CGFloat duration = _scrollView.width/(IsIpad?(_speed*1.35):_speed);
    
    _scrollView.left = self.width;
    __weak ScrollingNoticeView *ws = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        ws.scrollView.right = 0;
    } completion:^(BOOL finished) {
        ws.scrollView.left = ws.width;
    }];
}
- (void)restart {
    if (messageArray.count) {
        NSArray *mess = [NSArray arrayWithArray:messageArray];
        [self scrollWithMessages:mess];
    }
}
@end
