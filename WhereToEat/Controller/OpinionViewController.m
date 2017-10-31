//
//  OpinionViewController.m
//  WhereToEat
//
//  Created by 王磊 on 2017/10/30.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLab;

@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateBtnClick:(id)sender {
    [self.textView resignFirstResponder];
    WLLog(@"提交");
    [self upLoadOpinion];
}

-(void)DidChange:(NSNotification*)noti{
   
    if (self.textView.text.length > 0) {
        self.placeHolderLab.hidden=YES;
    }
    else{
        self.placeHolderLab.hidden=NO;
    }
}

-(void)upLoadOpinion{
    WLWEAKSELF
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    //确定请求路径
    NSURL *url = [NSURL URLWithString:FeedBackServerInterface];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法
    requestM.HTTPMethod = @"POST";
    //设置请求体
    requestM.HTTPBody = [[NSString stringWithFormat:@"text=%@&uuid=%@",self.textView.text,uuid] dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          if (data) {
                                              NSDictionary *respDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                              long long result = [respDic longlongForKey:@"result" defaultValue:0];
                                              if (result==200) {
                                              
                                                  [SVProgressHUD showSuccessWithStatus:@"感谢您的反馈" duration:1.2];
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [weakself back];
                                                  });
                                              }else{
                                                  [SVProgressHUD showErrorWithStatus:@"反馈暂不成功" duration:1.2];
                                              }
                                          }
                                          //解析返回的数据
                                          WLLog(@"upLoadOpinion %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          WLLog(@"error %@",error);
                                      }];
    //发送请求
    [dataTask resume];
    
}

-(void)back{
    WLLog(@"back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    WLLog(@"反馈 dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
