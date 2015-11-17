//
//  DataBaseEngine.m
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "DataBaseEngine.h"
#import "NSString+DocumentFilePath.h"
#import "FMDB.h"
#import "StatusModel.h"

#define kStatusFileName @"kStatusFileName"
#define kStatusTableName @"status"

static NSArray *statusTableColumns;

@implementation DataBaseEngine
+(void)initialize{
    //将数据库文件copy到Document下
    [DataBaseEngine copyFile2Documents];
}
+(void)copyFile2Documents{
    NSString *source = [[NSBundle mainBundle]pathForResource:@"status" ofType:@"db"];
    NSString *toPath = [NSString filePathWithName:kStatusFileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:toPath]) {
        [manager copyItemAtPath:source toPath:toPath error:nil];
    }
    
}
+(NSArray *)tableColumn:(NSString *)tableName{
    //创建db
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathWithName:kStatusFileName]];
    //打开db
    if (![db open]) {
        NSLog(@"%@",db.lastError);
    }
    //执行查询，查询所有字段的信息
    FMResultSet *result = [db getTableSchema:tableName];
    NSMutableArray *columns = [NSMutableArray array];
    while ([result next]) {
        [columns addObject:[result objectForColumnName:@"name"]];
         
    }
    //关闭db
    [db close];
    return columns;
}
+(void)saveStatus2DataBase:(NSArray *)status{
    //创建一个数据库操作队列
    
    
}

@end
