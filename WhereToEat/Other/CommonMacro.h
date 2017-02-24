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

#define WLScreenHIphone4s 480
#define WLScreenHIphone5s  568
#define WLScreenHIphone6s  667
#define WLScreenHIphone6sp  736
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
#endif /* CommonMacro_h */
