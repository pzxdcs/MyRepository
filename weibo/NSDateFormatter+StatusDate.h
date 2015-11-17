//
//  NSDateFormatter+StatusDate.h
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (StatusDate)

//根据时间字符串，转化为时间
-(NSDate *)statusDateWithString:(NSString *)dateString;

@end
