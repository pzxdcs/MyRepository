//
//  UITableView+IndexWithIndexPath.h
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (IndexWithIndexPath)

//根据indexPath计算出cell在table中的index
-(NSInteger)indexWithIndexPath:(NSIndexPath *)indexPath;

@end