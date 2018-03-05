 //
//  LFTabBarController.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "LFTabBarController.h"
#import "LFTabBar.h"
#import <objc/runtime.h>

NSString *const LFTabBarItemTitle = @"CYLTabBarItemTitle";
NSString *const LFTabBarItemImage = @"CYLTabBarItemImage";
NSString *const LFTabBarItemSelectedImage = @"CYLTabBarItemSelectedImage";

NSUInteger LFTabbarItemsCount = 0;
NSUInteger LFPlusButtonIndex = 0;
CGFloat LFTabBarItemWidth = 0.0f;
// TabBarItemWidth 改变的通知标志
NSString *const LFTabBarItemWidthDidChangeNotification = @"LFTabBarItemWidthDidChangeNotification";

static void * const LFSwappableImageViewDefaultOffsetContext = (void*)&LFSwappableImageViewDefaultOffsetContext;


@interface NSObject (LFTabBarControllerItemInternal)

- (void)lf_setTabBarController:(LFTabBarController *)tabBarController;

@end

@interface LFTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, assign, getter=isObservingSwappableImageViewDefaultOffset) BOOL observingSwappableImageViewDefaultOffset;

@end

@implementation LFTabBarController

@synthesize viewControllers = _viewControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    //处理 tabBar 使用自定义 tabBar 添加发布按钮
    [self setUpTabBar];
    //KVO 监听
    if (!self.isObservingSwappableImageViewDefaultOffset) {
        [self.tabBar addObserver:self forKeyPath:@"swappableImageViewDefaultOffset" options:NSKeyValueObservingOptionNew context:LFSwappableImageViewDefaultOffsetContext];
        self.observingSwappableImageViewDefaultOffset = YES;
    }
    self.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [self.tabBar layoutSubviews];
}

- (void)viewWillLayoutSubviews {
    if (!self.tabBarHeight) {
        return;
    }
    self.tabBar.frame = ({
        CGRect frame = self.tabBar.frame;
        CGFloat tabBarHeight = self.tabBarHeight;
        frame.size.height = tabBarHeight;
        frame.origin.y = self.view.frame.size.height - tabBarHeight;
        frame;
    });
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *controller = self.selectedViewController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)controller;
        return navi.topViewController.supportedInterfaceOrientations;
    }else {
        return controller.supportedInterfaceOrientations;
    }
}


- (void)dealloc {
    // KVO反注册
    if (self.isObservingSwappableImageViewDefaultOffset) {
        [self.tabBar removeObserver:self forKeyPath:@"swappableImageViewDefaultOffset"];
    }
}

#pragma mark - public Methods
- (instancetype) initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
    self = [super init];
    if (self) {
        _tabBarItemsAttributes = tabBarItemsAttributes;
        self.viewControllers = viewControllers;
    }
    return self;
}

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
    return [[self alloc] initWithViewControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes];
}

+ (BOOL)havePlusButton {
    if (LFExternPlusButton) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)allItemsInTabBarCount {
    NSUInteger allItemsInTabBar = LFTabbarItemsCount;
    if ([LFTabBarController havePlusButton]) {
        allItemsInTabBar += 1;
    }
    return allItemsInTabBar;
}


- (id<UIApplicationDelegate>)appDelegate {
    return [UIApplication sharedApplication].delegate;
}


- (UIWindow *)rootWindow {
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    return result;
}

#pragma mark -
#pragma mark - Private Methods

- (void)setUpTabBar {
    [self setValue:[[LFTabBar alloc] init] forKey:@"tabBar"];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        if ((!_tabBarItemsAttributes) || (_tabBarItemsAttributes.count != viewControllers.count)) {
            [NSException raise:@"LFTabBarController" format:@"The count of CYLTabBarControllers is not equal to the count of tabBarItemsAttributes.【Chinese】设置_tabBarItemsAttributes属性时，请确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
        }
        if (LFPlusChildViewControlle) {
            NSMutableArray *viewControllersWithPlusButton = [NSMutableArray arrayWithArray:viewControllers];
            [viewControllersWithPlusButton insertObject:LFPlusChildViewControlle atIndex:LFPlusButtonIndex];
            _viewControllers = [viewControllersWithPlusButton copy];
        }else {
            _viewControllers = [viewControllers copy];
        }
        LFTabbarItemsCount = [viewControllers count];
        LFTabBarItemWidth = ([UIScreen mainScreen].bounds.size.width - LFPlusButtonWidth) / (LFTabbarItemsCount);
        NSUInteger idx = 0;
        for (UIViewController *viewController in viewControllers) {
            NSString *title = nil;
            NSString *normalImageName = nil;
            NSString *selectedImageName = nil;
            if (viewController != LFPlusChildViewControlle) {
                title = _tabBarItemsAttributes[idx][LFTabBarItemTitle];
                normalImageName = _tabBarItemsAttributes[idx][LFTabBarItemImage];
                selectedImageName = _tabBarItemsAttributes[idx][LFTabBarItemSelectedImage];
            }else {
                idx --;
            }
            [self addOneChildViewController:viewController
                                  WithTitle:title
                            normalImageName:normalImageName
                          selectedImageName:selectedImageName];
            [viewController lf_setTabBarController:self];
            idx++;
        }
    }else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController lf_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

/*
 UIImageRenderingMode
 typedef NS_ENUM(NSInteger, UIImageRenderingMode) {
 UIImageRenderingModeAutomatic,//根据图片的使用环境和所处的绘图上下文自动调整渲染模式 是默认值
 UIImageRenderingModeAlwaysOriginal,     // 始终绘制图片原始状态，不使用Tint Color
 UIImageRenderingModeAlwaysTemplate,     // 始终根据Tint Color绘制图片，忽略图片的颜色信息
 }
 */
//添加一个控制器
- (void)addOneChildViewController:(UIViewController *)viewController
                        WithTitle:(NSString *)title
                  normalImageName:(NSString *)normalImageName
                selectedImageName:(NSString *)selectedImageName {
    viewController.tabBarItem.title = title;
    if (normalImageName) {
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.image = normalImage;
    }
    
    if (selectedImageName) {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = selectedImage;
    }
    
    if ([self shouldCustomizeImageInsets]) {
        viewController.tabBarItem.imageInsets = self.imageInsets;
    }
    if (self.shouldCustomizeTitlePositionAdjustment) {
        viewController.tabBarItem.titlePositionAdjustment = self.titlePositionAdjustment;
    }
    [self addChildViewController:viewController];
}


- (BOOL)shouldCustomizeImageInsets {
    BOOL shouldCustomizeImageInsets = self.imageInsets.top != 0.f || self.imageInsets.left != 0.f || self.imageInsets.bottom != 0.f || self.imageInsets.right != 0.f;
    return shouldCustomizeImageInsets;
}

- (BOOL)shouldCustomizeTitlePositionAdjustment {
    BOOL shouldCustomizeTitlePositionAdjustment = self.titlePositionAdjustment.horizontal != 0.f || self.titlePositionAdjustment.vertical != 0.f;
    return shouldCustomizeTitlePositionAdjustment;
}

#pragma mark - KVO Method

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != LFSwappableImageViewDefaultOffsetContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == LFSwappableImageViewDefaultOffsetContext) {
        CGFloat swappableImageViewDefaultOffset = [change[NSKeyValueChangeNewKey] floatValue];
        [self offsetTabBarSwappableImageViewToFit:swappableImageViewDefaultOffset];
    }
}

- (void)offsetTabBarSwappableImageViewToFit:(CGFloat)swappableImageViewDefaultOffset {
    if (self.shouldCustomizeImageInsets) {
        return;
    }
    NSArray<UITabBarItem *> *tabBarItems = [self lf_tabBarController].tabBar.items;
    [tabBarItems enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIEdgeInsets imageInset = UIEdgeInsetsMake(swappableImageViewDefaultOffset, 0, -swappableImageViewDefaultOffset, 0);
        obj.imageInsets = imageInset;
        if (!self.shouldCustomizeTitlePositionAdjustment) {
            obj.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
        }
    }];
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController {
    NSUInteger selectedIndex = tabBarController.selectedIndex;
    UIButton *plusButton = LFExternPlusButton;
    if (LFPlusChildViewControlle) {
        if ((selectedIndex == LFPlusButtonIndex) && (viewController != LFPlusChildViewControlle)) {
            plusButton.selected = NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation NSObject (LFTabBarController)

- (void)lf_setTabBarController:(LFTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(lf_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

- (LFTabBarController *)lf_tabBarController {
    LFTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(lf_tabBarController));
    if (tabBarController) {
        return tabBarController;
    }
    if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController]) {
        tabBarController = [[(UIViewController *)self parentViewController] lf_tabBarController];
        return tabBarController;
    }
    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
    UIWindow *window = delegate.window;
    if ([window.rootViewController isKindOfClass:[LFTabBarController class]]) {
        tabBarController = (LFTabBarController *)window.rootViewController;
    }
    return tabBarController;
}

@end


