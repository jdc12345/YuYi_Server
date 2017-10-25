//
//  YYPatientsViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPatientsViewController.h"
#import "YYHomeNewTableViewCell.h"
#import "PatientsTableViewCell.h"
#import "YYSettingViewController.h"
#import "NotficationViewController.h"
#import <UIImageView+WebCache.h>
#import "YYHomeUserModel.h"
#import "PatientDetailViewController.h"
#import "YYSearchTableViewController.h"
#import <MJExtension.h>
#import "PatientModel.h"
#import <UIImageView+WebCache.h>
#import "UIButton+Badge.h"
#import "YHPullDownMenu.h"
#import <MJRefresh.h>

static NSInteger start = 0;
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
//        if ([self.titleStr isEqualToString:@"search"]) {
//            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64) style:UITableViewStylePlain];
//        }else{
//            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) style:UITableViewStylePlain];
//    }
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[PatientsTableViewCell class] forCellReuseIdentifier:@"PatientsTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        if (self.searchTrueName.length > 0) {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.offset(0);
            }];
        }else{
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(64);
                make.left.right.bottom.offset(0);
            }];
        }
        
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
    [self httpRequestForUserList];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *urlStr;
        if ([weakSelf.titleStr isEqualToString:@"search"]) {//从个人功能部分查看数据跳转过来
            if (weakSelf.searchTrueName.length > 0) {
                NSString *searchName = [self.searchTrueName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                urlStr = [NSString stringWithFormat:@"%@token=%@&trueName=%@&start=0&limit=6",mPatientListTotal,mDefineToken,searchName];
            }else{
                urlStr = [NSString stringWithFormat:@"%@token=%@&start=0&limit=6",mPatientListTotal,mDefineToken];
            }
            
        }else{//患者功能模块
            urlStr = mPatientListMine;
        }
        
        if ([weakSelf.titleStr isEqualToString:@"search"]) {
            
            [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf.dataSource removeAllObjects];
                NSLog(@"%@",responseObject);
                NSArray *patientList = responseObject[@"rows"];
                if (patientList.count > 0) {
                    for (NSDictionary *dict in patientList) {
                        PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                        [weakSelf.dataSource addObject:patientModel];
                    }
                    start = weakSelf.dataSource.count;
                    [weakSelf.tableView reloadData];
                    if (patientList.count < 6) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    EmptyDataView *emptyView =[[EmptyDataView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) AndImageStr:@"没有消息"];
                    [weakSelf.view addSubview:emptyView];
                }
                [weakSelf.tableView.mj_header endRefreshing];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        }else{
            [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&start=0&limit=6",urlStr,mDefineToken] method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [weakSelf.dataSource removeAllObjects];
                NSArray *patientList = responseObject[@"rows"];
                if (patientList.count > 0) {
                    for (NSDictionary *dict in patientList) {
                        PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                        [weakSelf.dataSource addObject:patientModel];
                    }
                    start = weakSelf.dataSource.count;
                    [weakSelf.tableView reloadData];
                    if (patientList.count < 6) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    EmptyDataView *emptyView =[[EmptyDataView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) AndImageStr:@"没有消息"];
                    [weakSelf.view addSubview:emptyView];
                }
                [weakSelf.tableView.mj_header endRefreshing];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                [weakSelf.tableView.mj_header endRefreshing];
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }];
        }

        }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入加载状态后会自动调用这个block
        if (weakSelf.dataSource.count==0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        if (start % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSString *urlStr;
        if ([weakSelf.titleStr isEqualToString:@"search"]) {//从个人功能部分查看数据跳转过来
            if (weakSelf.searchTrueName.length > 0) {
                NSString *searchName = [self.searchTrueName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                urlStr = [NSString stringWithFormat:@"%@token=%@&trueName=%@&start=%ld&limit=6",mPatientListTotal,mDefineToken,searchName,start];
            }else{
                urlStr = [NSString stringWithFormat:@"%@token=%@&start=%ld&limit=6",mPatientListTotal,mDefineToken,start];
            }
            
        }else{//患者功能模块
            urlStr = mPatientListMine;
        }
        
        if ([weakSelf.titleStr isEqualToString:@"search"]) {
            
            [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"%@",responseObject);
                NSArray *patientList = responseObject[@"rows"];
                if (patientList.count > 0) {
                    for (NSDictionary *dict in patientList) {
                        PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                        [weakSelf.dataSource addObject:patientModel];
                    }
                    start = weakSelf.dataSource.count;
                    [weakSelf.tableView reloadData];
                    if (start % 6 != 0) {//显示没有更多数据了
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [weakSelf.tableView.mj_footer endRefreshing];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                [weakSelf.tableView.mj_footer endRefreshing];
            }];
        }else{
            [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&start=%ld&limit=6",urlStr,mDefineToken,start] method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                NSArray *patientList = responseObject[@"rows"];
                if (patientList.count > 0) {
                    for (NSDictionary *dict in patientList) {
                        PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                        [weakSelf.dataSource addObject:patientModel];
                    }
                    start = weakSelf.dataSource.count;
                    [weakSelf.tableView reloadData];
                    if (start % 6 != 0) {//显示没有更多数据了
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [weakSelf.tableView.mj_footer endRefreshing];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                [weakSelf.tableView.mj_footer endRefreshing];
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }];
        }

    }];

//    if (![self.titleStr isEqualToString:@"search"]) {
//          [self httpRequestForUserList];
//        NSLog(@"执行网路请求123213  %@",self.titleStr);
//    }
    
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
    patientDVC.patientModel = patient;
    [self.navigationController pushViewController:patientDVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"source count = %ld",self.dataSource.count);
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = self.dataSource.firstObject;
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83 *kiphone6H;
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
    [SVProgressHUD showWithStatus:@"Loading..."];
    if ([self.titleStr isEqualToString:@"search"]) {//从个人功能部分查看数据跳转过来
        if (self.searchTrueName.length > 0) {//搜索跳转
            NSString *searchName = [self.searchTrueName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            urlStr = [NSString stringWithFormat:@"%@token=%@&trueName=%@&start=0&limit=6",mPatientListTotal,mDefineToken,searchName];
        }else{//查看数据
            urlStr = [NSString stringWithFormat:@"%@token=%@&start=0&limit=6",mPatientListTotal,mDefineToken];
        }
        
    }else{//患者功能模块
        urlStr = mPatientListMine;
    }
    
    if ([self.titleStr isEqualToString:@"search"]) {
        
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSArray *patientList = responseObject[@"rows"];
            if (patientList.count > 0) {
            for (NSDictionary *dict in patientList) {
                PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:patientModel];
            }
                start = self.dataSource.count;
            [self.tableView reloadData];
                if (start % 6 != 0) {//显示没有更多数据了
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }

        }else{
            EmptyDataView *emptyView =[[EmptyDataView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) AndImageStr:@"没有消息"];
            [self.view addSubview:emptyView];
        }
            [SVProgressHUD dismiss];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            
        }];
    }else{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&start=0&limit=6",urlStr,mDefineToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *patientList = responseObject[@"rows"];
        if (patientList.count > 0) {
            for (NSDictionary *dict in patientList) {
                PatientModel *patientModel = [PatientModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:patientModel];
            }
            start = self.dataSource.count;
            [self.tableView reloadData];
            if (start % 6 != 0) {//显示没有更多数据了
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            EmptyDataView *emptyView =[[EmptyDataView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) AndImageStr:@"没有消息"];
            [self.view addSubview:emptyView];
        }
        [SVProgressHUD dismiss];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.pd removeFromSuperview];
    [SVProgressHUD dismiss];
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
