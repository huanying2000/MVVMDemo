//
//  BaseViewModel.h
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionHandler)(NSError *error);

@protocol BaseViewModelDelegate <NSObject>

@optional
//获取数据
- (void)getDataFromNetCompletionHandler:(completionHandler)completionHandler;

//刷新
- (void)refreshDataCompletionHandler:(completionHandler)completionHandler;

/** 获取更多 */
- (void)getMoreDataCompletionHandler:(completionHandler)completionHandler;

@end


@interface BaseViewModel : NSObject <BaseViewModelDelegate>

@property (nonatomic,strong) NSMutableArray *dataMarr;
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;

//取消任务
- (void)cacelTask;

//暂停任务
- (void)suspendTask;

//继续任务
- (void)resumeTask;


@end
