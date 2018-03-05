
//
//  BarItem.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/23.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BarItem.h"

@implementation BarItem

+ (void) addBackItemToVC:(UIViewController *)vc {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 45, 44);
    [btn bk_addEventHandler:^(id sender) {
        [vc.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    //使用弹簧控件缩小菜单按钮和边缘距离
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -16;
    vc.navigationItem.leftBarButtonItems = @[spaceItem,backItem];
}

@end
