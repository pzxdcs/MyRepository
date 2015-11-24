//
//  Status DetailVC.h
//  weibo
//
//  Created by qingyun on 15/11/23.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    kComment,
    kRetwitter,
    kLike,
} StatusDetailCellType;
@class StatusModel;
@class StatusDetailHeaderView;

@interface StatusDetailVC : UITableViewController

@property(nonatomic,strong)StatusModel *statusModel;
@property (nonatomic)StatusDetailCellType type;//默认选择comment

@end
