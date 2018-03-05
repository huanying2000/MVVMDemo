//
//  AppDelegate+LFLog.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/23.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "AppDelegate+LFLog.h"

@implementation AppDelegate (LFLog)

- (void)initializeWithApplication:(UIApplication *)application {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

@end
