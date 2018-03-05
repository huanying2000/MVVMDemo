//
//  LFProgressView.h
//  MVVMNews
//
//  Created by ios开发 on 2018/1/25.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFProgressView : UIView
@property (nonatomic,strong) NSArray *itemFrames;
@property (nonatomic,assign) CGColorRef color;
@property (nonatomic,assign) CGFloat progress;
/** 进度条的速度因数，默认为 15，越小越快， 大于 0 */
@property (nonatomic,assign) CGFloat speedFactor;
@property (nonatomic,assign) CGFloat cornerRadius;

@property (nonatomic,assign) BOOL naughty;
@property (nonatomic,assign) BOOL isTriangle;
@property (nonatomic,assign) BOOL hollow;
@property (nonatomic,assign) BOOL hasBorder;

- (void)setProgressWithOutAnimate:(CGFloat)progress;

- (void)moveToPosition:(NSInteger)pos;
@end
