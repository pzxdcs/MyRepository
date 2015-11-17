//
//  MainVC.m
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "MainVC.h"
#import "Common.h"
#import "Account.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //没有登录默认显示第三个模块，登录显示第一个模块
    if ([[Account currentAccount]isLogin]) {
        self.selectedIndex = 0;
        
    }else{
        self.selectedIndex = 3;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout:) name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login:) name:kLoginNotification object:nil];
}

-(void)logout:(NSNotification *)notification{
    //弹出登录界面
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:vc animated:YES completion:nil];
    self.selectedIndex = 3;
}
-(void)login:(NSNotification *)notification{
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
