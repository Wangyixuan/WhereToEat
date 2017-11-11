//
//  WLGlobalManager.h
//  WhereToEat
//
//  Created by 王磊 on 2017/11/10.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WLSharedGlobalManager [WLGlobalManager sharedGlobalManager]

@interface WLGlobalManager : NSObject

+(instancetype)sharedGlobalManager;
+(void)releaseSingleton;

-(void)updateUserLocation;
-(void)naviClickWithCrood:(CLLocationCoordinate2D)coord name:(NSString*)name;
//用户所在区域
@property(nonatomic,assign) BMKCoordinateRegion userRegion;

@end
