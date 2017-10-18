//
//  YYInformationTableViewCell.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYInformationTableViewCell.h"
#import <Masonry.h>
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <UIImageView+WebCache.h>

@interface YYInformationTableViewCell()
@property(nonatomic,weak)UIImageView *bigImageView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *commentLabel;
@end

@implementation YYInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setModel:(YYInfoDetailModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    if (!model.commentNum) {
        model.commentNum = @"0";
    }
    self.commentLabel.text = [NSString stringWithFormat:@"%@评",model.commentNum];
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.picture];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
}
- (void)setupUI{
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"info.png"];
    self.bigImageView = imageView;
    [self.contentView addSubview:imageView];
    //资讯标题
    UILabel *titleLabel = [UILabel labelWithText:@"帖子标题帖子标题帖子标题帖子标题" andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:18];
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    //评论数
    UILabel *commentLabel = [UILabel labelWithText:@"16评" andTextColor:[UIColor colorWithHexString:@"666666"] andFontSize:12];
    commentLabel.numberOfLines = NSNotFound;
    [self.contentView addSubview:commentLabel];
    self.commentLabel = commentLabel;
    //分割线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [self.contentView addSubview:line];
    
    //约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.offset(0);
        make.width.offset(112*kiphone6);
        make.height.offset(75*kiphone6H);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(21*kiphone6H);
        make.right.equalTo(imageView.mas_left).offset(-10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15*kiphone6H);
        make.left.equalTo(titleLabel);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(imageView.mas_bottom).offset(4*kiphone6);
//        make.width.offset([UIScreen mainScreen].bounds.size.width);//必须加
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
