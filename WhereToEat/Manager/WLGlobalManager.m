//
//  WLGlobalManager.m
//  WhereToEat
//
//  Created by 王磊 on 2017/11/10.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "WLGlobalManager.h"
#import <MapKit/MapKit.h>
#import "LocationChange.h"


@interface WLGlobalManager()<BMKLocationServiceDelegate>
//定位服务
@property(nonatomic,strong) BMKLocationService *locationManager;

@end

@implementation WLGlobalManager

static dispatch_once_t once;
static WLGlobalManager *instance;

+ (instancetype)sharedGlobalManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}

-(instancetype)init{
    if (self = [super init]) {
        _locationManager=[[BMKLocationService alloc]init];
    }
    return self;
}

-(void)updateUserLocation {
    
    //请求定位服务  
    _locationManager.delegate = self;
    [_locationManager startUserLocationService];
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;{
    //    WLLog(@"位置更新");
    CLLocationCoordinate2D coords = userLocation.location.coordinate;
    [_locationManager stopUserLocationService];
    _locationManager.delegate = nil;
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01,0.01);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coords, span);
    WLLog(@"位置%f,%f",coords.latitude,coords.longitude);
    self.userRegion = region;
    [self uploadUserLocationWithLat:coords.latitude andLon:coords.longitude];
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
        default: [SVProgressHUD showErrorWithStatus:@"定位失败,请重试" duration:1.2];
            break;
    }
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

//上传用户坐标
-(void)uploadUserLocationWithLat:(double)lat andLon:(double)lon{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    //确定请求路径
    NSString *urlStr = [NSString stringWithFormat:@"%@?lat=%f&lon=%f&uuid=%@",UpLoadLocationServerInterface,lat,lon,uuid];
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /**
     根据对象创建 Task 请求
     
     url  方法内部会自动将 URL 包装成一个请求对象（默认是 GET 请求）
     completionHandler  完成之后的回调（成功或失败）
     
     param data     返回的数据（响应体）
     param response 响应头
     param error    错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          //解析服务器返回的数据
                                          WLLog(@"uploadLocation%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          WLLog(@"error %@",error);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
}

@end
