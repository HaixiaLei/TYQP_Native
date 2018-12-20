//
//  BasicNavigationController.m
//  DemonProject
//
//  Created by david on 2018/7/23.
//  Copyright © 2018年 david. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}



#pragma mark  UIGestureRecognizerDelegate

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) { //是为了解决右推返回的问题
        if (self.viewControllers.count == 1) {
            return NO;
        }
        
//        if ([self.topViewController isKindOfClass:NSClassFromString(@"LotteryViewController1")]) {
//            return NO;
//        }
    }
    return YES;
}

//// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//
//}
//
//// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
//// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
////
//// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//}
//
//// called once per attempt to recognize, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
//// return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
////
//// note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
//
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
//
//}
//
//
//
//// called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
//
//}



#pragma mark 屏幕方向
-(BOOL)shouldAutorotate
{
//    NSLog(@"11============= shouldAutorotate ");
    return [self.viewControllers.lastObject shouldAutorotate];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    NSLog(@"11============= supportedInterfaceOrientations ");
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    NSLog(@"%@==11==>旋转了哦",NSStringFromCGSize(size));
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
//    [self.viewControllers.lastObject viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
