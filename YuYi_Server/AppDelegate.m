//
//  AppDelegate.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AppDelegate.h"
#import "YYTabBarController.h"
#import <RongIMKit/RongIMKit.h>
#import "CcUserModel.h"
#import "YYLogInVC.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "YYChatListViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate,RCIMReceiveMessageDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic, strong) YYTabBarController *yyTabBar;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *userToken = userModel.userToken;
    
    if (userToken) {
        //初始化一个tabBar控制器
        YYTabBarController *tabbarVC = [[YYTabBarController alloc]init];
        self.window.rootViewController = tabbarVC;
        self.yyTabBar = tabbarVC;
       
    }else{
        YYLogInVC *logInVC = [[YYLogInVC alloc]init];
        self.window.rootViewController = logInVC;
    }
     [self.window makeKeyAndVisible];
    
    
  
    
    
    [[RCIM sharedRCIM] initWithAppKey:@"25wehl3u2qo7w"];
    
   //   登陆融云
    
        [[RCIM sharedRCIM] connectWithToken:mRCToken     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//            [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
            [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
            [[RCIM sharedRCIM] setDisableMessageNotificaiton:NO];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%d", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
    
    
    // 融云控制台输出信息种类
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Error;
    //////////////////
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"14387858f853dc00f5c5959a"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
    
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            //点击允许
            NSLog(@"注册通知成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
            }];
        } else {
            //点击不允许
            NSLog(@"注册通知失败");
        }
    }];
    //注册推送（同iOS8）
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    // Override point for customization after application launch.
    return YES;
}

// 极光推送 注册 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}
// 融云
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@qwqwqqw",userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"%@",userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    
    NSString * unreadNum = [NSString stringWithFormat:@"%d",unreadMsgCount];
    NSDictionary * dict = @{@"unreadNum":unreadNum};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageUnreadNum" object:nil userInfo:dict];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = unreadMsgCount;
    
    // 注册通知
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
    }
    NSLog(@"还剩余的未接收的消息数：%d", left);
    
    
    
    
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    
    localNote.alertBody = @"在干吗?";
    
    localNote.alertAction = @"解锁";
    
    localNote.hasAction = NO;
    
    localNote.alertLaunchImage = @"123Abc";
    // 2.6.设置alertTitle
    localNote.alertTitle = @"你有一条新通知";
    // 2.7.设置有通知时的音效
    localNote.soundName = @"buyao.wav";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 999;
    // 2.9.设置额外信息
    localNote.userInfo = @{@"type" : @"聊天"};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"来了么");
    // 必须要监听--应用程序在后台的时候进行的跳转
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"进行界面的跳转");
        // 如果在上面的通知方法中设置了一些，可以在这里打印额外信息的内容，就做到监听，也就可以根据额外信息，做出相应的判断
//        NSLog(@"%@", notification.userInfo);
        
        
        YYTabBarController *tabbarVC = (YYTabBarController *)self.window.rootViewController;
        tabbarVC.selectedIndex = 4;
        
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    NSLog(@"========%@", notification);
    //如果需要在应用在前台也展示通知
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    self.yyTabBar.selectedIndex = 3;
    

    YYChatListViewController *chatList = [[YYChatListViewController alloc]init];
    if ([self.yyTabBar.viewControllers.lastObject respondsToSelector:@selector(pushViewController: animated:)]) {
        [self.yyTabBar.viewControllers.lastObject pushViewController:chatList animated:YES];
    }
    NSLog(@"response:%@", response);
}
@end
