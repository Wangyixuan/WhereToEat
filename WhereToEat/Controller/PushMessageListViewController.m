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
    NSArray *keyArray = [KKSharedLocalManager.plistDataDic allKeys];
    if (keyArray.count>0) {
        for (NSString *str in keyArray) {
            NSString *uidStr = [KKSharedLocalManager kkValueForKey:str];
//            if (self.search.delegate==nil) {
//                self.search.delegate = self;
//            }
            BMKPoiDetailSearchOption*detailSearch = [[BMKPoiDetailSearchOption alloc]init];
            detailSearch.poiUid = uidStr;
            [self.dataArr addObject:detailSearch];

        }
        [self.tableView reloadData];
    }else{
        
    }
}

//- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
//    WLLog(@"resultDetail %@",poiDetailResult.name);
//    WLLog(@"error %u",errorCode);
//    [self.dataArr addObject:poiDetailResult];
//    [self.tableView reloadData];
//}

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
