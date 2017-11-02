//
//  YYDetailRecardViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYDetailRecardViewController.h"
#import "YYPersonalTableViewCell.h"
#import "YYPInfomationTableViewCell.h"
#import "RecardDetailModel.h"
#import <MJExtension.h>


@interface YYDetailRecardViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) RecardDetailModel *dataModel;



@property (nonatomic, weak) UILabel *doctorLabel;
@property (nonatomic, weak) UILabel *departmentLabel;   // 科室
@property (nonatomic, weak) UILabel *outpatientLabel;  // 门诊

@end

@implementation YYDetailRecardViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[YYPInfomationTableViewCell class] forCellReuseIdentifier:@"YYPInfomationTableViewCell"];
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
    self.title = @"挂号详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.view.autoresizesSubviews = NO;
    
//    [self httpRequest];
    [self tableView];
    self.tableView.tableFooterView = [self setTableFootView];
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"就诊时间",@"编号",@"患者姓名",@"性别",@"年龄",@"就诊医院",@"就诊科室",@"就诊医生"]]];
    //    self.iconList =@[@[@"18511694068",@"男",@"24"],@[@"黑龙江哈尔滨",@"程序员",@"未婚"],@[@"2016-10-23"]];
    
    
   
    
    // Do any additional setup after loading the view.
}
- (UIView *)setTableFootView{
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 94*kiphone6H)];
    personV.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    UIView *contentView  = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    
    [personV addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.right.offset(-10 *kiphone6);
        make.left.offset(10 *kiphone6);
    }];
    
    return personV;
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *section_row = self.dataSource[section];
    return section_row.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 47*kiphone6H ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 *kiphone6H;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10 *kiphone6H)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPInfomationTableViewCell *infoTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYPInfomationTableViewCell" forIndexPath:indexPath];
    
    infoTableViewCell.titleLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
        if (indexPath.row ==  0) {
            infoTableViewCell.seeRecardLabel.text = self.appointmentModel.visitTimeString;
        }else if (indexPath.row ==  1) {
            infoTableViewCell.seeRecardLabel.text = self.appointmentModel.info_id;

        }else if (indexPath.row ==  2) {
            infoTableViewCell.seeRecardLabel.text = self.appointmentModel.trueName;
            
        }else if (indexPath.row ==  3) {
            if ([self.appointmentModel.gender isEqualToString:@"0"]) {
                infoTableViewCell.seeRecardLabel.text = @"男";
            }else{
                infoTableViewCell.seeRecardLabel.text = @"女";
            }
            
            
        }else if (indexPath.row ==  4) {
            infoTableViewCell.seeRecardLabel.text = self.appointmentModel.age;
            
        }else if (indexPath.row ==  5) {
            infoTableViewCell.seeRecardLabel.text = self.appointmentModel.hospitalName;
        }else if (indexPath.row ==  6) {
        infoTableViewCell.seeRecardLabel.text = self.appointmentModel.clinicName;
        }else if (indexPath.row ==  7) {
        infoTableViewCell.seeRecardLabel.text = self.appointmentModel.physicianTrueName;
        }
    
    return infoTableViewCell;
    
}

#pragma mark -
#pragma mark ------------Http client----------------------

//- (void)httpRequest{
//    NSString *tokenStr = [CcUserModel defaultClient].userToken;
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&id=%@",mAppointmentDetail,tokenStr,self.recardID] method:0 parameters:nil prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
////        NSArray *array = responseObject;
////        NSDictionary *dict = responseObject;
////        self.dataModel = [RecardDetailModel mj_objectWithKeyValues:dict];
////        self.tableView.tableFooterView = [self personInfomation];
//////        [self.tableView reloadData];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
