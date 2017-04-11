//
//  YYCardDetailTVCell.m
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/29.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import "YYCardDetailTVCell.h"
#import <Masonry.h>
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "HttpClient.h"
@interface YYCardDetailTVCell()
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *countLabel;
@property(nonatomic,weak)UILabel *contentLabel;
@property(nonatomic,weak)UIImageView *bigImageView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *conentLabel;
@property(nonatomic,weak)UIButton *praiseBtn;
@end
@implementation YYCardDetailTVCell

-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
-(void)setInfoModel:(YYCardDetailPageModel *)infoModel{
    _infoModel = infoModel;
    NSString *iconUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,infoModel.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrlStr]];
    self.nameLabel.text = infoModel.trueName;
    self.timeLabel.text = infoModel.createTimeString;
    self.countLabel.text = infoModel.likeNum;
    self.titleLabel.text = infoModel.title;
    self.contentLabel.text = infoModel.content;
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,infoModel.picture];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    if (infoModel.isLike) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
    }

}
- (void)setupUI{
    //icon
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"add_pic"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 15;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    //name
    UILabel *nameLabel = [UILabel labelWithText:@"LIM" andTextColor:[UIColor colorWithHexString:@"6a6a6a"] andFontSize:12];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    //time
    UILabel *timeLabel = [UILabel labelWithText:@"1小时前" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    //赞数
    UILabel *countLabel = [UILabel labelWithText:@"375" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    //赞btn
    UIButton *praiseBtn = [[UIButton alloc]init];
    [praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"like-selected"] forState:UIControlStateHighlighted];
    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:praiseBtn];
    self.praiseBtn = praiseBtn;
    //帖子标题
    UILabel *titleLabel = [UILabel labelWithText:@"帖子标题帖子标题" andTextColor:[UIColor colorWithHexString:@"2b2b2b"] andFontSize:17];
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    //帖子内容
    UILabel *contentLabel = [UILabel labelWithText:@"帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容" andTextColor:[UIColor colorWithHexString:@"2b2b2b"] andFontSize:14];
    contentLabel.numberOfLines = NSNotFound;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"add_pic"];
    [self.contentView addSubview:imageView];
    self.bigImageView = imageView;

    //约束
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(20*kiphone6);
        make.width.height.offset(30*kiphone6);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20*kiphone6);
        make.centerY.equalTo(iconView);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countLabel.mas_left).offset(-5*kiphone6);
        make.centerY.equalTo(iconView);
        make.width.height.offset(20*kiphone6);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(20*kiphone6);
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(20);
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
        make.height.offset(335*kiphone6);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
        make.width.offset([UIScreen mainScreen].bounds.size.width);//必须加
    }];
}
- (void)praisePlus:(UIButton*)sender{
        CcUserModel *model = [CcUserModel defaultClient];
        NSString *token = model.userToken;
        NSString *urlStr = [NSString stringWithFormat:@"%@/likes/LikeNum.do?id=%@&token=%@",mPrefixUrl,self.infoModel.info_id,token];
        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
    
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
    
            }else{
                //点赞/删除未成功
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
        }];
        NSInteger count = [self.countLabel.text integerValue];
        if (self.infoModel.isLike) {
            count -= 1;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
            [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            self.infoModel.isLike = false;
            self.infoModel.likeNum = [NSString stringWithFormat:@"%ld",count];
        }else{
            count += 1;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
            [sender setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
            self.infoModel.isLike = true;
            self.infoModel.likeNum = [NSString stringWithFormat:@"%ld",count];
        }
    
//    NSInteger count = [self.countLabel.text integerValue];
//    count += 1;
//    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
