//
//  YYSearchTableViewController.m
//  YuYi_Client
//
//  Created by 万宇 on 2017/3/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYSearchTableViewController.h"
#import "YYSearchRecordSingleton.h"
#import "UIColor+colorValues.h"
#import <Masonry.h>
#import "HttpClient.h"
#import "YYModel.h"
#import "YYPatientsViewController.h"
//#import "YYMedinicalDetailModel.h"
//#import "YYMedicinalDetailVC.h"
//#import "YYHospitalInfoViewController.h"
//#import "YYInfomationModel.h"

static NSString *dentifier=@"cellforappliancelist";
@interface YYSearchTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic) NSMutableArray  *searchingList;//新搜索出的数据
@property (strong,nonatomic) NSMutableArray  *searchedList;//搜索记录数据
@property(nonatomic,strong)NSUserDefaults *defaults;
//@property(nonatomic,weak)UITableView *tableView;//显示数据的列表
@property(nonatomic,weak)UITextField *searchField;//输入框
@property(nonatomic,assign)NSInteger flag;//判断点击cell是否跳转的标记
@property(nonatomic,assign)NSInteger sectionHeight;//组尾高度
@property(nonatomic,assign)BOOL active;//更新新搜索的数据的开关
@end

@implementation YYSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //搜索框
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
//    headerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:headerView];
    //取消按钮
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"25f368"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(50);
    }];
    //输入框
    UITextField *searchField = [[UITextField alloc]init];
    [headerView addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(btn.mas_left);
    }];
    searchField.delegate = self;
    self.searchField = searchField;
    if (self.searchCayegory==1) {
        searchField.placeholder = @"搜索患者";
    }else if (self.searchCayegory==0){
        searchField.placeholder = @"搜索药品";
    }
    searchField.clearButtonMode = UITextFieldViewModeAlways;//删除内容的❎
    [searchField setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
    //输入框左侧放大镜
    UIImage *image = [UIImage imageNamed:@"search_normal"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [imageView sizeToFit];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width+5, imageView.frame.size.height)];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.right.bottom.offset(0);
    }];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.leftView = view;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    [searchField.layer setMasksToBounds:YES];
    [searchField.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    //边框宽度
    [searchField.layer setBorderWidth:0.8];
    searchField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    //tableView
    //解决状态栏透明
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView *stateView = [[UIView alloc]init];
    stateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stateView];
    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(20);
    }];

    self.navigationController.navigationBar.hidden = true;
    [UIApplication sharedApplication].statusBarHidden = false;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *searchString = [self.searchField text];
    
    if (searchString.length >0) {
        YYPatientsViewController *dataAnalyseVC = [[YYPatientsViewController alloc]init];
        dataAnalyseVC.view.frame = CGRectMake(0, 64, kScreenW, kScreenH -64);
        [self.view addSubview:dataAnalyseVC.view];
        
        [self addChildViewController:dataAnalyseVC];
        
        
        [self.searchField resignFirstResponder];
    }
   
    
    
    return true;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.active = false;
//    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}

#pragma btnClicks
-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)clearSearedList:(UIButton*)sender{
//    if (self.searchCayegory==0) {
//        
//    }else if (self.searchCayegory==1){
//        
//    }
    if (self.searchCayegory==0) {
        [self.defaults removeObjectForKey:@"searchedList"];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
    }

    }else if (self.searchCayegory==1){
        [self.defaults removeObjectForKey:@"searchedHospitalList"];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedHospitalList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
        }

    }
//    [self.tableView reloadData];
}
#pragma 懒加载
-(NSMutableArray *)searchingList{
    if (_searchingList==nil) {
        _searchingList = [NSMutableArray array];
    }
    return _searchingList;
}
//页面出现和消失
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchingList removeAllObjects];
    //加载搜索记录
    if (self.searchCayegory==0) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
            
        }
    }else if(self.searchCayegory==1){
        self.defaults = [NSUserDefaults standardUserDefaults];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedHospitalList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
            
        }
 
    }
    
//    [self.tableView reloadData];//页面出现时候刷新数据
    self.searchField.text = nil;//页面出现时候清空搜索框数据
    self.navigationController.navigationBar.hidden = true;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.active = false;//在页面跳转时候关闭显示搜索新数据的开关，以便在页面从新出现时候为搜索记录数据;
    self.navigationController.navigationBar.hidden = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
