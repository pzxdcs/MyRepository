//
//  Account.h
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

@property (nonatomic, strong)NSString *accessToken;//访问令牌；
@property (nonatomic, strong)NSString *uid;//用户id
@property (nonatomic, strong)NSDate *expires;//过期时间

+(instancetype)currentAccount;//返回单例对象

//保存登录信息
-(void)saveLoginInfo:(NSDictionary *)info;

//判断登录状态
-(BOOL)isLogin;

//包含token的用于请求的可变字典
-(NSMutableDictionary *)requestParameters;

-(void)logOut;


@end