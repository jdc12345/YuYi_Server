//
//  InvitationViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "InvitationViewController.h"
#import <Masonry.h>
#import "UIButton+Badge.h"
#import "UIColor+Extension.h"
#import "YYpostCardVC.h"
#import "NSObject+Formula.h"
#import "YYCardTableViewCell.h"
#import "YYCardDetailVC.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "CcUserModel.h"

@interface InvitationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, strong) UITableView *tableView;
@end
static NSString *cellId = @"cell_id";
@implementation InvitationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *token = userModel.userToken;
    NSString *hotUrlStr;
    if ([self.titleStr isEqualToString:@"我的帖子"]) {
        hotUrlStr = [NSString stringWithFormat:@"%@start=0&limit=6&token=%@",mMyAcademicpaper,token];
    }else{
        hotUrlStr = [NSString stringWithFormat:@"%@start=0&limit=6&token=%@",mMyLike,token];
    }
    
    [self loadHotInfosWithUrlStr:hotUrlStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setInfos:(NSArray *)infos{
    _infos = infos;
    [self.tableView reloadData];
}
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) style:UITableViewStylePlain];
//    tableView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(64);
//        make.left.right.bottom.offset(0);
//    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 150;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[YYCardTableViewCell class] forCellReuseIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infos.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150*kiphone6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.model = self.infos[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YYCardDetailVC *cardVC = [[YYCardDetailVC alloc]initWithInfo:cell.model.info_id];
    
    //    cardVC.info_id = cell.model.info_id;
    [self.navigationController pushViewController:cardVC animated:true];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)loadHotInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"rows"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.infos = mArr;
        [self setupUI];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
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
