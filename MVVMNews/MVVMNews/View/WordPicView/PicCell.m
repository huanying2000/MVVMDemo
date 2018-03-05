//
//  PicCell.m
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "PicCell.h"

@implementation PicCell



- (MyImageView *)iconIV {
    if(_iconIV == nil) {
        _iconIV = [[MyImageView alloc] init];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(2);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(200);
        }];
    }
    return _iconIV;
}

- (UILabel *)titleLB {
    if(_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = LFTitleFont;
        [self.contentView addSubview:_titleLB];
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(LFSCREENWIDTH/3*2);
            make.top.mas_equalTo(self.iconIV.mas_bottom).mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _titleLB;
}

- (UILabel *)browseNum {
    if(_browseNum == nil) {
        _browseNum = [[UILabel alloc] init];
        _browseNum.textColor = [UIColor lightGrayColor];
        _browseNum.textAlignment = NSTextAlignmentRight;
        _browseNum.font = LFSubtitleFont;
        [self.contentView addSubview:_browseNum];
        [_browseNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLB);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(65);
        }];
    }
    return _browseNum;
}



@end
