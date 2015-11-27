//
//  moreVC.m
//  weibo
//
//  Created by qingyun on 15/11/26.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "moreVC.h"

@interface moreVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic)BOOL showAnimation;

@end

@implementation moreVC
- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.showAnimation) {
        [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = obj;
            //动画目标位置
            CGRect frame = button.frame;
            //动画的开始位置
            button.frame = CGRectOffset(button.frame, 0, self.view.frame.size.height - button.frame.origin.y);
            [UIView animateWithDuration:.6f
                                  delay:(idx * 0.1)
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 button.frame = frame;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }];
        self.showAnimation = YES;
    }
}
- (IBAction)click:(UIButton *)sender {
    switch ([sender tag]) {
        case 1:
        {
            UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"sendStatusNav"];
            VC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            //从照片库选择图片
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            //指定媒体源
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
            
        default:
            break;
    }
}

#pragma mark - imagePickerView  delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    //取出选择的图片
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    //将图片传给发微博的界面
    UINavigationController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"sendStatusNav"];
    NSMutableArray *array = [NSMutableArray arrayWithObject:selectedImage];
    [VC.viewControllers[0] setValue:array forKey:@"selectedImages"];
    [self presentViewController:VC animated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
