//
//  CommonMacro.h
//  Where to eat
//
//  Created by 王磊 on 16/3/22.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

// Log打印，发布阶段自动关闭
#ifdef DEBUG
#define WLLog(...)  NSLog(__VA_ARGS__)
#else
#define WLLog(...)
#endif

#define KKScreenHeightIphone4s 480
#define KKScreenHeightIphone5  568
#define KKScreenHeightIphone6  667
#define KKScreenHeightIphone6p  736
#define KKScreenHeightIphoneX  812

#define KKScreenWidthIphone5  320
#define KKScreenWidthIphone6 375
#define KKScreenWidthIphone6p 414
#define KKScreenWidthIphoneX 375

#define WLScreenW [UIScreen mainScreen].bounds.size.width
#define WLScreenH [UIScreen mainScreen].bounds.size.height
#define sphereViewW WLScreenW*0.8
#define sphereViewH sphereViewW
//添加 随机按钮
#define BtnW WLScreenW*(276/750.0)
#define BtnH WLScreenW*(102/750.0)
//搜索页面按钮
#define btnsW WLScreenW*(98/750.0)
//app产品色
#define appOrange [UIColor colorWithRed:255/255.0 green:128/255.0 blue:26/255.0 alpha:1]
//app store 跳转链接
#define appURL @"http://itunes.apple.com/us/app/id1112067909"

// Block weakself strongself
#define WLWEAKSELF __weak typeof(self) weakself = self;
#define WLSTRONGSELF __strong typeof(weakself) strongself = weakSelf;

#define WLViewController(StoryboardID) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:StoryboardID];

//StringFormat
#define KKStringWithFormat(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]
#define KKUserDefaults [NSUserDefaults standardUserDefaults]
//String bank
#define KKStringIsBlank(string)  [NSString isBlank:string]
#define KKStringIsNotBlank(string) [NSString isNotBlank:string]

#define KKRegexNotBlack  @"^.+$"

#define KK_STATUSBAR_HEIGHT    [[UIApplication sharedApplication] statusBarFrame].size.height
#define KK_NAVIGATIONBAR_HEIGHT   self.navigationController.navigationBar.frame.size.height
#define KK_STATUSBAR_AND_NAVIGATIONBAR_HEIGHT (KK_NAVIGATIONBAR_HEIGHT+KK_STATUSBAR_HEIGHT)
#define KK_HOMEBAR_HEIGHT 32

#endif /* CommonMacro_h */
