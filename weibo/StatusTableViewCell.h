//
//  StatusTableViewCell.h
//  weibo
//
//  Created by qingyun on 15/11/16.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel;

@interface StatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;

@property (weak, nonatomic) IBOutlet UIView *contentImageSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentImgHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *reTwitterContent;
@property (weak, nonatomic) IBOutlet UIView *reTwitterImgSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reTwiImgSupHeightConstaint;



-(void)bindingStatusModel:(StatusModel *)info;
+(CGFloat)cellHeightForStatus:(StatusModel *)status;
@end
