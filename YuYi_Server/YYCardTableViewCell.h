//
//  YYCardTableViewCell.h
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/27.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCardDetailModel.h"
@interface YYCardTableViewCell : UITableViewCell
@property(nonatomic,strong)YYCardDetailModel *model;
@property(nonatomic,assign)BOOL likeState;//代理属性
@end
