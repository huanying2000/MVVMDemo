//
//  HomeModel.m
//  MVVMNews
//
//  Created by ios开发 on 2018/1/24.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

@end

@implementation HomeResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"newslist":[HomeResultNewslistModel class],@"focusimg" : [HomeResultFocusimgModel class],@"headlineinfo":[HomeResultHeadlineinfoModel class]};
}

@end


@implementation HomeResultTopnewsinfoModel

@end

@implementation HomeResultNewslistModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id", @"anewstype":@"newstype"};
}

@end


@implementation HomeResultFocusimgModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end


@implementation HomeResultHeadlineinfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end


