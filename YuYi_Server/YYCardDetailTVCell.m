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
#import "YYCardPostPictureCell.h"
static NSString *cell_id = @"cell_id";
@interface YYCardDetailTVCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *countLabel;
@property(nonatomic,weak)UILabel *contentLabel;
@property(nonatomic,weak)UIImageView *bigImageView;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *conentLabel;
@property(nonatomic,weak)UIButton *praiseBtn;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *imagesArr;
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
    if (![infoModel.picture isEqualToString:@""]) {
        NSArray *array = [infoModel.picture componentsSeparatedByString:@";"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
        [arr removeLastObject];
        self.imagesArr = arr;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.imagesArr.count*kScreenW);
        }];
        [self.tableView reloadData];
    }
//    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,infoModel.picture];
//    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
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
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.image = [UIImage imageNamed:@"add_pic"];
//    [self.contentView addSubview:imageView];
//    self.bigImageView = imageView;
    UITableView *tableView = [[UITableView alloc]init];
    [self.contentView addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YYCardPostPictureCell class] forCellReuseIdentifier:cell_id];
    self.tableView = tableView;
    tableView.userInteractionEnabled = false;

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
        make.width.height.offset(30*kiphone6);
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
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(20);
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
        make.height.offset(self.imagesArr.count*kScreenW);

    }];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentLabel.mas_bottom).offset(20);
//        make.left.offset(20*kiphone6);
//        make.right.offset(-20*kiphone6);
//        make.height.offset(335*kiphone6);
//    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableView.mas_bottom);
        make.width.offset([UIScreen mainScreen].bounds.size.width);//必须加
    }];
}
#pragma UItableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imagesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCardPostPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.imagesArr[indexPath.row]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imageUrlStr]
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            cell.image = image;
                        }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenW;
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
    //发通知
    NSNumber *boolNumber = [NSNumber numberWithBool:self.infoModel.isLike];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshLikeStateWithInfoModel:" object:nil userInfo:@{@"likeState":boolNumber,@"infoId":self.infoModel.info_id}];
    
//    NSInteger count = [self.countLabel.text integerValue];
//    count += 1;
//    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}
//将通知中心移除

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshLikeStateWithInfoModel:" object:nil];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
