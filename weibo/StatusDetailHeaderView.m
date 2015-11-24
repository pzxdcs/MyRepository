//
//  StatusDetailHeaderView.m
//  weibo
//
//  Created by qingyun on 15/11/24.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "StatusDetailHeaderView.h"
#import "StatusModel.h"

@implementation StatusDetailHeaderView

-(void)awakeFromNib{
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

-(void)bindingStatus:(StatusModel *)status{
    [self.reTwiter setTitle:status.repost_count.stringValue forState:UIControlStateNormal];
    [self.comment setTitle:status.comments_count.stringValue forState:UIControlStateNormal];
    [self.like setTitle:status.attitudes_count.stringValue forState:UIControlStateNormal];
}
-(void)selectButton:(UIButton *)selcted{
    [selcted setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (self.reTwiter != selcted) {
        [self.reTwiter setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    if (self.comment != selcted) {
        [self.comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    if (self.like != selcted) {
        [self.like setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}






@end
