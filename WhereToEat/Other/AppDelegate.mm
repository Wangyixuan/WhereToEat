//
//  AppDelegate.m
//  Where to eat
//
//  Created by 王磊 on 16/2/23.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "GuideViewController.h"
#import "SVProgressHUD.h"

#ifdef DEBUG
#define isProduction 0
#else
#define isProduction 1
#endif

BMKMapManager* _mapManager;

@implementation AppDelegate

@synthesize window;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//   BOOL canOpenBMK = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"diowtHBh0Pgpl6mAjgI3bnZhHpTmu42L" generalDelegate:self];
    if (!ret) {
        WLLog(@"manager start failed!");
    }
//    [NSThread sleepForTimeInterval:5];
    [self.window makeKeyAndVisible];
    
    //微信注册
    [WXApi registerApp:@"wx6d3a408dd9b6d159" withDescription:@"哪儿吃"];
    // 极光推送
    [self JPushWithOptions:launchOptions];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
    }
    //请求定位服务
    _locationManager=[[BMKLocationService alloc]init];
    _locationManager.delegate = self;
    [_locationManager startUserLocationService];
    
    
    return YES;
}

-(void)JPushWithOptions:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else{
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"eee7286d55479b61b58e24e6"
                          channel:@"AppStore"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //    [BMKMapView willBackGround];//废弃方法（空实现）,逻辑由地图SDK控制
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
    WLLog(@"位置%f,%f",coords.latitude,coords.longitude);
    [self uploadUserLocationWithLat:coords.latitude andLon:coords.longitude];
}

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
- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    _locationManager.delegate = self;
    [_locationManager startUserLocationService];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //    [BMKMapView didForeGround];废弃方法（空实现）,逻辑由地图SDK控制
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}
#pragma mark - Register Remote Notification
/*ios8 need this api， ios10不调用*/
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    WLLog(@"ios8 register setting");
    //[application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    WLLog(@"register remote notification:%@",deviceToken);
    
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    WLLog(@"fail register remote notification:%@",[error description]);
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    [JPUSHService resetBadge];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        WLLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPushMessage" object:nil userInfo:nil];
    }
    else {
        // 判断为本地通知
        WLLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPushMessage" object:nil userInfo:nil];

    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
     [JPUSHService resetBadge];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        WLLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPushMessage" object:nil userInfo:nil];

    }
    else {
        // 判断为本地通知
        WLLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newPushMessage" object:nil userInfo:nil];

    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newPushMessage" object:nil userInfo:nil];

}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        WLLog(@"联网成功");
    }
    else{
        WLLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        WLLog(@"授权成功");
    }
    else {
        WLLog(@"onGetPermissionState %d",iError);
    }
}

-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    
    WLLog(@"%@",resp);
    switch (resp.errCode) {
        case WXSuccess:
            [SVProgressHUD showSuccessWithStatus:@"谢谢您的支持!" duration:2.0];
            break;
        case WXErrCodeUserCancel:
            [SVProgressHUD showErrorWithStatus:@"为什么不呢..." duration:2.0];
            break;
        default:
            break;
    }
}
@end
