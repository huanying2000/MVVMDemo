//
//  PicNetManager.h
//  MVVMNews
//
//  Created by ios开发 on 2018/3/2.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseNetManager.h"

@interface PicNetManager : BaseNetManager

+ (id)getPicWithSetID:(NSInteger)setID kCompletionHandler;

@end
