//
//  YYNoticeListVC.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/10/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYNoticeListVC.h"
#import "YJNoticeListTVCell.h"
//#import "YJFriendStateDetailVC.h"
//#import "YJCommunityCarNoticesCenterVC.h"
#import "YJNoticeListModel.h"
//#import "YJCommunityCarDetailVC.h"
//#import "YJActivitiesDetailsVC.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NotficationViewController.h"

static NSInteger start = 0;
static NSString* tableCell = @"table_cell";
@interface YYNoticeListVC ()
@property(nonatomic,strong)NSMutableArray *noticesArr;//全部消息数据源
@property(nonatomic,strong)NSMutableArray *publicNoticesArr;//公告消息数据源
@end

@implementation YYNoticeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadNoticeData];
    [self.tableView registerClass:[YJNoticeListTVCell class] forCellReuseIdentifier:tableCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90*kiphone6;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *noticeUrlStr = [NSString stringWithFormat:@"%@/messagePhysician/findPage.do?token=%@&start=0&limit=10",mPrefixUrl,mDefineToken];
        [[HttpClient defaultClient]requestWithPath:noticeUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf.publicNoticesArr removeAllObjects];//从新请求需要更新数据
            NSString *total = responseObject[@"total"];
            if ([total integerValue]>0) {
                NSArray *arr = responseObject[@"rows"];
                NSMutableArray *mArr = [NSMutableArray array];
                BOOL token = false;
                for (NSDictionary *dic in arr) {
                    YJNoticeListModel *infoModel = [YJNoticeListModel mj_objectWithKeyValues:dic];
                    if (infoModel.msgType > 1) {//公告以外消息
                        [mArr addObject:infoModel];
                    }else{//公告消息
                        //只执行一次
                        if (!token) {
                            [mArr insertObject:infoModel atIndex:0];
                            token = true;
                        }
                        [weakSelf.publicNoticesArr addObject:infoModel];//公告消息数据源
                    }
                }
                weakSelf.noticesArr = mArr;
                start = weakSelf.noticesArr.count;
                [weakSelf.tableView reloadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }else{
                [SVProgressHUD showInfoWithStatus:@"你目前没有消息可以查看"];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }];
        
    }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入加载状态后会自动调用这个block
        if (self.noticesArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        if (start % 10 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        NSString *noticeUrlStr = [NSString stringWithFormat:@"%@/messagePhysician/findPage.do?token=%@&start=%ld&limit=10",mPrefixUrl,mDefineToken,start];
        [[HttpClient defaultClient]requestWithPath:noticeUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *total = responseObject[@"total"];
            if ([total integerValue]>0) {
                NSArray *arr = responseObject[@"rows"];
                NSMutableArray *mArr = [NSMutableArray array];
                BOOL token = false;
                for (NSDictionary *dic in arr) {
                    YJNoticeListModel *infoModel = [YJNoticeListModel mj_objectWithKeyValues:dic];
                    if (infoModel.msgType > 1) {//公告以外消息
                        [mArr addObject:infoModel];
                    }else{//公告消息
                        //只执行一次
                        if (!token&&weakSelf.publicNoticesArr.count==0) {
                            [mArr insertObject:infoModel atIndex:0];
                            token = true;
                        }
                        [weakSelf.publicNoticesArr addObject:infoModel];//公告消息数据源
                    }
                }
                if (mArr.count>0) {
                    [weakSelf.noticesArr addObjectsFromArray:mArr];//消息数据源
                    [weakSelf.tableView reloadData];
                    start = weakSelf.noticesArr.count;
                    if (start % 10 != 0) {
                       [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
//                [weakSelf.noticesArr addObjectsFromArray:mArr];
//                start = weakSelf.noticesArr.count;
//                [weakSelf.tableView reloadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }else{
                [SVProgressHUD showInfoWithStatus:@"你目前没有更多消息可以查看"];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
            return ;
        }];
    }];
}
//首次请求数据
-(void)loadNoticeData{
    [SVProgressHUD show];// 动画开始
    NSString *noticeUrlStr = [NSString stringWithFormat:@"%@/messagePhysician/findPage.do?token=%@&start=0&limit=10",mPrefixUrl,mDefineToken];
    [[HttpClient defaultClient]requestWithPath:noticeUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        NSString *total = responseObject[@"total"];
        if ([total integerValue]>0) {
            NSArray *arr = responseObject[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            BOOL token = false;
            for (NSDictionary *dic in arr) {
                YJNoticeListModel *infoModel = [YJNoticeListModel mj_objectWithKeyValues:dic];
                //消息类型--1=宇医公告，2=挂号通知，3=点赞资讯，4=点赞帖子，5=点赞帖子评论，6=帖子评论，7=资讯评论
            
                if (infoModel.msgType > 1) {//公告以外消息
                    
                    [mArr addObject:infoModel];
                }else{//公告
                    //只执行一次
                    if (!token) {
                        [mArr insertObject:infoModel atIndex:0];
                        token = true;
                    }
                    [self.publicNoticesArr addObject:infoModel];//公告消息数据源
                }
            }
            self.noticesArr = mArr;
            start = self.noticesArr.count;
            [self.tableView reloadData];
            if (start % 10 != 0) {//显示没有更多数据了
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }else{
            [SVProgressHUD showInfoWithStatus:@"你目前没有消息可以查看"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.noticesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJNoticeListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
    YJNoticeListModel *infoModel = self.noticesArr[indexPath.row];
    if (self.publicNoticesArr.count>0) {//存在公告消息
        if (indexPath.row==0) {
            infoModel.avatar = @"public_notice";
        }
    }
    cell.model = infoModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJNoticeListModel *model = self.noticesArr[indexPath.row];
    //消息类型--1=宇医公告，2=挂号通知，3=点赞资讯，4=点赞帖子，5=点赞帖子评论，6=帖子评论，7=资讯评论
    switch (model.msgType) {
        case 1:
            //跳转公告
        {
            NotficationViewController *noticeVC = [[NotficationViewController alloc]init];
            noticeVC.publicNoticesArr = self.publicNoticesArr;
            [self.navigationController pushViewController:noticeVC animated:true];
        }
            break;
        case 2:
            //跳转挂号通知
            break;
        case 3:
            //跳转点赞资讯
            break;
        case 4:
            //跳转
            break;
        case 5:
            //跳转点赞帖子评论
            break;
        case 6:
            //跳转帖子评论
            break;
        case 7:
            //跳转资讯评论
            break;
        default:
            break;
    }
//    if (model.msgType > 10&&model.msgType < 31) {
//        YJFriendStateDetailVC *vc = [[YJFriendStateDetailVC alloc]init];
//        vc.stateId = [NSString stringWithFormat:@"%ld",model.referId];
//        [self.navigationController pushViewController:vc animated:true];
//    }else if (model.msgType > 30&&model.msgType < 51){
//        YJActivitiesDetailsVC *vc = [[YJActivitiesDetailsVC alloc]init];
//        vc.activityId = model.referId;
//        [self.navigationController pushViewController:vc animated:true];
//    }else if (model.msgType > 50&&model.msgType < 71){
//        YJCommunityCarNoticesCenterVC *vc = [[YJCommunityCarNoticesCenterVC alloc]init];
//        vc.carNoticesArr = self.carNoticesArr;//传递拼车消息
//        [self.navigationController pushViewController:vc animated:true];
        //        if (model.msgType == 52 || model.msgType == 53) {//52=司机接单，53=乘客加入
        //            YJCommunityCarNoticesCenterVC *vc = [[YJCommunityCarNoticesCenterVC alloc]init];
        //            vc.carNoticesArr = self.carNoticesArr;//传递拼车消息
        //            [self.navigationController pushViewController:vc animated:true];
        //        }else if (model.msgType == 51){
        //            YJCommunityCarDetailVC *vc = [[YJCommunityCarDetailVC alloc]init];
        //            vc.carpoolingId = model.referId;
        //            [self.navigationController pushViewController:vc animated:true];
        //        }
//    }
    //http://192.168.1.55:8080/smarthome/mobileapi/messageLog/save.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE 标记消息为已读
//    NSString *noticeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/messageLog/save.do?token=%@&messageId=%ld",mPrefixUrl,mDefineToken1,model.info_id];
//    [[HttpClient defaultClient]requestWithPath:noticeUrlStr method:1 parameters:nil prepareExecute:^{
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];// 动画结束
//        if ([responseObject[@"code"] isEqualToString:@"0"] ) {
//            //标记成功
//            YJNoticeListModel *infoModel = self.noticesArr[indexPath.row];
//            infoModel.isRead = true;
//            NSArray *indexs = @[indexPath];
//            [tableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];//去掉圆点
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];// 动画结束
//        return ;
//    }];
    
}
/**
 *  左滑cell时出现什么按钮
 */
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    YJNoticeListModel *model = self.noticesArr[indexPath.row];
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        //       http://192.168.1.55:8080/smarthome/mobileapi/message/delete.do?ids=1234,12345&token=9DB2FD6FDD2F116CD47CE6C48B3047EE
//        NSString *urlStr = [NSString stringWithFormat:@"%@messagePhysician/findPage.do?ids=%ld&token=%@",mPrefixUrl,model.info_id,mDefineToken];
//        [SVProgressHUD show];// 动画开始
//        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
//            
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            [SVProgressHUD dismiss];//动画结束
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [self.noticesArr removeObjectAtIndex:indexPath.row];
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }else{
//                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [SVProgressHUD dismiss];//动画结束
//            [SVProgressHUD showErrorWithStatus:@"删除未成功，请稍后再试"];
//            return ;
//        }];
//        
//        
//    }];
//    return @[action1];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*kiphone6;
}
#pragma -懒加载
-(NSMutableArray *)noticesArr{
    if (_noticesArr == nil) {
        _noticesArr = [NSMutableArray array];
    }
    return _noticesArr;
}
-(NSMutableArray *)publicNoticesArr{
    if (_publicNoticesArr == nil) {
        _publicNoticesArr = [NSMutableArray array];
    }
    return _publicNoticesArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
