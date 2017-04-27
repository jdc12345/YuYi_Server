//
//  YYCommentTVCell.h
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/29.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCommentInfoModel.h"
#import "YYCardCommentDetailModel.h"
@interface YYCommentTVCell : UITableViewCell
@property(nonatomic,strong)YYCommentInfoModel *infoCommentModel;
@property(nonatomic,strong)YYCardCommentDetailModel *comModel;
@property(nonatomic,weak)UILabel *countLabel;
@end
