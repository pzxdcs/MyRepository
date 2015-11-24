//
//  StatusDetailHeaderView.h
//  weibo
//
//  Created by qingyun on 15/11/24.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel;

@interface StatusDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *reTwiter;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *like;
-(void)bindingStatus:(StatusModel*)status;
-(void)selectButton:(UIButton *)selcted;

@end
