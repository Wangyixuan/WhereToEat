//
//  NSDictionary+JsonDict.h
//
//  Created by Mr.Wang on 15/2/11.
//  Copyright (c) 2015年 王志明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonDict)

- (NSNumber *)numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (long long int)longlongForKey:(NSString *)key defaultValue:(long long int)defaultValue;

@end
