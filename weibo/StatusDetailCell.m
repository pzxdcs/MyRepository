//
//  StatusDetailCell.m
//  weibo
//
//  Created by qingyun on 15/11/24.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "StatusDetailCell.h"
#import "StatusModel.h"
#import "NSString+TextHeight.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "NSDateFormatter+StatusDate.h"
#import "UserModel.h"


@implementation StatusDetailCell

- (void)awakeFromNib {
    // Initialization code
}
+(CGFloat)cellHeightForStatus:(StatusModel *)statusModel{
    //正文的开始位置是56，加上正文的高度，就是cell的总高度
    CGFloat cellHeight = 56;
    
    //68，8 分别是label左右两边的距离
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 68 - 8, MAXFLOAT);
    
    CGFloat textHeight = [statusModel.text HeightWithSize:size Font:[UIFont systemFontOfSize:16]];
    cellHeight += textHeight;
    //返回cell总高度
    return cellHeight + 1;
    
}
-(void)bindingRetwitter:(StatusModel *)status{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url]];
    self.name.text = status.user.name;
    self.time = [NSDateFormatter localizedStringFromDate:status.created_at dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    self.comment.text = status.text;
}
+(CGFloat)cellHeightForComment:(NSDictionary *)comment{
    CGFloat height = 49;
    CGSize size = CGSizeMake([[UIScreen mainScreen]bounds].size.width-61-8 , MAXFLOAT);
    NSString *text = comment[@"text"];
    CGFloat textHeight = [text HeightWithSize:size Font:[UIFont systemFontOfSize:17]];
    height += textHeight;
    return height + 1;
  }
-(void)bindingComment:(NSDictionary *)comment{
    NSDictionary *userInfo = [comment objectForKey:@"user"];
    //用户头像地址
    NSString *urlString = [userInfo objectForKey:kUserProfileImageURL];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:urlString]];
    //用户昵称
    [self.name setText:userInfo[kUserInfoName]];
    //时间
    NSString *timeString = comment[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *createdAt = [formatter statusDateWithString:timeString];
    //格式化时间为字符串
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    self.time.text = dateStr;
    self.comment.text = comment[@"text"];
   }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
