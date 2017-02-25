//
//  NSDictionary+JsonDict.m
//
//  Created by Mr.Wang on 15/2/11.
//  Copyright (c) 2015年 王志明. All rights reserved.
//

#import "NSDictionary+JsonDict.h"

#define kValueForKey id obj = [self valueForKey:key]; \
                     if (obj == nil || [obj isNSNull]) { \
                        return defaultValue; \
                     } \

@implementation NSDictionary (JsonDict)

- (NSNumber *)numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue {
    kValueForKey
    return [obj NSNumberValue:defaultValue];
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    kValueForKey
    return [obj NSStirngValue:defaultValue];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue {
    kValueForKey
    return [obj NSUItegerValue:defaultValue];
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    kValueForKey
    return [obj NSIntegerValue:defaultValue];
}

- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue {
    kValueForKey
    return [obj floatValue:defaultValue];
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    kValueForKey
    return [obj doubleValue:defaultValue];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    kValueForKey
    return [obj BOOLValue:defaultValue];
}

- (long long int)longlongForKey:(NSString *)key defaultValue:(long long int)defaultValue {
    kValueForKey
    return [obj longlongValue:defaultValue];
}

@end
