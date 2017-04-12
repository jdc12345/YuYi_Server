//
//  YYNotficTableViewCell.h
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYNotficTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *nextImageV;
@property (nonatomic, strong) UILabel *seeRecardLabel;
@property (nonatomic, strong) UITextField *editInfoText;

- (void)setType:(NSString *)cellType;


@property (nonatomic, copy) void(^sexClick)(NSString *);
@end
