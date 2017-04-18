//
//  YYInformationVC.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYInformationVC;
@protocol refreshDelegate <NSObject>//协议

- (void)transViewController:(YYInformationVC*)learningVC;//协议方法
- (void)transForFootRefreshWithViewController:(YYInformationVC*)learningVC;//上拉加载协议方法
@end
@interface YYInformationVC : UIViewController
@property(nonatomic,strong)NSMutableArray *infos;
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, assign) id<refreshDelegate>delegate;//代理属性

@end
