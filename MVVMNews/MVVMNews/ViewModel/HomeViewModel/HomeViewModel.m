//
//  HomeViewModel.m
//  MVVMNews
//
//  Created by ios开发 on 2018/2/28.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype) initWithType:(NewsListType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        NSAssert1(NO, @"%s 必须使用initWithType方法初始化", __func__);
    }
    return self;
}

- (NSInteger)rowNum {
    return self.dataMarr.count;
}

- (HomeResultNewslistModel *)modelForRow:(NSInteger)row {
    return self.dataMarr[row];
}

- (NSURL *)iconURLForRow:(NSInteger)row {
    return [NSURL URLWithString:[self modelForRow:row].smallpic];
}

- (NSString *)titleForRow:(NSInteger)row {
    return [self modelForRow:row].title;
}
- (NSString *)dateForRow:(NSInteger)row {
    return [self modelForRow:row].time;
}

- (NSInteger)mediaTypeForRow:(NSInteger)row {
    return [self modelForRow:row].mediatype;
}

- (NSInteger)IDForRow:(NSInteger)row {
    return [self modelForRow:row].ID;
}

- (NSString *)commentNumForRow:(NSInteger)row {
    if ([self mediaTypeForRow:row] == 3) {
        return [NSString stringWithFormat:@"%ld播放", [self modelForRow:row].replycount];
    }else {
        return [NSString stringWithFormat:@"%ld评论",[self modelForRow:row].replycount];
    }
}

- (void)getDataFromNetCompletionHandler:(completionHandler)completionHandler {
    self.dataTask = [HomeNetManager getNewsListType:self.type lastTime:self.updateTime page:self.page completionHandler:^(HomeModel *model, NSError *error) {
        if (!error) {
            if (self.page == 1) {
                [self.dataMarr removeAllObjects];
                NSMutableArray *mArr = [[NSMutableArray alloc] init];
                for (HomeResultFocusimgModel *obj in model.result.focusimg) {
                    [mArr addObject:obj.imgurl];
                }
                self.headImgURLs = [mArr copy];
            }
            [self.dataMarr addObjectsFromArray:model.result.newslist];
            
        }
        completionHandler(error);
    }];
}

- (void)refreshDataCompletionHandler:(completionHandler)completionHandler {
    self.page = 1;
    self.updateTime = @"0";
    [self getDataFromNetCompletionHandler:completionHandler];
}

- (void)getMoreDataCompletionHandler:(completionHandler)completionHandler {
    self.page += 1;
    HomeResultNewslistModel *model = self.dataMarr.lastObject;
    self.updateTime = model.lasttime;
    [self getDataFromNetCompletionHandler:completionHandler];
}

- (BOOL)hasHeadImg {
    return self.headImgURLs.count != 0;
}


@end
