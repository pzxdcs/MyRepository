//
//  NSString+DocumentFilePath.m
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "NSString+DocumentFilePath.h"

@implementation NSString (DocumentFilePath)
+(NSString *)filePathWithName:(NSString *)name{
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documents stringByAppendingPathComponent:name];
}
@end
