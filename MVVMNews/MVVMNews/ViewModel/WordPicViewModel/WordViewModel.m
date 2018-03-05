//
//  WordViewModel.m
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "WordViewModel.h"

@implementation WordViewModel

- (NSInteger)rowNum {
    return self.dataMarr.count;
}

- (WordModel *)modelForRow:(NSInteger)row {
    return self.dataMarr[row];
}

- (NSString *)contentForRow:(NSInteger)row {
    return [@"        " stringByAppendingString:[self modelForRow:row].text];
}

- (NSString *)zanNumForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld", [self modelForRow:row].zan];
}

- (NSString *)dateForRow:(NSInteger)row {
    return [self modelForRow:row].created_at;
}

- (void)getDataFromNetCompletionHandler:(completionHandler)completionHandler {
    self.dataTask = [WordNetManager getWordWithPage:self.page completionHandler:^(id model, NSError *error) {
        if (!error) {
            if (self.page == 1) {
                [self.dataMarr removeAllObjects];
            }
            [self.dataMarr addObjectsFromArray:model];
        }
        completionHandler(error);
    }];
}

- (void)refreshDataCompletionHandler:(completionHandler)completionHandler {
    self.page = 1;
    [self getDataFromNetCompletionHandler:completionHandler];
}

- (void)getMoreDataCompletionHandler:(completionHandler)completionHandler {
    self.page += 1;
    [self getDataFromNetCompletionHandler:completionHandler];
}


@end
