//
//  NSString+Valid.m
//  GlassesIntroduce
//
//  Created by 王志明 on 14/12/15.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

-(BOOL)isChinese{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isNumber
{
    NSString *match=@"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isChar
{
    NSString *match=@"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isBottomLine
{
    return [self isEqualToString:@"_"];
}

- (BOOL)isMatchsRegex:(NSString *)regex {
    return [self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound;
}

- (BOOL)isBlank {
    return ![self isNotBlank];
}

- (BOOL)isNotBlank {
    return [self isMatchsRegex:KKRegexNotBlack];
}

+ (BOOL)isBlank:(NSString *)string {
    return !string || [string isKindOfClass:[NSNull class]] || string.length==0 || string==nil; //[string isBlank];
}

+ (BOOL)isNotBlank:(NSString *)string {
    return ![self isBlank:string];//![NSString isBlank:string]; //
}

//自定义
+(BOOL)kkIsBlank:(NSString*)string{
    return string.length==0||string==nil||[string isKindOfClass:[NSNull class]]||!string;
}

//-(NSMutableAttributedString*)splitByPercent:(NSValue**)rangeValue
//{
//    NSRange startRange = [self rangeOfString:@"%"];
//    if(startRange.location!=NSNotFound)
//    {
//        NSString *substr=[self substringFromIndex:startRange.location+1];
//        NSRange endRange=[substr rangeOfString:@"%"];
//        if(endRange.location!=NSNotFound)
//        {
//            NSRange rang=NSMakeRange(startRange.location, endRange.location);
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self stringByReplacingOccurrencesOfString:@"%" withString:@""]];
//            [attributedString addAttribute:NSForegroundColorAttributeName value:KKColorHomeOrange range:rang];
//            
//            if(rangeValue!=nil) *rangeValue=[NSValue valueWithRange:rang];
//            
//            return attributedString;
//        }
//    }
//    
//    return nil;
//}

////判断url是否完整 并补全
//-(NSString*)checkURL{
//    NSString *newURL;
//    if ([self hasPrefix:@"http"]||[self hasPrefix:@"https"]) {
//        newURL = self;
//    }else{
//        newURL = [NSString stringWithFormat:@"%@/%@/%@", KKServerDomain,App,self];
//    }
//    return newURL;
//}

//判断昵称是否合法
-(BOOL)nickNameIsMatch{
    
    NSString *temp = nil;
    for(int i =0; i < [self length]; i++)
    {
        temp = [self substringWithRange:NSMakeRange(i, 1)];
        
        if (![temp isChinese]&&![temp isChar]&&![temp isNumber]&&![temp isBottomLine]) {
            WLLog(@"昵称不合法");
            return NO;
        }
    }
    return YES;
}

-(NSString *)splitWhiteSpaceChar
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL)isNotEmpty:(NSString *)str {
    
    if (!str) {
        return NO;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return NO;
        } else {
            return YES;
        }
    }
}

@end
