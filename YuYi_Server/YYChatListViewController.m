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


#define RCDHTTPTOOL [RCDHttpTool shareInstance]

@interface YYChatListViewController ()
@property(nonatomic, assign) NSUInteger index;
@end

@implementation YYChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"咨询";
    [self.conversationListTableView  setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    
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

    // Do any additional setup after loading the view.
}

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    NSLog(@"%@",dataSource);
    
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            }
        if ([model.lastestMessage
             isKindOfClass:[RCGroupNotificationMessage class]]) {
            RCGroupNotificationMessage *groupNotification =
            (RCGroupNotificationMessage *)model.lastestMessage;
            if ([groupNotification.operation isEqualToString:@"Quit"]) {
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

//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0f;
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
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    
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
