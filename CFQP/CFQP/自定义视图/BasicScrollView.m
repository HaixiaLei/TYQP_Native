//
//  BasicScrollView.m
//  DemonProject
//
//  Created by david on 2018/7/13.
//  Copyright © 2018年 david. All rights reserved.
//

#import "BasicScrollView.h"

@implementation BasicScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];//KVO
        
        
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            [self setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            self.scrollsToTop = NO;
        }
#endif
    }
    return self;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}
@end
