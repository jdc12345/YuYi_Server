//
//  YYNotficationViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYNotficationViewController.h"
#import "UIColor+Extension.h"
#import "YYNotficTableViewCell.h"
//#import "FMActionSheet.h"
//#import "YYAutoMeasureViewController.h"
//#import "YYHandleMeasureViewController.h"
//#import "YYConnectViewController.h"
#import "HttpClient.h"
//#import "YYInfomationModel.h"
#import "CcUserModel.h"
#import <MJExtension.h>
#import "NoyficationModel.h"
#import "NotficationViewController.h"
#import <UIImageView+WebCache.h>
@interface YYNotficationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) FMActionSheet *fmActionS;
@property (nonatomic, assign) NSInteger currentRow;


// 测试数据
@property (nonatomic, copy) NSArray *rowHArray;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *contentArray;
@property (nonatomic, copy) NSArray *iconArray;



@end

@implementation YYNotficationViewController
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_tableView registerClass:[YYNotficTableViewCell class] forCellReuseIdentifier:@"YYNotficTableViewCell"];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息";
    [self httpRequest];
    [self tableView];
    self.rowHArray = @[@"130",@"160",@"130"];
    self.titleArray = @[@"宇医公告",@"血压测量",@"挂号通知"];
    self.contentArray = @[@"更新通知：你已经很久没看我了，最近我又很多好玩的新功能哦，快点来更新吧～",@"测量通知：您当前的测量结果是：高压／109mmHg，低压／74mmHg，血压水平／正常",@"挂号成功：LIM_,2月22日上午，涿州市中医院-呼吸科-李美丽医师，请准时就诊"];
    self.iconArray  = @[@"inform",@"sphygmomanometers",@"registration"];
    
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotficationViewController *notfictVC = [[NotficationViewController alloc]init];
    [self.navigationController pushViewController:notfictVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.dataSource.count);
    if (self.dataSource.count == 0) {
        return 3;
    }
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70 *kiphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYNotficTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYNotficTableViewCell" forIndexPath:indexPath];
    
   
    if (self.dataSource.count == 0) {
        homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
        homeTableViewCell.titleLabel.text = self.titleArray[indexPath.row];
//        homeTableViewCell.introduceLabel.text = self.contentArray[indexPath.row];
    }else{
        NoyficationModel *infoModel = self.dataSource[indexPath.row];
        if ([infoModel.msgType isEqualToString:@"1"]) {
            homeTableViewCell.iconV.image = [UIImage imageNamed:@"inform"];
            homeTableViewCell.titleLabel.text = @"宇医公告";
        }else{
            [homeTableViewCell.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,infoModel.avatar]]];
            homeTableViewCell.titleLabel.text = infoModel.title;
        }
        homeTableViewCell.seeRecardLabel.text = infoModel.content;
    }
    
    //    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    //    homeTableViewCell.titleLabel.text = self.titleArray[indexPath.row];
    
    
    
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    
    return homeTableViewCell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpRequest{
    
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@%@&start=0&limit=10",mMessages,[CcUserModel defaultClient].userToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *rowArray = responseObject[@"rows"];
        for (NSDictionary *dict in rowArray){
            NoyficationModel *infoModel = [NoyficationModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:infoModel];
        }
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 0 *kiphone6)];
        headView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headView;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
