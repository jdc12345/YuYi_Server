//
//  YYAutoMeasureViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYAutoMeasureViewController.h"
#import "YYCardView.h"
#import "UIColor+Extension.h"
#import <Masonry.h>
//#import "YYMeasureTableViewCell.h"
#import "YYMemberTableViewCell.h"
#import "HttpClient.h"

#import "HttpClient.h"
#import "CcUserModel.h"
#import "YYHomeUserModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>

@interface YYAutoMeasureViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *memberView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) YYCardView *cardView1;
@property (nonatomic, weak) YYCardView *cardView2;
@property (nonatomic, assign) NSInteger currentUser;
@end

@implementation YYAutoMeasureViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40*kiphone6, kScreenW, self.memberView.frame.size.height -90 *kiphone6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.indicatorStyle =
//        _tableView.rowHeight = kScreenW *77/320.0 +10;
//        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_tableView registerClass:[YYMemberTableViewCell class] forCellReuseIdentifier:@"YYMemberTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.memberView addSubview:_tableView];
        // [self.memberView sendSubviewToBack:_tableView];
        self.currentUser = 0;
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.title = self.navTitle;
    [self httpRequestForUser];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)createOtherView{
    
    CGFloat cardH;
    YYCardView *card = [[YYCardView alloc]initWithFrame:CGRectMake(10 *kiphone6, (64 +10) *kiphone6, kScreenW - 20 *kiphone6, 100 *kiphone6)];
    self.cardView1 = card;
    if ([self.navTitle isEqualToString:@"当前体温"]) {
        card.titleLabel.text = @"体温";
        card.dataLabel.text = @"38℃";
    }else{
        card.titleLabel.text = @"收缩压（高压）";
        card.dataLabel.text = @"110";
    }
    
    if ([self.navTitle isEqualToString:@"当前血压"]) {
        YYCardView *cardView = [[YYCardView alloc]initWithFrame:CGRectMake(10 *kiphone6, CGRectGetMaxY(card.frame) +10 *kiphone6, kScreenW - 20 *kiphone6, 100 *kiphone6)];
        cardView.titleLabel.text = @"舒张压（低压）";
        cardView.dataLabel.text = @"90";
        self.cardView2 = cardView;
        [self.view addSubview:cardView];
        
        cardH = CGRectGetMaxY(cardView.frame);
        
    }else{
        
        UILabel *promptLabel= [[UILabel alloc]initWithFrame:CGRectMake(25 *kiphone6 ,CGRectGetMaxY(card.frame) +9 *kiphone6, kScreenW, 12)];
        promptLabel.text = @"*当前体温偏高请尽快就医";
        promptLabel.textColor = [UIColor colorWithHexString:@"e80000"];
        promptLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:promptLabel];
        
        
        cardH = CGRectGetMaxY(card.frame);

    }
    
    [self.view addSubview:card];
    
    
    self.memberView  = [[UIView alloc] initWithFrame:CGRectMake(0, cardH + 30 *kiphone6, kScreenW, kScreenH - cardH - 30*kiphone6)];
    self.memberView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.memberView];
    [self createMemberView];
}

- (void)createMemberView{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 *kiphone6, 0, kScreenW, 40 *kiphone6)];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.textColor = [UIColor colorWithHexString:@"333333"];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.text = @"数据录入";
    [self.memberView addSubview:headerLabel];
    
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    UIButton *sureBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 1.5 *kiphone6;
    sureBtn.layer.borderWidth = 0.5 *kiphone6;
    sureBtn.layer.borderColor = [UIColor colorWithHexString:@"25f368"].CGColor;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [sureBtn setTintColor:[UIColor colorWithHexString:@"25f368"]];
    [sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [sureBtn addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.memberView addSubview:sureBtn];
    [self.memberView addSubview:lineL];
    
    
    WS(ws);
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.memberView).with.offset(-9.5 *kiphone6);
        make.centerX.equalTo(ws.memberView);
        make.size.mas_equalTo(CGSizeMake(100 *kiphone6 ,30 *kiphone6));
    }];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.memberView).with.offset(-49 *kiphone6);
        make.centerX.equalTo(ws.memberView);
        make.size.mas_equalTo(CGSizeMake(kScreenW *kiphone6 ,1 *kiphone6));
    }];
    [self tableView];
    
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60 *kiphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YYMemberTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYMemberTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 3) {
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"add-1"];
        homeTableViewCell.titleLabel.text = @"添加其他成员";
        homeTableViewCell.titleLabel.textColor = [UIColor colorWithHexString:@"c7c5c5"];
    }else{
        homeTableViewCell.titleLabel.highlightedTextColor = [UIColor whiteColor];
        homeTableViewCell.selectedBackgroundView = [[UIView alloc] initWithFrame:homeTableViewCell.frame] ;
        homeTableViewCell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        
        YYHomeUserModel *homeUser = self.dataSource[indexPath.row];
        homeTableViewCell.titleLabel.text = homeUser.trueName;
        [homeTableViewCell.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,homeUser.avatar]]];
    }
    return homeTableViewCell;

}

-(void)buttonClick:(UIButton *)button{
    [button setBackgroundColor:[UIColor colorWithHexString:@"25f368"]];
}
-(void)buttonClick1:(UIButton *)button{
    [button setBackgroundColor:[UIColor whiteColor]];
    [self httpRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)httpRequest{
    NSString *urlStr ;
    NSDictionary *parametersDict;
    
    // token
    NSString *usertoken = [CcUserModel defaultClient].userToken;
    // humeuserId
    NSInteger current = self.currentUser;
    YYHomeUserModel *homeUser = self.dataSource[current];
    NSLog(@"%@,%@,%@,%@",usertoken,homeUser.info_id,self.cardView1.dataLabel.text,self.cardView2.dataLabel.text);
    
    if ([self.navTitle isEqualToString:@"当前血压"]) {
        urlStr = mBloodpressure;
        parametersDict = @{@"token":usertoken,
                           @"humeuserId":homeUser.info_id,
                           @"systolic":self.cardView1.dataLabel.text,
                           @"diastolic":self.cardView2.dataLabel.text
                           };
    }else{
        urlStr = mTemperature;
        parametersDict = @{@"token":usertoken,
                           @"humeuserId":homeUser.info_id,
                           @"temperaturet":self.cardView1.dataLabel.text
                           };
    }
    
    
    NSLog(@"参数：　%@",parametersDict);
    
    [[HttpClient defaultClient]requestWithPath:urlStr method:1 parameters:parametersDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)httpRequestForUser{
    NSString *userToken = [CcUserModel defaultClient].userToken;
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@%@",mHomeusers,userToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"homeUsers = %@",responseObject);
        NSArray *usersList = responseObject[@"result"];
        for (NSDictionary *dict in usersList) {
            YYHomeUserModel *homeUser = [YYHomeUserModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:homeUser];
            [self createOtherView];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
