//
//  HomeCell.h
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell

@property (nonatomic,strong) MyImageView *iconIV;
@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong)UILabel *dateLB;
@property (nonatomic,strong) UILabel *commentNumLB;

@end
