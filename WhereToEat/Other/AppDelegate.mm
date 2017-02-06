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

    [self.window makeKeyAndVisible];
    
    //微信注册
    [WXApi registerApp:@"wx6d3a408dd9b6d159" withDescription:@"哪儿吃"];

    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"launched"]) {
//        //程序第一次启动
//        GuideViewController *appStartController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:(@"GuideViewController")];
//        self.window.rootViewController = appStartController;
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"leftHand"];
//     }
//    else{
//        ComeBackViewController *comeBack =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:(@"ComeBackViewController")];
//        self.window.rootViewController = comeBack;
//}

    return YES;
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


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
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
