//
//  MyImageView.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        //UIViewContentModeScaleAspectFill 这是整个view会被图片填满，图片比例不变 意思是如果超出了imageView的大小 会裁剪
        //UIViewContentModeScaleAspectFit 这个图片都会在view里面显示，并且比例不变 这就是说 如果图片和view的比例不一样 就会有留白如下图1
        //UIViewContentModeScaleToFill 填充整个页面
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _imgView;
}

@end
