//
//  MyPointAnnotation.h
//  Where to eat
//
//  Created by 王磊 on 16/4/12.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MyPointAnnotation : BMKShape
///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//uid由于请求详细信息
@property (nonatomic, strong) NSString *uidString;
//店名
@property (nonatomic, strong) NSString *name;
//地址
@property (nonatomic, strong) NSString *address;
@end
