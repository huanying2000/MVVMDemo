//
//  LFTabBar.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "LFTabBar.h"
#import "LFPlusButton.h"
#import "LFTabBarController.h"

//定义一个指针变量 指向LFTabBarContext的地址 通过LFTabBarContext访问到变量 LFTabBarContext的数据
static void *const LFTabBarContext = (void *)&LFTabBarContext;

@interface LFTabBar ()
// 发布按钮 就是那个比较特殊的按钮
@property (nonatomic,strong) UIButton<LFPlusButtonSubclassing> *plusButton;
@property (nonatomic,assign) CGFloat tabBarItemWidth;

@property (nonatomic,copy) NSArray *tabBarButtonArray;

@end

@implementation LFTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    if (LFExternPlusButton) {
        self.plusButton = LFExternPlusButton;
        [self addSubview:(UIButton *)self.plusButton];
    }
    //KVO 监听
    _tabBarItemWidth = LFTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:LFTabBarContext];
    return self;
}


- (NSArray *)tabBarButtonArray {
    if (_tabBarButtonArray == nil) {
        NSArray *tabBarButtonArray = [[NSArray alloc] init];
        _tabBarButtonArray = tabBarButtonArray;
    }
    return _tabBarButtonArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat taBarWidth = self.bounds.size.width;
    CGFloat taBarHeight = self.bounds.size.height;
    LFTabBarItemWidth = (taBarWidth - LFPlusButtonWidth) / LFTabbarItemsCount;
    //frame.origin.x 按递增排列的数组
    NSArray *sortedSubviews = [self sortedSubviews];
    self.tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    [self setupSwappableImageViewDefaultOffset:self.tabBarButtonArray[0]];
    if (!LFExternPlusButton) {
        return;
    }
    //特殊按钮 Y坐标中心店的偏移量
    CGFloat multiplierOfTabBarHeight = [self multiplierOfTabBarHeight:taBarHeight];
    //想再偏移量的基础上再移动的偏移量
    CGFloat constantOfPlusButtonCenterYOffset = [self constantOfPlusButtonCenterYOffsetForTabBarHeight:taBarHeight];
    //默认特殊按钮在中间
    self.plusButton.center = CGPointMake(taBarWidth * 0.5, taBarHeight * multiplierOfTabBarHeight + constantOfPlusButtonCenterYOffset);
    NSUInteger plusButtonIndex = [self plusButtonIndex];
    [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= plusButtonIndex) {
            childViewX = buttonIndex * LFTabBarItemWidth + LFPlusButtonWidth;
        }else {
            childViewX = buttonIndex * LFTabBarItemWidth;
        }
        //仅仅修改ChildView的X和宽度
        childView.frame = CGRectMake(childViewX, CGRectGetMinY(childView.frame), LFTabBarItemWidth, CGRectGetHeight(childView.frame));
    }];
    [self bringSubviewToFront:self.plusButton];
}

/*
 1.sortedArrayUsingComparator这个方法本身就是按递增的方式排序。
 2.返回的返回值（NSOrderedAscending 不交换，NSOrderedSame 不交换，NSOrderedDescending 交换）。
 例如：object1 < object2 返回：NSOrderedDescending 则交换（变为object2，object1），以保证安方法本身升序。返回NSOrderedAscending，两者不交换。
 */
- (NSArray *)sortedSubviews {
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];
    return sortedSubviews;
}


- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews {
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
        }
    }];
    if (LFPlusChildViewControlle) {
        [tabBarButtonMutableArray removeObjectAtIndex:LFPlusButtonIndex];
    }
    return [tabBarButtonMutableArray copy];
}

- (void)setupSwappableImageViewDefaultOffset:(UIView *)tabBarButton {
    __block BOOL shouldCustomizeImageView = YES;
    __block CGFloat swappableImageViewHeight = 0.f;
    __block CGFloat swappableImageViewDefaultOffset = 0.f;
    CGFloat tabBarHeight = self.frame.size.height;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
            shouldCustomizeImageView = NO;
        }
        swappableImageViewHeight = obj.frame.size.height;
        BOOL isSwappableImageView = [obj isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")];
        if (isSwappableImageView) {
            swappableImageViewDefaultOffset = (tabBarHeight - swappableImageViewHeight) * 0.5 * 0.5;
        }
        if (isSwappableImageView && swappableImageViewDefaultOffset == 0.f) {
            shouldCustomizeImageView = NO;
        }
    }];
    if (shouldCustomizeImageView) {
        self.swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
    }
}

//调整plusButton的origin.y
- (CGFloat)multiplierOfTabBarHeight:(CGFloat)taBarHeight {
    CGFloat multiplierOfTabBarHeight;
    if ([[self.plusButton class] respondsToSelector:@selector(multiplierOfTabBarHeight:)]) {
        multiplierOfTabBarHeight = [[self.plusButton class] multiplierOfTabBarHeight:taBarHeight];
    }else if ([[self.plusButton class] respondsToSelector:@selector(multiplerInCenterY)]) {
        multiplierOfTabBarHeight = [[self.plusButton class] multiplerInCenterY];
    }else {
        CGSize sizeOfPlusButton = self.plusButton.frame.size;
        CGFloat heightDifference = sizeOfPlusButton.height - self.bounds.size.height;
        if (heightDifference) {
            multiplierOfTabBarHeight = 0.5;
        }else {
            CGPoint center = CGPointMake(self.bounds.size.height * 0.5, self.bounds.size.height * 0.5);
            center.y = center.y - heightDifference * 0.5;
            multiplierOfTabBarHeight = center.y / self.bounds.size.height;
        }
    }
    return multiplierOfTabBarHeight;
}

//调整的基础上再调整
- (CGFloat) constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)taBarHeight {
    CGFloat constantOfPlusButtonCenterYOffset = 0.f;
    if ([[self.plusButton class] respondsToSelector:@selector(constantOfPlusButtonCenterYOffsetForTabBarHeight:)]) {
        constantOfPlusButtonCenterYOffset = [[self.plusButton class] constantOfPlusButtonCenterYOffsetForTabBarHeight:taBarHeight];
    }
    return constantOfPlusButtonCenterYOffset;
}

//PlusButton的index 用于计算PlusButton的位置
- (NSInteger)plusButtonIndex {
    NSInteger plusButtonIndex;
    if ([[self.plusButton class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
        plusButtonIndex = [[self.plusButton class] indexOfPlusButtonInTabBar];
        //仅修改self.plusButton的x,ywh值不变
        self.plusButton.frame = CGRectMake(plusButtonIndex * LFTabBarItemWidth, CGRectGetMinY(self.plusButton.frame), CGRectGetWidth(self.plusButton.frame), CGRectGetHeight(self.plusButton.frame));
    }else {
        if (LFTabbarItemsCount % 2 != 0) {
            [NSException raise:@"LFTabBarController" format:@"If the count of LFTabbarControllers is odd,you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果LFTabbarControllers的个数是奇数，你必须在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = LFTabbarItemsCount * 0.5;
    }
    LFPlusButtonIndex = plusButtonIndex;
    return plusButtonIndex;
}


#pragma mark - KVO监听
//控制是自动通知还是手动通知 这里选择手动通知
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != LFTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (context == LFTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LFTabBarItemWidthDidChangeNotification object:self];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat)tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

- (void)setSwappableImageViewDefaultOffset:(CGFloat)swappableImageViewDefaultOffset {
    if (swappableImageViewDefaultOffset != 0.f) {
        [self willChangeValueForKey:@"swappableImageViewDefaultOffset"];
        _swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
        [self didChangeValueForKey:@"swappableImageViewDefaultOffset"];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL canNotResponseEvent = self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO);
    if (canNotResponseEvent) { //不响应事件
        return nil;
    }
    if (!LFExternPlusButton && ![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    if (LFExternPlusButton) {
        CGRect plusButtonFrame = self.plusButton.frame;
        BOOL isInPlusButtonFrame  =CGRectContainsPoint(plusButtonFrame, point);
        if (!isInPlusButtonFrame && (point.y < 0)) {
            return nil ;
        }
        if (isInPlusButtonFrame) {
            return LFExternPlusButton;
        }
    }
    
    NSArray *tabBarButtons = self.tabBarButtonArray;
    if (self.tabBarButtonArray.count == 0) {
        tabBarButtons = [self tabBarButtonFromTabBarSubviews:self.subviews];
    }
    for (NSInteger index = 0; index < tabBarButtons.count; index ++) {
        UIView *selectedTabBarButton = tabBarButtons[index];
        CGRect selectedTabBarButtonFrame = selectedTabBarButton.frame;
        if (CGRectContainsPoint(selectedTabBarButtonFrame, point)) {
            return selectedTabBarButton;
        }
    }
    return nil;
}

@end
