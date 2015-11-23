//
//  StatusSectionFooterView.h
//  weibo
//
//  Created by qingyun on 15/11/23.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel;

@interface StatusSectionFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *reTwiter;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *assist;
-(void)bindingStatus:(StatusModel *)status;

@end
