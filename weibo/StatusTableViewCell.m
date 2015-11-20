//
//  StatusTableViewCell.m
//  weibo
//
//  Created by qingyun on 15/11/16.
//  Copyright (c) 2015年 张雪城. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "Common.h"
#import "NSString+TextHeight.h"
#import "SDPhotoBrowser.h"
#import "UIButton+WebCache.h"

#define kImageWidth 90
#define kImageHeight 90
#define kImageEdge 5
#define kImageCount 3

@interface StatusTableViewCell () <SDPhotoBrowserDelegate>


@end

@implementation StatusTableViewCell
+(CGFloat)cellHeightForStatus:(StatusModel *)status{
    CGFloat cellHeight = 61;//正文开始的高度
    //手动计算cell高度
    NSString *text = status.text;
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 16, MAXFLOAT);
    CGFloat textHeight = [text HeightWithSize:size Font:[UIFont systemFontOfSize:17]];
    
    //加上文字的高度
    cellHeight += textHeight;
    
    //如果有转发微博，那么就不显示正文图片
    StatusModel *reStatus = status.retweeted_status;
    if (reStatus) {
        //加上转发微博需要的高度
        cellHeight += [reStatus.text HeightWithSize:size Font:[UIFont systemFontOfSize:17]];
        
        //加上转发微博图片需要的高度
        cellHeight += [StatusTableViewCell imageContentViewHeightForPics:reStatus.pic_urls];
        
    }else {
        //计算出图片显示需要的高度
        NSArray *pics = status.pic_urls;
        cellHeight += [StatusTableViewCell imageContentViewHeightForPics:pics];
    }
    
    
    //返回cell的高度
    return cellHeight + 8 + 1;
}

+(CGFloat)imageContentViewHeightForPics:(NSArray *)pics{
    //根据图片的张数，计算view显示需要的高度
    //向上取整
    NSInteger line = ceil(pics.count/(CGFloat)kImageCount);
    NSInteger height = line*kImageHeight + (line - 1)*kImageEdge;
    
    return height;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)bandingStatusModel:(StatusModel *)info{
    //    NSDictionary *userInfo = info[@"user"];
    //    NSString *imageUrl = userInfo[@"profile_image_url"];
    
    
#if 0
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.icon setImage:image];
        });
        
        
    });
#else
    //通过SDWebImage 下载图片
    //    [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:info.user.profile_image_url]];
#endif
    
    //    self.name.text = userInfo[@"name"];
    //    self.time.text = info[@"created_at"];
    //    self.source.text = info[@"source"];
    //    self.content.text = info[@"text"];
    self.name.text = info.user.name;
    self.time.text = info.createdString;
    self.source.text = info.source;
    self.content.text = info.text;
    
    StatusModel *reStatus = info.retweeted_status;
    if (reStatus) {
        //绑定图片,清空正文的图片
        [self bandingImages:nil View:self.contentImageSuperView Contrianst:self.ContentImgHeightConstraint];
        self.reTwitterContent.text = reStatus.text;
        [self bandingImages:reStatus.pic_urls View:self.reTwitterImgSuperView Contrianst:self.reTwiImgSupHeightConstaint];
    }else{
        //绑定图片
        [self bandingImages:info.pic_urls View:self.contentImageSuperView Contrianst:self.ContentImgHeightConstraint];
        
        //清除转发控件的内容
        self.reTwitterContent.text = nil;
        [self bandingImages:nil View:self.reTwitterImgSuperView Contrianst:self.reTwiImgSupHeightConstaint];
    }
    
    
}
-(void)bandingImages:(NSArray *)pics View:(UIView *)superView Contrianst:(NSLayoutConstraint*)constraint{
    //移除所有的子视图
    NSArray *subViews = superView.subviews;
    //对数组中的每一个对象发消息
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //调整View到合适的高度
    CGFloat height = [StatusTableViewCell imageContentViewHeightForPics:pics];
    constraint.constant = height;
    
    //添加imageView
    [pics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [[UIButton alloc] init];
        //frame
        CGFloat x = idx%kImageCount*(kImageWidth + kImageEdge);
        CGFloat y = idx/kImageCount*(kImageHeight + kImageEdge);
        button.frame = CGRectMake(x, y, kImageWidth, kImageHeight);
        //url
        NSString *urlstring = obj[kStatusThumbnailPic];
        [button sd_setImageWithURL:[NSURL URLWithString:urlstring] forState:UIControlStateNormal];
        //添加到父视图上
        [superView addSubview:button];
        [button addTarget:self action:@selector(imageShow:) forControlEvents:UIControlEventTouchUpInside];
        //button保存索引
        button.tag = idx;
    }];
    
}

-(void)imageShow:(UIButton *)button{
    //创建一个图片浏览器实例
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    //当前图片所处的索引
    browser.currentImageIndex = button.tag;
    //原图的父控件
    browser.sourceImagesContainerView = button.superview;
    //图片的总数
    browser.imageCount = button.superview.subviews.count;
    //指定delegate
    browser.delegate = self;
    [browser show];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - Photo Browser

//返回临时的占位图片，就是原来的小图
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    //在显示的时候，指定了该属性
    UIButton *button = browser.sourceImagesContainerView.subviews[index];
    //找到按钮后，返回按钮显示的图片
    return button.currentImage;
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    UIButton *button = browser.sourceImagesContainerView.subviews[index];
    NSString *urlString = button.sd_currentImageURL.absoluteString;
    NSString *newString = [urlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    return [NSURL URLWithString:newString];
}

@end
