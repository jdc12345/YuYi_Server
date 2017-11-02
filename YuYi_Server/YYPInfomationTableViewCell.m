//
//  YYPInfomationTableViewCell.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPInfomationTableViewCell.h"

@implementation YYPInfomationTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    
    //backView
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.top.bottom.offset(0);
    }];
    //..邪恶的分割线
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"李美丽";
    
    self.seeRecardLabel = [[UILabel alloc]init];
    self.seeRecardLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.seeRecardLabel.font = [UIFont systemFontOfSize:14];
    self.seeRecardLabel.textAlignment = NSTextAlignmentLeft;
//    self.seeRecardLabel.backgroundColor = [UIColor cyanColor];
    
//    self.editInfoText = [[UITextField alloc]init];
//    self.editInfoText.textColor = [UIColor colorWithHexString:@"333333"];
//    self.editInfoText.font = [UIFont systemFontOfSize:14];
//    self.editInfoText.textAlignment = NSTextAlignmentRight;
//    self.editInfoText.hidden = YES;
    
    
    [backView addSubview:lineL];
    [backView addSubview:self.titleLabel];
    [backView addSubview:self.seeRecardLabel];
//    [self.contentView addSubview:self.editInfoText];
    
    
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10 *kiphone6);
    }];
    
    [self.seeRecardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-10 *kiphone6);
    }];
//    [self.editInfoText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).with.offset(-10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(200 , 14 *kiphone6));
//    }];
}
- (void)setType:(NSString *)cellType{
//    if ([cellType isEqualToString:@"cellbounce"]) {
//        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bounceCellClick)];
//        [self.seeRecardLabel addGestureRecognizer:tapGest];
//    }else if([cellType isEqualToString:@"celltextfield"]){
//        self.seeRecardLabel.hidden = YES;
//        self.editInfoText.hidden = NO;
//    }
}
- (void)bounceCellClick{
//    self.sexClick(@"123");
    // self.seeRecardLabel.text = sex;
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
