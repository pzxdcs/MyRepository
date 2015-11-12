//
//  UITableView+IndexWithIndexPath.m
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "UITableView+IndexWithIndexPath.h"

@implementation UITableView (IndexWithIndexPath)
- (NSInteger)indexWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    //当前section之前的section一共有多少行
    for (int i=0; i < indexPath.section; i++) {
        index += [self numberOfRowsInSection:i];
    }
    //加上当前处于第几行
    index += indexPath.row;
    return index;

}

@end
