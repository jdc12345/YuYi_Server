//
//  ReciveAppointmentViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "ReciveAppointmentViewController.h"
#import "UIColor+Extension.h"
#import "YYHomeNewTableViewCell.h"
#import <Masonry.h>
#import "YYRecardTableViewCell.h"
#import "YYDetailRecardViewController.h"
#import "HttpClient.h"
#import "CcUserModel.h"
#import "RecardModel.h"
#import <MJExtension.h>
#import "YHPullDownMenu.h"
@interface ReciveAppointmentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation ReciveAppointmentViewController


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 +60, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        // _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[YYRecardTableViewCell class] forCellReuseIdentifier:@"YYRecardTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        
        [self createMeau];
        // [self.view sendSubviewToBack:_tableView];
        
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
    self.title = @"挂号接收";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@"2016-01-05",@"2016-06-06",@"2016-07-08",@"2016-09-08"]];
    //    self.iconList =@[@"Personal-EMR-icon-",@"Personal-message-icon-",@"Personal-shopping -icon-",@"order_icon_",@"family-icon--1",@"equipment-icon-",@"goods-icon-",@"Set-icon-"];
    
    
    //    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70 *kiphone6)];
    //    headView.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    //    [headView addSubview:imageV];
    //    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(headView).with.offset(20 *kiphone6);
    //        make.left.equalTo(headView).with.offset(20 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake((kScreenW -40*kiphone6), 30 *kiphone6));
    //    }];
    //   self.tableView.tableHeaderView = [self personInfomation];
//    [self httpRequest];
    [self tableView];

    
    // Do any additional setup after loading the view.
}
- (void)createMeau{
    UIView *meauView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 60)];
    meauView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:meauView];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"科室";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:13];

    [meauView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(meauView).with.offset(0);
        make.left.equalTo(meauView).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
    }];

    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.shadowColor = [UIColor colorWithHexString:@"d5d5d5"].CGColor;
    cardView.layer.shadowRadius = 1 *kiphone6;
    cardView.layer.shadowOffset = CGSizeMake(1, 1);
    cardView.layer.shadowOpacity = 1;

    [meauView addSubview:cardView];

    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(meauView).with.offset(0);
        make.left.equalTo(titleLabel.mas_right).with.offset(10);
        make.right.equalTo(meauView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 60 , 29 ));
    }];

    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"全部";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel = nameLabel;
    [cardView addSubview:nameLabel];

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView).with.offset(0);
        make.left.equalTo(cardView).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(100 , 13 ));
    }];

    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"展开"];
    [imageV sizeToFit];

    [cardView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView).with.offset(0);
        make.right.equalTo(cardView).with.offset(-10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
    }];




    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
    [cardView addGestureRecognizer:tapGest];
}

- (UIView *)personInfomation{
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 90 *kiphone6)];
    personV.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    [personV addSubview:headerView];
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LIM_"]];
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
    
    return personV;
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    RecardModel *recardModel = self.dataSource[indexPath.row];
    YYDetailRecardViewController *detailRecardVC = [[YYDetailRecardViewController alloc]init];
//    detailRecardVC.recardID = recardModel.info_id;
    [self.navigationController pushViewController:detailRecardVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count >0) {
        return self.dataSource.count;
    }else{
        return 2;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70 *kiphone6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0 *kiphone6;
}

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
//    WS(ws);
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
    YYRecardTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYRecardTableViewCell" forIndexPath:indexPath];
    if (self.dataSource.count >0) {
        RecardModel *recardModel = self.dataSource[indexPath.row];
        homeTableViewCell.titleLabel.text = [recardModel.createTimeString componentsSeparatedByString:@" "].firstObject;
    }else{
        homeTableViewCell.titleLabel.text = @"张三";
        homeTableViewCell.seeRecardLabel.text = @"挂号时间：2017-03-12 09:40";
    }
   //recardModel.createTimeString;
    //    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    
    return homeTableViewCell;
    
}
- (void)headViewClick{
    NSLog(@"123");
    NSArray *items = @[@"东方不败", @"步惊云", @"女娲大帝"];
    YHPullDownMenu *pd=[[YHPullDownMenu alloc]initPullDownMenuWithItems:items cellHeight:30 menuFrame:CGRectMake(50, 10 +108.5, kScreenW -60, 300) clickIndexHandle:^(NSInteger index) {
        switch (index) {
            case 0://这个是选中哪一行的时候的输出，或者执行的动作，此处打印相关的信息
                NSLog(@"selected=东方不败;");
                self.nameLabel.text = items[0];
                break;
            case 1:
                NSLog(@"selected=步惊云;");
                self.nameLabel.text = items[1];
                break;
            case 2:
                NSLog(@"selected=女娲大帝;");
                self.nameLabel.text = items[2];
                break;
                
            default:
                break;
        }
    }];
    pd.backgroundColor=[UIColor clearColor];
    [pd show];
    //    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
    //    pInfoVC.personalModel = self.personalModel;
    //    [self.navigationController pushViewController:pInfoVC animated:YES];
}

#pragma mark -
#pragma mark ------------Http client----------------------

- (void)httpRequest{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mMedicalToken,[CcUserModel defaultClient].userToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *rowArray = responseObject[@"result"];
        NSLog(@"%@",responseObject);
        for (NSDictionary *dict in rowArray) {
            
            RecardModel *recardModel = [RecardModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:recardModel];
        }
        if (self.dataSource.count != 0) {
            [self tableView];
        }
        
        //        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
