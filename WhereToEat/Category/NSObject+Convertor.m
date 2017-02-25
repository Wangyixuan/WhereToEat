//
//  NSObject+Convertor.m
//
//  Created by 王志明 on 15/1/22.
//  Copyright (c) 2015年 王志明. All rights reserved.
//

#import "NSObject+Convertor.h"

@implementation NSObject (Convertor)

- (BOOL)isNSNull {
    return [self isKindOfClass:[NSNull class]];
}

- (BOOL)isNSNumber {
    return [self isKindOfClass:[NSNumber class]];
}

- (BOOL)isNSValue {
    return [self isKindOfClass:[NSValue class]];
}

- (BOOL)isNSString {
    return [self isKindOfClass:[NSString class]];
}

- (id)NSObjectValue {
    if ([self isNSNull]) {
        return nil;
    }
    return self;
}

- (NSString *)NSStirngValue:(NSString *)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }

    if ([self isNSNumber]) {
        return [obj stringValue];
    }
    
    return self.description;
}

- (NSNumber *)NSNumberValue:(NSNumber *)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString]) {
        return [[[NSNumberFormatter alloc] init] numberFromString:obj];
    }
    
    if ([self isNSNumber]) {
        return obj;
    }

    return defaultValue;
}

- (NSUInteger)NSUItegerValue:(NSUInteger)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString]) {
        return [obj integerValue];
    }
    
    if ([self isNSNumber]) {
        return [obj unsignedIntegerValue];
    }

    return defaultValue;
}

- (NSInteger)NSIntegerValue:(NSUInteger)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString] || [self isNSNumber]) {
        return [obj integerValue];
    }
    
    return defaultValue;
}

- (float)floatValue:(float)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString] || [self isNSNumber]) {
        return [obj floatValue];
    }
    
    return defaultValue;
}

- (double)doubleValue:(double)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString] || [self isNSNumber]) {
        return [obj doubleValue];
    }
    
    return defaultValue;
}

- (BOOL)BOOLValue:(BOOL)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString] || [self isNSNumber] || [self isNSValue]) {
        return [obj boolValue];
    }
    
    return defaultValue;
}

- (long long int)longlongValue:(long long int)defaultValue {
    id obj = self;
    
    if ([self isNSNull]) {
        return defaultValue;
    }
    
    if ([self isNSString] || [self isNSNumber]) {
        return [obj longLongValue];
    }
    
    return defaultValue;
}

@end
