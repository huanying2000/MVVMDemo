//
//  NSObject+Hint.h
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Hint)

//显示加载
- (void)showLoad;

//加载完毕
- (void)hideLoad;

//显示成功(及提示文字)
- (void)showSuccessWithMsg:(NSObject *)msg;

/** 显示错误（及提示文字） */
- (void)showErrorWithMsg:(NSObject *)msg;


@end
