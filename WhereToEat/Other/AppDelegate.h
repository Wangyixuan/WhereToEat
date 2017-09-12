//
//  AppDelegate.h
//  Where to eat
//
//  Created by 王磊 on 16/2/23.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "WXApi.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,WXApiDelegate,JPUSHRegisterDelegate,BMKLocationServiceDelegate>

@property (strong, nonatomic) UIWindow *window;
//定位服务
@property(nonatomic,strong) BMKLocationService *locationManager;
@end

