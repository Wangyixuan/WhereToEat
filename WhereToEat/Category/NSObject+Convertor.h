//
//  NSObject+Convertor.h
//
//  Created by 王志明 on 15/1/22.
//  Copyright (c) 2015年 王志明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Convertor)

- (BOOL)isNSNull;
- (BOOL)isNSNumber;
- (BOOL)isNSString;

// defaultValue是obj为NSNull时返回的结果

- (id)NSObjectValue;
- (NSString *)NSStirngValue:(NSString *)defaultValue;
- (NSNumber *)NSNumberValue:(NSNumber *)defaultValue;
- (NSUInteger)NSUItegerValue:(NSUInteger)defaultValue;
- (NSInteger)NSIntegerValue:(NSUInteger)defaultValue;
- (float)floatValue:(float)defaultValue;
- (double)doubleValue:(double)defaultValue;
- (BOOL)BOOLValue:(BOOL)defaultValue;
- (long long int)longlongValue:(long long int)defaultValue;

@end