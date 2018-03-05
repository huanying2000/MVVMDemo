//
//  LFTabBarController.h
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPlusButton.h"
#import "UIViewController+LFTabBarControllerExtension.h"

FOUNDATION_EXTERN NSString *const LFTabBarItemTitle;
FOUNDATION_EXTERN NSString *const LFTabBarItemImage;
FOUNDATION_EXTERN NSString *const LFTabBarItemSelectedImage;
FOUNDATION_EXTERN NSUInteger LFTabbarItemsCount;
FOUNDATION_EXTERN NSUInteger LFPlusButtonIndex;
FOUNDATION_EXTERN CGFloat LFPlusButtonWidth;
FOUNDATION_EXTERN CGFloat LFTabBarItemWidth;
FOUNDATION_EXTERN NSString *const LFTabBarItemWidthDidChangeNotification;

@interface LFTabBarController : UITabBarController

@property (nonatomic,readwrite,copy) NSArray <UIViewController *> * viewControllers;

@property (nonatomic,readwrite,copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

@property (nonatomic,assign) CGFloat tabBarHeight;

@property (nonatomic,readwrite,assign) UIEdgeInsets imageInsets;

@property (nonatomic,readwrite,assign) UIOffset titlePositionAdjustment;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;


+ (BOOL)havePlusButton;



+ (NSUInteger) allItemsInTabBarCount;

- (id<UIApplicationDelegate>)appDelegate;

- (UIWindow *)rootWindow;





@end

@interface NSObject (LFTabBarController)

/*!
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `CYLTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, readonly) LFTabBarController *lf_tabBarController;

@end

