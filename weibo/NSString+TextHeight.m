//
//  NSString+TextHeight.m
//  weibo
//
//  Created by qingyun on 15/11/17.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//
#import "NSString+TextHeight.h"

@implementation NSString (TextHeight)

-(CGFloat)HeightWithSize:(CGSize)size Font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName: font};
    
    CGRect band = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return band.size.height;
}

@end
