//
//  ContactsCell.m
//  WhereToEat
//
//  Created by 王磊 on 2017/2/25.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#import "ContactsCell.h"
@interface ContactsCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString *img = [dataDic stringForKey:@"img" defaultValue:@""];
    
    self.headImg.image = [UIImage imageNamed:img];
    self.nameLab.text = [dataDic stringForKey:@"name" defaultValue:@""];
    
}
@end
