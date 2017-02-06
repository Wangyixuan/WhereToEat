//
//  OldViewController.m
//  Where to eat
//
//  Created by 王磊 on 16/3/19.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "OldViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "XLSphereView.h"
#import "MyPopView.h"
#import "LocalManager.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "DetailViewController.h"

@interface OldViewController ()<GADInterstitialDelegate,BMKPoiSearchDelegate>
@property (strong, nonatomic) GADBannerView *bannerView;
@property (nonatomic, strong) UIButton *showADBtn;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic,strong) XLSphereView *sphereView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) MyPopView *popView;
@property (nonatomic, strong) BMKPoiSearch *search;
@property (nonatomic, strong) BMKPoiDetailSearchOption *detailSearch;
@property (nonatomic, strong) UIButton *annBtn;
@property (nonatomic, strong) UIButton *randomBtn;
@end

@implementation OldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.array = [NSMutableArray array];
    //底部横幅广告
    
    self.bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, WLScreenH-100, WLScreenW, 50)];
//    self.bannerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-5111159436910163/5991395931";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ @"2e6de24a40a9b203977d3aa2f6fcade5"];
    [self.bannerView loadRequest:request];
    [self.view bringSubviewToFront:self.bannerView];
    //创建插页广告
    [self createAndLoad];
    //创建球形标签
    [self createBallView];
    //POI搜索
    self.search = [[BMKPoiSearch alloc]init];
    self.detailSearch = [[BMKPoiDetailSearchOption alloc]init];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake((WLScreenW*0.5- BtnW)*0.5,self.sphereView.frame.origin.y+self.sphereView.frame.size.height+self.view.frame.size.width*0.1,BtnW,BtnH)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:appOrange forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"p1_Button_bg"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"p1_Button_sel_bg"] forState:UIControlStateHighlighted];

    [addBtn addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    self.annBtn = addBtn;
   
    UIButton *randomBtn = [[UIButton alloc]initWithFrame:CGRectMake(WLScreenW*0.5+(WLScreenW*0.5-BtnW)*0.5,self.annBtn.frame.origin.y,BtnW,BtnH)];
    [randomBtn setTitle:@"随机" forState:UIControlStateNormal];
    [randomBtn setTitleColor:appOrange forState:UIControlStateNormal];
    [randomBtn setBackgroundImage:[UIImage imageNamed:@"p1_Button_bg"] forState:UIControlStateNormal];
    [randomBtn setBackgroundImage:[UIImage imageNamed:@"p1_Button_sel_bg"] forState:UIControlStateHighlighted];

    [randomBtn addTarget:self action:@selector(showAD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:randomBtn];
    self.randomBtn = randomBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createBallView) name:@"updatePlist" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removePopView) name:@"removePopView" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.search.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.search.delegate = nil;
}

-(void)createBallView{
    [self.sphereView removeFromSuperview];
    //创建球形标签
    if (WLScreenH==WLScreenHIphone4s) {
        _sphereView = [[XLSphereView alloc] initWithFrame:CGRectMake(30, WLScreenW*0.1, sphereViewW, sphereViewH)];
//        _sphereView.backgroundColor = [UIColor redColor];
    }else if (WLScreenH==WLScreenHIphone5s){
        _sphereView = [[XLSphereView alloc] initWithFrame:CGRectMake(30, WLScreenW*0.2, sphereViewW, sphereViewH)];
//        _sphereView.backgroundColor = [UIColor greenColor];
    }else if (WLScreenH==WLScreenHIphone6s){
        _sphereView = [[XLSphereView alloc] initWithFrame:CGRectMake(30, WLScreenW*0.2, sphereViewW, sphereViewH)];
//        _sphereView.backgroundColor = [UIColor blueColor];
    }else{
        _sphereView = [[XLSphereView alloc] initWithFrame:CGRectMake(30, WLScreenW*0.2, sphereViewW, sphereViewH)];
//        _sphereView.backgroundColor = [UIColor yellowColor];
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
   //获取所以收藏的店面
    NSArray *keyArray = [KKSharedLocalManager.plistDataDic allKeys];
    UIImage *btnBG = [UIImage imageNamed:@"p1_btn_bg"];
    CGFloat top = 0; // 顶端盖高度
    
    CGFloat bottom = 0 ; // 底端盖高度
    
    CGFloat left = 100; // 左端盖宽度
    
    CGFloat right = 100; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    btnBG = [btnBG resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    //如果已有收藏 显示收藏店面
    if (keyArray.count>0) {
        [self.showADBtn removeFromSuperview];
        for (int i = 0; i < keyArray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            NSString *name = [keyArray objectAtIndex:i];
            NSString *nameStr = [NSString stringWithFormat:@"%@",name];
   

            [btn setTitle:nameStr forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:btnBG forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:24.];
            CGSize textSize = [nameStr sizeWithAttributes:@{ NSFontAttributeName :btn.titleLabel.font}];
            btn.frame = CGRectMake(0, 0, textSize.width+20, textSize.height+15);
//            [btn sizeToFit];
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [array addObject:btn];
            [_sphereView addSubview:btn];
        }
        self.array = array;
    }
    //如果还没有收藏 显示提示
    else{
        if (self.array.count>0) {
            [self.array removeAllObjects];
        }
        NSArray *hitArray = [NSArray arrayWithObjects:@" 还没有收藏 ",@" 快去添加 ",@" 吧 ! ! ! ",@" 还没有收藏 ",@" 快去添加 ",@" 吧 ! ! ! ",@" 还没有收藏 ",@" 快去添加 ",@" 吧 ! ! ! ",@" 重要的事情说三遍 ",nil];
        for (int i = 0; i < hitArray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            NSString *hit = [hitArray objectAtIndex:i];
            [btn setTitle:hit forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:btnBG forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:24.];
            CGSize textSize = [hit sizeWithAttributes:@{ NSFontAttributeName :btn.titleLabel.font}];
            btn.frame = CGRectMake(0, 0, textSize.width+10, textSize.height+10);
//            [btn sizeToFit];
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            [array addObject:btn];
            [_sphereView addSubview:btn];
        }
    }
    [_sphereView setItems:array];
    [self.view addSubview:_sphereView];
}

//创建插入式广告
-(void)createAndLoad{
    //GADInterstitial一次性对象 使用之后需重新创建
    self.interstitial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-5111159436910163/2898328738"];
    self.interstitial.delegate = self;
    GADRequest *interRequest = [GADRequest request];
//    interRequest.testDevices = @[ @"2e6de24a40a9b203977d3aa2f6fcade5"];
    [self.interstitial loadRequest:interRequest];
}

//去添加按钮方法
-(void)goSearch{
    //跳转到搜索页面
    self.tabBarController.selectedIndex=1;
}

//点击随机按钮 显示广告
-(void)showAD{
    WLLog(@"显示广告");
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
        WLLog(@"显示成功");
    }else{
        WLLog(@"显示失败");
        //显示随机结果
        [self randomBtnClick];
    }
}
//选出随机结果
-(void)randomBtnClick{
    WLLog(@"随机");
    WLLog(@"%@",self.array);
    if (self.array.count>0) {
        int x = arc4random() % self.array.count;
        if (self.array.count>x) {
            UIButton *result = [self.array objectAtIndex:x];
            [self buttonPressed:result];
        }
    }else{
        self.tabBarController.selectedIndex=1;
    }
}

//点击店面 获取详细信息
- (void)buttonPressed:(UIButton *)btn
{
    [_sphereView timerStop];
    //点击按钮变大
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
        //点击按钮 通过key 获取uid 请求数据展示
        NSString *uidStr = [KKSharedLocalManager kkValueForKey:btn.titleLabel.text];
        if (self.search.delegate==nil) {
            self.search.delegate = self;
        }
        self.detailSearch.poiUid = uidStr;
        BOOL resultCode = [self.search poiDetailSearch:self.detailSearch];
        if (resultCode) {
            WLLog(@"成功");
        }else{
            WLLog(@"失败");
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [_sphereView timerStart];
        }];
    }];
}

#pragma mark - GADInterstitialDelegate
-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{
   //显示随机结果
    [self randomBtnClick];

}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
 
    //重新创建插页广告
    [self createAndLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    //    WLLog(@"resultDetail %@",poiDetailResult);
    WLLog(@"error %u",errorCode);
    
    [self createPopViewWithDetailResult:poiDetailResult];

}

-(void)createPopViewWithDetailResult:(BMKPoiDetailResult*)poiDetailResult{
    [self.popView removeFromSuperview];
    
    MyPopView *popView = [MyPopView loadMyPopView];
    popView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 126);
    popView.detailResult = poiDetailResult;
    popView.bottomView.hidden = NO;
    [self.view addSubview:popView];
    self.popView = popView;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (WLScreenH==WLScreenHIphone4s) {
            popView.frame = CGRectMake(0, self.view.bounds.size.height-126, self.view.bounds.size.width, 126);
            self.sphereView.frame = CGRectMake(40, 20, WLScreenW*0.7, WLScreenW*0.7);
            self.annBtn.frame = CGRectMake((WLScreenW*0.5- BtnW)*0.5,(popView.frame.origin.y-20-self.sphereView.frame.size.height-BtnH)*0.5+20+self.sphereView.frame.size.height,BtnW,BtnH);
            self.randomBtn.frame = CGRectMake(WLScreenW*0.5+(WLScreenW*0.5-BtnW)*0.5,self.annBtn.frame.origin.y,BtnW,BtnH);
        }else if (WLScreenH==WLScreenHIphone5s){
            popView.frame = CGRectMake(0, self.view.bounds.size.height-175, self.view.bounds.size.width, 126);
            self.sphereView.frame = CGRectMake(30, 30,sphereViewW , sphereViewH);
            self.annBtn.frame = CGRectMake((WLScreenW*0.5- BtnW)*0.5,(popView.frame.origin.y-30-sphereViewH-BtnH)*0.5+30+sphereViewH,BtnW,BtnH);
            self.randomBtn.frame = CGRectMake(WLScreenW*0.5+(WLScreenW*0.5-BtnW)*0.5,self.annBtn.frame.origin.y,BtnW,BtnH);
        }else if (WLScreenH==WLScreenHIphone6s){
            popView.frame = CGRectMake(0, self.view.bounds.size.height-175, self.view.bounds.size.width, 126);
            self.sphereView.frame = CGRectMake(30, 40,sphereViewW , sphereViewH);
            self.annBtn.frame = CGRectMake((WLScreenW*0.5- BtnW)*0.5,(popView.frame.origin.y-40-sphereViewH-BtnH)*0.5+40+sphereViewH,BtnW,BtnH);
            self.randomBtn.frame = CGRectMake(WLScreenW*0.5+(WLScreenW*0.5-BtnW)*0.5,self.annBtn.frame.origin.y,BtnW,BtnH);
        }else{
            popView.frame = CGRectMake(0, self.view.bounds.size.height-175, self.view.bounds.size.width, 126);
            self.sphereView.frame = CGRectMake(30, 50,sphereViewW , sphereViewH);
            self.annBtn.frame = CGRectMake((WLScreenW*0.5- BtnW)*0.5,(popView.frame.origin.y-50-sphereViewH-BtnH)*0.5+50+sphereViewH,BtnW,BtnH);
            self.randomBtn.frame = CGRectMake(WLScreenW*0.5+(WLScreenW*0.5-BtnW)*0.5,self.annBtn.frame.origin.y,BtnW,BtnH);
        }
   }];
    
    __weak typeof(self) weakself = self;
    popView.detailBlock = ^(NSString *detailURL){
        WLLog(@"详情");
        DetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailVC.detailURL = detailURL;
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:detailVC];
        [weakself presentViewController:navController animated:YES completion:nil];
    };
}

-(void)removePopView{
    [self.popView removeFromSuperview];
    
    if (WLScreenH==WLScreenHIphone4s) {
        self.sphereView.frame = CGRectMake(30, WLScreenW*0.1, sphereViewW, sphereViewH);
    }else if (WLScreenH==WLScreenHIphone5s){
        self.sphereView.frame =CGRectMake(30, WLScreenW*0.2, sphereViewW, sphereViewH);
    }else if (WLScreenH==WLScreenHIphone6s){
        self.sphereView.frame =CGRectMake(30, WLScreenW*0.2, sphereViewW, sphereViewH);
    }else{
        self.sphereView.frame =CGRectMake(30, WLScreenW*0.2, sphereViewW, sphereViewH);
    }
    self.annBtn.frame = CGRectMake((WLScreenW*0.5- BtnW)*0.5,self.sphereView.frame.origin.y+self.sphereView.frame.size.height+self.view.frame.size.width*0.1,BtnW,BtnH);
    self.randomBtn.frame = CGRectMake(WLScreenW*0.5+(WLScreenW*0.5-BtnW)*0.5,self.annBtn.frame.origin.y,BtnW,BtnH);
  
}

@end
