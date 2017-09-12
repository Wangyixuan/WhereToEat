//
//  MyPopView.m
//  Where to eat
//
//  Created by 王磊 on 16/4/12.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "MyPopView.h"
#import "WCAlertView.h"
#import "LocalManager.h"

@interface MyPopView ()
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *oldFavoriteBtn;

//店名
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
//人均价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//电话
@property (weak, nonatomic) IBOutlet UIButton *phoneNub;
//uid 用于查询详细结果
@property (nonatomic, strong) NSString *uid;
//详情页面url
@property (nonatomic, strong) NSString *detailURL;
//店面坐标
@property (nonatomic, assign) CLLocationCoordinate2D toCoord;
//背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end


@implementation MyPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:255/255.0 green:201/255.0 blue:111/255.0 alpha:1].CGColor;
    
    UIImage *btnBG = [UIImage imageNamed:@"popView_bg"];
    CGFloat top = 0; // 顶端盖高度
    
    CGFloat bottom = 0 ; // 底端盖高度
    
    CGFloat left = 70; // 左端盖宽度
    
    CGFloat right =70; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    btnBG = [btnBG resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bgImage.image = btnBG;
    
}

+(instancetype)loadMyPopView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MyPopView" owner:nil options:nil].firstObject;
}

//得到详细信息 控件赋值
-(void)setDetailResult:(BMKPoiDetailResult *)detailResult{
    _detailResult = detailResult;
    self.titleLabel.text = detailResult.name;
    self.subTitleLabel.text = detailResult.address;
    self.uid = detailResult.uid;
   
    NSString *nubStr =detailResult.phone;
    //会有多个电话号码的情况 只截取第一个电话号码
    NSArray *nubArray = [nubStr componentsSeparatedByString:@","];
    NSString *nub1 = [nubArray firstObject];
    [self.phoneNub setTitle:nub1 forState:UIControlStateNormal];
   
    self.detailURL = detailResult.detailUrl;
    self.toCoord = detailResult.pt;
    NSString *priceStr = [NSString stringWithFormat:@"人均:%%￥%.1f%%",detailResult.price];
    NSArray *array = [priceStr componentsSeparatedByString:@"%"];
    NSString *s1 = [array objectAtIndex:0];
    NSString *s2 = [array objectAtIndex:1];
    NSString *priceOffStr = [NSString stringWithFormat:@"%@%@",s1,s2];
    NSMutableAttributedString *priceMutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",priceOffStr]];
    //改变颜色
    [priceMutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(s1.length,s2.length)];
    self.priceLabel.attributedText = priceMutStr;
   //查询plist 如果已存在显示已收藏
    NSString *uid = [KKSharedLocalManager kkValueForKey:self.titleLabel.text];
    if (self.bottomView.hidden == YES) {
        if (uid.length>0) {
            self.favoriteBtn.selected = YES;
        }else{
            self.favoriteBtn.selected = NO;
        }
    }else{
        if (uid.length>0) {
            self.oldFavoriteBtn.selected = YES;
        }else{
            self.oldFavoriteBtn.selected = NO;
        }
    }
}

//点击电话按钮时间
- (IBAction)phoneNubClick:(UIButton*)sender {
    [WCAlertView showAlertWithTitle:@"您确定要拨打" message:sender.titleLabel.text customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.titleLabel.text]]];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
}

//收藏按钮
- (IBAction)favoriteBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
   //如果选中 说明已收藏 存入pilst
    if (sender.selected==YES) {
        [KKSharedLocalManager setKKValue:self.uid forKey:self.titleLabel.text];
        if (self.uploadBlock) {
            self.uploadBlock(self.detailResult);
        }
    }
    //取消选中 不收藏 从plist删除
    else{
        [KKSharedLocalManager removeKKValueForKey:self.titleLabel.text];
    }
    //更新球形标签
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePlist" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removePopView" object:nil];
    WLLog(@"收藏");
}

//跳转详情页面
- (IBAction)detailBtnClick:(id)sender {
    if (self.detailBlock) {
        self.detailBlock(self.detailURL);
    }
}

//导航 跳转到百度地图客户端 (如果没有跳转到系统地图)
- (IBAction)poisionBtnClick:(id)sender {
    if (self.poisionBlock) {
        self.poisionBlock(self.toCoord,self.titleLabel.text);
    }
}
- (IBAction)closeBtnClick:(id)sender {
    [self removeFromSuperview];
}

@end
