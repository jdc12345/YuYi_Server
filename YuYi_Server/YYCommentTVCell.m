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
@property(nonatomic, assign)CGFloat sizeHeight;
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
//资讯评论数据
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
//学术圈评论数据
-(void)setComModel:(YYCardCommentDetailModel *)comModel{
    _comModel = comModel;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,comModel.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"add_pic"]];
    self.nameLabel.text =  comModel.trueName;
    self.timeLabel.text = comModel.createTimeString;
    self.contentLabel.text = comModel.content;
    self.countLabel.text = comModel.likeNum;

//    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] init];
//    if ([self stringContainsEmoji:comModel.content]) {
//        NSMutableAttributedString *unContentEmojistring = [[NSMutableAttributedString alloc] initWithString:comModel.content];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 2;
//        [unContentEmojistring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [unContentEmojistring length])];
//        [mutableString appendAttributedString:unContentEmojistring];
//        comModel.content = [mutableString string];
//    }
//
//    [self.contentLabel sizeToFit];
    CGSize textSize = [comModel.content boundingRectWithSize:CGSizeMake(kScreenW-65*kiphone6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(textSize.height);
    }];
    self.sizeHeight = textSize.height;
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    self.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 20;

    }
- (void)updateViewConstraints {
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(10*kiphone6);
        make.left.equalTo(_timeLabel);
        make.right.offset(-20*kiphone6);
        make.height.offset(self.sizeHeight);
    }];
    
    [self updateViewConstraints];
}
////判断是否含有Emoji表情
//- (BOOL)stringContainsEmoji:(NSString *)string
//{
//    __block BOOL returnValue =NO;
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//        const unichar hs = [substring characterAtIndex:0];
//        // surrogate pair
//        if (0xd800) {
//            if (0xd800 <= hs && hs <= 0xdbff) {
//                if (substring.length > 1) {
//                    const unichar ls = [substring characterAtIndex:1];
//                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                    if (0x1d000 <= uc && uc <= 0x1f77f) {
//                        returnValue =YES;
//                    }
//                }
//            }else if (substring.length > 1) {
//                const unichar ls = [substring characterAtIndex:1];
//                if (ls == 0x20e3) {
//                    returnValue =YES;
//                }
//            }else {
//                // non surrogate
//                if (0x2100 <= hs && hs <= 0x27ff) {
//                    returnValue =YES;
//                }else if (0x2B05 <= hs && hs <= 0x2b07) {
//                    returnValue =YES;
//                }else if (0x2934 <= hs && hs <= 0x2935) {
//                    returnValue =YES;
//                }else if (0x3297 <= hs && hs <= 0x3299) {
//                    returnValue =YES;
//                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                    returnValue =YES;
//                }
//            }
//        }
//    }];
//    return returnValue;
//}
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
    UIView *line = [[UIView alloc]init];//分割线
    line.alpha = 0.6f;
    line.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:line];
    //约束
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(20*kiphone6);
        make.width.height.offset(30*kiphone6);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    [nameLabel sizeToFit];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    [timeLabel sizeToFit];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10*kiphone6);
        make.left.equalTo(timeLabel);
        make.right.offset(-20*kiphone6);
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20*kiphone6);
        make.centerY.equalTo(iconView);
    }];
    [countLabel sizeToFit];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countLabel.mas_left).offset(-5*kiphone6);
        make.centerY.equalTo(iconView);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(0.5*kiphone6);
    }];
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(contentLabel.mas_bottom).offset(20*kiphone6);
//        make.width.offset([UIScreen mainScreen].bounds.size.width);//必须加
//    }];

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
