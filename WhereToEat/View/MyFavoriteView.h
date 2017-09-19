//
//  MyFavoriteView.h
//  WhereToEat
//
//  Created by 王磊 on 2017/9/19.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFavoriteView : UIView
//详细结果数据
@property (nonatomic, strong) BMKPoiDetailResult *detailResult;
//跳转详情页面
@property (nonatomic, copy) void(^detailBlock)(NSString *detailURL);
//导航
@property (nonatomic, copy) void(^poisionBlock)(CLLocationCoordinate2D coord,NSString *name);
//上传收藏
@property (nonatomic, copy) void (^uploadBlock)(BMKPoiDetailResult *detailResult);

+(instancetype)loadMyFavoriteView;

@end
