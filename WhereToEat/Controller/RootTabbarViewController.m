//
//  RootTabbarViewController.m
//  Where to eat
//
//  Created by 王磊 on 16/3/19.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "RootTabbarViewController.h"

@interface RootTabbarViewController ()

@end

@implementation RootTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    // Item选中图片
//    NSArray *selectedImages = @[@"Button_sel",@"tabbar_gift_s",@"tabbar_found_s",@"tabbar_me_s"];
//    // 设置选中图片
//    NSArray *viewControllers = self.viewControllers;
//    NSUInteger count = viewControllers.count;
//    for (NSUInteger i = 0; i < count; i++) {
//        UIViewController *vc = viewControllers[i];
//        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
    self.tabBar.tintColor = appOrange;
    self.tabBar.translucent = NO;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
