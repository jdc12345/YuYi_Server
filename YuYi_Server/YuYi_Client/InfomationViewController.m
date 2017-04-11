//
//  InfomationViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/21.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "InfomationViewController.h"
#import "UIColor+Extension.h"
#import "YYHomeNewTableViewCell.h"
#import "YYInfoDetailViewController.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "YYInfomationModel.h"
#import <UIImageView+WebCache.h>

@interface InfomationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation InfomationViewController
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_tableView registerClass:[YYHomeNewTableViewCell class] forCellReuseIdentifier:@"YYHomeNewTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];

    
    
    [self httpRequest];
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYInfoDetailViewController *infoDetailVC = [[YYInfoDetailViewController alloc]init];
     YYInfomationModel *infoModel = self.dataSource[indexPath.row];
    infoDetailVC.info_id = infoModel.info_id;
    [self.navigationController pushViewController:infoDetailVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110 *kiphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYInfomationModel *infoModel = self.dataSource[indexPath.row];
    YYHomeNewTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYHomeNewTableViewCell" forIndexPath:indexPath];
    [homeTableViewCell createDetailView:3];
//    homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"cell%ld",(indexPath.row)%2 +1]];
    [homeTableViewCell.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", mPrefixUrl,infoModel.picture]]];
    homeTableViewCell.titleLabel.text = infoModel.title;
    homeTableViewCell.introduceLabel.text = infoModel.smalltitle;
//    homeTableViewCell.backgroundColor = [UIColor cyanColor];
    
    return homeTableViewCell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpRequest{
    [[HttpClient defaultClient]requestWithPath:mHomepageInfoList method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *rowArray = responseObject[@"rows"];
        for (NSDictionary *dict in rowArray){
            YYInfomationModel *infoModel = [YYInfomationModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:infoModel];
        }
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5 *kiphone6)];
        headView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headView;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
