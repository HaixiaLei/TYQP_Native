//
//  GameButton.m
//  CFQP
//
//  Created by david on 2018/12/30.
//  Copyright © 2018 david. All rights reserved.
//

#import "GameButton.h"

@implementation GameButton {
    BOOL stop;
    BOOL isAnimating;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    NSLog(@"高亮:%i",highlighted);
    if (highlighted && (!isAnimating)) {
        NSLog(@"");
        isAnimating = YES;
        stop = NO;
        [self animatImageView];
    } else {
        isAnimating = NO;
        stop = YES;
    }
}

- (void)animatImageView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.myImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.myImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (!stop) {
                [self animatImageView];
            }
        }];
    }];
}



@end
