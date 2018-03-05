//
//  AppDelegate.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/23.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "WordController.h"
#import "VideoController.h"
#import "MyController.h"
#import "LFTabBarController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2];
    [self configGlobalUIStyle];
    [self setupViewControllers];
    self.window.rootViewController = self.tabBarController;
    return YES;
}


//配置导航栏
- (void)configGlobalUIStyle {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"backgroundImage"] forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)setupViewControllers {
    UINavigationController *navi0 = [HomeController defaultHomeNavi];
    UINavigationController *navi1 = [WordController defaultWordNavi];
    UINavigationController *navi2 = [VideoController defaultVideoNavi];
    UINavigationController *vc3 = [MyController defaultMyNavi];
    LFTabBarController *tbc = [LFTabBarController new];
    [self customTabBarForController:tbc];
    [tbc setViewControllers:@[navi0,navi1,navi2,vc3]];
    self.tabBarController = tbc;
}

- (void)customTabBarForController:(LFTabBarController *)tbc {
    NSDictionary *dict0 = @{LFTabBarItemTitle:@"首页",
                            LFTabBarItemImage:@"news",
                            LFTabBarItemSelectedImage:@"newsblue"};
    NSDictionary *dict1 = @{LFTabBarItemTitle:@"图文",
                            LFTabBarItemImage:@"live",
                            LFTabBarItemSelectedImage:@"liveblue"};
    NSDictionary *dict2 = @{LFTabBarItemTitle:@"视频",
                            LFTabBarItemImage:@"market",
                            LFTabBarItemSelectedImage:@"marketblue"};
    NSDictionary *dict3 = @{LFTabBarItemTitle:@"我的",
                            LFTabBarItemImage:@"my",
                            LFTabBarItemSelectedImage:@"myblue"};
    NSArray *tabBarItemsAttributes = @[dict0,dict1,dict2,dict3];
    tbc.tabBarItemsAttributes = tabBarItemsAttributes;
}

- (UIWindow *)window {
    if(_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (UITabBarController *)tabBarController {
    if(_tabBarController == nil) {
        _tabBarController = [[UITabBarController alloc] init];
    }
    return _tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
