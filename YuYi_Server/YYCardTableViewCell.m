//
//  YYCardTableViewCell.m
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/27.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import "YYCardTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <Masonry.h>

@interface YYCardTableViewCell ()
@property(nonatomic,weak)UILabel *praiseCountLabel;
@property(nonatomic,weak)UIImageView *imagesView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *contentLabel;
@end

@implementation YYCardTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setImage:(NSString *)image{
    _image = image;
    if (image) {
        self.imageView.image = [UIImage imageNamed:image];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10*kiphone6);
            make.width.height.offset(55*kiphone6);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(10*kiphone6);
            make.right.offset(-20*kiphone6);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10*kiphone6);
        }];
    }else{
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left).offset(-10*kiphone6);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10*kiphone6);
            make.width.height.offset(0);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(10*kiphone6);
            make.right.offset(-20*kiphone6);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10*kiphone6);
        }];
    }
    
}
- (void)setupUI{
//    self.contentView.backgroundColor = [UIColor orangeColor];
    //帖子标题
    UILabel *titleLabel = [UILabel labelWithText:@"帖子标题" andTextColor:[UIColor colorWithHexString:@"2b2b2b"] andFontSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:imageView];
    //帖子内容
    UILabel *contentLabel = [UILabel labelWithText:@"帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容" andTextColor:[UIColor colorWithHexString:@"6a6a6a"] andFontSize:13];
    contentLabel.numberOfLines = 3;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    //发帖时间
    UILabel *timeLabel = [UILabel labelWithText:@"3小时前" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:timeLabel];

    //赞btn
    UIButton *praiseBtn = [[UIButton alloc]init];
    [praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"like-selected"] forState:UIControlStateHighlighted];
    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:praiseBtn];
    //赞次数
    UILabel *praiseCountLabel = [UILabel labelWithText:@"379" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:praiseCountLabel];
    self.praiseCountLabel = praiseCountLabel;
    //回帖btn
    UIButton *repliesBtn = [[UIButton alloc]init];
    [repliesBtn setImage:[UIImage imageNamed:@"Comment"] forState:UIControlStateNormal];
    [repliesBtn addTarget:self action:@selector(repliesPlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:repliesBtn];
    //回帖次数
    UILabel *repliesLabel = [UILabel labelWithText:@"379" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:repliesLabel];
    //约束布局
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left).offset(-10*kiphone6);
        make.top.equalTo(titleLabel.mas_bottom).offset(10*kiphone6);
        make.width.height.offset(0);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.offset(-20*kiphone6);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(contentLabel.mas_bottom).offset(20*kiphone6);
    }];
    [repliesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_top);
        make.right.offset(-20*kiphone6);
    }];
    [repliesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.right.equalTo(repliesLabel.mas_left).offset(-7*kiphone6);
    }];
    [praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_top);
        make.right.equalTo(repliesBtn.mas_left).offset(-15*kiphone6);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.right.equalTo(praiseCountLabel.mas_left).offset(-7*kiphone6);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(timeLabel.mas_bottom).offset(20*kiphone6);
        make.width.offset([UIScreen mainScreen].bounds.size.width);
    }];

}
- (void)praisePlus:(UIButton*)sender{
    NSInteger count = [self.praiseCountLabel.text integerValue];
    count += 1;
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
}
- (void)repliesPlus:(UIButton*)sender{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
