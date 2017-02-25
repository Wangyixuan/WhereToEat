//
//  ContactsViewController.m
//  WhereToEat
//
//  Created by 王磊 on 2017/2/25.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCell.h"

#define cellIdentidier @"ContactsCell"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contactFucArr;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentidier bundle:nil] forCellReuseIdentifier:cellIdentidier];
    
    NSDictionary *new = @{@"img":@"newFriends",@"name":@"新的朋友"};
    NSDictionary *group = @{@"img":@"groupPublicHeader",@"name":@"群聊"};
    self.contactFucArr = [NSArray arrayWithObjects:new,group, nil];
    _sectionTitles = [NSMutableArray array];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.contactFucArr.count;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    return 15;
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.sectionTitles;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return nil;
//    }
//    
//    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
//    label.backgroundColor = [UIColor clearColor];
//    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
//    [contentView addSubview:label];
//    return contentView;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentidier forIndexPath:indexPath];
        if (self.contactFucArr.count>indexPath.row) {
            cell.dataDic = [self.contactFucArr objectAtIndex:indexPath.row];
        }
        return cell;
    }
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentidier forIndexPath:indexPath];
    return cell;
}
@end
