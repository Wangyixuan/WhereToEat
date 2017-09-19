//
//  PushMessageListViewController.m
//  WhereToEat
//
//  Created by 王磊 on 2017/9/12.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "PushMessageListViewController.h"
#import "PushMesCell.h"

#define cellIdentifier @"PushMesCell"


@interface PushMessageListViewController ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation PushMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
 
    self.dataArr = [NSMutableArray array];
    [self loadData];
}

-(void)loadData{
 
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    //确定请求路径
    NSString *urlStr = [NSString stringWithFormat:@"%@?uuid=%@&page_index=-1",PushListServerInterface,uuid];
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建 NSURLSession 对象
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
                                          WLLog(@"uploadLocation%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          WLLog(@"error %@",error);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
}

-(void)loadMoreData{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    //确定请求路径
    NSString *urlStr = [NSString stringWithFormat:@"%@?uuid=%@&page_index=10",PushListServerInterface,uuid];
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建 NSURLSession 对象
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
                                          WLLog(@"uploadLocation%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          WLLog(@"error %@",error);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.search.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.search.delegate = nil;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PushMesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section<self.dataArr.count) {
        cell.detailSearch = [self.dataArr objectAtIndex:indexPath.section];
    }
    return cell;
}

-(void)dealloc{
    WLLog(@"push list dealloc");
}
@end
