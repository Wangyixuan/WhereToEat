//
//  NetWorkingUtils.h
//  WhereToEat
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetWorkingManager [NetWorkingUtils sharedManager]

@interface NetWorkingUtils : NSObject

+(instancetype)sharedManager;
+(void)releaseSingleton;

@property (nonatomic, strong) NSURLSession *session;

+(void)createTaskWithURL:(NSString*)urlStr andMethodIsPost:(BOOL)post andParams:(NSDictionary*)params;
@end
