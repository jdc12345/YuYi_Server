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
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "HttpClient.h"
@interface YYCommentTVCell ()
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *contentLabel;
@property(nonatomic,weak)UILabel *countLabel;
@property(nonatomic,weak)UIButton *praiseBtn;
@end
@implementation YYCommentTVCell
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

-(void)setInfoCommentModel:(YYCommentInfoModel *)infoCommentModel{
    _infoCommentModel = infoCommentModel;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,infoCommentModel.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"add_pic"]];
    self.nameLabel.text =  infoCommentModel.trueName;
    self.timeLabel.text = infoCommentModel.createTimeString;
    self.contentLabel.text = [infoCommentModel.content stringByRemovingPercentEncoding];
    self.praiseBtn.hidden = true;
    self.countLabel.hidden = true;
}

-(void)setComModel:(YYCardCommentDetailModel *)comModel{
    _comModel = comModel;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,comModel.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"add_pic"]];
    self.nameLabel.text =  comModel.trueName;
    self.timeLabel.text = comModel.createTimeString;
//    self.contentLabel.text = comModel.content;
    self.contentLabel.text = [comModel.content stringByRemovingPercentEncoding];
    self.countLabel.text = comModel.likeNum;
}
- (void)setupUI{
    UIView *line = [[UIView alloc]init];//分割线
    line.alpha = 0.6f;
    line.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(0.5*kiphone6);
    }];
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
    self.praiseBtn = praiseBtn;

    //点赞次数
    UILabel *countLabel = [UILabel labelWithText:@"35" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
   
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
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10*kiphone6);
        make.left.equalTo(timeLabel);
        make.right.offset(-20*kiphone6);
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20*kiphone6);
        make.centerY.equalTo(iconView);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countLabel.mas_left).offset(-5*kiphone6);
        make.centerY.equalTo(iconView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentLabel.mas_bottom).offset(20*kiphone6);
        make.width.offset([UIScreen mainScreen].bounds.size.width);//必须加
    }];

}
- (void)praisePlus:(UIButton*)sender{
//    CcUserModel *model = [CcUserModel defaultClient];
//    NSString *token = model.userToken;
//    NSString *urlStr = [NSString stringWithFormat:@"%@/likes/UpdateLikeNum.do?id=%@&token=%@",mPrefixUrl,self.comModel.info_id,token];
//    [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//            
//        }else{
//            //点赞/删除未成功
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    NSInteger count = [self.countLabel.text integerValue];
//    if (self.comModel.state) {
//        count -= 1;
//        self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
//        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//        self.infoDetailModel.state = false;
//        self.infoDetailModel.likeNum = [NSString stringWithFormat:@"%ld",count];
//    }else{
//        count += 1;
//        self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
//        [sender setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
//        self.infoDetailModel.state = true;
//        self.infoDetailModel.likeNum = [NSString stringWithFormat:@"%ld",count];
//    }

    
    NSInteger count = [self.countLabel.text integerValue];
    count += 1;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
