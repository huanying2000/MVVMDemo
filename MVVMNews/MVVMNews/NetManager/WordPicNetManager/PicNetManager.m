//
//  PicNetManager.m
//  MVVMNews
//
//  Created by ios开发 on 2018/3/2.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "PicNetManager.h"
#import "PicModel.h"

@implementation PicNetManager

+ (id)getPicWithSetID:(NSInteger)setID completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *path = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/morelist/0096/4GJ60096/%ld.json", setID];
    return [self get:path params:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([PicModel mj_objectArrayWithKeyValuesArray:responseObj], error);
    }];
}

@end
