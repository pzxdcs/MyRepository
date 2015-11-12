//
//  loginVC.m
//  weibo
//
//  Created by qingyun on 15/11/12.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "loginVC.h"
#import "Account.h"
#import "Common.h"
#import "AFNetworking.h"

@implementation loginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //引导用户到授权界面
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code", kAPPkey, kRedirectURI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //webview加载一个url地址
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - webView delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //2判断请求的地址是否是以回调地址开头，然后获取code
    NSURL *url = request.URL;//请求的url地址
    NSString *urlString = url.absoluteString;//获取url的string
    //字符串如果是以回调地址开头
    if ([urlString hasPrefix:kRedirectURI]) {
        NSLog(@"%@", urlString);
        //用分割字符串
        NSArray *result = [urlString componentsSeparatedByString:@"code="];
        NSString *code = result.lastObject;
        
        //请求access_token
        NSString *requestUrl = @"https://api.weibo.com/oauth2/access_token";
        NSDictionary *params = @{@"client_id":kAPPkey
                                 ,@"client_secret":kAppSecret,
                                 @"grant_type":@"authorization_code",
                                 @"code":code,
                                 @"redirect_uri":kRedirectURI};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager POST:requestUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //第四步，接受accessToken
            NSLog(@"%@", responseObject);
            
            //保存登录信息到单例model中
            [[Account currentAccount] saveLoginInfo:responseObject];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            NSLog(@"----%@", operation.responseString);
        }];
        
        return NO;
    }
    
    return YES;
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
