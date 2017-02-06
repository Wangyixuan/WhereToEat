//
//  firstView.m
//  WhereToEat
//
//  Created by 王磊 on 16/4/23.
//  Copyright © 2016年 WLtech. All rights reserved.
//

#import "firstView.h"
@interface firstView()



@end


@implementation firstView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf:)];
    [self addGestureRecognizer:tap];
    
}

-(void)removeSelf:(UITapGestureRecognizer*)tap{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
    [self removeFromSuperview];
}

+(instancetype)loadFirstView{
    
     return [[NSBundle mainBundle] loadNibNamed:@"firstView" owner:nil options:nil].firstObject;
}

@end
