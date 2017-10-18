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
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "HttpClient.h"
#import "YYCardDetailTVCell.h"
@interface YYCardTableViewCell ()
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *praiseCountLabel;
@property(nonatomic,weak)UIImageView *imagesView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *contentLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *repliesLabel;
@property(nonatomic,weak)UIButton *praiseBtn;
@end

@implementation YYCardTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setModel:(YYCardDetailModel *)model{
    _model = model;
    NSString *iconUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrlStr]];
    self.nameLabel.text = model.trueName;
    self.titleLabel.text = model.title;
    if ([model.picture isEqualToString:@""]) {
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imagesView.mas_right);
        }];
        
    }else{
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(55*kiphone6);
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imagesView.mas_right).offset(10*kiphone6);
        }];
        NSArray *array = [model.picture componentsSeparatedByString:@";"]; //以分号分割图片字符串
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,array[0]];
        [self.imagesView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    }
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.createTimeString;
    self.praiseCountLabel.text = model.likeNum;
    self.repliesLabel.text = model.commentNum;
    self.praiseBtn.selected = self.model.isLike;

}
- (void)setupUI{
    
//    self.contentView.backgroundColor = [UIColor orangeColor];
    //分割线
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.contentView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(10*kiphone6H);
    }];
    //icon
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 12.5*kiphone6H;
    iconView.image = [UIImage imageNamed:@"avatar"];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    //名字
    UILabel *nameLabel = [UILabel labelWithText:@"LIMIN" andTextColor:[UIColor colorWithHexString:@"6a6a6a"] andFontSize:12];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    //帖子标题
    UILabel *titleLabel = [UILabel labelWithText:@"帖子标题" andTextColor:[UIColor colorWithHexString:@"2b2b2b"] andFontSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:imageView];
    self.imagesView = imageView;
    //帖子内容
    UILabel *contentLabel = [UILabel labelWithText:@"帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容帖子内容" andTextColor:[UIColor colorWithHexString:@"6a6a6a"] andFontSize:13];
    contentLabel.numberOfLines = 3;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    //发帖时间
    UILabel *timeLabel = [UILabel labelWithText:@"3小时前" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:11];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    //赞btn
    UIButton *praiseBtn = [[UIButton alloc]init];
    [praiseBtn setImage:[UIImage imageNamed:@"cycle_like"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"cycle_like_selected"] forState:UIControlStateSelected];
    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:praiseBtn];
    self.praiseBtn = praiseBtn;
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
    self.repliesLabel = repliesLabel;
    //约束布局
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(sepView.mas_bottom).offset(15*kiphone6H);
        make.width.height.offset(25*kiphone6H);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(iconView.mas_bottom).offset(15*kiphone6H);
        make.right.offset(-20*kiphone6);
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10*kiphone6);
        make.width.height.offset(55*kiphone6);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
        make.right.offset(-20*kiphone6);
        make.top.equalTo(titleLabel.mas_bottom).offset(10*kiphone6);
        make.height.offset(55*kiphone6);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(titleLabel.mas_bottom).offset(85*kiphone6);
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
        make.width.height.offset(20*kiphone6);
    }];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(praiseBtn.mas_bottom).offset(20*kiphone6);
//        make.width.offset([UIScreen mainScreen].bounds.size.width);
//    }];

}
- (void)praisePlus:(UIButton*)sender{
    sender.selected = !sender.selected;
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSString *urlStr = [NSString stringWithFormat:@"%@/likes/LikeNum.do?id=%@&token=%@",mPrefixUrl,self.model.info_id,token];
    [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            
        }else{
            //点赞/删除未成功
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    NSInteger count = [self.praiseCountLabel.text integerValue];
    if (self.model.isLike) {
        count -= 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        self.model.likeNum = [NSString stringWithFormat:@"%ld",count];
    }else{
        count += 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        self.model.likeNum = [NSString stringWithFormat:@"%ld",count];
    }
    self.model.isLike = sender.selected;
}
//在详情页面返回时候更新点赞状态
-(void)setLikeState:(BOOL)likeState{
    _likeState = likeState;
    self.praiseBtn.selected = likeState;
    NSInteger count = [self.praiseCountLabel.text integerValue];
    if (likeState) {
        count += 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        self.model.likeNum = [NSString stringWithFormat:@"%ld",count];
    }else{
        count -= 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        self.model.likeNum = [NSString stringWithFormat:@"%ld",count];
    }
}
- (void)repliesPlus:(UIButton*)sender{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
