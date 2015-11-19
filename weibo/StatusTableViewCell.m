//
//  StatusTableViewCell.m
//  weibo
//
//  Created by qingyun on 15/11/16.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StatusModel.h"
#import "UserModel.h"

@implementation StatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)bandingStatusModel:(StatusModel *)info{
    //    NSDictionary *userInfo = info[@"user"];
    //    NSString *imageUrl = userInfo[@"profile_image_url"];
    
    
#if 0
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.icon setImage:image];
        });
        
        
    });
#else
    //通过SDWebImage 下载图片
    //    [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:info.user.profile_image_url]];
#endif
    
    //    self.name.text = userInfo[@"name"];
    //    self.time.text = info[@"created_at"];
    //    self.source.text = info[@"source"];
    //    self.content.text = info[@"text"];
    self.name.text = info.user.name;
    self.time.text = info.createdString;
    self.source.text = info.source;
    self.content.text = info.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
