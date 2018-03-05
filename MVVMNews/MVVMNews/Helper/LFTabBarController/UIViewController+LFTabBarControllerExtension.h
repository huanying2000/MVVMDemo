//
//  UIViewController+LFTabBarControllerExtension.h
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LFPopSelectTabBarChildViewControllerCompletion)(__kindof UIViewController *selectedTabBarChildViewController);


@interface UIViewController (LFTabBarControllerExtension)

/*
 Pop 到当前 NavigationController 的栈底 并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param index 需要选择的控制器 在 TabBar 的index
 @return 最终被选择的控制器
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */

- (UIViewController *)lf_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index;

//和上面的效果一样 但是是Block形式
- (void)lf_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(LFPopSelectTabBarChildViewControllerCompletion)completion;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param classType 需要选择的控制器所属的类。
 @return 最终被选择的控制器。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (UIViewController *)lf_popSelectTabBarChildViewControllerForClassType:(Class)classType;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param classType 需要选择的控制器所属的类。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (void)lf_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(LFPopSelectTabBarChildViewControllerCompletion)completion;

@end
