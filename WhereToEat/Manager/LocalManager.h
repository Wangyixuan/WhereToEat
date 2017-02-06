//
//  LocalManager.h
//  WhereToEat
//
//  Created by 王磊 on 16/4/13.
//  Copyright © 2016年 WLtech. All rights reserved.
// 用于存储收藏的店面 key:店名 value:uid(用于查询详细信息)

#import <Foundation/Foundation.h>


#define KKSharedLocalManager [LocalManager sharedLocalPlistManager]

@interface LocalManager : NSObject

//从plist读取到的dic
@property(strong,nonatomic) NSMutableDictionary *plistDataDic;

+(instancetype)sharedLocalPlistManager;
+(void)releaseSingleton;

//增加或者更新数据，自动保存
-(void)setKKValue:(id)value forKey:(NSString*)key;

//删除数据,自动保存
-(void)removeKKValueForKey:(NSString*)key;

//读取数据
-(id)kkValueForKey:(NSString*)key;


@end
