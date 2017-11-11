//
//  PushMessageListViewController.m
//  WhereToEat
//
//  Created by 王磊 on 2017/9/12.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "PushMessageListViewController.h"
#import "DetailViewController.h"
#import "PushMesCell.h"
#import "WLPoiDetailResult.h"

#import <MapKit/MapKit.h>
#import "LocationChange.h"

#define cellIdentifier @"PushMesCell"


@interface PushMessageListViewController ()<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
//定位服务
@property(nonatomic,strong) BMKLocationService *locationManager;
//用户所在区域
@property(nonatomic,assign) BMKCoordinateRegion userRegion;
@end

@implementation PushMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
 
    self.dataArr = [NSMutableArray array];
    [self loadData];
    
    //请求定位服务
    _locationManager=[[BMKLocationService alloc]init];   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    _locationManager.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    _locationManager.delegate = nil;
    
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
                                          WLLog(@"pushList%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          WLLog(@"error %@",error);
                                          if(!error && data.length > 0) {
                                              NSDictionary *respDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                              NSArray *gymList = [respDic objectForKey:@"gymList"];
                                              if (gymList.count>0) {
                                                  for (NSDictionary *dic in gymList) {
                                                      WLPoiDetailResult *poiResult = [[WLPoiDetailResult alloc]initPoiDetailResultWithDic:dic];
                                                      [self.dataArr addObject:poiResult];
                                                      
                                                  }
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self.tableView reloadData];
                                                  });
                                                  
                                                  
                                              }
                                          
                                          }
                                          
                                          
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
                                          WLLog(@"pushList%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          WLLog(@"error %@",error);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.pushDetailResult = [self.dataArr objectAtIndex:indexPath.section];
    }
    WLWEAKSELF
    cell.pushDetailBlock = ^(NSString *detailURL){
        WLLog(@"详情");
        DetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailVC.detailURL = detailURL;
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:detailVC];
        [weakself presentViewController:navController animated:YES completion:nil];
    };
    cell.pushPoisionBlock = ^(CLLocationCoordinate2D coord,NSString*name){
        [WLSharedGlobalManager updateUserLocation];       
        [WLSharedGlobalManager naviClickWithCrood:coord name:name];
       
        WLLog(@"导航");
    };
    return cell;
}

-(void)dealloc{
    WLLog(@"push list dealloc");
}
@end
