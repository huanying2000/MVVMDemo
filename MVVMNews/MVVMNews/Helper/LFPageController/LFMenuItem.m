//
//  LFMenuItem.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "LFMenuItem.h"

@interface LFMenuItem () {
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    NSInteger _sign;
    CGFloat _gap;
    CGFloat _step;
    __weak CADisplayLink *_link;
}

@end

@implementation LFMenuItem

#pragma mark - Public Methods
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.normalColor = [UIColor blackColor];
        self.selectedColor = [UIColor blackColor];
        self.normalSize = 15;
        self.selectedSize = 18;
        self.numberOfLines = 0;
    }
    return self;
}


//获取速率
- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0;
    }
    return _speedFactor;
}

//设置选中 隐士动画所在
- (void)setSelected:(BOOL)selected {
    if (self.selected == selected) {
        return;
    }
    _selected = selected;
    _sign = (selected == YES) ? 1 : -1;
    _gap = (selected == YES) ? (1.0 - self.rate) : (self.rate - 0.0);
    _step = _gap / self.speedFactor;
    if (_link) {
        [_link invalidate];
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)rateChange {
    if (_gap > 0.000001) {
        _gap -= _step;
        if (_gap < 0.0) {
            self.rate = (int)(self.rate + _sign * _step + 0.5);
            return;
        }
        self.rate += _sign * _step;
    }else {
        self.rate = (int)(self.rate + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

- (void)setRate:(CGFloat)rate {
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat minScale = self.normalSize / self.selectedSize;
    CGFloat trueScale = minScale + (1 - minScale)*rate;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

- (void)selectedItemWithoutAnimation {
    self.rate = 1.0;
    _selected = YES;
}

- (void)deselectedItemWithoutAnimation {
    self.rate = 0;
    _selected = NO;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
}


#pragma mark - Private Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(didPressedMenuItem:)]) {
        [self.delegate didPressedMenuItem:self];
    }
}










@end
