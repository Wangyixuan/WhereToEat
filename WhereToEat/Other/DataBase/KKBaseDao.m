//
//  KKBaseDao.m
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import "KKBaseDao.h"

#define KKSharedDatabaseHelper [KKDatabaseHelper sharedDatabaseHelper]

/** 数据库队列单例 */
@interface KKDatabaseHelper : NSObject

+(instancetype)sharedDatabaseHelper;
@property(strong,nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation KKDatabaseHelper

+(instancetype)sharedDatabaseHelper
{
    static dispatch_once_t _once;
    static KKDatabaseHelper *instance;
    
    dispatch_once(&_once, ^{
        instance = [[self alloc] init];
        instance.dbQueue = [FMDatabaseQueue databaseQueueWithPath:DatabasePath];
        WLLog(@"dbpath:%@",DatabasePath);
    });
    
    return instance;
}

@end


@implementation KKBaseDao

//检查表
-(void)checkTable:(NSString *)tableName createTable:(NSString *(^)())createTableSql updateTable:(void (^)(FMDatabase *))updateTable
{
    [KKSharedDatabaseHelper.dbQueue inDatabase:^(FMDatabase *db) {
       
        //开启statement缓存
        db.shouldCacheStatements=YES;
        
        //创建表
        if(![db tableExists:tableName])
        {
            NSString *createsql=createTableSql();
            BOOL result = [db executeUpdate:createsql];
            WLLog(@"create table %@,%@",tableName,result ? @"succeed":@"failed");
        }
        
        //判断数据表版本
        NSString *key = KKStringWithFormat(@"table_version_%@",tableName);
        NSString *tableverson = [KKUserDefaults objectForKey:key];
        
        //默认为空,改成1
        if(KKStringIsBlank(tableverson))
        {
            [KKUserDefaults setObject:@"1" forKey:key];
            [KKUserDefaults synchronize];
        }
        
        if(updateTable)
        {
            updateTable(db);
        }
        
    }];
}

//查询
-(void)query:(id (^)(FMDatabase *))process completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground
{
    if (inbackground) {
        
        // 1.开启异步任务
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            //KKLog(@"%s : %@", __func__, [NSThread currentThread]);
            
            // 2.在队列中操作数据库
            [KKSharedDatabaseHelper.dbQueue inDatabase:^(FMDatabase *db) {
                
                id result = nil;
                @try {
                    // 3.执行业务逻辑代码
                    result = process(db);
                }
                @catch (NSException *exception) {
                    WLLog(@"DBerror %s : %@", __func__, exception);
                }
                @finally {
                    
                }
                
                // 4.回到UI线程，调用者处理结果
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(result);
                    }
                });
            }];
        });
    } else {
        
        //KKLog(@"%s : %@", __func__, [NSThread currentThread]);
        
        // 1.在队列中操作数据库
        [KKSharedDatabaseHelper.dbQueue inDatabase:^(FMDatabase *db) {
            
            id result = nil;
            @try {
                // 2.执行业务逻辑代码
                result = process(db);
            }
            @catch (NSException *exception) {
                WLLog(@"DBerror %s : %@", __func__, exception);
            }
            @finally {
                
            }
            
            // 3.调用者处理结果
            if (completion) {
                completion(result);
            }
        }];
    }
}

//增删改
-(void)update:(BOOL (^)(FMDatabase *))process completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground
{
    if (inbackground) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            //KKLog(@"%s : %@", __func__, [NSThread currentThread]);
            
            // 2.在队列中操作数据库
            [KKSharedDatabaseHelper.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                BOOL success = NO;
                @try {
                    // 3.执行业务逻辑代码
                    success = process(db);
                }
                @catch (NSException *exception) {
                    WLLog(@"DBerror %s : %@", __func__, exception);
                }
                @finally {
                    *rollback = !success;
                }
                
                // 4.回到UI线程，调用者处理结果
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(success);
                    }
                });
            }];
        });
    } else {
        
        //KKLog(@"%s : %@", __func__, [NSThread currentThread]);
        
        // 1.在队列中操作数据库
        [KKSharedDatabaseHelper.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            BOOL success = NO;
            @try {
                // 2.执行业务逻辑代码
                success = process(db);
            }
            @catch (NSException *exception) {
                WLLog(@"DBerror %s : %@", __func__, exception);
            }
            @finally {
                *rollback = !success;
            }
            
            // 3.调用者处理结果
            if (completion) {
                completion(success);
            }
        }];
    }
}



















@end
