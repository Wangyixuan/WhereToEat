//
//  NSString+Valid.h
//  GlassesIntroduce
//
//  Created by 王志明 on 14/12/15.
//  Copyright (c) 2014年 王志明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)

/** 是否为中文 */
- (BOOL)isChinese;
/** 是否为数字 */
-(BOOL)isNumber;
/** 是否为英文字符 */
-(BOOL)isChar;
/** 是否为下划线 */
-(BOOL)isBottomLine;
/** 是否匹配一个正则表达式 */
- (BOOL)isMatchsRegex:(NSString *)regex;
/** 空白字符串，包含nil */
+ (BOOL)isBlank:(NSString *)string;
+ (BOOL)isNotBlank:(NSString *)string;
/** 空白字符串 */
- (BOOL)isBlank;
- (BOOL)isNotBlank;

/** KK自定义为空*/
+(BOOL)kkIsBlank:(NSString*)string;


//-(NSMutableAttributedString*)splitByPercent:(NSValue**)rangeValue;
////检查url是否完整
//-(NSString*)checkURL;
//判断昵称是否合法
-(BOOL)nickNameIsMatch;

//去除前后空白字符
-(NSString*)splitWhiteSpaceChar;
//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL)isNotEmpty:(NSString *)str;

@end
