//
//  YYPersonalViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPersonalViewController.h"
#import "UIColor+Extension.h"
#import "YYHomeNewTableViewCell.h"
#import <Masonry.h>
// #import "YYSectionViewController.h"
#import "YYPersonalTableViewCell.h"
// #import "NotficationViewController.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "YYHomeUserModel.h"
#import "InvitationViewController.h"
#import "AgreeViewController.h"
#import "ConsultViewController.h"
#import "CheckDataViewController.h"
#import "ReciveAppointmentViewController.h"
#import "YYSettingViewController.h"
#import "NotficationViewController.h"
#import "UIBarButtonItem+Helper.h"


#define myToken @"6DD620E22A92AB0AED590DB66F84D064"
@interface YYPersonalViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) YYHomeUserModel *personalModel;

@end

@implementation YYPersonalViewController

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
        [_tableView registerClass:[YYPersonalTableViewCell class] forCellReuseIdentifier:@"YYPersonalTableViewCell"];
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
    //    [self httpRequest];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // ,@[@"购物车",@"订单详情"] ,@[@"Personal-shopping -icon-",@"order_icon_"]
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"我的帖子",@"我的点赞"],@[@"咨询",@"查看数据",@"挂号接收"]]];
    self.iconList =@[@[@"Personal-EMR-icon-",@"Personal-message-icon-"],@[@"family-icon--1",@"equipment-icon-"],@[@"goods-icon-",@"Set-icon-"]];
    
    
    self.navigationItem. leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" normalColor:[UIColor colorWithHexString:@"25f368"] highlightedColor:[UIColor colorWithHexString:@"25f368"] target:self action:@selector(pushSettingVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"消息" normalColor:[UIColor colorWithHexString:@"25f368"] highlightedColor:[UIColor colorWithHexString:@"25f368"] target:self action:@selector(pushNotficVC)];
    //    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70 *kiphone6)];
    //    headView.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    //    [headView addSubview:imageV];
    //    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(headView).with.offset(20 *kiphone6);
    //        make.left.equalTo(headView).with.offset(20 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake((kScreenW -40*kiphone6), 30 *kiphone6));
    //    }];
    self.tableView.tableHeaderView = [self personInfomation];
    
    // [self tableView];
    
    // Do any additional setup after loading the view.
}
- (UIView *)personInfomation{
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 170 *kiphone6)];
    personV.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
    [personV addGestureRecognizer:tapGest];
    
    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
//    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    
//    [personV addSubview:headerView];
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconV.layer.cornerRadius = 32.5 *kiphone6;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"赵启平  主任医师";
    nameLabel.textColor = [UIColor colorWithHexString:@"6a6a6a"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //
    UILabel *idName = [[UILabel alloc]init];
    idName.text = @"涿州市中医院  检验科";
    idName.textColor = [UIColor colorWithHexString:@"6a6a6a"];
    idName.font = [UIFont systemFontOfSize:12];
    idName.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.backgroundColor = [UIColor cyanColor];
    [settingBtn addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *notficVC = [UIButton buttonWithType:UIButtonTypeCustom];
    notficVC.backgroundColor = [UIColor cyanColor];
    [notficVC addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:idName];
    
    [personV addSubview:settingBtn];
    [personV addSubview:notficVC];
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV).with.offset(35);
        make.centerX.equalTo(personV);
        make.size.mas_equalTo(CGSizeMake(65 *kiphone6, 65 *kiphone6));
    }];
//    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(personV).with.offset(15);
//        make.top.equalTo(personV).with.offset(35);
//        make.size.mas_equalTo(CGSizeMake(20 *kiphone6, 20 *kiphone6));
//    }];
//    [notficVC mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(personV).with.offset(35);
//        make.right.equalTo(personV).with.offset(-15);
//        make.size.mas_equalTo(CGSizeMake(20 *kiphone6, 20 *kiphone6));
//    }];
    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconV.mas_bottom).with.offset(15 *kiphone6);
        make.left.equalTo(personV).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14 *kiphone6));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10 *kiphone6);
        make.left.equalTo(personV).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14 *kiphone6));;
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
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[InvitationViewController alloc]init] animated:YES];
        }else{
            AgreeViewController *shopVC = [[AgreeViewController alloc]init];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            ConsultViewController *familyVC = [[ConsultViewController alloc]init];
            [self.navigationController pushViewController:familyVC animated:YES];
        }else if(indexPath.row == 1){
            CheckDataViewController *equipmentVC = [[CheckDataViewController alloc]init];
            [self.navigationController pushViewController:equipmentVC animated:YES];
        }else{
            ReciveAppointmentViewController *equipmentVC = [[ReciveAppointmentViewController alloc]init];
            [self.navigationController pushViewController:equipmentVC animated:YES];
        }

    
    
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataSource[section];
    return list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56.5 *kiphone6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    return headerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPersonalTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYPersonalTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.section][indexPath.row];
//    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.section][indexPath.row]];
    
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
//防止导航栏设置影响其他页面
-(void)viewWillAppear:(BOOL)animated{
    //把导航栏变透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.translucent = true;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    //    self.navigationController.navigationBar.translucent = false;
}
- (void)pushSettingVC{
    NSLog(@"123");
    [self.navigationController pushViewController:[[YYSettingViewController alloc]init] animated:YES];
}
- (void)pushNotficVC{
    NSLog(@"435");
    [self.navigationController pushViewController:[[NotficationViewController alloc]init] animated:YES];
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
