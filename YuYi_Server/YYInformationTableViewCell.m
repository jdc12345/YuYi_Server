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
@property(nonatomic,weak)UILabel *contentLabel;
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
    self.contentLabel.text = model.content;
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
    UILabel *titleLabel = [UILabel labelWithText:@"帖子标题帖子标题帖子标题帖子标题" andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:13];
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    //资讯内容
    UILabel *contentLabel = [UILabel labelWithText:@"帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容" andTextColor:[UIColor colorWithHexString:@"666666"] andFontSize:12];
    contentLabel.numberOfLines = NSNotFound;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
        
    //约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(4*kiphone6);
        make.left.offset(10*kiphone6);
        make.width.height.offset(92*kiphone6);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(4*kiphone6);
        make.left.equalTo(imageView.mas_right).offset(30*kiphone6);
        make.right.offset(-20*kiphone6);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10*kiphone6);
        make.left.equalTo(imageView.mas_right).offset(30*kiphone6);
        make.right.offset(-20*kiphone6);
        make.bottom.offset(-6*kiphone6);
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
