//
//  PicCell.h
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCell : UITableViewCell

@property (strong, nonatomic) MyImageView *iconIV;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *browseNum;

@end
