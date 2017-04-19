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
#import "YYSearchTableViewController.h"
#import "CcUserModel.h"
#import <MJExtension.h>
#import "HttpClient.h"
#import "PatientModel.h"
#import <UIImageView+WebCache.h>
#import "UIButton+Badge.h"
#import "YHPullDownMenu.h"

@interface YYPatientsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) YYHomeUserModel *personalModel;
@property (nonatomic, weak)YHPullDownMenu *pd;




@end

@implementation YYPatientsViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        if ([self.titleStr isEqualToString:@"search"]) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) style:UITableViewStylePlain];
    }
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self httpRequest];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    
    
    
    
    

    // ,@[@"购物车",@"订单详情"] ,@[@"Personal-shopping -icon-",@"order_icon_"]
//    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"电子病例",@"消息",@"家庭用户管理",@"用户设备管理",@"收货地址",@"设置"]]];
//    self.iconList =@[@[@"Personal-EMR-icon-",@"Personal-message-icon-",@"family-icon--1",@"equipment-icon-",@"goods-icon-",@"Set-icon-"]];
    if (self.isTotal) {
        // 右侧搜索按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightButton setFrame:CGRectMake(0,0,20, 20)];
        
        [rightButton setBackgroundImage:[UIImage imageNamed:@"search_normal"] forState:UIControlStateNormal];
        
        [rightButton addTarget:self action:@selector(pushToSearchVC) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        self.navigationItem.rightBarButtonItem = rightItem;
        
        [rightButton sizeToFit];
        
        
//        self.tableView.tableHeaderView = [self personInfomation];
    }
    if (![self.titleStr isEqualToString:@"search"]) {
          [self httpRequestForUserList];
        NSLog(@"执行网路请求123213  %@",self.titleStr);
    }
    
    //    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70 *kiphone6)];
    //    headView.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    //    [headView addSubview:imageV];
    //    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(headView).with.offset(20 *kiphone6);
    //        make.left.equalTo(headView).with.offset(20 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake((kScreenW -40*kiphone6), 30 *kiphone6));
    //    }];
//    self.tableView.tableHeaderView = nil;//[self personInfomation];
  
    
    // [self tableView];
    
    // Do any additional setup after loading the view.
}
//- (void)createMeau{
//    UIView *meauView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 60)];
//    meauView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    [self.view addSubview:meauView];
//    
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.text = @"科室";
//    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    titleLabel.font = [UIFont systemFontOfSize:13];
//    
//    [meauView addSubview:titleLabel];
//    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(meauView).with.offset(0);
//        make.left.equalTo(meauView).with.offset(10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
//    }];
//    
//    UIView *cardView = [[UIView alloc]init];
//    cardView.backgroundColor = [UIColor whiteColor];
//    cardView.layer.shadowColor = [UIColor colorWithHexString:@"d5d5d5"].CGColor;
//    cardView.layer.shadowRadius = 1 *kiphone6;
//    cardView.layer.shadowOffset = CGSizeMake(1, 1);
//    cardView.layer.shadowOpacity = 1;
//    
//    [meauView addSubview:cardView];
//    
//    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(meauView).with.offset(0);
//        make.left.equalTo(titleLabel.mas_right).with.offset(10);
//        make.right.equalTo(meauView).with.offset(-10);
//        make.size.mas_equalTo(CGSizeMake(kScreenW - 60 , 29 ));
//    }];
//    
//    UILabel *nameLabel = [[UILabel alloc]init];
//    nameLabel.text = @"全部";
//    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    nameLabel.font = [UIFont systemFontOfSize:13];
//    
//    [cardView addSubview:nameLabel];
//    
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(cardView).with.offset(0);
//        make.left.equalTo(cardView).with.offset(10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
//    }];
//    
//    UIImageView *imageV = [[UIImageView alloc]init];
//    imageV.image = [UIImage imageNamed:@"展开"];
//    [imageV sizeToFit];
//    
//    [cardView addSubview:imageV];
//    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(cardView).with.offset(0);
//        make.right.equalTo(cardView).with.offset(-10 *kiphone6);
////        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
//    }];
//    
//    
//   
//
//    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
//    [cardView addGestureRecognizer:tapGest];
//}
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
//     NSArray *items = @[@"东方不败", @"步惊云", @"女娲大帝"];
//    YHPullDownMenu *pd=[[YHPullDownMenu alloc]initPullDownMenuWithItems:items cellHeight:35 menuFrame:CGRectMake(50, 10 +108.5 -64, kScreenW -60, 300) clickIndexHandle:^(NSInteger index) {
//        switch (index) {
//            case 0://这个是选中哪一行的时候的输出，或者执行的动作，此处打印相关的信息
//                NSLog(@"selected=东方不败;");
//                break;
//            case 1:
//                NSLog(@"selected=步惊云;");
//                break;
//            case 2:
//                NSLog(@"selected=女娲大帝;");
//                break;
//                
//            default:
//                break;
//        }
//    }];
//    pd.backgroundColor=[UIColor clearColor];
//    self.pd = pd;
//    [self.pd show];
//    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
//    pInfoVC.personalModel = self.personalModel;
//    [self.navigationController pushViewController:pInfoVC animated:YES];
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientModel *patient = self.dataSource[indexPath.row];
    PatientDetailViewController *patientDVC = [[PatientDetailViewController alloc]init];
    patientDVC.info_id = patient.info_id;
    [self.navigationController pushViewController:patientDVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"source count = %ld",self.dataSource.count);
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = self.dataSource.firstObject;
    return self.dataSource.count;
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
//    NSArray *array = self.dataSource[0];
    PatientModel *patient = self.dataSource[indexPath.row];
    homeTableViewCell.titleLabel.text = patient.trueName;
    
    [homeTableViewCell.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,patient.avatar]]];
    
    return homeTableViewCell;
    
}

#pragma mark -
#pragma mark ------------Http client----------------------
//- (void)httpRequest{
//    NSString *tokenStr = [CcUserModel defaultClient].userToken;
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@%@",mMyInfo,tokenStr] method:0 parameters:nil prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"res = = %@",responseObject);
//        NSDictionary *dict = responseObject[@"result"];
//        //        CcUserModel *userMoedel = [CcUserModel mj_objectWithKeyValues:responseObject];
//        YYHomeUserModel *userMoedel = [YYHomeUserModel mj_objectWithKeyValues:dict];
//        
//        
//        NSLog(@"%@",userMoedel.avatar);
//        
//        
//        [self.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,userMoedel.avatar]]];
//        
//        self.nameLabel.text = userMoedel.trueName;
//        self.idLabel.text = [NSString stringWithFormat:@"%@",userMoedel.info_id];
//        self.personalModel = userMoedel;
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}
- (void)pushToSearchVC{
    YYSearchTableViewController *searchVC = [[YYSearchTableViewController alloc]init];
    searchVC.searchCayegory = 1;
    [self.navigationController pushViewController:searchVC animated:true];
}

- (void)httpRequestForUserList{
    NSString *urlStr;
    NSLog(@"%@",self.titleStr);
//    if ([self.titleStr isEqualToString:@"all"]) {
        urlStr = mPatientListTotal;
//    }else{
//        urlStr = mPatientListMine;
//    }
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    if ([self.titleStr isEqualToString:@"search"]) {
        [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&trueName=1",urlStr,userModel.userToken] method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSArray *patientList = responseObject[@"rows"];
            for (NSDictionary *dict in patientList) {
                PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:patientModel];
            }
            [self tableView];
            
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",urlStr,userModel.userToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"123123%@",responseObject);
        NSArray *patientList = responseObject[@"rows"];
        for (NSDictionary *dict in patientList) {
            PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:patientModel];
        }
        [self tableView];


        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.pd removeFromSuperview];
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
