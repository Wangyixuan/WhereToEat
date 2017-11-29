//
//  SetTableViewController.m
//  WhereToEat
//
//  Created by 王磊 on 16/4/15.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "SetTableViewController.h"
#import "WCAlertView.h"
#import "ShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SVProgressHUD.h"
#import "OpinionViewController.h"

@interface SetTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *VersionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *leftHand;

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取版本信息
    NSString *verStr = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *buildStr = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
#ifdef DEBUG
    self.VersionLabel.text = [NSString stringWithFormat:@"For iPhone Dev V%@-%@",verStr,buildStr];
#else
    self.VersionLabel.text = [NSString stringWithFormat:@"For iPhoneV%@-%@",verStr,buildStr];

#endif
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"leftHand"]==YES) {
        self.leftHand.on = YES;
    }else{
        self.leftHand.on = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==1) {
        self.leftHand.on = !self.leftHand.on;
        [self leftHandClick:self.leftHand];
    
    }else if (indexPath.row == 2) {
        
        [WCAlertView showAlertWithTitle:@"您确定要发送邮件" message:@"tttttt9676@gmail.com"customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if(buttonIndex == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://tttttt9676@gmail.com"]];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    
    }
    else if (indexPath.row == 3){
        WLLog(@"share");
        //判断是否有微信
        if ([WXApi isWXAppInstalled]) {
            ShareView *shareV = [ShareView showShareViewWithFrame:CGRectMake(0, 0, WLScreenW, WLScreenH) andView:self.tabBarController.view];
            WLLog(@"%@",shareV);
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有安装微信" duration:2.0];
        }
    }else if (indexPath.row == 4){
        WLLog(@"反馈");
        OpinionViewController *opinionVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OpinionViewController"];
        [self.navigationController pushViewController:opinionVC animated:YES];

    }
}

- (IBAction)leftHandClick:(UISwitch*)sender {
    
    if (sender.on==YES) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"leftHand"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"leftHand"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createBtns" object:nil];
}



@end

