//
//  YYPersonalViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPersonalViewController.h"
#import "YYHomeNewTableViewCell.h"
#import "YYPersonalTableViewCell.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "YYHomeUserModel.h"
#import "InvitationViewController.h"
#import "AgreeViewController.h"
#import "YYChatListViewController.h"
#import "YYPatientsViewController.h"
#import "ReciveAppointmentViewController.h"
#import "YYSettingViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "UIButton+Badge.h"
#import "YYNoticeListVC.h"
#import "YYPInfomartionViewController.h"
#import "AppDelegate.h"

//#define myToken @"6DD620E22A92AB0AED590DB66F84D064"
@interface YYPersonalViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) YYHomeUserModel *personalModel;

@property (nonatomic, weak) UIButton *rightNotBtn;

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
    [self httpRequest];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    if (@available(iOS 11.0, *)) {
//        如果你的APP中使用的是自定义的navigationbar，隐藏掉系统的navigationbar，并且tableView的frame为(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)开始，那么系统会自动调整SafeAreaInsets值为(20,0,0,0)，如果使用了系统的navigationbar，那么SafeAreaInsets值为(64,0,0,0)，如果也使用了系统的tabbar，那么SafeAreaInsets值为(64,0,49,0)
//        即使把navigationbar设置为透明的，系统也认为安全区域是从navigationbar的bottom开始的,想要从导航栏左上角开始需要添加下边的代码,作用是计算tableview的adjustContentInset（表示contentView.frame.origin偏移了scrollview.frame.origin多少；是系统计算得来的，计算方式由contentInsetAdjustmentBehavior决定）
        NSLog(@"----------safeAreaInsets--------------->top:%f,botoom:%f",self.view.safeAreaInsets.top,self.view.safeAreaInsets.bottom);
        NSLog(@"----------adjustedContentInset--------------->top:%f,botoom:%f",self.tableView.adjustedContentInset.top,self.tableView.adjustedContentInset.bottom);
        NSLog(@"-----------contentInset-------------->top:%f,botoom:%f",self.tableView.contentInset.top,self.tableView.contentInset.bottom);
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    只有到两个属性都设置成可以延伸时，页面起始点才会从状态栏也就是屏幕最左上角开始
//    延伸视图包含不包含不透明的Bar,是用来指定导航栏是透明的还是不透明
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    从导航栏左上角开始计算起始点
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    CcUserModel *ccuserModel = [CcUserModel defaultClient];
    if(![ccuserModel.telephoneNum isEqualToString:@"18511694068"]){
        self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"我的帖子",@"我的点赞"],@[@"咨询",@"查看数据",@"挂号接收"]]];}
    else{
        self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"我的帖子",@"我的点赞"]]];
    }
//    self.iconList =@[@[@"Personal-EMR-icon-",@"Personal-message-icon-"],@[@"family-icon--1",@"equipment-icon-"],@[@"goods-icon-",@"Set-icon-"]];    
    
    // 左侧地址按钮   测
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setFrame:CGRectMake(0,0,20, 20)];
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftButton sizeToFit];
    
    // 右侧通知按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0,0,20, 20)];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"notfiy_select"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(pushNotficVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton sizeToFit];
    
    self.rightNotBtn = rightButton;

    self.tableView.tableHeaderView = [self personInfomation];
    
    // [self tableView];
    
    // Do any additional setup after loading the view.
}
- (UIView *)personInfomation{
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 225 *kiphone6H)];
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"2feaeb"].CGColor, (__bridge id)[UIColor colorWithHexString:@"1ebeec"].CGColor];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenW, 225 *kiphone6H);
    [personV.layer insertSublayer:gradientLayer atIndex:0];
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconV.layer.cornerRadius = 40 *kiphone6;
    iconV.clipsToBounds = true;
    iconV.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
    [iconV addGestureRecognizer:tapGest];

    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"医生  职级";
    nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //
    UILabel *idName = [[UILabel alloc]init];
    idName.text = @"医院  科室";
    idName.textColor = [UIColor colorWithHexString:@"ffffff"];
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
        make.top.offset(64);
        make.centerX.equalTo(personV);
        make.size.mas_equalTo(CGSizeMake(80 *kiphone6, 80 *kiphone6));
    }];

    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconV.mas_bottom).offset(12.5 *kiphone6);
        make.centerX.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenW, 14 *kiphone6));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10 *kiphone6);
        make.centerX.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenW, 14 *kiphone6));;
    }];
    
    self.nameLabel = nameLabel;
    self.idLabel = idName;
    self.iconV = iconV;
    
    return personV;
}
- (void)headViewClick{
    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
    pInfoVC.personalModel = self.personalModel;
    [self.navigationController pushViewController:pInfoVC animated:YES];
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            InvitationViewController *myVC = [[InvitationViewController alloc]init];
            myVC.titleStr = @"我的帖子";
            [self.navigationController pushViewController:myVC animated:YES];
        }else{
//            AgreeViewController *shopVC = [[AgreeViewController alloc]init];
//            [self.navigationController pushViewController:shopVC animated:YES];
            InvitationViewController *myVC = [[InvitationViewController alloc]init];
            myVC.titleStr = @"我的点赞";
            [self.navigationController pushViewController:myVC animated:YES];
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            if (appdelegate.isHasPower) {//医生是否有权限
                YYChatListViewController *familyVC = [[YYChatListViewController alloc]init];
                [self.navigationController pushViewController:familyVC animated:YES];
            }else{
                [SVProgressHUD showInfoWithStatus:@"你还没有该权限"];
            }
            
        }else if(indexPath.row == 1){
            YYPatientsViewController *equipmentVC = [[YYPatientsViewController alloc]init];
            equipmentVC.titleStr = @"search";
            equipmentVC.isTotal = YES;
            [self.navigationController pushViewController:equipmentVC animated:YES];
        }else{//挂号
            ReciveAppointmentViewController *equipmentVC = [[ReciveAppointmentViewController alloc]init];
            [self.navigationController pushViewController:equipmentVC animated:YES];
        }

    
    
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    self.tabBarController.selectedIndex = 4;
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
    NSLog(@"token = %@",tokenStr);
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@%@",mMyInfo,tokenStr] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"res = = %@",responseObject);
        NSDictionary *dict = responseObject[@"physician"];
        //        CcUserModel *userMoedel = [CcUserModel mj_objectWithKeyValues:responseObject];
        YYHomeUserModel *userMoedel = [YYHomeUserModel mj_objectWithKeyValues:dict];
        
        
        NSLog(@"%@",userMoedel.avatar);
        
        
        [self.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,userMoedel.avatar]]];
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",userMoedel.trueName,userMoedel.title];
        self.idLabel.text = [NSString stringWithFormat:@"%@  %@",userMoedel.hospitalName,userMoedel.departmentName];
        self.personalModel = userMoedel;
        
        
        NSString *messageCount = responseObject[@"hasMessage"];
        if ([messageCount integerValue] >0) {
            self.rightNotBtn.badgeValue = @" ";
            self.rightNotBtn.badgeBGColor = [UIColor redColor];
            self.rightNotBtn.badgeFont = [UIFont systemFontOfSize:0.1];
            self.rightNotBtn.badgeOriginX = 16;
            self.rightNotBtn.badgeOriginY = 1;
            self.rightNotBtn.badgePadding = 0.1;
            self.rightNotBtn.badgeMinSize = 5;
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

////防止导航栏设置影响其他页面
-(void)viewWillAppear:(BOOL)animated{
    //把导航栏变透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
//    self.navigationController.navigationBar.translucent = true;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
//        self.navigationController.navigationBar.translucent = false;
}
//设置按钮点击事件
- (void)pushSettingVC{
    [self.navigationController pushViewController:[[YYSettingViewController alloc]init] animated:YES];
}
//消息按钮点击事件
- (void)pushNotficVC{
    YYNoticeListVC *noticeVC = [[YYNoticeListVC alloc]init];
    [self.navigationController pushViewController:noticeVC animated:YES];
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
