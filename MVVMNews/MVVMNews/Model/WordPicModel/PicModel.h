//
//  PicModel.h
//  MVVMNews
//
//  Created by ios开发 on 2018/3/2.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseModel.h"


@interface PicModel : BaseModel

@property (nonatomic, copy) NSString *clientcover1;

@property (nonatomic, copy) NSString *datetime;

@property (nonatomic, copy) NSString *setname;

@property (nonatomic, copy) NSString *setid;

@property (nonatomic, copy) NSString *topicname;

@property (nonatomic, copy) NSString *pvnum;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *imgsum;

@property (nonatomic, copy) NSString *clientcover;

@property (nonatomic, copy) NSString *tcover;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *scover;

@property (nonatomic, copy) NSString *seturl;

@property (nonatomic, copy) NSString *createdate;

@property (nonatomic, strong) NSArray<NSString *> *pics;

@property (nonatomic, copy) NSString *replynum;

@end
