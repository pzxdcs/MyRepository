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
    
    //没有登录默认显示第三个模块
    if ([[Account currentAccount] isLogin]) {
        self.selectedIndex = 0;
    }else{
        self.selectedIndex =3;
    }
    [self setTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kLoginNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTabBar
{
    self.tabBar.tintColor = [UIColor orangeColor];
    
    //添加中间的➕
    
    CGFloat addBtnW = 50;
    CGFloat addBtnH = 40;
    
    CGFloat addBtnX = self.tabBar.frame.size.width / 2 - addBtnW / 2;
    CGFloat addBtnY = (self.tabBar.frame.size.height - addBtnH) / 2;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH);
    [self.tabBar addSubview:addBtn];
    addBtn.layer.cornerRadius = 4;
    [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor orangeColor];
    [addBtn addTarget:self action:@selector(compose:) forControlEvents:UIControlEventTouchDown];
}
-(void)compose:(UIButton *)btn{
    //弹出发微博界面
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    [self presentViewController:VC animated:YES completion:nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
