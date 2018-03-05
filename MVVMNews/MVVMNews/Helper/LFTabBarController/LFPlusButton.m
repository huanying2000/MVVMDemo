//
//  LFPlusButton.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "LFPlusButton.h"
#import "LFTabBarController.h"

CGFloat LFPlusButtonWidth = 0.0f;
UIButton<LFPlusButtonSubclassing> *LFExternPlusButton = nil;
UIViewController *LFPlusChildViewControlle = nil;


@implementation LFPlusButton

#pragma - mark -
#pragma mark - public Methods
+ (void)registerPlusButton {
    if (![self conformsToProtocol:@protocol(LFPlusButtonSubclassing)]) {
        return;
    }
    
    Class<LFPlusButtonSubclassing> class = self;
    UIButton<LFPlusButtonSubclassing> *plusButton = [class plusButton];
    LFExternPlusButton = plusButton;
    LFPlusButtonWidth = plusButton.frame.size.width;
    if ([[self class] respondsToSelector:@selector(plusChildViewController)]) {
        LFPlusChildViewControlle = [class plusChildViewController];
        [[self class] addSelectViewControllerTarget:plusButton];
        if ([[self class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
            LFPlusButtonIndex = [[self class] indexOfPlusButtonInTabBar];
        } else {
            [NSException raise:@"LFTabBarController" format:@"If you want to add PlusChildViewController, you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果你想使用PlusChildViewController样式，你必须同时在你自定义的plusButton中实现 `+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
    }
}

+ (void)registerSubclass {
    [self registerPlusButton];
}

- (void)plusChildViewControllerButtonClicked:(UIButton<LFPlusButtonSubclassing> *)sender {
    sender.selected = YES;
    [self lf_tabBarController].selectedIndex = LFPlusButtonIndex;
}

+ (void)addSelectViewControllerTarget:(UIButton<LFPlusButtonSubclassing> *)plusButton {
    id target = self;
    NSArray<NSString *> *selectorNamesArray = [plusButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    if (selectorNamesArray.count == 0) {
        target = plusButton;
        selectorNamesArray = [plusButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    }
    [selectorNamesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL selector =  NSSelectorFromString(obj);
        [plusButton removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }];
    [plusButton addTarget:plusButton action:@selector(plusChildViewControllerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


@end
