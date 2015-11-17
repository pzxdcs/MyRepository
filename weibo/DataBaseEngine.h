//
//  DataBaseEngine.h
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject
//将网络请求的所有微博字典保存
+(void)saveStatus2DataBase:(NSArray *)status;

//查询微博记录
+(NSArray *)statusFromDB;

@end
