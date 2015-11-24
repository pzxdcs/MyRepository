//
//  Status DetailVC.m
//  weibo
//
//  Created by qingyun on 15/11/23.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "StatusDetailVC.h"
#import "StatusTableViewCell.h"
#import "StatusModel.h"
#import "Common.h"
#import "Account.h"
#import "AFNetworking.h"
#import "StatusDetailCell.h"
#import "StatusDetailHeaderView.h"


@interface StatusDetailVC ()
@property (nonatomic, strong)StatusDetailHeaderView *headerView;

@property (nonatomic ,strong)NSArray * commentData;//正文的数据源

@property (nonatomic ,strong)NSArray *reTwiterData;//转发的数据源

@end

@implementation StatusDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博正文";
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"StatusDetailHeaderView" owner:self options:nil]objectAtIndex:0];
    [self.headerView bindingStatus:self.statusModel];
    [self.headerView.comment addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.reTwiter addTarget:self action:@selector(reTwiter:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.like addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)comment:(UIButton *)sender{
    self.type = kComment;
   // [self.headerView.comment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [self.headerView.reTwiter setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.headerView selectButton:sender];
    //请求评论数据
    NSString *url = [kBaseUrl stringByAppendingPathComponent:@"2/comments/show.json"];
    NSMutableDictionary *dic = [[Account currentAccount ]requestParameters];
    [dic setObject:self.statusModel.statusId forKey:@"id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *comments = responseObject[@"comments"];
        self.commentData = comments;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)reTwiter:(UIButton *)sender{
    self.type = kRetwitter;
    [self.headerView selectButton:sender];
   // [self.headerView.reTwiter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.headerView.comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSString *url = [kBaseUrl stringByAppendingPathComponent:@"2/statuses/repost_timeline.json"];
    NSMutableDictionary *parameters = [[Account currentAccount]requestParameters];
    [parameters setObject:self.statusModel.statusId forKey:@"id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据字典数组
        NSArray *Info = responseObject[@"reposts"];
        NSMutableArray *result = [NSMutableArray array];
        [Info enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            StatusModel *status = [[StatusModel alloc] initWithStatusInfo:obj];
            [result addObject:status];
        }];
        //更新数据源
        self.reTwiterData = result;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)like:(UIButton *)sender{
    [self.headerView selectButton:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        switch (self.type) {
            case kComment:
            {
            
                return self.commentData.count;
            }
                break;
            case kRetwitter:
            {
                
                return self.reTwiterData.count;
            }
            default:
                return 0;
                break;
        }
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
        [cell bindingStatusModel:self.statusModel];
        return cell;
    }else{
        StatusDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
        switch (self.type) {
            case kComment:
            {
                
                [cell bindingComment:self.commentData[indexPath.row]];
                
            }
                break;
            case kRetwitter:
            {
                

                [cell bindingRetwitter:self.reTwiterData[indexPath.row]];
            }
            default:
                break;
        }
        return cell;
    }

    // Configure the cell...
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [StatusTableViewCell cellHeightForStatus:self.statusModel];
    }else{
        switch (self.type) {
            case kComment:{
                return [StatusDetailCell cellHeightForComment:self.commentData[indexPath.row]];
            }
                break;
            case kRetwitter:{
                return [StatusDetailCell cellHeightForStatus:self.reTwiterData[indexPath.row]];
            }
            default:
                return 0;
                break;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }
    return 30.f;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.headerView;
    }else{
        return nil;
    }
    
}



@end
