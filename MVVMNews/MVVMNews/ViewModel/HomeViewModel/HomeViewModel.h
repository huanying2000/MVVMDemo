//
//  HomeViewModel.h
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseViewModel.h"
#import "HomeNetManager.h"

@interface HomeViewModel : BaseViewModel

- (instancetype) initWithType:(NewsListType)type;
@property (nonatomic) NewsListType type;
@property (strong, nonatomic) NSString *updateTime;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger rowNum;

- (NSURL *)iconURLForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSString *)dateForRow:(NSInteger)row;
- (NSString *)commentNumForRow:(NSInteger)row;
- (NSInteger)IDForRow:(NSInteger)row;

- (NSInteger)mediaTypeForRow:(NSInteger)row;

/** 存放头部滚动图片数组 */
@property (strong, nonatomic) NSArray *headImgURLs;

/** 头部是否有视图 */
@property (nonatomic) BOOL hasHeadImg;

@end
