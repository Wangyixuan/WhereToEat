//
//  WLPoiDetailResult.h
//  WhereToEat
//
//  Created by 王磊 on 2017/11/10.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLPoiDetailResult : NSObject
///POI名称
@property (nonatomic, strong) NSString* name;
///POI地址
@property (nonatomic, strong) NSString* address;
///POI电话号码
@property (nonatomic, strong) NSString* phone;
///POIuid
@property (nonatomic, strong) NSString* uid;
///POI详情页url
@property (nonatomic, strong) NSString* detailUrl;
///POI价格
@property (nonatomic) double price;
///POI地理坐标
@property (nonatomic) CLLocationCoordinate2D pt;

-(instancetype)initPoiDetailResultWithDic:(NSDictionary*)dic;
@end
