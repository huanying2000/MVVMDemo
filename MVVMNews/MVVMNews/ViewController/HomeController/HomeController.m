//
//  HomeController.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "HomeController.h"
#import "HomeListController.h"

@interface HomeController ()

@end

@implementation HomeController

+ (UINavigationController *)defaultHomeNavi {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HomeController *vc = [[HomeController alloc] initWithViewControllerClasses:[self viewControllerClasses] andTheirTitles:[self itemNames]];
        vc.menuViewStyle = LFMenuViewStyleLine;
        vc.keys = [[self vcKeys] copy];
        vc.values = [[self vcValues] copy];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

+ (NSArray *)itemNames {
    return @[@"最新",@"新闻",@"评测",@"导购",@"用车",@"技术",@"文化",@"改装",@"游记"];
}

+ (NSArray *) viewControllerClasses {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:[HomeListController class]];
    }
    return [mArr copy];
}


+ (NSArray *)vcKeys {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:@"infoType"];
    }
    return [mArr copy];
}

+ (NSArray *)vcValues {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self itemNames].count; i ++) {
        [mArr addObject:@(i)];
    }
    return [mArr copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻来了";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
