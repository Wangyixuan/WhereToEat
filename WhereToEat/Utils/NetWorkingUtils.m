//
//  NetWorkingUtils.m
//  WhereToEat
//
//  Created by 王磊 on 2017/9/13.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "NetWorkingUtils.h"

static dispatch_once_t once;
static NetWorkingUtils *instance;


@implementation NetWorkingUtils

+ (instancetype)sharedManager {
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

+ (void)releaseSingleton {
    
    once = 0;
    instance = nil;
    
}
-(instancetype)init
{
    if(self=[super init])
    {
    
      self.session = [NSURLSession sharedSession];
    }
    return self;
}


+(void)createTaskWithURL:(NSString*)urlStr andMethodIsPost:(BOOL)post andParams:(NSDictionary*)params{
    
    //确定请求路径
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法
    requestM.HTTPMethod = post?@"POST":@"GET";
    //设置请求体
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    /**
     根据对象创建 Task 请求
     
     url  方法内部会自动将 URL 包装成一个请求对象（默认是 GET 请求）
     completionHandler  完成之后的回调（成功或失败）
     
     param data     返回的数据（响应体）
     param response 响应头
     param error    错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          
                                          //解析服务器返回的数据
                                          WLLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          //默认在子线程中解析数据
                                          //                                          NSLog(@"%@", [NSThread currentThread]);
                                          WLLog(@"error %@",error);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
    
}
@end
