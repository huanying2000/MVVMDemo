//
//  LFMenuView.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/25.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "LFMenuView.h"

@interface LFMenuView () <LFMenuItemDelegate>
@property (nonatomic,weak) LFMenuItem *selItem;
@property (nonatomic,strong) NSMutableArray *frames;
@property (nonatomic,readonly) NSInteger titlesCount;
@property (nonatomic,assign) NSInteger selectIndex;
@end


static CGFloat const LFProgressHeight = 2.0;
static CGFloat const LFMenuItemWidth = 60.0;
static NSInteger const LFMenuItemTagOffset = 6250;
static NSInteger const LFBadgeViewTagOffset = 1212;




@implementation LFMenuView

#pragma mark - Setter
- (void)setLayoutMode:(LFMenuViewLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    if (!self.superview) {
        return;
    }
    [self reload];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!self.scrollView) {
        return;
    }
    CGFloat leftMargin = self.contentMargin + self.leftView.frame.size.width;
    CGFloat rightMargin = self.contentMargin + self.rightView.frame.size.width;
    CGFloat contentWidth = self.scrollView.frame.size.width + leftMargin + rightMargin;
    CGFloat startX = self.leftView ? self.leftView.frame.origin.x : self.scrollView.frame.origin.x - self.contentMargin;
    if (startX + contentWidth / 2 != self.bounds.size.width / 2) {
        CGFloat xOffset = (contentWidth - self.bounds.size.width) / 2;
        self.scrollView.frame = ({
            CGRect frame = self.scrollView.frame;
            frame.origin.x -= xOffset;
            frame;
        });
        
        self.leftView.frame = ({
            CGRect frame = self.leftView.frame;
            frame.origin.x -= xOffset;
            frame;
        });
        
        self.rightView.frame = ({
            CGRect frame = self.rightView.frame;
            frame.origin.x -= xOffset;
            frame;
        });
    }
}

- (void)setProgressViewCornerRadius:(CGFloat)progressViewCornerRadius {
    _progressViewCornerRadius = progressViewCornerRadius;
    if (self.progressView) {
        self.progressView.cornerRadius = _progressViewCornerRadius;
    }
}

- (void)setSpeedFactor:(CGFloat)speedFactor {
    _speedFactor = speedFactor;
    if (self.progressView) {
        self.progressView.speedFactor = _speedFactor;
    }
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LFMenuItem class]]) {
            ((LFMenuItem *)obj).speedFactor = _speedFactor;
        }
    }];
}


- (void)setProgressWidths:(NSArray *)progressWidths {
    _progressWidths = progressWidths;
    if (!self.progressView.superview) {
        return;
    }
    [self resetFramesFromIndex:0];
}

- (void)setLeftView:(UIView *)leftView {
    if (self.leftView) {
        [self.leftView removeFromSuperview];
        _leftView = nil;
    }
    if (leftView) {
        [self addSubview:leftView];
        _leftView = leftView;
    }
    [self resetFrames];
}

- (void)setRightView:(UIView *)rightView {
    if (self.rightView) {
        [self.rightView removeFromSuperview];
        _rightView = nil;
    }
    if (rightView) {
        [self addSubview:rightView];
        _rightView = rightView;
    }
    [self resetFrames];
}

- (void)setContentMargin:(CGFloat)contentMargin {
    _contentMargin = contentMargin;
    if (self.scrollView) {
        [self resetFrames];
    }
}

#pragma mark - getter

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = self.selectedColor;
    }
    return _lineColor;
}

- (NSMutableArray *)frames {
    if (_frames == nil) {
        _frames = [NSMutableArray arrayWithCapacity:0];
    }
    return _frames;
}

- (UIColor *)selectedColor {
    if ([self.delegate respondsToSelector:@selector(menuView:titleColorForState:)]) {
        return [self.delegate menuView:self titleColorForState:LFMenuItemStateSelected];
    }
    return [UIColor blackColor];
}

- (UIColor *)normalColor {
    if ([self.delegate respondsToSelector:@selector(menuView:titleColorForState:)]) {
        return [self.delegate menuView:self titleColorForState:LFMenuItemStateNormal];
    }
    return [UIColor blackColor];
}

- (CGFloat)selectedSize {
    if ([self.delegate respondsToSelector:@selector(menuView:titleSizeForState:)]) {
        return [self.delegate menuView:self titleSizeForState:LFMenuItemStateSelected];
    }
    return 18.0;
}

- (CGFloat)normalSize {
    if ([self.delegate respondsToSelector:@selector(menuView:titleSizeForState:)]) {
        return [self.delegate menuView:self titleSizeForState:LFMenuItemStateNormal];
    }
    return 15.0;
}

- (UIView *)badgeViewAtIndex:(NSInteger)index {
    if (![self.dataSource respondsToSelector:@selector(menuView:badgeViewAtIndex:)]) {
        return nil;
    }
    UIView *badgeView = [self.dataSource menuView:self badgeViewAtIndex:index];
    if (!badgeView) {
        return nil;
    }
    badgeView.tag = index + LFBadgeViewTagOffset;
    
    return badgeView;
}

#pragma mark - Public Methods

- (void)setProgressViewIsNaughty:(BOOL)progressViewIsNaughty {
    _progressViewIsNaughty = progressViewIsNaughty;
    if (self.progressView) {
        self.progressView.naughty = progressViewIsNaughty;
    }
}

- (void)reload {
    [self.frames removeAllObjects];
    [self.progressView removeFromSuperview];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self addItems];
    [self makeStyle];
}

- (void)slideMenuAtProgress:(CGFloat)progress {
    if (self.progressView) {
        self.progressView.progress = progress;
    }
    NSInteger tag = (NSInteger)progress + LFMenuItemTagOffset;
    CGFloat rate = progress - tag + LFMenuItemTagOffset;
    LFMenuItem *currentItem = (LFMenuItem *)[self viewWithTag:tag];
    LFMenuItem *nextItem = (LFMenuItem *)[self viewWithTag:tag+1];
    if (rate == 0.0) {
        [self.selItem deselectedItemWithoutAnimation];
        self.selItem = currentItem;
        [self.selItem selectedItemWithoutAnimation];
        [self refreshContenOffset];
        return;
    }
    currentItem.rate = 1- rate;
    nextItem.rate = rate;
}

- (void)selectItemAtIndex:(NSInteger)index {
    NSInteger tag = index + LFMenuItemTagOffset;
    NSInteger currentIndex = self.selItem.tag - LFMenuItemTagOffset;
    self.selectIndex = index;
    if (index == currentIndex || !self.selItem) {
        return;
    }
    LFMenuItem *item = (LFMenuItem *)[self viewWithTag:tag];
    [self.selItem deselectedItemWithoutAnimation];
    self.selItem = item;
    [self.selItem selectedItemWithoutAnimation];
    [self.progressView setProgressWithOutAnimate:index];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:index currentIndex:currentIndex];
    }
    [self refreshContenOffset];
}

//让选中的item位于中间
- (void)refreshContenOffset {
    CGRect frame = self.selItem.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > width / 2) {
        CGFloat targetX;
        if ((contentSize.width - itemX) <= width / 2) {
            targetX = contentSize.width - width;
        }else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    //MARK: 暂时解决多选问题
    [self deselectedItemsIfNeeded];
}


- (void)deselectedItemsIfNeeded {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LFMenuItem class]]) {
            LFMenuItem *item = (LFMenuItem *)obj;
            if (item != self.selItem && item.selected == YES) {
                [item deselectedItemWithoutAnimation];
            }
        }
    }];
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index andWidth:(BOOL)update{
    if (index >= self.titlesCount || index < 0) {
        return;
    }
    LFMenuItem *item = (LFMenuItem *)[self viewWithTag:(index + LFMenuItemTagOffset)];
    item.text = title;
    if (!update) {
        return;
    }
    [self resetFrames];
}

- (void)updateBadgeViewAtIndex:(NSInteger)index {
    UIView *oldBadgeView = [self.scrollView viewWithTag:LFBadgeViewTagOffset + index];
    if (oldBadgeView) {
        [oldBadgeView removeFromSuperview];
    }
    
    [self addBadgeViewAtIndex:index];
    [self resetBadgeFrame:index];
}

- (void)addBadgeViewAtIndex:(NSInteger)index {
    UIView *badgeView = [self badgeViewAtIndex:index];
    if (badgeView) {
        [self.scrollView addSubview:badgeView];
    }
}

- (NSInteger)titlesCount {
    return [self.dataSource numbersOfTitlesInMenuView:self];
}
//当自己重写一个UIView的时候有可能用到这个方法,当本视图的父类视图改变的时候,系统会自动的执行这个方法.newSuperview是本视图的新父类视图.newSuperview有可能是nil.
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.scrollView) {
        return;
    }
    [self addScrollView];
    [self addItems];
    [self makeStyle];
    [self addBadgeViews];
    
    if (self.selectIndex == 0) { return; }
    [self selectItemAtIndex:self.selectIndex];
}


- (void)addScrollView {
    CGFloat width = self.frame.size.width - self.contentMargin * 2;
    CGFloat height = self.frame.size.height;
    CGRect frame = CGRectMake(self.contentMargin, 0, width, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}


- (void)addBadgeViews {
    for (int i = 0; i < self.titlesCount; i++) {
        [self addBadgeViewAtIndex:i];
    }
}

- (void)resetFramesFromIndex:(NSInteger)index {
    [self.frames removeAllObjects];
    [self calculateItemFrames];
    for (NSInteger i = index; i < self.titlesCount; i++) {
        [self resetItemFrame:i];
        [self resetBadgeFrame:i];
    }
    if (!self.progressView.superview) { return; }
    CGRect frame = self.progressView.frame;
    frame.size.width = self.scrollView.contentSize.width;
    if (self.style == LFMenuViewStyleLine || self.style == LFMenuViewStyleTriangle) {
        frame.origin.y = self.frame.size.height - self.progressHeight - self.progressViewBottomSpace;
    } else {
        frame.origin.y = (self.scrollView.frame.size.height - frame.size.height) / 2.0;
    }
    
    self.progressView.frame = frame;
    self.progressView.itemFrames = [self convertProgressWidthsToFrames];
    [self.progressView setNeedsDisplay];
}

- (void)resetItemFrame:(NSInteger)index {
    LFMenuItem *item = (LFMenuItem *)[self viewWithTag:LFMenuItemTagOffset + index];
    CGRect frame = [self.frames[index] CGRectValue];
    item.frame = frame;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuView:didLayoutItemFrame:atIndex:)]) {
        [self.delegate menuView:self didLayoutItemFrame:item atIndex:index];
    }
}

- (void)resetBadgeFrame:(NSInteger)index {
    CGRect frame = [self.frames[index] CGRectValue];
    UIView *badgeView = [self.scrollView viewWithTag:(LFBadgeViewTagOffset + index)];
    if (badgeView) {
        CGRect badgeFrame = [self badgeViewAtIndex:index].frame;
        badgeFrame.origin.x += frame.origin.x;
        badgeView.frame = badgeFrame;
    }
}

- (void)makeStyle {
    CGRect frame = CGRectZero;
    if (self.style == LFMenuViewStyleDefault) {
        return;
    }
    if (self.style == LFMenuViewStyleLine) {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : LFProgressHeight;
        frame = CGRectMake(0, self.frame.size.height - self.progressHeight - self.progressViewBottomSpace, self.scrollView.contentSize.width, self.progressHeight);
    }else {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : self.frame.size.height * 0.8;
        frame = CGRectMake(0, (self.frame.size.height - self.progressHeight) / 2, self.scrollView.contentSize.width, self.progressHeight);
    }
    self.progressViewCornerRadius = self.progressViewCornerRadius > 0 ? self.progressViewCornerRadius : self.progressHeight / 2.0;
    [self lf_addProgressViewWithFrame:frame
                           isTriangle:(self.style == LFMenuViewStyleTriangle)
                            hasBorder:(self.style == LFMenuViewStyleSegmented)
                               hollow:(self.style == LFMenuViewStyleFloodHollow)
                         cornerRadius:self.progressViewCornerRadius];
}

- (void)resetFrames {
    CGRect frame = self.bounds;
    if (self.rightView) {
        CGRect rightFrame = self.rightView.frame;
        rightFrame.origin.x = frame.size.width - rightFrame.size.width;
        self.rightView.frame = rightFrame;
        frame.size.width -= rightFrame.size.width;
    }
    if (self.leftView) {
        CGRect leftFrame = self.leftView.frame;
        leftFrame.origin.x = 0;
        self.leftView.frame = leftFrame;
        frame.origin.x += leftFrame.size.width;
        frame.size.width -= leftFrame.size.width;
    }
    
    
    frame.origin.x += self.contentMargin;
    frame.size.width -= self.contentMargin * 2;
    self.scrollView.frame = frame;
    
    [self resetFramesFromIndex:0];
}

- (void)addItems {
    //布局
    [self calculateItemFrames];
    for (int i = 0; i < self.titlesCount; i ++) {
        CGRect frame = [self.frames[i] CGRectValue];
        LFMenuItem *item = [[LFMenuItem alloc] initWithFrame:frame];
        if (self.fontName) {
            item.font = [UIFont fontWithName:self.fontName size:self.selectedSize];
        }else {
            item.font = [UIFont systemFontOfSize:self.selectedSize];
        }
        
        item.tag = (i + LFMenuItemTagOffset);
        item.delegate = self;
        item.text = [self.dataSource menuView:self titleAtIndex:i];
        item.textAlignment = NSTextAlignmentCenter;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menuView:initialMenuItem:atIndex:)]) {
            item = [self.dataSource menuView:self initialMenuItem:item atIndex:i];
        }
        
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
        item.normalSize    = self.normalSize;
        item.selectedSize  = self.selectedSize;
        item.normalColor   = self.normalColor;
        item.selectedColor = self.selectedColor;
        item.speedFactor   = self.speedFactor;
        if (i == 0) {
            [item selectedItemWithoutAnimation];
            self.selItem = item;
        }else {
            [item deselectedItemWithoutAnimation];
        }
        [self.scrollView addSubview:item];
    }
}

//计算所有item的frame值 主要是为了适配所有item的宽度之和小于屏幕宽的情况
#warning 关于item的frame 我觉得可以改进
- (void) calculateItemFrames {
    //获取第一个item的间距
    CGFloat contentWidth = [self itemMarginAtIndex:0];
    for (int i = 0; i < self.titlesCount; i ++) {
        CGFloat itemW = LFMenuItemWidth;
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuView:widthForItemAtIndex:)]) {
            itemW = [self.delegate menuView:self widthForItemAtIndex:i];
        }
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        //记录frame
        [self.frames addObject:[NSValue valueWithCGRect:frame]];
        contentWidth += itemW + [self itemMarginAtIndex:i+1];
    }
    //如果总宽度小于屏幕宽 重新计算 frame 为item间添加间距
    if (contentWidth < self.scrollView.frame.size.width) {
        CGFloat distance = self.scrollView.frame.size.width - contentWidth;
        CGFloat (^shiftDis)(int);
        switch (self.layoutMode) {
            case LFMenuViewLayoutModeScatter: {
                CGFloat gap = distance / (self.titlesCount + 1);
                shiftDis = ^CGFloat(int index) {
                    return gap * (index + 1);
                };
                break;
            }
            case LFMenuViewLayoutModeLeft: {
                shiftDis = ^CGFloat(int index) { return 0.0; };
                break;
            }
            case LFMenuViewLayoutModeRight: {
                shiftDis = ^CGFloat(int index) { return distance; };
                break;
            }
            case LFMenuViewLayoutModeCenter: {
                shiftDis = ^CGFloat(int index) { return distance / 2; };
                break;
            }
        }
        for (int i = 0; i < self.frames.count; i++) {
            CGRect frame = [self.frames[i] CGRectValue];
            frame.origin.x += shiftDis(i);
            self.frames[i] = [NSValue valueWithCGRect:frame];
        }
        contentWidth = self.scrollView.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
    
}

- (CGFloat)itemMarginAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuView:itemMarginAtIndex:)]) {
        return [self.delegate menuView:self itemMarginAtIndex:index];
    }
    return 0.0;
}

//MARK:Progress View
- (void) lf_addProgressViewWithFrame:(CGRect)frame isTriangle:(BOOL)isTriangle hasBorder:(BOOL)hasBorder hollow:(BOOL)isHollow cornerRadius:(CGFloat)cornerRadius{
    LFProgressView *pView = [[LFProgressView alloc] initWithFrame:frame];
    pView.itemFrames = [self convertProgressWidthsToFrames];
    pView.color = self.lineColor.CGColor;
    pView.isTriangle = isTriangle;
    pView.hasBorder = hasBorder;
    pView.hollow = isHollow;
    pView.cornerRadius = cornerRadius;
    pView.naughty = self.progressViewIsNaughty;
    pView.speedFactor = self.speedFactor;
    pView.backgroundColor = [UIColor clearColor];
    self.progressView = pView;
    [self.scrollView insertSubview:self.progressView atIndex:0];
}

#warning 设置ProgressView 的ItemWidth
- (NSArray *) convertProgressWidthsToFrames {
    if (!self.frames.count) {
        NSAssert(NO, @"BUUUUUUUG...SHOULDN'T COME HERE!!");
    }
    if (self.progressWidths.count) {
        NSMutableArray *progressFrames = [NSMutableArray array];
        for (int i = 0; i < self.frames.count; i++) {
            CGRect itemFrame = [self.frames[i] CGRectValue];
            CGFloat progressWidth = [self.progressWidths[i] floatValue];
            CGFloat x = itemFrame.origin.x + (itemFrame.size.width - progressWidth) / 2;
            CGRect progressFrame = CGRectMake(x, itemFrame.origin.y, progressWidth, 0);
            [progressFrames addObject:[NSValue valueWithCGRect:progressFrame]];
        }
        return progressFrames.copy;
    }
    return self.frames;
}

- (void)didPressedMenuItem:(LFMenuItem *)menuItem {
    if (self.selItem == menuItem) {
        return;
    }
    
    CGFloat progress = menuItem.tag - LFMenuItemTagOffset;
    [self.progressView moveToPosition:progress];
    
    NSInteger currentIndex = self.selItem.tag - LFMenuItemTagOffset;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
       [self.delegate menuView:self didSelesctedIndex:menuItem.tag - LFMenuItemTagOffset currentIndex:currentIndex];
    }
    menuItem.selected = YES;
    self.selItem.selected = NO;
    self.selItem = menuItem;
    NSTimeInterval delay = self.style == LFMenuViewStyleDefault ? 0 : 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 让选中的item位于中间
        [self refreshContenOffset];
    });
}

@end
