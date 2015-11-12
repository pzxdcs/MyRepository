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
    self.scrollView.contentSize = CGSizeMake(1500, 667);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    // Do any additional setup after loading the view.
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        self.PageController.currentPage = self.scrollView.contentOffset.x/375;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.PageController.currentPage = self.scrollView.contentOffset.x/375;
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
