//
//  YYRecordInfoDisplayTVCell.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/10/20.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYRecordInfoDisplayTVCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *nextImageV;
@property (nonatomic, strong) UILabel *seeRecardLabel;
@property (nonatomic, strong) UITextField *editInfoText;

- (void)setType:(NSString *)cellType;


@property (nonatomic, copy) void(^sexClick)(NSString *);
@end
