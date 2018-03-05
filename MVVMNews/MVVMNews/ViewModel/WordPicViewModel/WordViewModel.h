//
//  WordViewModel.h
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseViewModel.h"
#import "WordNetManager.h"

@interface WordViewModel : BaseViewModel

@property (nonatomic) NSInteger rowNum;

- (NSString *)contentForRow:(NSInteger)row;
- (NSString *)zanNumForRow:(NSInteger)row;
- (NSString *)dateForRow:(NSInteger)row;

@property (nonatomic) NSInteger page;

@end
