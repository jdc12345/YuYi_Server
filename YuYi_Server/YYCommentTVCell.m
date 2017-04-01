//
//  YYCommentTVCell.m
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/29.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import "YYCommentTVCell.h"
#import <Masonry.h>
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"


@interface YYCommentTVCell ()
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *contentLabel;
@property(nonatomic,weak)UILabel *countLabel;
@end
@implementation YYCommentTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //icon
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"add_pic"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 15;
    [self.contentView addSubview:iconView];
    //name
    UILabel *nameLabel = [UILabel labelWithText:@"LIM" andTextColor:[UIColor colorWithHexString:@"6a6a6a"] andFontSize:12];
    [self.contentView addSubview:nameLabel];
    //time
    UILabel *timeLabel = [UILabel labelWithText:@"1小时前" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:timeLabel];
    //帖子内容
    UILabel *contentLabel = [UILabel labelWithText:@"帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容" andTextColor:[UIColor colorWithHexString:@"2b2b2b"] andFontSize:14];
    contentLabel.numberOfLines = NSNotFound;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    //赞btn
    UIButton *praiseBtn = [[UIButton alloc]init];
    [praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"like-selected"] forState:UIControlStateHighlighted];
    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:praiseBtn];

    //点赞次数
    UILabel *countLabel = [UILabel labelWithText:@"35" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
    //约束
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(20);
        make.width.height.offset(30);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(15);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(iconView.mas_right).offset(15);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.left.equalTo(timeLabel);
        make.right.offset(-20);
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(iconView);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countLabel.mas_left).offset(-5);
        make.centerY.equalTo(iconView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentLabel.mas_bottom).offset(20);
        make.width.offset([UIScreen mainScreen].bounds.size.width);//必须加
    }];


}
- (void)praisePlus:(UIButton*)sender{
    NSInteger count = [self.countLabel.text integerValue];
    count += 1;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
