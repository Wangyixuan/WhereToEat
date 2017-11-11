//
//  PushMesCell.h
//  WhereToEat
//
//  Created by 王磊 on 2017/9/12.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLPoiDetailResult.h"

@interface PushMesCell : UITableViewCell

//跳转详情页面
@property (nonatomic, copy) void(^pushDetailBlock)(NSString *detailURL);
//导航
@property (nonatomic, copy) void(^pushPoisionBlock)(CLLocationCoordinate2D coord,NSString *name);
//@property (nonatomic, strong) BMKPoiDetailSearchOption*detailSearch;
//详细结果数据
@property (nonatomic, strong) WLPoiDetailResult *pushDetailResult;
@end
