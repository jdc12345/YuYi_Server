//
//  YYPatientsViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPatientsViewController.h"
#import "UIColor+Extension.h"
#import "YYHomeNewTableViewCell.h"
#import <Masonry.h>
#import "PatientsTableViewCell.h"
#import "YYSettingViewController.h"
#import "NotficationViewController.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "YYHomeUserModel.h"
#import "PatientDetailViewController.h"

@interface YYPatientsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) YYHomeUserModel *personalModel;

@end

@implementation YYPatientsViewController

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
        [_tableView registerClass:[PatientsTableViewCell class] forCellReuseIdentifier:@"PatientsTableViewCell"];
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
    self.title = @"患者";
    //    [self httpRequest];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    // ,@[@"购物车",@"订单详情"] ,@[@"Personal-shopping -icon-",@"order_icon_"]
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"电子病例",@"消息",@"家庭用户管理",@"用户设备管理",@"收货地址",@"设置"]]];
    self.iconList =@[@[@"Personal-EMR-icon-",@"Personal-message-icon-",@"family-icon--1",@"equipment-icon-",@"goods-icon-",@"Set-icon-"]];
    
    
    //    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70 *kiphone6)];
    //    headView.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    //    [headView addSubview:imageV];
    //    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(headView).with.offset(20 *kiphone6);
    //        make.left.equalTo(headView).with.offset(20 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake((kScreenW -40*kiphone6), 30 *kiphone6));
    //    }];
    self.tableView.tableHeaderView = nil;//[self personInfomation];
    
    // [self tableView];
    
    // Do any additional setup after loading the view.
}
- (UIView *)personInfomation{
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 90 *kiphone6)];
    personV.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
    [personV addGestureRecognizer:tapGest];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    [personV addSubview:headerView];
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconV.layer.cornerRadius = 25;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"李美丽";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    //
    UILabel *idName = [[UILabel alloc]init];
    idName.text = @"用户：18328887563";
    idName.textColor = [UIColor colorWithHexString:@"333333"];
    idName.font = [UIFont systemFontOfSize:13];
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:idName];
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV).with.offset(10);
        make.left.equalTo(personV).with.offset(25 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(50 *kiphone6, 50 *kiphone6));
    }];
    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV).with.offset(31.5 *kiphone6);
        make.left.equalTo(iconV.mas_right).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(140 *kiphone6, 14 *kiphone6));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10 *kiphone6);
        make.left.equalTo(nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(260 *kiphone6, 13 *kiphone6));
    }];
    
    self.nameLabel = nameLabel;
    self.idLabel = idName;
    self.iconV = iconV;
    
    return personV;
}
- (void)headViewClick{
    NSLog(@"123");
//    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
//    pInfoVC.personalModel = self.personalModel;
//    [self.navigationController pushViewController:pInfoVC animated:YES];
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientDetailViewController *patientDVC = [[PatientDetailViewController alloc]init];
    [self.navigationController pushViewController:patientDVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataSource.firstObject;
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60 *kiphone6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    return headerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientsTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PatientsTableViewCell" forIndexPath:indexPath];
    NSArray *array = self.dataSource[0];
    homeTableViewCell.titleLabel.text = array[indexPath.row];
//    homeTableViewCell.iconV.image = array[indexPath.row];
    
    return homeTableViewCell;
    
}

#pragma mark -
#pragma mark ------------Http client----------------------
- (void)httpRequest{
    NSString *tokenStr = [CcUserModel defaultClient].userToken;
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@%@",mMyInfo,tokenStr] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"res = = %@",responseObject);
        NSDictionary *dict = responseObject[@"result"];
        //        CcUserModel *userMoedel = [CcUserModel mj_objectWithKeyValues:responseObject];
        YYHomeUserModel *userMoedel = [YYHomeUserModel mj_objectWithKeyValues:dict];
        
        
        NSLog(@"%@",userMoedel.avatar);
        
        
        [self.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,userMoedel.avatar]]];
        
        self.nameLabel.text = userMoedel.trueName;
        self.idLabel.text = [NSString stringWithFormat:@"%@",userMoedel.info_id];
        self.personalModel = userMoedel;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    [self httpRequest];
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
