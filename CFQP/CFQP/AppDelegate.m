//
//  AppDelegate.m
//  CFQP
//
//  Created by david on 2018/12/15.
//  Copyright © 2018 david. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[Singleton shared] setupTimerFor1Second];
    __weak id ws = self;
    mainDelegate = ws;
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Application_Did_Become_Active object:nil];
}

@end
