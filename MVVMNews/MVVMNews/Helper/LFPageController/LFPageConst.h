//
//  LFPageConst.h
//  MVVMNews
//
//  Created by ios开发 on 2018/2/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#ifndef LFPageConst_h
#define LFPageConst_h

//  标题的颜色(选中/非选中) (P.S.标题颜色是可动画的)
#define LFTitleColorSelected [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1]
#define LFTitleColorNormal   [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
//  导航菜单栏的背景颜色
#define LFMenuBGColor        [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]

//标题的尺寸 选中和非选中
//  标题的尺寸(选中/非选中)
static CGFloat const LFTitleSizeSelected = 18.0f;
static CGFloat const LFTitleSizeNormal   = 15.0f;
//  导航菜单栏的高度
static CGFloat const LFMenuHeight        = 30.0f;
//  导航菜单栏每个item的宽度
static CGFloat const LFMenuItemWidth     = 65.0f;

//  如需要利用观察者来订阅通知，请将 postNotification 设置为 YES
//
//  当一个控制器的视图 被添加到父控制器的时候会发布一个通知
//  可用于判断当前控制器的序号，主要用于当同一个控制器管理时，通过判断序号来加载相应数据
//  传递的数据包含两个信息，当前序号 (index) 以及标题 (title)
//
//  NOTE:由于缓存机制，不会在 controller 移出屏幕时销毁控制器，若想要控制器视图移除屏幕后不再收到通知，可在 -viewWillDisappear: 或 -viewDidDisappear: 中 removeObserver.
//  视图复用版本详见：https://github.com/wangmchn/YKPageView
static NSString *const LFControllerDidAddToSuperViewNotification = @"LFControllerDidAddToSuperViewNotification";

//  当一个控制器完全被展示在用户面前时发送的通知
//  可用于判断当前控制器的序号，加载或者刷新当前数据.
//  传递的数据包含两个信息，当前序号 (index) 以及标题 title
//
//  NOTE:由于缓存机制，不会在 controller 移出屏幕时销毁控制器，若想要控制器视图移除屏幕后不再收到通知，可在 -viewWillDisappear: 或 -viewDidDisappear: 中 removeObserver.并且相应的，在 -viewWillAppear: 中添加 observer
static NSString *const LFControllerDidFullyDisplayedNotification = @"LFControllerDidFullyDisplayedNotification";

#endif /* LFPageConst_h */