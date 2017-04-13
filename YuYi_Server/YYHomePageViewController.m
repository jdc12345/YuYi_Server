//
//  YYHomePageViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYHomePageViewController.h"
#import "YYCycleView.h"
#import <Masonry.h>
#import "YYInformationVC.h"
#import "YYInformationTableViewCell.h"
#import "NSObject+Formula.h"
#import "UIColor+colorValues.h"
#import "HttpClient.h"
#import "YYInfoDetailVC.h"
#import "YYInfoDetailModel.h"
#import <MJExtension.h>

static NSString *cell_id = @"cell_id";
@interface YYHomePageViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
//跟button的监听事件有关
@property(weak, nonatomic)UIView *cardLineView;
//
@property(weak, nonatomic)UIScrollView *cardDetailView;
//根据scrollView滚动距离设置滚动线位置时候需要
@property(strong, nonatomic)NSArray *cardCategoryButtons;
//设置滚动线约束时候需要
@property(strong, nonatomic)UIView *infosView;
@property(nonatomic,strong)NSArray *hotInfos;
@property(nonatomic,strong)NSArray *todayInfos;
@property(nonatomic,strong)NSArray *recentInfos;
//子控制器
@property(weak, nonatomic)YYInformationVC *hotInfosVC;
@property(weak, nonatomic)YYInformationVC *todayInfosVC;
@property(weak, nonatomic)YYInformationVC *recentInfosVC;

@end

@implementation YYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self loadData];
    
}
- (void)loadData {
//    http://192.168.1.55:8080/yuyi/doctorlyinformation/getTodayAll.do?start=2&limit=8
//    http://192.168.1.55:8080/yuyi/doctorlyinformation/find.do?start=0&limit=3
//    http://192.168.1.55:8080/yuyi/doctorlyinformation/findPage.do?start=0&limit=3
    
    NSString *todayUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/getTodayAll.do?start=2&limit=8",mPrefixUrl];
    NSString *hotUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/find.do?start=0&limit=3",mPrefixUrl];
    NSString *recentUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/findPage.do?start=0&limit=3",mPrefixUrl];
    [self loadTodayInfosWithUrlStr:todayUrlStr];
    [self loadRecentInfosWithUrlStr:recentUrlStr];
    [self loadHotInfosWithUrlStr:hotUrlStr];
//    self.hotInfos = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"4",@"5",@"6", nil];
//    self.todayInfos = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
//    self.recentInfos = [NSArray arrayWithObjects:@"1",@"2", nil];
    
}
-(void)loadTodayInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"result"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.todayInfos = mArr;
        [self setupUI];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)loadHotInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"result"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.hotInfosVC.infos = mArr;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
-(void)loadRecentInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"result"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.recentInfosVC.infos = mArr;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

//
-(void)setupUI{
    //轮播图
    YYCycleView *cycleView = [[YYCycleView alloc]init];
    cycleView.itemClick = ^(NSString *index){
        YYInfoDetailVC *infoDetail = [[YYInfoDetailVC alloc]init];
        infoDetail.info_id = index;
        [self.navigationController pushViewController:infoDetail animated:YES];
        
    };
    //    cycleView.frame = CGRectMake(0, 0, kScreenW, 200*kiphone6);
    [self.view addSubview:cycleView];
    //添加帖子分类
    UIView *infosView = [[UIView alloc]init];
    infosView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infosView];
    //
    self.infosView = infosView;
    //添加商家分类按钮
    UIButton *todyInfoButton = [[UIButton alloc]init];
    UIButton *recentInfoButton = [[UIButton alloc]init];
    UIButton *hotInfoButton = [[UIButton alloc]init];
    //设置按钮标题
    [hotInfoButton setTitle:@"热门" forState:UIControlStateNormal];
    [todyInfoButton setTitle:@"今日推荐" forState:UIControlStateNormal];
    [recentInfoButton setTitle:@"最新" forState:UIControlStateNormal];
    //把按钮添加到一个数组中
    NSArray *cardCategoryButtons = @[todyInfoButton,recentInfoButton,hotInfoButton];
    //
    self.cardCategoryButtons = cardCategoryButtons;
    //循环把各个按钮通用的部分设置
    for (int i = 0; i < cardCategoryButtons.count; i ++) {
        UIButton *btn = cardCategoryButtons[i];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        //
        btn.tag = i;
        //添加按钮的监听事件
        [btn addTarget:self action:@selector(shopCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [infosView addSubview:btn];
    }
    
    //添加滑动线
    UIView *cardLineView = [[UIView alloc]init];
    [cardLineView setBackgroundColor:[UIColor greenColor]];
    [infosView addSubview:cardLineView];
    self.cardLineView = cardLineView;
    
    //添加帖子信息
    UIScrollView *cardDetailView = [[UIScrollView alloc]init];
    //打开分页符
    cardDetailView.pagingEnabled = YES;
    //取消滚动条
    cardDetailView.showsVerticalScrollIndicator = NO;
    cardDetailView.showsHorizontalScrollIndicator = NO;
    cardDetailView.bounces = false;
    cardDetailView.backgroundColor = [UIColor orangeColor];
    //添加帖子详情
    [self.view addSubview:cardDetailView];
    self.cardDetailView = cardDetailView;
    self.cardDetailView.delegate = self;
    //
    YYInformationVC *hotInfoVC = [[YYInformationVC alloc]init];
    YYInformationVC *todayInfoVC = [[YYInformationVC alloc]init];
    YYInformationVC *recentInfoVC = [[YYInformationVC alloc]init];
    //传数据
    hotInfoVC.infos = self.hotInfos;
    todayInfoVC.infos = self.todayInfos;
    recentInfoVC.infos = self.recentInfos;
    //
    hotInfoVC.view.backgroundColor = [UIColor whiteColor];
    todayInfoVC.view.backgroundColor = [UIColor blueColor];
    recentInfoVC.view.backgroundColor = [UIColor whiteColor];
    
    //添加子控件的view
    [cardDetailView addSubview:hotInfoVC.view];
    [cardDetailView addSubview:todayInfoVC.view];
    [cardDetailView addSubview:recentInfoVC.view];
    //建立父子关系
    [self addChildViewController:hotInfoVC];
    [self addChildViewController:todayInfoVC];
    [self addChildViewController:recentInfoVC];
    //告诉程序已经添加成功
    [hotInfoVC didMoveToParentViewController:self];
    [todayInfoVC didMoveToParentViewController:self];
    [recentInfoVC didMoveToParentViewController:self];
    //
    self.hotInfosVC = hotInfoVC;
    self.todayInfosVC = todayInfoVC;
    self.recentInfosVC = recentInfoVC;
    //设置轮播器约束
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.offset(kScreenW);
        make.height.offset(200*kiphone6);
    }];
    //设置帖子分类约束
    [infosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(44*kiphone6);
    }];
    //设置按钮约束
    [cardCategoryButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18*kiphone6);
        make.bottom.offset(0);
    }];
    //循环设置按钮的等宽
    for (int i = 0; i < cardCategoryButtons.count-1; i ++) {
        UIButton *currentBtn = cardCategoryButtons[i];
        UIButton *nextBtn = cardCategoryButtons[i+1];
        //
        if (i==0) {
            [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10*kiphone6);
            }];
            
        }
        if (i==cardCategoryButtons.count-2) {
            [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-(kScreenW-240*kiphone6));
            }];
        }
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(currentBtn);
            make.left.equalTo(currentBtn.mas_right);
        }];
        
    }
    //设置滑动线的约束
    [cardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(64*kiphone6);
        make.height.offset(2);
        make.bottom.equalTo(todyInfoButton);
        make.centerX.equalTo(todyInfoButton);
    }];
    //约束
    [cardDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(infosView.mas_bottom);
        make.bottom.offset(-64*kiphone6);
    }];
    [cardDetailView layoutIfNeeded];
    [todayInfoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [recentInfoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(todayInfoVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [hotInfoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.equalTo(recentInfoVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
    }];
    
    
}

//按钮的监听事件
-(void)shopCategoryButtonClick:(UIButton*)sender{
    [self.cardDetailView setContentOffset:CGPointMake(sender.tag*self.cardDetailView.bounds.size.width, 0) animated:YES];
    if (sender.tag == 0) {
        NSString *todayUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/getTodayAll.do?start=2&limit=8",mPrefixUrl];
        [[HttpClient defaultClient]requestWithPath:todayUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.todayInfosVC.infos = mArr;
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else if (sender.tag == 1){
        NSString *recentUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/findPage.do?start=0&limit=3",mPrefixUrl];
        [self loadRecentInfosWithUrlStr:recentUrlStr];
    }else if (sender.tag == 2){
        NSString *hotUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/find.do?start=0&limit=3",mPrefixUrl];
        [self loadHotInfosWithUrlStr:hotUrlStr];
    }
}
//根据偏移距离设置滚动线的位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取偏移量
    CGFloat offSetX = self.cardDetailView.contentOffset.x;
    // NSLog(@"%f",offSetX);
    //找到按钮数组的第一个按钮和最后一个按钮
    UIButton *firstBtn = self.cardCategoryButtons.firstObject;
    UIButton *lastBtn = self.cardCategoryButtons.lastObject;
    //滚动线的滑动范围
    CGFloat dis = lastBtn.center.x - firstBtn.center.x;
    //获取这个范围的最大值和最小值
    CGFloat leftValue = -(dis/2);
    CGFloat rightValue = dis/2;
    //要求的值所在的数值区域
    YHValue resValue = YHValueMake(leftValue, rightValue);
    //参照数值的区域
    YHValue conValue = YHValueMake(0, (self.cardCategoryButtons.count-1)*self.cardDetailView.bounds.size.width);
    //偏移距离
    CGFloat res = [NSObject resultWithConsult:offSetX andResultValue:resValue andConsultValue:conValue];
    UIButton *secondBtn = self.cardCategoryButtons[1];
    //按钮所在view宽和scrollView的宽不相等，所以需要减去该距离
    CGFloat d = self.view.center.x - secondBtn.center.x;
    //根据偏移距离设置滚动线的位置
    [self.cardLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(64*kiphone6);
        make.height.offset(2);
        make.bottom.equalTo(self.infosView);
        make.centerX.offset(res-d);
    }];
    
    //
    [self.cardLineView layoutIfNeeded];
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

@end
