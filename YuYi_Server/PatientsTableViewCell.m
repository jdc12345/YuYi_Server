//
//  PatientsTableViewCell.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "PatientsTableViewCell.h"

@implementation PatientsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    
    //backView
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    
    self.iconV = [[UIImageView alloc]init];
    self.iconV.image = [UIImage imageNamed:@"cell1"];
    self.iconV.layer.cornerRadius = 45 *0.5;
    self.iconV.clipsToBounds = YES;
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium"size:14];
    self.titleLabel.text = @"李美丽";
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Patient_arrow"]];
    
    [self.contentView addSubview:backView];
    [backView addSubview:self.iconV];
    [backView addSubview:self.titleLabel];
    [backView addSubview:imageV];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10 *kiphone6);
        make.right.offset(-10*kiphone6);
        make.bottom.offset(0);
    }];
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(45 *kiphone6, 45 *kiphone6));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconV.mas_right).offset(10 *kiphone6);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(7.5 *kiphone6, 13 *kiphone6));
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
