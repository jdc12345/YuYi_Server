//
//  YYHomePageViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYHomePageViewController.h"
#import "YYCycleView.h"
#import "YYInformationVC.h"
#import "YYInformationTableViewCell.h"
#import "NSObject+Formula.h"
#import "YYInfoDetailVC.h"
#import "YYInfoDetailModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>

static NSString *cell_id = @"cell_id";
static NSInteger hotStart = 0;//上拉加载起始位置
static NSInteger recentStart = 0;
static NSInteger todayStart = 0;
@interface YYHomePageViewController ()<UIScrollViewDelegate,refreshDelegate>
@property(nonatomic,weak)UITableView *tableView;
//跟button的监听事件有关
@property(weak, nonatomic)UIView *cardLineView;
//
@property(weak, nonatomic)UIScrollView *cardDetailView;
//根据scrollView滚动距离设置滚动线位置时候需要
@property(strong, nonatomic)NSArray *cardCategoryButtons;
//设置滚动线约束时候需要
@property(strong, nonatomic)UIView *infosView;
@property(nonatomic,strong)NSMutableArray *hotInfos;
@property(nonatomic,strong)NSMutableArray *todayInfos;
@property(nonatomic,strong)NSMutableArray *recentInfos;
//子控制器
@property(weak, nonatomic)YYInformationVC *hotInfosVC;
@property(weak, nonatomic)YYInformationVC *todayInfosVC;
@property(weak, nonatomic)YYInformationVC *recentInfosVC;

@end

@implementation YYHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self loadData];
    
}

- (void)loadData {
//    http://192.168.1.55:8080/yuyi/doctorlyinformation/getTodayAll.do?start=2&limit=8
//    http://192.168.1.55:8080/yuyi/doctorlyinformation/find.do?start=0&limit=3
//    http://192.168.1.55:8080/yuyi/doctorlyinformation/findPage.do?start=0&limit=3
    
    NSString *todayUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/getTodayAll.do?start=0&limit=6",mPrefixUrl];
    NSString *hotUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/find.do?start=0&limit=6",mPrefixUrl];
    NSString *recentUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/findPage.do?start=0&limit=6",mPrefixUrl];
    [SVProgressHUD show];// 动画开始
    [self loadTodayInfosWithUrlStr:todayUrlStr];
    [self loadRecentInfosWithUrlStr:recentUrlStr];
    [self loadHotInfosWithUrlStr:hotUrlStr];

    
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
        [SVProgressHUD dismiss];// 动画结束
        [self setupUI];
        if (self.todayInfos.count>0) {
            todayStart = self.todayInfos.count;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
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
        if (self.hotInfosVC.infos.count>0) {
            hotStart = self.hotInfosVC.infos.count;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return ;
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
        if (self.recentInfosVC.infos.count>0) {
            recentStart = self.recentInfosVC.infos.count;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return ;
    }];
    
}

//
-(void)setupUI{
    /*//轮播图
    YYCycleView *cycleView = [[YYCycleView alloc]init];
    cycleView.itemClick = ^(NSString *index){
        YYInfoDetailVC *infoDetail = [[YYInfoDetailVC alloc]init];
        infoDetail.info_id = index;
        [self.navigationController pushViewController:infoDetail animated:YES];
        
    };
    //    cycleView.frame = CGRectMake(0, 0, kScreenW, 200*kiphone6);
    [self.view addSubview:cycleView];*/
    //添加帖子分类
    UIView *infosView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    infosView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:infosView];
    //
    self.infosView = infosView;
    //添加商家分类按钮
    UIButton *todyInfoButton = [[UIButton alloc]init];
    UIButton *recentInfoButton = [[UIButton alloc]init];
    UIButton *hotInfoButton = [[UIButton alloc]init];
    //设置按钮标题
    [hotInfoButton setTitle:@"热门" forState:UIControlStateNormal];
    [todyInfoButton setTitle:@"推荐" forState:UIControlStateNormal];
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
    [cardLineView setBackgroundColor:[UIColor colorWithHexString:@"333333"]];
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
    //设置代理
    hotInfoVC.delegate = self;
    todayInfoVC.delegate = self;
    recentInfoVC.delegate = self;
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
    /*//设置轮播器约束
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.offset(kScreenW);
        make.height.offset(200*kiphone6);
    }];*/
//    //设置帖子分类约束
//    [infosView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(cycleView.mas_bottom);
////        make.left.right.offset(0);
////        make.height.offset(44*kiphone6);
//        make.top.left.right.bottom.offset(0);
//    }];
    //设置按钮约束
    [cardCategoryButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.bottom.offset(0);
    }];
    //循环设置按钮的等宽
    for (int i = 0; i < cardCategoryButtons.count-1; i ++) {
        UIButton *currentBtn = cardCategoryButtons[i];
        UIButton *nextBtn = cardCategoryButtons[i+1];
        //
        if (i==0) {
            [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
            }];
            
        }
        if (i==cardCategoryButtons.count-2) {
            [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
            }];
        }
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(currentBtn);
            make.left.equalTo(currentBtn.mas_right);
        }];
        
    }
    //设置滑动线的约束
    [cardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(34*kiphone6);
        make.height.offset(3);
        make.bottom.equalTo(todyInfoButton);
        make.centerX.equalTo(todyInfoButton);
    }];
    //约束
    [cardDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        //make.top.equalTo(cycleView.mas_bottom);
        make.bottom.offset(-44);
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
        make.width.offset(34*kiphone6);
        make.height.offset(3);
        make.bottom.equalTo(self.infosView);
        make.centerX.offset(res-d);
    }];
    
    //
    [self.cardLineView layoutIfNeeded];
}
#pragma mark- refreshDelegate
-(void)transViewController:(YYInformationVC *)learningVC{
    if (learningVC == self.hotInfosVC) {
        NSString *hotUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/find.do?start=0&limit=6",mPrefixUrl];
        [[HttpClient defaultClient]requestWithPath:hotUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.hotInfos = mArr;
            self.hotInfosVC.infos = mArr;
            if (self.hotInfosVC.infos.count>0) {
                hotStart = self.hotInfosVC.infos.count;
            }
            [learningVC.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_header endRefreshing];
            return ;
        }];
    }else if (learningVC == self.todayInfosVC){
        NSString *todayUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/getTodayAll.do?start=0&limit=6",mPrefixUrl];
        [[HttpClient defaultClient]requestWithPath:todayUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.todayInfos = mArr;
            self.todayInfosVC.infos = mArr;
            if (self.todayInfosVC.infos.count>0) {
                todayStart = self.todayInfosVC.infos.count;
            }
            [learningVC.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_header endRefreshing];
            return ;
        }];
        
    }else if (learningVC == self.recentInfosVC){
        NSString *recentUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/findPage.do?start=0&limit=6",mPrefixUrl];
        [[HttpClient defaultClient]requestWithPath:recentUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.recentInfosVC.infos = mArr;
            self.recentInfos = mArr;
            if (self.recentInfosVC.infos.count>0) {
                recentStart = self.recentInfosVC.infos.count;
            }
            [learningVC.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_header endRefreshing];
            return ;
        }];
        
    }
}

-(void)transForFootRefreshWithViewController:(YYInformationVC *)learningVC{
    if (learningVC == self.hotInfosVC) {
        if (hotStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [learningVC.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSString *hotUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/find.do?start=%ld&limit=6",mPrefixUrl,hotStart];
        [[HttpClient defaultClient]requestWithPath:hotUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            [self.hotInfosVC.infos addObjectsFromArray:mArr];
//            [self.hotInfos addObjectsFromArray:mArr];
            hotStart = self.hotInfosVC.infos.count;
            [learningVC.tableView reloadData];
            [learningVC.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_footer endRefreshing];
        }];
    }else if (learningVC == self.todayInfosVC){
        if (todayStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [learningVC.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSString *todayUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/getTodayAll.do?start=%ld&limit=6",mPrefixUrl,todayStart];
        [[HttpClient defaultClient]requestWithPath:todayUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            [self.todayInfosVC.infos addObjectsFromArray:mArr];
//            [self.todayInfos addObjectsFromArray:mArr];
            todayStart = self.todayInfosVC.infos.count;
            [learningVC.tableView reloadData];
            [learningVC.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_footer endRefreshing];
        }];
        
    }else if (learningVC == self.recentInfosVC){
        if (recentStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [learningVC.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSString *recentUrlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/findPage.do?start=%ld&limit=6",mPrefixUrl,recentStart];
        [[HttpClient defaultClient]requestWithPath:recentUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            [self.recentInfosVC.infos addObjectsFromArray:mArr];
//            [self.recentInfos addObjectsFromArray:mArr];
            recentStart = self.recentInfosVC.infos.count;
            [learningVC.tableView reloadData];
            [learningVC.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_footer endRefreshing];
        }];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.infosView.hidden = true;
    [SVProgressHUD dismiss];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.infosView.hidden = false;
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
