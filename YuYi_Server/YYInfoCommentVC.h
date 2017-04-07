//
//  YYInfoCommentVC.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/7.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInfoDetailModel.h"
@interface YYInfoCommentVC : UIViewController
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, strong) YYInfoDetailModel *infoDetailModel;
@end
