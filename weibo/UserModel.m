//
//  UserModel.m
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "UserModel.h"
#import "Common.h"

@implementation UserModel

-(instancetype)initWithUserInfo:(NSDictionary *)user{
    self = [super init];
    if (self) {
        self.userId = user[kUserID];
        self.name = user[kUserInfoName];
        self.location = user[@"location"];
        self.userDescription = user[kUserDescription];
        self.profile_image_url = user[kUserProfileImageURL];
        self.verified = [user[@"verified"] boolValue];
        self.verified_reason = user[kUserVerifiedReson];
        self.avatar_large = user[kUserAvatarLarge];
    }
    return self;
}

@end

