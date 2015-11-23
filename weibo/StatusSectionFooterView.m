//
//  StatusSectionFooterView.m
//  weibo
//
//  Created by qingyun on 15/11/23.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "StatusSectionFooterView.h"
#import "StatusModel.h"

@implementation StatusSectionFooterView
-(void)awakeFromNib{
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}
-(void)bindingStatus:(StatusModel *)status{
    [self.reTwiter setTitle:status.repost_count.stringValue forState:UIControlStateNormal];
    [self.comment setTitle:status.comments_count.stringValue forState:UIControlStateNormal];
    [self.assist setTitle:status.attitudes_count.stringValue forState:UIControlStateNormal];
    
}

@end
