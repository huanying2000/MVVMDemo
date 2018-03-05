//
//  PicViewModel.h
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseViewModel.h"
#import "PicNetManager.h"
#import "PicModel.h"

@interface PicViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger rowNum;

- (NSArray *)iconURLsForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSString *)browseNumForRow:(NSInteger)row;

@property (nonatomic,assign) NSInteger setID;


- (PicModel *)modelForRow:(NSInteger)row;

@end
