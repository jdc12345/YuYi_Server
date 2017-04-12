//
//  YYNotficTableViewCell.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYNotficTableViewCell.h"
#import <Masonry.h>
#import "UIColor+Extension.h"

@implementation YYNotficTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    
    
    //..邪恶的分割线
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    self.iconV = [[UIImageView alloc]init];
    
    [self.contentView addSubview:self.iconV];
    
    WS(ws);
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).with.offset(15);
        make.left.equalTo(ws.contentView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(40 , 40));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"李美丽";
    
    self.seeRecardLabel = [[UILabel alloc]init];
    self.seeRecardLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.seeRecardLabel.font = [UIFont systemFontOfSize:12];
    self.seeRecardLabel.textAlignment = NSTextAlignmentLeft;
//        self.seeRecardLabel.backgroundColor = [UIColor cyanColor];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = @"12:09";
    
    self.editInfoText = [[UITextField alloc]init];
    self.editInfoText.textColor = [UIColor colorWithHexString:@"333333"];
    self.editInfoText.font = [UIFont systemFontOfSize:14];
    self.editInfoText.textAlignment = NSTextAlignmentRight;
    self.editInfoText.hidden = YES;
    
    
    [self.contentView addSubview:lineL];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.seeRecardLabel];
    [self.contentView addSubview:self.editInfoText];
    [self.contentView addSubview:self.timeLabel];
    
    

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(17);
        make.left.equalTo(ws.iconV.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    
    [self.seeRecardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(ws.iconV.mas_right).with.offset(10 );
        make.size.mas_equalTo(CGSizeMake(260 , 12 ));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(17);
        make.right.equalTo(ws.contentView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(120 , 12));
    }];
    [self.editInfoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(200 , 14 *kiphone6));
    }];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.iconV.mas_right).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1));
    }];
}
- (void)setType:(NSString *)cellType{
    if ([cellType isEqualToString:@"cellbounce"]) {
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bounceCellClick)];
        [self.seeRecardLabel addGestureRecognizer:tapGest];
    }else if([cellType isEqualToString:@"celltextfield"]){
        self.seeRecardLabel.hidden = YES;
        self.editInfoText.hidden = NO;
    }
}
- (void)bounceCellClick{
    self.sexClick(@"123");
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
