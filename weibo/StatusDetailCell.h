//
//  StatusDetailCell.h
//  weibo
//
//  Created by qingyun on 15/11/24.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel;

@interface StatusDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comment;;

@property (weak, nonatomic) IBOutlet UIButton *zan;
+(CGFloat)cellHeightForComment:(NSDictionary *)comment;
-(void)bindingComment:(NSDictionary *)comment;
+(CGFloat)cellHeightForStatus:(StatusModel *)statusModel;
-(void)bindingRetwitter:(StatusModel *)status;

@end
