//
//  PushMesCell.m
//  WhereToEat
//
//  Created by 王磊 on 2017/9/12.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "PushMesCell.h"
#import "WCAlertView.h"
#import "LocalManager.h"


@interface PushMesCell()<BMKPoiSearchDelegate>
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *pushFavoriteBtn;
//店名
@property (weak, nonatomic) IBOutlet UILabel *pushTitleLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *pushSubTitleLabel;
//人均价格
@property (weak, nonatomic) IBOutlet UILabel *pushPriceLabel;
//电话
@property (weak, nonatomic) IBOutlet UIButton *pushPhoneNub;
//uid 用于查询详细结果
@property (nonatomic, strong) NSString *pushUid;
//详情页面url
@property (nonatomic, strong) NSString *pushDetailURL;
//店面坐标
@property (nonatomic, assign) CLLocationCoordinate2D pushCoord;
//背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (nonatomic, strong) BMKPoiSearch *search;
//详细结果数据
@property (nonatomic, strong) BMKPoiDetailResult *pushDetailResult;
@end

@implementation PushMesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    
    self.search = [[BMKPoiSearch alloc]init];
    self.search.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDetailSearch:(BMKPoiDetailSearchOption *)detailSearch{
    _detailSearch = detailSearch;
    BOOL resultCode = [self.search poiDetailSearch:detailSearch];
    if (resultCode) {
        WLLog(@"成功");
    }else{
        WLLog(@"失败");
    }
}
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    WLLog(@"resultDetail %@",poiDetailResult.name);
    WLLog(@"error %u",errorCode);
    self.pushDetailResult = poiDetailResult;
}

//得到详细信息 控件赋值
-(void)setPushDetailResult:(BMKPoiDetailResult *)pushDetailResult{
    _pushDetailResult = pushDetailResult;
    self.pushTitleLabel.text = pushDetailResult.name;
    self.pushSubTitleLabel.text = pushDetailResult.address;
    self.pushUid = pushDetailResult.uid;
    
    NSString *nubStr =pushDetailResult.phone;
    //会有多个电话号码的情况 只截取第一个电话号码
    NSArray *nubArray = [nubStr componentsSeparatedByString:@","];
    NSString *nub1 = [nubArray firstObject];
    [self.pushPhoneNub setTitle:nub1 forState:UIControlStateNormal];
    
    self.pushDetailURL = pushDetailResult.detailUrl;
    self.pushCoord = pushDetailResult.pt;
    NSString *priceStr = [NSString stringWithFormat:@"人均:%%￥%.1f%%",pushDetailResult.price];
    NSArray *array = [priceStr componentsSeparatedByString:@"%"];
    NSString *s1 = [array objectAtIndex:0];
    NSString *s2 = [array objectAtIndex:1];
    NSString *priceOffStr = [NSString stringWithFormat:@"%@%@",s1,s2];
    NSMutableAttributedString *priceMutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",priceOffStr]];
    //改变颜色
    [priceMutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(s1.length,s2.length)];
    self.pushPriceLabel.attributedText = priceMutStr;
    //查询plist 如果已存在显示已收藏
    NSString *uid = [KKSharedLocalManager kkValueForKey:self.pushTitleLabel.text];
    if (uid.length>0) {
        self.pushFavoriteBtn.selected = YES;
    }else{
        self.pushFavoriteBtn.selected = NO;
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
        [KKSharedLocalManager setKKValue:self.pushUid forKey:self.pushTitleLabel.text];
    }
    //取消选中 不收藏 从plist删除
    else{
        [KKSharedLocalManager removeKKValueForKey:self.pushTitleLabel.text];
    }
    //更新球形标签
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePlist" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removePopView" object:nil];
    WLLog(@"收藏");
}

//跳转详情页面
- (IBAction)detailBtnClick:(id)sender {
    if (self.pushDetailBlock) {
        self.pushDetailBlock(self.pushDetailURL);
    }
}

//导航 跳转到百度地图客户端 (如果没有跳转到系统地图)
- (IBAction)poisionBtnClick:(id)sender {
    if (self.pushPoisionBlock) {
        self.pushPoisionBlock(self.pushCoord,self.pushTitleLabel.text);
    }
}
@end
