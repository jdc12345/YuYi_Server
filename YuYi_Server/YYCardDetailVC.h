//
//  YYCardDetailVC.h
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/29.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCardDetailVC : UIViewController
@property(nonatomic,copy)NSString *info_id;

-(instancetype)initWithInfo:(NSString*)info_id;
@end
