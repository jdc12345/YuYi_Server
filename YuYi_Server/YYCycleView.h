//
//  YYCycleView.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCycleView : UIView
//@property (nonatomic, copy) void(^bannerClick)(BOOL isShopping);
@property (nonatomic, copy) void(^itemClick)(NSString  *index);
//@property (nonatomic, copy) void(^addFamily)(NSString  *index);
- (instancetype)init;
@end
