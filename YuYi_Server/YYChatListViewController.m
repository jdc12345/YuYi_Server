//
//  YYChatListViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/7.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYChatListViewController.h"
#import "RCDChatListCell.h"
#import <UIImageView+WebCache.h>
#import "RCDHttpTool.h"
#import "YYWordsViewController.h"
#import "YYHomeUserModel.h"
#import <MJExtension.h>

#define RCDHTTPTOOL [RCDHttpTool shareInstance]

@interface YYChatListViewController ()<RCIMUserInfoDataSource>
///<RCIMReceiveMessageDelegate>
@property(nonatomic, assign) NSUInteger index;
@end

@implementation YYChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"咨询";
    [self.conversationListTableView  setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
//    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[
                                        @(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_PUBLICSERVICE),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)
                                        ]];
    
    //聚合会话类型
    [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
    
    
    
    //定位未读数会话
    self.index = 0;
    //    //接收定位到未读数会话的通知
    //    [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(GotoNextCoversation)
    //     name:@"GotoNextCoversation"
    //     object:nil];
    //
    //    [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(updateForSharedMessageInsertSuccess)
    //     name:@"RCDSharedMessageInsertSuccess"
    //     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCell:)
                                                 name:@"RefreshConversationList"
                                               object:nil];

    // 没有消息时候显示的空页面.
    self.emptyConversationView = [[EmptyDataView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) AndImageStr:@"没有消息"];
//    设置在会话列表中显示的头像形状，矩形或者圆形（全局有效）
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    [self setConversationPortraitSize:CGSizeMake(40, 40)];
//    是否在发送的所有消息中携带当前登录的用户信息
    [[RCIM sharedRCIM] setEnableMessageAttachUserInfo:true];
    // 用户信息提供者
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //如果设置为NO，则SDK在需要显示用户信息时，会调用用户信息提供者获取用户信息并缓存到Cache，此Cache在App生命周期结束时会被移除，下次启动时会再次通过用户信息提供者获取信息。 如果设置为YES，则会将获取到的用户信息持久化存储在本地，App下次启动时Cache会仍然有效
    [[RCIM sharedRCIM]setEnablePersistentUserInfoCache:true];
}
//在缓存到本地前需要向服务器请求一次数据
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
//http://192.168.1.168:8082/yuyi/homeuser/findMyUserInfo.do?token=293AB53EF708A14175A44DE3378D8BFA&personalId=18301264693
//    token=医生的token
//    personalId=患者的id，手机号；
    NSString *getUserInfoUrl = [NSString stringWithFormat:@"%@%@&personalId=%@",mRCUserInfoUrl,mDefineToken,userId];
    [[HttpClient defaultClient] requestWithPath:getUserInfoUrl method:0 parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        YYHomeUserModel *modle = [YYHomeUserModel mj_objectWithKeyValues:dic];
        if ([modle.gender isEqualToString:@"1"]) {
            modle.gender = @"男";
        }else if ([modle.gender isEqualToString:@"0"]){
            modle.gender = @"女";
        }else{
            modle.gender = @"未知";
        }
        if (!modle.age) {
            modle.age = @"未知";
        }
        NSString *titleName = [NSString stringWithFormat:@"%@(%@ %@)",modle.trueName?modle.trueName:@"患者",modle.gender,modle.age];
                RCUserInfo *userModel_rc = [[RCUserInfo alloc]initWithUserId:userId name:titleName portrait:[NSString stringWithFormat:@"%@%@",mPrefixUrl,responseObject[@"avatar"]]];
        return completion(userModel_rc);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
//即将加载列表数据源的回调,您可以在回调中修改、添加、删除数据源的元素来定制显示的内容，会话列表会根据您返回的修改后的数据源进行显示,比如插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    NSLog(@"%@",dataSource);
    NSLog(@"%@",[RCIM sharedRCIM].currentUserInfo.description);
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            }
        //群组通知消息
        if ([model.lastestMessage
             isKindOfClass:[RCGroupNotificationMessage class]]) {
            RCGroupNotificationMessage *groupNotification =
            (RCGroupNotificationMessage *)model.lastestMessage;
            if ([groupNotification.operation isEqualToString:@"Quit"]) {//退出操作通知
                NSData *jsonData =
                [groupNotification.data dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary = [NSJSONSerialization
                                            JSONObjectWithData:jsonData
                                            options:NSJSONReadingMutableContainers
                                            error:nil];
                NSDictionary *data =
                [dictionary[@"data"] isKindOfClass:[NSDictionary class]]
                ? dictionary[@"data"]
                : nil;
                NSString *nickName =
                [data[@"operatorNickname"] isKindOfClass:[NSString class]]
                ? data[@"operatorNickname"]
                : nil;
                if ([nickName isEqualToString:[RCIM sharedRCIM].currentUserInfo.name]) {
                    [[RCIMClient sharedRCIMClient]
                     removeConversation:model.conversationType
                     targetId:model.targetId];
                    [self refreshConversationTableViewIfNeeded];
                }
            }
        }
    }
    
    return dataSource;
}
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCConversationCell *Rcell = (RCConversationCell *)cell;
    Rcell.conversationTitle.text = cell.model.conversationTitle;

}
//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f*kiphone6H;
}
//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName = nil;
    __block NSString *portraitUri = nil;
    RCContactNotificationMessage *_contactNotificationMsg = nil;
    
//    __weak RCDChatListViewController *weakSelf = self;
    WS(weakSelf);
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                _contactNotificationMsg =
                (RCContactNotificationMessage *)model.lastestMessage;
                if (_contactNotificationMsg.sourceUserId == nil) {
                    RCDChatListCell *cell =
                    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@""];
                    cell.lblDetail.text = @"好友请求";
                    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
                    return cell;
                }
                NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]
                                                 objectForKey:_contactNotificationMsg.sourceUserId];
                if (_cache_userinfo) {
                    userName = _cache_userinfo[@"username"];
                    portraitUri = _cache_userinfo[@"portraitUri"];
                } else {
                    NSDictionary *emptyDic = @{};
                    [[NSUserDefaults standardUserDefaults]
                     setObject:emptyDic
                     forKey:_contactNotificationMsg.sourceUserId];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [RCDHTTPTOOL
                     getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                     completion:^(RCUserInfo *user) {
                         if (user == nil) {
                             return;
                         }
                         RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                         rcduserinfo_.name = user.name;
                         rcduserinfo_.userId = user.userId;
                         rcduserinfo_.portraitUri = user.portraitUri;
                         
                         model.extend = rcduserinfo_;
                         
                         // local cache for userInfo
                         NSDictionary *userinfoDic = @{
                                                       @"username" : rcduserinfo_.name,
                                                       @"portraitUri" : rcduserinfo_.portraitUri
                                                       };
                         [[NSUserDefaults standardUserDefaults]
                          setObject:userinfoDic
                          forKey:_contactNotificationMsg.sourceUserId];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         [weakSelf.conversationListTableView
                          reloadRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:
                          UITableViewRowAnimationAutomatic];
                     }];
                }
            }
        
    } else {
        RCDUserInfo *user = (RCDUserInfo *)model.extend;
        userName = user.name;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell =
    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@""];
    //------------------------------后添加的这句代码，需要确认------------------------------
    _contactNotificationMsg =
    (RCContactNotificationMessage *)model.lastestMessage;
    
    NSString *operation = _contactNotificationMsg.operation;
    NSString *operationContent;
    if ([operation isEqualToString:@"Request"]) {
        operationContent = [NSString stringWithFormat:@"来自%@的好友请求", userName];
    } else if ([operation isEqualToString:@"AcceptResponse"]) {
        operationContent = [NSString stringWithFormat:@"%@通过了你的好友请求", userName];
    }
    cell.lblDetail.text = operationContent;
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
    cell.labelTime.text = [RCKitUtility ConvertMessageTime:model.sentTime/1000];
    cell.model = model;
    return cell;
}
/*!
 在会话列表中，收到新消息的回调
 
 @param notification    收到新消息的notification
 
 @discussion SDK在此方法中有针对消息接收有默认的处理（如刷新等），如果您重写此方法，请注意调用super。
 
 notification的object为RCMessage消息对象，userInfo为NSDictionary对象，其中key值为@"left"，value为还剩余未接收的消息数的NSNumber对象。
 */
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    //收到消息后更新会话列表
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self refreshConversationTableViewIfNeeded];
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//    conversationVC.conversationType = model.conversationType;
//    conversationVC.targetId = model.targetId;
//    conversationVC.title = @"想显示的会话标题";
//    [self.navigationController pushViewController:conversationVC animated:YES];
    YYWordsViewController *wordVC = [[YYWordsViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    wordVC.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    wordVC.targetId = model.targetId;
    wordVC.conversationTitle = model.conversationTitle;
    [self.navigationController pushViewController:wordVC animated:YES];
}
-(void)refreshCell:(NSNotification *)notify
{
    /*
     NSString *row = [notify object];
     RCConversationModel *model = [self.conversationListDataSource objectAtIndex:[row intValue]];
     model.unreadMessageCount = 0;
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
     });
     */
    [self refreshConversationTableViewIfNeeded];
}

- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
    }
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    NSLog(@"还剩余的未接收的消息数：%d", totalUnreadCount);
    [self refreshConversationTableViewIfNeeded];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
