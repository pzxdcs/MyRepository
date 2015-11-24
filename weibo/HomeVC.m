//
//  HomeVC.m
//  weibo
//
//  Created by qingyun on 15/11/16.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "HomeVC.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "StatusTableViewCell.h"
#import "StatusModel.h"
#import "DataBaseEngine.h"
#import "UINavigationController+notification.h"
#import "StatusSectionFooterView.h"

@interface HomeVC ()

@property (nonatomic, strong)NSArray *statuses;//微博数据
@property (nonatomic)BOOL isLoadMore;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.backgroundColor =  [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.statuses = [DataBaseEngine statusFromDB];
    self.isLoadMore = YES;
    UINib *nib = [UINib nibWithNibName:@"StatusSectionFooterView" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"StatusSectionFooterView"];
    //下拉刷新
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    self.refreshControl = control;
    control.tintColor = [UIColor lightGrayColor];
    NSDictionary *attibutes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString *attibuteString = [[NSAttributedString alloc]initWithString:@"下拉加载更多" attributes:attibutes];
    control.attributedTitle = attibuteString;
    [control addTarget:self action:@selector(loadNew:) forControlEvents:UIControlEventValueChanged];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - load data

-(void)loadData{
    //url地址，还有请求的需要提交的参数
    NSString *urlString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSDictionary *params = [[Account currentAccount] requestParameters];
    //未登录的判断
    if (!params) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        //请求到的数据，首先转化为model，然后再使用
        NSArray *statusesInfo = responseObject[@"statuses"];
        NSMutableArray *resutArray = [NSMutableArray arrayWithCapacity:statusesInfo.count];
        
        //遍历每一个status字典，并且转化为model，保存在resutArray中
        [statusesInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            StatusModel *model = [[StatusModel alloc] initWithStatusInfo:obj];
            [resutArray addObject:model];
        }];
        
        // 将所有的model作为数据源
        self.statuses = resutArray;
        
        
        //更新数据源后刷新UI
        [self.tableView reloadData];
        //保存到数据库中
        [DataBaseEngine saveStatus2DataBase:statusesInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}
-(void)loadNew:(UIRefreshControl*)sender{
    //更改refresh的状态
    UIRefreshControl *control = sender;
    NSDictionary *attiributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"正在请求最新的数据" attributes:attiributes];
    control.attributedTitle = attStr;
    
    
    //请求更新的数据
    //注意点：以路径的方式追加
    
    
    NSString *urlString = [kBaseUrl stringByAppendingPathComponent:@"2/statuses/home_timeline.json"];
    
    NSMutableDictionary *params = [[Account currentAccount] requestParameters];
      NSLog(@"------%@-------",[self.statuses.firstObject statusId]);
    [params setObject:[self.statuses.firstObject statusId] forKey:@"since_id"];
  
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        //        更改数据源
        NSArray *statusInfo = responseObject[@"statuses"];
        NSMutableArray *result = [NSMutableArray array];
        [statusInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            StatusModel *status = [[StatusModel alloc] initWithStatusInfo:obj];
            [result addObject:status];
        }];
        //老的追加到新的后面
        [result addObjectsFromArray:self.statuses];
        //result作为最新的数据源
        self.statuses = result;
        
        //刷新ui
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        
        UIRefreshControl *control = sender;
        NSDictionary *attiributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"下拉加载更新数据" attributes:attiributes];
        control.attributedTitle = attStr;
        
        NSString *noticationString;
        if (statusInfo.count == 0) {
            noticationString = @"没有更新的微博了";
        }else{
            //给用户提示加载了多少数据
            noticationString = [NSString stringWithFormat:@"更新了%ld条微博", statusInfo.count];
        }
        [self.navigationController showNotification:noticationString];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        UIRefreshControl *control = sender;
        NSDictionary *attiributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"下拉请求更新的数据" attributes:attiributes];
        control.attributedTitle = attStr;
    }];
    
    
    
    //刷新UI
    //停止刷新
}

-(void)reloadMore{
    if (!self.isLoadMore) {
        return;
    }
    //请求数据
    NSString *urlStr = [kBaseUrl stringByAppendingPathComponent:@"2/statuses/home_timeline.json"];
    NSMutableDictionary *params = [[Account currentAccount]requestParameters];
    [params setObject:[self.statuses.lastObject statusId] forKey:@"max_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *statusInfo = responseObject[@"statuses"];
        if (statusInfo.count<20) {
            self.isLoadMore = NO;
        }
        NSMutableArray *result = [NSMutableArray array];
        [result addObjectsFromArray:self.statuses];
        [statusInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            StatusModel *status = [[StatusModel alloc]initWithStatusInfo:obj];
            [result addObject:status];
        }];
        self.statuses = result;
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)reTwiter:(UIButton *)sender{
    
}
-(void)commit:(UIButton *)sender{
    
}
-(void)attibute:(UIButton *)sender{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.statuses.count;
    // Return the number of sections.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusesCell" forIndexPath:indexPath];
    
    [cell bindingStatusModel:self.statuses[indexPath.section]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusesCell"];
//    [cell bandingStatusModel:self.statuses[indexPath.row]];
//    //设置正文显示的宽度
//    cell.content.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 16;
//    cell.reTwitterContent.preferredMaxLayoutWidth =
//    [[UIScreen mainScreen] bounds].size.width - 16;
//    //转发微博正文
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;

    return [StatusTableViewCell cellHeightForStatus:self.statuses[indexPath.section]];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.statuses.count-1) {
        [self reloadMore];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }
    return 20.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    StatusSectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StatusSectionFooterView"];
    [footerView bindingStatus:self.statuses[section]];
    [footerView.reTwiter addTarget:self action:@selector(reTwiter:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.comment addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.assist addTarget:self action:@selector(attibute:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    StatusModel *status = self.statuses[indexPath.section];
    UIViewController *VC = segue.destinationViewController;
    [VC setValue:status forKey:@"_statusModel"];
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
