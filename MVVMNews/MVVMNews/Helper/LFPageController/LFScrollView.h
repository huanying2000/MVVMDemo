//
//  LFScrollView.h
//  MVVMNews
//
//  Created by ios开发 on 2018/2/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFScrollView : UIScrollView<UIGestureRecognizerDelegate>

//左滑时启用其他手势  比如系统左滑 sidemenu左滑 默认NO
@property (nonatomic,assign) BOOL otherGestureRecognizerSimultaneously;
@end
