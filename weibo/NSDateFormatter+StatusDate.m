//
//  NSDateFormatter+StatusDate.m
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "NSDateFormatter+StatusDate.h"

@implementation NSDateFormatter (StatusDate)

-(NSDate *)statusDateWithString:(NSString *)dateString{
    NSString *formatterString = @"EEE MMM dd HH:mm:ss zzz yyyy";
    NSLocale *uslocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    self.locale = uslocale;
    //指定时间格式化格式
    self.dateFormat = formatterString;
    return [self dateFromString:dateString];
}

@end