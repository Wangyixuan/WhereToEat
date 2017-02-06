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

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

