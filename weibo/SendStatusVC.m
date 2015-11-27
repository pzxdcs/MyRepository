//
//  SendStatusVC.m
//  weibo
//
//  Created by qingyun on 15/11/26.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "SendStatusVC.h"
#import "AFNetworking.h"
#import "Common.h"
#import "Account.h"
#import "SVProgressHUD.h"
#define kImageWidth 90
#define kImageHeight 90
#define kImageEdge 5
#define kImageCount 3

@interface SendStatusVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,strong)UIView *imageSuperView;

@end

@implementation SendStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.textView.delegate = self;
    self.imageSuperView = [[UIView alloc]init];
    self.tableView.tableFooterView = self.imageSuperView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutSelectedImages];
    
}
+(CGFloat)imageContentViewHeightForPics:(NSArray *)pics{
    //根据图片的张数，计算view显示需要的高度
    //向上取整
    NSInteger line = ceil((pics.count + 1)/(CGFloat)kImageCount);
    NSInteger height = line*kImageHeight + (line - 1)*kImageEdge;
    
    return height;
}
-(void)layoutSelectedImages{
    //移除所有子视图
    NSArray *subViews = self.imageSuperView.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //调整view的高度
    CGFloat heiht = [SendStatusVC imageContentViewHeightForPics:self.selectedImages];
    self.imageSuperView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, heiht);
    //添加imageView
    [self.selectedImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc]init];
        CGFloat x = idx%kImageCount*(kImageWidth + kImageEdge);
        CGFloat y = idx/kImageCount*(kImageHeight + kImageEdge);
        imageView.frame = CGRectMake(x, y, kImageWidth, kImageHeight);
        imageView.image = obj;
        //添加到父视图
        [self.imageSuperView addSubview:imageView];
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSInteger idx = self.selectedImages.count;
    CGFloat x = idx%kImageCount*(kImageWidth + kImageEdge);
    CGFloat y = idx/kImageCount*(kImageHeight + kImageEdge);
    button.frame = CGRectMake(x, y, kImageWidth, kImageHeight);
    [button setTitle:@"添加图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageSuperView addSubview:button];
    self.tableView.tableFooterView = self.imageSuperView;
    
}
-(void)addPic:(UIButton *)button{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate =self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sender:(UIBarButtonItem *)sender {
    if (self.selectedImages.count == 0) {
        [self sendText];
    }else{
        [self sendImage];
    }
}

-(void)sendText{
    //发文字微博

    NSString *url = [kBaseUrl stringByAppendingPathComponent:@"2/statuses/update.json"];
    NSMutableDictionary *params = [[Account currentAccount ]requestParameters];
    [params setObject:self.textView.text forKey:@"status"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [[[[UIApplication sharedApplication]delegate]window].rootViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendImage{
    //发图片微博
    NSString *url = @"https://upload.api.weibo.com/2/statuses/upload.json";
    NSMutableDictionary *params = [[Account currentAccount]requestParameters];
    [params setObject:self.textView.text forKey:@"status"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //以表单方式提交图片
        UIImage *image = self.selectedImages[0];
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"pic" fileName:@"statusImage" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [[[[UIApplication sharedApplication]delegate]window].rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.label.hidden = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        self.label.hidden = NO;
    }
}
#pragma mark - image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    //取出图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!self.selectedImages) {
        self.selectedImages = [NSMutableArray array];
    }
    [self.selectedImages addObject:image];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
