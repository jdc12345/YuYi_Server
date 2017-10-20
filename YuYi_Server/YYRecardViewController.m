//
//  YYRecardViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYRecardViewController.h"
//#import "YYHomeNewTableViewCell.h"
//#import "YYSectionViewController.h"
//#import "YYPersonalTableViewCell.h"
//#import "YYRecardTableViewCell.h"
//#import "YYDetailRecardViewController.h"
//#import "RecardModel.h"
#import <MJExtension.h>
#import "YYPatientRecordModel.h"
#import "YYPatientRecordTVCell.h"
#import "YYRecordDetailVC.h"

@interface YYRecardViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *iconList;


@end

@implementation YYRecardViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        // _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[YYPatientRecordTVCell class] forCellReuseIdentifier:@"YYPatientRecordTVCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        // [self.view sendSubviewToBack:_tableView];
        
    }
    return _tableView;
}
-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self.tableView reloadData];
}
//- (NSMutableArray *)dataSource{
//    if (_dataSource == nil) {
//        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
//    }
//    return _dataSource;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子病例";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self httpRequest];

}


#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPatientRecordModel *recardModel = self.dataSource[indexPath.row];
    YYRecordDetailVC *detailRecardVC = [[YYRecordDetailVC alloc]init];
    detailRecardVC.model = recardModel;
    [self.navigationController pushViewController:detailRecardVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85 *kiphone6H;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50 *kiphone6;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    RecardModel *recardModel = self.dataSource[0];
//    
//    
//    UIView *allHeadSectionV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50 *kiphone6)];
//    allHeadSectionV.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 40 *kiphone6)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    UILabel *nameLabel = [[UILabel alloc]init];
//    nameLabel.text = [NSString stringWithFormat:@"%@的病例",recardModel.persinalId];
//    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    nameLabel.font = [UIFont systemFontOfSize:15];
//    
//    
//    [headerView addSubview:nameLabel];
//
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(headerView);
//        make.left.equalTo(headerView).with.offset(10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(kScreenW ,15));
//    }];
//    
//    [allHeadSectionV addSubview:headerView];
//    return allHeadSectionV;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPatientRecordTVCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYPatientRecordTVCell" forIndexPath:indexPath];
    YYPatientRecordModel *recardModel = self.dataSource[indexPath.row];
    homeTableViewCell.model = recardModel;
   
    return homeTableViewCell;
    
}

#pragma mark -
#pragma mark ------------Http client----------------------

//- (void)httpRequest{
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mMedicalToken,[CcUserModel defaultClient].userToken] method:0 parameters:nil prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSArray *rowArray = responseObject[@"result"];
//        NSLog(@"%@",responseObject);
//        for (NSDictionary *dict in rowArray) {
//        
//            RecardModel *recardModel = [RecardModel mj_objectWithKeyValues:dict];
//            [self.dataSource addObject:recardModel];
//        }
//        if (self.dataSource.count != 0) {
//            [self tableView];
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}

@end
