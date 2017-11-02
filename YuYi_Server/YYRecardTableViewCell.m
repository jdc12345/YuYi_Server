//
//  YYRecardTableViewCell.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYRecardTableViewCell.h"
#import "UILabel+Addition.h"
@interface YYRecardTableViewCell ()
@property(nonatomic,weak)UILabel *nameLable;
@property(nonatomic,weak)UILabel *departmentLable;
@property(nonatomic,weak)UILabel *timeLable;
@end
@implementation YYRecardTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];        [self createDetailView];
    }
    return self;
}
-(void)setModel:(AppointmentModel *)model{
    _model = model;
    self.nameLable.text = model.trueName;
    
    NSString *appointmentTime = [model.visitTimeString substringWithRange:NSMakeRange(0, 16)];
    self.timeLable.text = appointmentTime;
    self.departmentLable.text = model.departmentName;
}
- (void)createDetailView{

    //渐变nameLabel
    UILabel *nameLabel = [UILabel labelWithText:@"名字" andTextColor:[UIColor colorWithHexString:@"ffffff"] andFontSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"2feaeb"].CGColor, (__bridge id)[UIColor colorWithHexString:@"1ebeec"].CGColor];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, 75*kiphone6, 75*kiphone6);
    [nameLabel.layer insertSublayer:gradientLayer atIndex:0];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
        make.width.height.offset(75*kiphone6);
    }];
    self.nameLable = nameLabel;
    //右侧背景view
    UIView *rightBackView = [[UIView alloc]init];
    rightBackView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:rightBackView];
    [rightBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right);
        make.right.offset(-10*kiphone6);
        make.top.bottom.equalTo(nameLabel);
    }];
    //科室label
    UILabel *departmentLabel = [UILabel labelWithText:@"科室" andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:15];
    [rightBackView addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    self.departmentLable = departmentLabel;
    //
    UIImage *image = [UIImage imageNamed:@"record_arrow"];
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:image];
    [rightBackView addSubview:nextImage];
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(-10*kiphone6);
        make.width.offset(image.size.width);
        make.height.offset(image.size.height);
    }];
    //timeLabel
    UILabel *timeLabel = [UILabel labelWithText:@"2017-10-28" andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [rightBackView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextImage);
        make.right.equalTo(nextImage.mas_left);
    }];
    self.timeLable = timeLabel;

    UILabel *itemLabel = [UILabel labelWithText:@"就诊时间：" andTextColor:[UIColor colorWithHexString:@"666666"] andFontSize:12];
    [rightBackView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextImage);
        make.right.equalTo(timeLabel.mas_left);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
