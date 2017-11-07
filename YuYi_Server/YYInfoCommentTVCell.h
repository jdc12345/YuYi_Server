//
//  YYInfoCommentTVCell.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/11/6.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCommentInfoModel.h"

@interface YYInfoCommentTVCell : UITableViewCell
@property(nonatomic,strong)YYCommentInfoModel *infoCommentModel;

@property (nonatomic, assign) CGFloat cellHeight;
@end
