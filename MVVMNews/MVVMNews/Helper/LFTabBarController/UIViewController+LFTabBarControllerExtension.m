//
//  UIViewController+LFTabBarControllerExtension.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "UIViewController+LFTabBarControllerExtension.h"
#import "LFTabBarController.h"

@implementation UIViewController (LFTabBarControllerExtension)

- (UIViewController *)lf_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index {
    [self checkTabBarChildControllerValidityAtIndex:index];
    [self.navigationController popToRootViewControllerAnimated:NO];
    LFTabBarController *tabBarController = [self lf_tabBarController];
    tabBarController.selectedIndex = index;
    UIViewController *selectedTabBarChildViewController = tabBarController.selectedViewController;
    BOOL isNavigationController = [[selectedTabBarChildViewController class] isSubclassOfClass:[UINavigationController class]];
    if (isNavigationController) {
        return ((UINavigationController *)selectedTabBarChildViewController).viewControllers[0];
    }
    return selectedTabBarChildViewController;
}
- (void)lf_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(LFPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self lf_popSelectTabBarChildViewControllerAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (UIViewController *)lf_popSelectTabBarChildViewControllerForClassType:(Class)classType {
    LFTabBarController *tabBarController = [self lf_tabBarController];
    __block NSInteger atIndex = NSNotFound;
    [tabBarController.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj_ = nil;
        BOOL isNavigationController = [[tabBarController.viewControllers[idx] class] isSubclassOfClass:[UINavigationController class]];
        if (isNavigationController) {
            obj_ = ((UINavigationController *)obj).viewControllers[0];
        } else {
            obj_ = obj;
        }
        if ([obj_ isKindOfClass:classType]) {
            atIndex = idx;
            *stop = YES;
            return;
        }
    }];
    
    return [self lf_popSelectTabBarChildViewControllerAtIndex:atIndex];
}

- (void)cyl_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(LFPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self lf_popSelectTabBarChildViewControllerForClassType:classType];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}


- (void)checkTabBarChildControllerValidityAtIndex:(NSUInteger)index {
    LFTabBarController *tabBarController = [self lf_tabBarController];
    @try {
        UIViewController *viewController;
        viewController = tabBarController.viewControllers[index];
        if (index != tabBarController.selectedIndex) {
            LFExternPlusButton.selected = NO;
        }
    } @catch (NSException *exception) {
        NSString *formatString = @"\n\n\
        ------ BEGIN NSException Log ---------------------------------------------------------------------\n \
        class name: %@                                                                                    \n \
        ------line: %@                                                                                    \n \
        ----reason: The Class Type or the index or its NavigationController you pass in method `-cyl_popSelectTabBarChildViewControllerAtIndex` or `-cyl_popSelectTabBarChildViewControllerForClassType` is not the item of CYLTabBarViewController \n \
        ------ END ---------------------------------------------------------------------------------------\n\n";
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__)];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
}


@end
