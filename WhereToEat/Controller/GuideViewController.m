//
//  GuideViewController.m
//  WhereToEat
//
//  Created by 王磊 on 16/4/15.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled=YES;
     NSInteger pageCount = 4;
    for (int i=0; i<pageCount; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_%d",i+1]]];
        imageview.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.userInteractionEnabled = NO;
        if (i==3) {
            imageview.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoMainClick)];
            [imageview addGestureRecognizer:tap];
        }
        [self.scrollView addSubview:imageview];
    }
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*pageCount, [UIScreen mainScreen].bounds.size.width);}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoMainClick{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launched"];
    self.view.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    WLLog(@"立即体验");
}

@end
