//
//  WLPoiDetailResult.m
//  WhereToEat
//
//  Created by 王磊 on 2017/11/10.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "WLPoiDetailResult.h"

@implementation WLPoiDetailResult
-(instancetype)initPoiDetailResultWithDic:(NSDictionary *)dic{
   
    if (self = [super init]) {
        self.name = [dic stringForKey:@"name" defaultValue:@""];
        self.address = [dic stringForKey:@"address" defaultValue:@""];
        self.uid = [dic stringForKey:@"id" defaultValue:@""];
        self.phone = [dic stringForKey:@"tele" defaultValue:@""];
        self.detailUrl = [dic stringForKey:@"url" defaultValue:@""];
        self.price = [dic doubleForKey:@"price" defaultValue:0];
        CGFloat lon = [dic floatForKey:@"lon" defaultValue:0];
        CGFloat lat = [dic floatForKey:@"lat" defaultValue:0];
        self.pt = CLLocationCoordinate2DMake(lat, lon);
        
    }
    
    return self;
}
@end
