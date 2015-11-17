//
//  UserModel.h
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong)NSString *userId;//id	int64	用户UID
@property (nonatomic, strong)NSString *name;//name	string	友好显示名称
@property (nonatomic, strong)NSString *location;//location	string	用户所在地
@property (nonatomic, strong)NSString *userDescription;//description	string	用户个人描述
@property (nonatomic, strong)NSString *profile_image_url;//profile_image_url	string	用户头像地址（中图），50×50像素
@property (nonatomic)BOOL verified;//verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
@property (nonatomic, strong)NSString *avatar_large;//avatar_large	string	用户头像地址（大图），180×180像素
@property (nonatomic, strong)NSString *verified_reason;//verified_reason	string	认证原因


-(instancetype)initWithUserInfo:(NSDictionary *)user;

@end
