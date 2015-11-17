//
//  Account.m
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "Account.h"
#import "NSString+DocumentFilePath.h"

#define kAccountFileName @"accountInfo"


@implementation Account

+(instancetype)currentAccount{
    static Account *account;
    
    //单次运行代码块
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        
        //解档文件
        //文件的路径
        NSString *filePath = [NSString filePathWithName:kAccountFileName];
        
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if (!account) {
            account = [[Account alloc] init];
        }
    });
    return account;
}

-(void)saveLoginInfo:(NSDictionary *)info{
    self.accessToken = info[@"access_token"];
    self.uid = info[@"uid"];
    //保存token的最后有效时间
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:[info[@"expires_in"] doubleValue]];
    self.expires = date;
    
    //保存到物理对象中
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //文件路径
    NSString *filePah = [documentPath stringByAppendingPathComponent:kAccountFileName];
    [NSKeyedArchiver archiveRootObject:self toFile:filePah];
}

-(BOOL)isLogin{
    //如果token是存在并且在有效期限内
    if (self.accessToken && [[NSDate date]compare:self.expires] < 0) {
        return YES;
    }
    return NO;
}

-(NSMutableDictionary *)requestParameters{
    if ([self isLogin]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:self.accessToken forKey:@"access_token"];
        return dic;
    }
    return nil;
}

-(void)logOut{
    //清除登录信息
    self.accessToken = nil;
    self.expires = nil;
    self.uid = nil;
    
    //删除物理（归档）文件
    NSString *filePath = [NSString filePathWithName:kAccountFileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark - coding

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.accessToken = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires= [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.accessToken forKey:@"access_token"];
    [aCoder encodeObject:self.expires forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    
}

@end
