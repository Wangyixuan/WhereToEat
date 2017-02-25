//
//  NewViewController.m
//  Where to eat
//
//  Created by 王磊 on 16/3/19.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "NewViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "MyPopView.h"
#import "MyPointAnnotation.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "LocationChange.h"
#import "LocalManager.h"
#import "firstView.h"




@interface NewViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate>
{
    BMKPointAnnotation* animatedAnnotation;
    
}
//地图View
@property (nonatomic, strong) BMKMapView *mapView;
//定位服务
@property(nonatomic,strong) BMKLocationService *locationManager;
//用户所在区域
@property(nonatomic,assign) BMKCoordinateRegion userRegion;
//用户标注
//@property (nonatomic, strong) id<BMKAnnotation> userAnn;
//是否是第一次进入地图
@property (nonatomic, assign) BOOL isFirst;
//搜索服务
@property (nonatomic, strong) BMKPoiSearch *search;
//周边搜索
@property (nonatomic, strong) BMKNearbySearchOption *nearbySearch;
//周边搜索结果列表页数("换一批"按钮控制)
@property (nonatomic, assign) int resultPage;
//搜索关键字输入
@property (strong, nonatomic) UITextField *keyWord;
@property (strong, nonatomic) UIView *keyWordView;
//店面详情搜索
@property (nonatomic, strong) BMKPoiDetailSearchOption *detailSearch;
//信息展示view
@property (nonatomic, strong) MyPopView *popView;
//信息结果数据
@property (nonatomic, strong) BMKPoiDetailResult *detailResult;
@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建地图
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.isSelectedAnnotationViewFront = YES;//选中的标注在最前面

    //关键词输入
    UITextField *keyWord = [[UITextField alloc]initWithFrame:CGRectMake(WLScreenW*(70/414.0), 70, WLScreenW-WLScreenW*(140/414.0), btnsW)];
    keyWord.backgroundColor = [UIColor whiteColor];
    keyWord.borderStyle = UITextBorderStyleRoundedRect;
    keyWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    keyWord.placeholder = @"输入关键字,如:火锅";
    keyWord.textColor = [UIColor lightGrayColor];
    [self.view addSubview:keyWord];
    self.keyWord = keyWord;
   //创建按钮
    [self createBtns];
    //默认第一次进入
    self.isFirst = YES;
    
    //POI搜索
    self.search = [[BMKPoiSearch alloc]init];
    self.detailSearch = [[BMKPoiDetailSearchOption alloc]init];
    self.nearbySearch = [[BMKNearbySearchOption alloc]init];

    //请求定位服务
    _locationManager=[[BMKLocationService alloc]init];
    [_locationManager startUserLocationService];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createBtns) name:@"createBtns" object:nil];
    
//     [self createFirstView];
    //判断是否是第一次进入
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        //第一次进入显示引导页面
        [self createFirstView];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"first"];
    }

    WLLog(@"viewDidLoad");
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.delegate = self;
    _locationManager.delegate = self;
    self.search.delegate = self;
    [self goUserLoc];
    //隐藏old页面popView
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removePopView" object:nil];
    //显示已选标注的popView
    if (self.detailResult != nil) {
        [self createPopViewWith:self.detailResult];
    }
    WLLog(@"viewWillApper");
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    // 不用时，置nil
    _mapView.delegate = nil;
    _locationManager.delegate = nil;
    self.search.delegate = nil;
    [self.popView removeFromSuperview];

    WLLog(@"viewWillDisapper");
}

#pragma mark - BMKMapViewDelegate
/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    WLLog(@"地图将要改变");
//    [_locationManager stopUserLocationService];
      [self.keyWord resignFirstResponder];
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    WLLog(@"地图完成改变");
//    [_locationManager startUserLocationService];
}

//根据标注 添加大头针view
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{

    if ([annotation isKindOfClass:[MyPointAnnotation class]]) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorRed;
            // 从天上掉下效果
            annotationView.animatesDrop = NO;
            // 设置可拖拽
            annotationView.draggable = NO;
            //点击是否显示泡泡
            annotationView.canShowCallout = NO;
        }
         return annotationView;
    }else{
        return nil;
    }
    
}

//选中大头针view 根据标注信息 搜索详细信息
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView setCenterCoordinate:view.annotation.coordinate];
    if ([view.annotation isKindOfClass:[MyPointAnnotation class]]) {
        self.detailSearch.poiUid = ((MyPointAnnotation*)view.annotation).uidString;
        BOOL resultCode = [self.search poiDetailSearch:self.detailSearch];
        if (resultCode) {
            WLLog(@"成功");
        }else{
            WLLog(@"失败");
            [SVProgressHUD showErrorWithStatus:@"获取失败,请再次点击" duration:1];
        }
    }
    WLLog(@"选中");
}
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    WLLog(@"取消选中");
    [self.popView removeFromSuperview];
    self.detailResult =nil;
}

//点击地图上原有的标注
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi{
     [self.keyWord resignFirstResponder];
    //如果没有直接创建
    if (animatedAnnotation==nil) {
        animatedAnnotation = [[BMKPointAnnotation alloc]init];
        animatedAnnotation.title = mapPoi.text;
        animatedAnnotation.coordinate = mapPoi.pt;
        [_mapView addAnnotation:animatedAnnotation];
    }else{
        //如果已有 移除后创建
        [_mapView removeAnnotation:animatedAnnotation];
        animatedAnnotation=nil;
        animatedAnnotation = [[BMKPointAnnotation alloc]init];
        animatedAnnotation.title = mapPoi.text;
        animatedAnnotation.coordinate = mapPoi.pt;
        [_mapView addAnnotation:animatedAnnotation];
    }
}

//点击空白处 移除显示的标注
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    WLLog(@"点击空白");
     [self.keyWord resignFirstResponder];
    [_mapView removeAnnotation:animatedAnnotation];
     animatedAnnotation=nil;
    [self.popView removeFromSuperview];
    self.detailResult =nil;

}
#pragma mark - BMKLocationServiceDelegate

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
//    WLLog(@"方向更新");
    [_mapView updateLocationData:userLocation];

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;{
//    WLLog(@"位置更新");
    [_mapView updateLocationData:userLocation];
    CLLocationCoordinate2D coords = userLocation.location.coordinate;
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01,0.01);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coords, span);
    self.userRegion = region;
    if (self.isFirst==YES) {
        //第一次定位 地图中心跳转到用户位置
        [self goUserLoc];
        self.isFirst = NO;
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    WLLog(@"location error %@",error);
    switch ([error code]) {
        case kCLErrorDenied:{
            UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alet show];
        }
            break;
        default:
            break;
    }
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
//    WLLog(@"result %@",poiResult.poiInfoList);
    WLLog(@"PoiResulterror %u",errorCode);
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            MyPointAnnotation *item = [[MyPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.uidString = poi.uid;
            [annotations addObject:item];
        }
        self.resultPage = poiResult.pageIndex;
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    }
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
//    WLLog(@"resultDetail %@",poiDetailResult);
    WLLog(@"DetailResulterror %u",errorCode);
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        [self createPopViewWith:poiDetailResult];
    }
}

#pragma mark - 私有方法

-(void)createBtns{
    //移除按钮 重新创建
    NSArray *subViews = self.view.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    //按钮x
    CGFloat btnX;
    //左手模式 按钮在屏幕左边
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"leftHand"]==YES) {
        btnX = WLScreenW*(15/414.0);
    }else{
        btnX = WLScreenW-WLScreenW*(65/414.0);
    }
    
    //周边搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(btnX,self.keyWord.frame.origin.y, btnsW, btnsW);
    [searchBtn setTitle:@"搜" forState:UIControlStateNormal];
    [searchBtn setTitleColor:appOrange forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_bg"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_sel_bg"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
//    searchBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:searchBtn];
    [self.view bringSubviewToFront:self.keyWordView];
    
    //定位用户按钮
    UIButton *goUserLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goUserLocBtn.frame = CGRectMake(btnX,self.keyWord.frame.origin.y+2+btnsW, btnsW, btnsW);
    [goUserLocBtn setTitle:@"定" forState:UIControlStateNormal];
    [goUserLocBtn setTitleColor:appOrange forState:UIControlStateNormal];
    [goUserLocBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_bg"] forState:UIControlStateNormal];
    [goUserLocBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_sel_bg"] forState:UIControlStateHighlighted];

    [goUserLocBtn addTarget:self action:@selector(goUserLoc) forControlEvents:UIControlEventTouchUpInside];
//    goUserLocBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:goUserLocBtn];

    //更换搜索结果
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(btnX,self.keyWord.frame.origin.y+((2+btnsW)*2), btnsW, btnsW);
    [nextBtn setTitle:@"下" forState:UIControlStateNormal];
    [nextBtn setTitleColor:appOrange forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_bg"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_sel_bg"] forState:UIControlStateHighlighted];

    [nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
//    nextBtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:nextBtn];
   
    //更换搜索结果
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtn.frame = CGRectMake(btnX,self.keyWord.frame.origin.y+((2+btnsW)*3), btnsW, btnsW);
    [previousBtn setTitle:@"上" forState:UIControlStateNormal];
    [previousBtn setTitleColor:appOrange forState:UIControlStateNormal];
    [previousBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_bg"] forState:UIControlStateNormal];
    [previousBtn setBackgroundImage:[UIImage imageNamed:@"p2_Button_sel_bg"] forState:UIControlStateHighlighted];

    [previousBtn addTarget:self action:@selector(previousPage) forControlEvents:UIControlEventTouchUpInside];
//    previousBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:previousBtn];
    
}

//开始搜索
-(void)startSearch{
    WLLog(@"搜索");
    [self.keyWord resignFirstResponder];
    //地图比例
    [_mapView setZoomLevel:13];
    //周边搜索 中心点 半径
    self.nearbySearch.location = self.userRegion.center;
    self.nearbySearch.radius = 3000;
    //关键词
    if (self.keyWord.text.length>0) {
        self.nearbySearch.keyword = self.keyWord.text;
    }else{
        self.nearbySearch.keyword = @"美食";
    }
    BOOL resultCode = [self.search poiSearchNearBy:self.nearbySearch];
    if (resultCode) {
        WLLog(@"成功");
    }else{
        WLLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"搜索失败,请重新搜索" duration:1];
    }
}

//定位到用户自己的位置
-(void)goUserLoc{
    
    WLLog(@"定位自己");
    [_mapView setRegion:self.userRegion animated:YES];
    [_mapView setCenterCoordinate:self.userRegion.center];
    
}

//更换搜索结果
-(void)nextPage{
    WLLog(@"下一页");
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    //搜索结果页索引+1
    self.nearbySearch.pageIndex = self.resultPage+1;
    self.nearbySearch.location = self.userRegion.center;
    self.nearbySearch.radius = 3000;
    if (self.keyWord.text.length>0) {
        self.nearbySearch.keyword = self.keyWord.text;
    }else{
        self.nearbySearch.keyword = @"美食";
    }
    BOOL resultCode = [self.search poiSearchNearBy:self.nearbySearch];
    if (resultCode) {
        WLLog(@"成功");
    }else{
        WLLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"搜索失败,请重新搜索" duration:1];
    }
}

-(void)previousPage{
     WLLog(@"上一页");
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    //搜索结果页索引+1
    if (self.resultPage>0) {
        self.nearbySearch.pageIndex = self.resultPage-1;
        self.nearbySearch.location = self.userRegion.center;
        self.nearbySearch.radius = 3000;
        if (self.keyWord.text.length>0) {
            self.nearbySearch.keyword = self.keyWord.text;
        }else{
            self.nearbySearch.keyword = @"美食";
        }
        BOOL resultCode = [self.search poiSearchNearBy:self.nearbySearch];
        if (resultCode) {
            WLLog(@"成功");
        }else{
            WLLog(@"失败");
            [SVProgressHUD showErrorWithStatus:@"搜索失败,请重新搜索" duration:1];
        }
    }
}

-(void)createPopViewWith:(BMKPoiDetailResult*)detailResult{
    
    MyPopView *popView = [MyPopView loadMyPopView];
    popView.frame = CGRectMake(0, self.view.bounds.size.height-126, self.view.bounds.size.width, 126);
    popView.bottomView.hidden = YES;
    popView.detailResult = detailResult;
    [self.view addSubview:popView];
    self.popView = popView;
    self.detailResult = detailResult;
    __weak typeof(self) weakself = self;
    popView.detailBlock = ^(NSString *detailURL){
        WLLog(@"详情");
        DetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailVC.detailURL = detailURL;
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:detailVC];
        [weakself presentViewController:navController animated:YES completion:nil];
    };
    popView.poisionBlock = ^(CLLocationCoordinate2D coord,NSString*name){
        [weakself naviClickWithCrood:coord name:name];
        WLLog(@"导航");
    };
}


//导航
-(void)naviClickWithCrood:(CLLocationCoordinate2D)coord name:(NSString*)name{
    //百度地图客户端
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"baidumap://map/"]]]) {
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving",self.userRegion.center.latitude,self.userRegion.center.longitude,coord.latitude,coord.longitude];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    //原生地图
    else{
        double bdDestLat,bdDestLon;
        bd_decrypt(coord.latitude, coord.longitude, &bdDestLat, &bdDestLon);
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(bdDestLat, bdDestLon);
    
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    toLocation.name = name;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
}

//第一次进入显示引导页面
-(void)createFirstView{
    firstView *fView = [firstView loadFirstView];
    fView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.tabBarController.view addSubview:fView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
