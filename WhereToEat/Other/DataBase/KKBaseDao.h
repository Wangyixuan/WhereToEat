//
//  KKBaseDao.h
//  KuaiKuai
//
//  Created by jichang.liu on 15/6/26.
//  Copyright (c) 2015年 liujichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define DatabasePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"KK.db"]

//查询回调
typedef void (^KKDaoQueryCompletion)(id result);
//增删改回调
typedef void (^KKDaoUpdateCompletion)(BOOL success);


/**Dao基类，对数据操作需要在UI中发起，Dao在后台线程中执行，调用者的CompletionBlock在UI线程中处理结果**/
@interface KKBaseDao : NSObject

//检查表
-(void)checkTable:(NSString*)tableName createTable:(NSString *(^)())createTableSql updateTable:(void (^)(FMDatabase *db))updateTable;

//查询
-(void)query:(id(^)(FMDatabase *db))process completion:(KKDaoQueryCompletion)completion inBackground:(BOOL)inbackground;

//增删改
-(void)update:(BOOL(^)(FMDatabase *db))process completion:(KKDaoUpdateCompletion)completion inBackground:(BOOL)inbackground;


@end
