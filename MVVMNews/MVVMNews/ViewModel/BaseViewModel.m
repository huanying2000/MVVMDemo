//
//  BaseViewModel.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel
//取消任务
- (void)cacelTask {
    [self.dataTask cancel];
}
//暂停任务
- (void)suspendTask {
    [self.dataTask suspend];
}
//继续任务
- (void)resumeTask {
    [self.dataTask resume];
}

- (NSMutableArray *)dataMarr {
    if (!_dataMarr) {
        _dataMarr = [[NSMutableArray alloc] init];
    }
    return _dataMarr;
}


@end
