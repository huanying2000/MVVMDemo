//
//  PicViewModel.m
//  MVVMNews
//
//  Created by ios开发 on 2018/3/5.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "PicViewModel.h"

@implementation PicViewModel

- (NSInteger)rowNum {
    return self.dataMarr.count;
}

- (PicModel *)modelForRow:(NSInteger)row {
    return self.dataMarr[row];
}

- (NSString *)titleForRow:(NSInteger)row {
    return [self modelForRow:row].setname;
}
- (NSString *)browseNumForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%@浏览", [self modelForRow:row].replynum];
}
- (NSArray *)iconURLsForRow:(NSInteger)row {
    return [self modelForRow:row].pics;
}


- (void)getDataFromNetCompletionHandler:(completionHandler)completionHandler {
    self.dataTask = [PicNetManager getPicWithSetID:self.setID completionHandler:^(id model, NSError *error) {
        if (self.setID == 82259) {
            [self.dataMarr removeAllObjects];
        }
        [self.dataMarr addObjectsFromArray:model];
        completionHandler(error);
    }];
}

- (void)refreshDataCompletionHandler:(completionHandler)completionHandler {
    self.setID = 82259;
    [self getDataFromNetCompletionHandler:completionHandler];
}

- (void)getMoreDataCompletionHandler:(completionHandler)completionHandler {
    PicModel *model = self.dataMarr.lastObject;
    self.setID = model.setid.integerValue;
    [self getDataFromNetCompletionHandler:completionHandler];
}

@end
