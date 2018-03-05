//
//  WordNetManager.h
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseNetManager.h"
#import "WordModel.h"

@interface WordNetManager : BaseNetManager

+ (id)getWordWithPage:(NSInteger)page kCompletionHandler;

@end
