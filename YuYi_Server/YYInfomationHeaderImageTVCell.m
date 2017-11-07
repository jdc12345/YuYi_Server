//
//  YYInfomationHeaderImageTVCell.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/11/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYInfomationHeaderImageTVCell.h"
#import <UIImageView+WebCache.h>

@interface YYInfomationHeaderImageTVCell()
@property(nonatomic,weak)UIImageView *bigImageView;
@property(nonatomic,weak)UILabel *titleLabel;
@end

@implementation YYInfomationHeaderImageTVCell

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
    self.titleLabel.text = model.title;
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.picture];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
}
- (void)setupUI{
    //图片
    UIImageView *bigView = [[UIImageView alloc]init];
    bigView.image = [UIImage imageNamed:@"info.png"];
    self.bigImageView = bigView;
    [self.contentView addSubview:bigView];
    //透明view
    UIView *alphaView = [[UIView alloc]init];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.6;
    [bigView addSubview:alphaView];
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"资讯标题";
    self.titleLabel = titleLabel;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:kPingFang_S size:18];
    [alphaView addSubview:titleLabel];
    //约束
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.offset(0);
    }];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,44 *kiphone6H));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10 *kiphone6);
        make.right.offset(-10 *kiphone6);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    }

@end
