//
//  LFMenuItem.h
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LFMenuItem;

typedef NS_ENUM(NSUInteger,LFMenuItemState) {
    LFMenuItemStateSelected,
    LFMenuItemStateNormal,
};

@protocol LFMenuItemDelegate <NSObject>

@optional
- (void)didPressedMenuItem:(LFMenuItem *)menuItem;

@end

@interface LFMenuItem : UILabel
//设置rate 并刷新标题状态
@property (nonatomic,assign) CGFloat rate;
//normale状态的字体大小 默认为15
@property (nonatomic,assign) CGFloat normalSize;
/** selected状态的字体大小，默认大小为18 */
@property (nonatomic, assign) CGFloat selectedSize;
/** normal状态的字体颜色，默认为黑色 (可动画) */
@property (nonatomic, strong) UIColor *normalColor;
/** selected状态的字体颜色，默认为红色 (可动画) */
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, weak) id<LFMenuItemDelegate> delegate;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
//进度条 速度因数 默认为 15 越小越快 大于0
@property (nonatomic,assign) CGFloat speedFactor;


- (void)selectedItemWithoutAnimation;
- (void)deselectedItemWithoutAnimation;

@end
