//
//  GuideViewController.m
//  weibo
//
//  Created by qingyun on 15/11/9.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"


@interface GuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *PageController;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 4 , frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
}
- (IBAction)guideButton:(UIButton *)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate guideEnd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        //不减速，则是scrollView滚动结束,设置选择到第几页
        self.PageController.currentPage = self.scrollView.contentOffset.x/375;
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //减速结束，就意味着scrollView滚动结束,设置滚到到第几页
    self.PageController.currentPage = self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
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
