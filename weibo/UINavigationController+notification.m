//
//  UINavigationController+notification.m
//  weibo
//
//  Created by qingyun on 15/11/20.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "UINavigationController+notification.h"

@implementation UINavigationController (notification)
-(void)showNotification:(NSString *)string{
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    label.text = string;
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:label belowSubview:self.navigationBar];
    [UIView animateWithDuration:.2 animations:^{
        label.frame = CGRectOffset(label.frame, 0, 44);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            label.frame = CGRectOffset(label.frame, 0, -44);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

@end
