//
//  AppDelegate.h
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMReceiveMessageDelegate, RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow * window;
@property (assign, nonatomic) BOOL  isHasPower;//医生是否有看病的权限

@end

