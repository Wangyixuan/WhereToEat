//
//  DetailViewController.m
//  WhereToEat
//
//  Created by 王磊 on 16/4/13.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "DetailViewController.h"
#import "SVProgressHUD.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    [self loadDetail];
}

-(void)cancelClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadDetail {
    
    NSURL *webURL = [NSURL URLWithString:self.detailURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:webURL];
    [self.webView loadRequest:request];
}

//开始加载 显示菊花
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    UIActivityIndicatorView *waitingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [waitingView startAnimating];
    UIBarButtonItem *waitingButton=[[UIBarButtonItem alloc] initWithCustomView:waitingView];
    self.navigationItem.rightBarButtonItem=waitingButton;
}

//加载成功 显示历史 或 刷新
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadDetail)];
    self.navigationItem.rightBarButtonItem=refreshButton;

}

//加载失败 显示刷新
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([error code] == NSURLErrorCancelled){
        return;
    }
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadDetail)];
    self.navigationItem.rightBarButtonItem=refreshButton;
    [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1.2];
}

-(void)dealloc{
    WLLog(@"detailView dealloc");
}

@end
