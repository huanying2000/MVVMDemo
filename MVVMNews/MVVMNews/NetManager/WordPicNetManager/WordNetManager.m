//
//  WordNetManager.m
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "WordNetManager.h"

@implementation WordNetManager

+ (id)getWordWithPage:(NSInteger)page completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *path = [NSString stringWithFormat:@"http://joke.luckyamy.com/api/?cat=dz&p=%ld&ap=ymds&ver=1.6", page];
    return [self get:path params:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([WordModel mj_objectArrayWithKeyValuesArray:responseObj],error);
    }];
}

@end
