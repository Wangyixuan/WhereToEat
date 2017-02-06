//
//  ShareView.m
//  WhereToEat
//
//  Created by 王磊 on 16/7/26.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface ShareView()


@end

@implementation ShareView

+(instancetype)showShareViewWithFrame:(CGRect)frame andView:(UIView*)view{

    ShareView *shareV = [[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil].firstObject;
    shareV.frame = frame;
    [view addSubview:shareV];
    return shareV;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnClick:)];
    [self addGestureRecognizer:tap];
    
    
}

//微信好友
- (IBAction)sessionBtnClick:(id)sender {
    [self shareAppWithScene:0];
}

//朋友圈
- (IBAction)timelineBtnClick:(id)sender {
    [self shareAppWithScene:1];
}

//收藏
- (IBAction)favoriteBtnClick:(id)sender {
    [self shareAppWithScene:2];
}

//取消按钮
- (IBAction)cancelBtnClick:(id)sender {
    
    [self removeFromSuperview];
}

-(void)shareAppWithScene:(NSInteger)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    WXWebpageObject *web = [WXWebpageObject object];
    //分享图片
    WXImageObject *imageObj = [WXImageObject object];

    if (scene==1) {
        UIImage *img = [UIImage imageNamed:@"QR"];
        NSData *imageData = UIImagePNGRepresentation(img);
        imageObj.imageData = imageData;
        message.mediaObject = imageObj;
    }else{
        message.mediaObject = web;
        web.webpageUrl = appURL;
    }
    
    message.title = @"解决吃饭难得问题";
    message.description = @"点击前往下载";
    UIImage *image = [UIImage imageNamed:@"iconImage"];
    [message setThumbImage:image];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = (int)scene;
    [WXApi sendReq:req];

    [self removeFromSuperview];
}

-(void)dealloc{
    WLLog(@"share dealloc");
}
@end
