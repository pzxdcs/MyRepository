//
//  StatusModel.m
//  weibo
//
//  Created by qingyun on 15/11/16.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//
#import "StatusModel.h"
#import "Common.h"
#import "NSDateFormatter+StatusDate.h"
#import "UserModel.h"

@implementation StatusModel

-(instancetype)initWithStatusInfo:(NSDictionary *)status{
    self = [super init];
    if (self) {
        NSString *created = status[kStatusCreateTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //将字符串按照格式转化为时间
        self.created_at = [formatter statusDateWithString:created];
        
        self.text = status[kStatusText];
        self.source = status[kStatusSource];
        self.user = [[UserModel alloc] initWithUserInfo:status[kStatusUserInfo]];
        NSDictionary *retweeted = status[kStatusRetweetStatus];
        //根据是否有字典，来初始化相对应的model
        if (retweeted) {
            self.retweeted_status = [[StatusModel alloc] initWithStatusInfo:retweeted];
        }
        self.repost_count = status[kStatusRepostsCount];
        self.comments_count = status[kStatusCommentsCount];
        self.attitudes_count = status[kStatusAttitudesCount];
        self.pic_urls = status[kStatusPicUrls];
        
    }
    return self;
}

@end
