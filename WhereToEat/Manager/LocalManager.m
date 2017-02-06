//
//  LocalManager.m
//  WhereToEat
//
//  Created by 王磊 on 16/4/13.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "LocalManager.h"


static dispatch_once_t once;
static LocalManager *instance;

@interface LocalManager ()


//plist路径
@property(strong,nonatomic) NSString *plistPath;

-(void)savePlist;

@end

@implementation LocalManager

+ (instancetype)sharedLocalPlistManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        WLLog(@"sharedLocalPlistManager init");
    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        if(_plistDataDic||_plistDataDic.count>0) [_plistDataDic removeAllObjects];
        
        _plistDataDic=[NSMutableDictionary dictionary];
        
        NSString *plistname=@"coords.plist";

        NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *path =  [patharray objectAtIndex:0];
        self.plistPath = [NSString stringWithFormat:@"%@/%@",path,plistname];
        
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.plistPath];
        if(exist)//存在路径，初始化数据
        {
            NSDictionary *data=[NSDictionary dictionaryWithContentsOfFile:self.plistPath];
            if(data&&data.count>0) [_plistDataDic addEntriesFromDictionary:data];
        }
        
    }
    
    return self;
}

-(void)setKKValue:(id)value forKey:(NSString *)key
{
    @synchronized(self) {
        
        [_plistDataDic setValue:value forKey:key];
        
        [self savePlist];
    }
    WLLog(@"保存成功");
}

-(void)removeKKValueForKey:(NSString *)key
{
    @synchronized(self) {
        
        [_plistDataDic removeObjectForKey:key];
        
        [self savePlist];
    }
    
}

-(id)kkValueForKey:(NSString *)key
{
    return [_plistDataDic valueForKey:key];
}



-(void)savePlist
{
    [_plistDataDic writeToFile:self.plistPath atomically:YES];
}


@end
