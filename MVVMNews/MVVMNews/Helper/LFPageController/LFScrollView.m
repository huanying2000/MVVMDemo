//
//  LFScrollView.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "LFScrollView.h"

@implementation LFScrollView
//是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
//是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // iOS横向滚动的scrollView和系统pop手势返回冲突的解决办法:     http://blog.csdn.net/hjaycee/article/details/49279951
    // 兼容系统pop手势 / FDFullscreenPopGesture / 如有自定义手势，需自行在此处判断
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    
    if (self.otherGestureRecognizerSimultaneously) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

//这个方法返回YES，第一个手势和第二个互斥时，第一个会失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //MARK: UITableViewCell 自定义手势可能要在此处自行定义
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end

/**
 关于手势
 
 **/
