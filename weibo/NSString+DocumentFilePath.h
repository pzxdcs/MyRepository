//
//  NSString+DocumentFilePath.h
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DocumentFilePath)
//根据文件名字返回文件路径
+(NSString *)filePathWithName:(NSString *)name;

@end
