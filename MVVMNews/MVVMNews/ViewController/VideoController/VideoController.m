//
//  VideoController.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "VideoController.h"

@interface VideoController ()

@end

@implementation VideoController

+ (UINavigationController *)defaultVideoNavi {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VideoController *vc = [[VideoController alloc] init];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
