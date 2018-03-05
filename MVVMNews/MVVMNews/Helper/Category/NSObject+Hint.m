
//
//  NSObject+Hint.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "NSObject+Hint.h"

@implementation NSObject (Hint)

- (void)showLoad {
    [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
}

- (void)hideLoad {
    [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
}

- (void)showSuccessWithMsg:(NSObject *)msg {
    [self hideLoad];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelText = msg.description;
    [progressHUD hide:YES afterDelay:toastDuration];
}

- (void)showErrorWithMsg:(NSObject *)msg {
    [self hideLoad];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelText = msg.description;
    [progressHUD hide:YES afterDelay:toastDuration];
}



//获取当前控制器的View
- (UIView *)currentView {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController]; //当前显示的控制器
    }
    if (!vc) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return vc.view;
}


@end
