//
//  YYSciencesViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYSciencesViewController.h"
#import "YYlearningCircleVC.h"
#import <Masonry.h>
#import "UIButton+Badge.h"
#import "UIColor+colorValues.h"
#import "YYpostCardVC.h"
#import "NSObject+Formula.h"
#import "YYCardDetailModel.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "CcUserModel.h"
#import <MJRefresh.h>
#import "YYNoticeListVC.h"

static NSInteger hotStart = 0;//上拉加载起始位置
static NSInteger recentStart = 0;
static NSInteger selectStart = 0;
@interface YYSciencesViewController ()<UIScrollViewDelegate,refreshDelegate>
//跟button的监听事件有关
@property(weak, nonatomic)UIView *cardLineView;
//
@property(weak, nonatomic)UIScrollView *cardDetailView;
//根据scrollView滚动距离设置滚动线位置时候需要
@property(strong, nonatomic)NSArray *cardCategoryButtons;
//设置滚动线约束时候需要
@property(strong, nonatomic)UIView *cardsView;
@property(nonatomic,strong)NSMutableArray *hotInfos;
@property(nonatomic,strong)NSMutableArray *selectInfos;
@property(nonatomic,strong)NSMutableArray *recentInfos;
//子控制器
@property(weak, nonatomic)YYlearningCircleVC *hotCardVC;
@property(weak, nonatomic)YYlearningCircleVC *selectCardVC;
@property(weak, nonatomic)YYlearningCircleVC *recentCardVC;
//发帖btn
@property(weak, nonatomic)UIButton *postMessageBtn;
//optionView
@property(weak, nonatomic)UIView *backView;
@property(weak, nonatomic)UIView *noticeView;
//发帖权限确定
@property(assign, nonatomic)BOOL post_if;

@end

@implementation YYSciencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"学术圈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self loadData];
}

- (void)loadData {
//    http://192.168.1.55:8080/yuyi/academicpaper/findhot.do?start=0&limit=6&token=EA62E69E02FABA4E4C9A0FDC1C7CAE10
//    http://192.168.1.55:8080/yuyi/academicpaper/Selected.do?start=0&limit=1
//    http://192.168.1.55:8080/yuyi/academicpaper/findtime.do?start=0&limit=6
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *token = userModel.userToken;
    NSString *hotUrlStr = [NSString stringWithFormat:@"%@/academicpaper/findhot.do?start=0&limit=6&token=%@",mPrefixUrl,token];
    NSString *selectUrlStr = [NSString stringWithFormat:@"%@/academicpaper/Selected.do?start=0&limit=6&token=%@",mPrefixUrl,token];
    NSString *recentUrlStr = [NSString stringWithFormat:@"%@/academicpaper/findtime.do?start=0&limit=6&token=%@",mPrefixUrl,token];
    [SVProgressHUD show];// 动画开始
    [self loadHotInfosWithUrlStr:hotUrlStr];
    [self loadSelectInfosWithUrlStr:selectUrlStr];
    [self loadRecentInfosWithUrlStr:recentUrlStr];
}
-(void)loadHotInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"rows"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.hotInfos = mArr;
        [SVProgressHUD dismiss];// 动画结束
        [self setupUI];
        if (self.hotInfos.count>0) {
            hotStart = self.hotInfos.count;
        }
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
    
}
-(void)loadSelectInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"result"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.selectInfos = mArr;
        self.selectCardVC.infos = mArr;
        if (self.selectCardVC.infos.count>0) {
            selectStart = self.selectCardVC.infos.count;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return ;
    }];
}
-(void)loadRecentInfosWithUrlStr:(NSString*)urlStr{
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"rows"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.recentInfos = mArr;
        self.recentCardVC.infos = mArr;
        if (self.selectCardVC.infos.count>0) {
            recentStart = self.recentCardVC.infos.count;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return ;
    }];
}
//
-(void)setupUI{
    self.navigationController.navigationBar.hidden = true;
    //添加帖子分类
    UIView *cardsView = [[UIView alloc]init];
    cardsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardsView];
    //
    self.cardsView = cardsView;
    //添加商家分类按钮
    UIButton *hotCardButton = [[UIButton alloc]init];
    UIButton *selectCardButton = [[UIButton alloc]init];
    UIButton *recentCardButton = [[UIButton alloc]init];
    //设置按钮标题
    [hotCardButton setTitle:@"热门" forState:UIControlStateNormal];
    [selectCardButton setTitle:@"精选" forState:UIControlStateNormal];
    [recentCardButton setTitle:@"最新" forState:UIControlStateNormal];
    //把按钮添加到一个数组中
    NSArray *cardCategoryButtons = @[hotCardButton,selectCardButton,recentCardButton];
    //
    self.cardCategoryButtons = cardCategoryButtons;
    //循环把各个按钮通用的部分设置
    for (int i = 0; i < cardCategoryButtons.count; i ++) {
        UIButton *btn = cardCategoryButtons[i];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        //
        btn.tag = i;
        //添加按钮的监听事件
        [btn addTarget:self action:@selector(shopCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cardsView addSubview:btn];
    }
    [hotCardButton setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
    //添加滑动线
    UIView *cardLineView = [[UIView alloc]init];
    [cardLineView setBackgroundColor:[UIColor colorWithHexString:@"1ebeec"]];
    [cardsView addSubview:cardLineView];
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
    //
    self.cardDetailView = cardDetailView;
    //
    self.cardDetailView.delegate = self;
    //
    YYlearningCircleVC *hotCardVC = [[YYlearningCircleVC alloc]init];
    YYlearningCircleVC *selectCardVC = [[YYlearningCircleVC alloc]init];
    YYlearningCircleVC *recentCardVC = [[YYlearningCircleVC alloc]init];
    //设置代理
    hotCardVC.delegate = self;
    selectCardVC.delegate = self;
    recentCardVC.delegate = self;
    //传数据
    hotCardVC.infos = self.hotInfos;
    selectCardVC.infos = self.selectInfos;
    recentCardVC.infos = self.recentInfos;
    //
    hotCardVC.view.backgroundColor = [UIColor whiteColor];
    selectCardVC.view.backgroundColor = [UIColor blueColor];
    recentCardVC.view.backgroundColor = [UIColor whiteColor];
    
    //添加子控件的view
    [cardDetailView addSubview:hotCardVC.view];
    [cardDetailView addSubview:selectCardVC.view];
    [cardDetailView addSubview:recentCardVC.view];
    //建立父子关系
    [self addChildViewController:hotCardVC];
    [self addChildViewController:selectCardVC];
    [self addChildViewController:recentCardVC];
    //告诉程序已经添加成功
    [hotCardVC didMoveToParentViewController:self];
    [selectCardVC didMoveToParentViewController:self];
    [recentCardVC didMoveToParentViewController:self];
    //
    self.hotCardVC = hotCardVC;
    self.selectCardVC = selectCardVC;
    self.recentCardVC = recentCardVC;
    //添加右侧消息中心按钮
    UIButton *informationBtn = [[UIButton alloc]init];
    [self.view addSubview:informationBtn];
    [informationBtn setImage:[UIImage imageNamed:@"notfiy_select"] forState:UIControlStateNormal];
//    informationBtn.badgeValue = @" ";
//    informationBtn.badgeBGColor = [UIColor redColor];
//    informationBtn.badgeFont = [UIFont systemFontOfSize:0.1];
//    informationBtn.badgeOriginX = 16;
//    informationBtn.badgeOriginY = 1;
//    informationBtn.badgePadding = 0.1;
//    informationBtn.badgeMinSize = 5;
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置帖子分类约束
    [cardsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(64*kiphone6);
    }];
    //设置按钮约束
    [cardCategoryButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.bottom.offset(0*kiphone6);
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
                make.right.offset(-([UIScreen mainScreen].bounds.size.width-170*kiphone6));
            }];
        }
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(currentBtn);
            make.left.equalTo(currentBtn.mas_right);
        }];
    }
    //设置滑动线的约束
    [cardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30*kiphone6);
        make.height.offset(2*kiphone6);
        make.bottom.equalTo(hotCardButton);
        make.centerX.equalTo(hotCardButton);
    }];
    //约束
    [cardDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(cardsView.mas_bottom);
        make.bottom.offset(-44);
    }];
    [cardDetailView layoutIfNeeded];
    [hotCardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [selectCardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(hotCardVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [recentCardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.equalTo(selectCardVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
    }];
    [informationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hotCardButton);
        make.right.offset(-20*kiphone6);
    }];
    //添加右侧发帖按钮
    UIButton *postMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70*kiphone6, self.view.frame.size.height-114*kiphone6, 50*kiphone6, 50*kiphone6)];
    [self.view addSubview:postMessageBtn];
    [self.view bringSubviewToFront:postMessageBtn];
    self.postMessageBtn = postMessageBtn;
    [postMessageBtn setImage:[UIImage imageNamed:@"postamessage"] forState:UIControlStateNormal];
    [postMessageBtn addTarget:self action:@selector(postMassageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//按钮的监听事件
-(void)shopCategoryButtonClick:(UIButton*)sender{
    [sender setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
    for (UIButton *btn in self.cardCategoryButtons) {
        if (btn.tag != sender.tag) {
            [btn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        }
    }
    [self.cardDetailView setContentOffset:CGPointMake(sender.tag*self.cardDetailView.bounds.size.width, 0) animated:YES];
}
-(void)informationBtnClick:(UIButton*)sender{
    YYNoticeListVC *noticeVC = [[YYNoticeListVC alloc]init];
    [self.navigationController pushViewController:noticeVC animated:true];
//    //大蒙布View
//    UIView *backView = [[UIView alloc]init];
//    backView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
//    backView.alpha = 0.2;
//    [self.view addSubview:backView];
//    self.backView = backView;
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//    backView.userInteractionEnabled = YES;
//    //添加tap手势：
//    //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
//    //将手势添加至需要相应的view中
//    //    [backView addGestureRecognizer:tapGesture];
//    
//    //提示框
//    UIView *noticeView = [[UIView alloc]init];
//    noticeView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:noticeView];
//    self.noticeView = noticeView;
//    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(backView);
//        make.width.offset(300*kiphone6);
//        make.height.offset(200*kiphone6);
//    }];
//    //noticeLabel
//    UILabel *noticeLabel = [[UILabel alloc]init];
//    noticeLabel.text = @"提示";
//    noticeLabel.font = [UIFont systemFontOfSize:17];
//    noticeLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    [noticeView addSubview:noticeLabel];
//    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(noticeView);
//        make.top.offset(25*kiphone6);
//    }];
//    //contentLabel
//    UILabel *contentLabel = [[UILabel alloc]init];
//    //提示内容
//    contentLabel.text = @"此功能暂时只对专业医生开放，你暂时还没有权限，去看看别的吧";
//    contentLabel.numberOfLines = 2;
//    contentLabel.font = [UIFont systemFontOfSize:15];
//    contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    [noticeView addSubview:contentLabel];
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(25*kiphone6);
//        make.top.equalTo(noticeLabel.mas_bottom).offset(25*kiphone6);
//        make.right.offset(-25*kiphone6);
//    }];
//    //confirmButton
//    UIButton *confirmButton = [[UIButton alloc]init];
//    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
//    [confirmButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    confirmButton.backgroundColor = [UIColor colorWithHexString:@"#25f368"];
//    [noticeView addSubview:confirmButton];
//    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.offset(0);
//        make.height.offset(60*kiphone6);
//    }];
//    //添加关闭提示框按钮的点击事件
//    [confirmButton addTarget:self action:@selector(closeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    
}
//-(void)closeNoticeView:(UIButton*)sender{
//    for (UIView *view in self.noticeView.subviews) {
//        [view removeFromSuperview];
//    }
//    [self.noticeView removeFromSuperview];
//    [self.backView removeFromSuperview];
//}
-(void)postMassageBtnClick:(UIButton*)sender{
    CcUserModel *ccuserModel = [CcUserModel defaultClient];
    if([ccuserModel.telephoneNum isEqualToString:@"18511694068"]){
        if (!self.post_if) {
            [self showAlertWithMessage:@"发帖功能会使用到你个人的头像和昵称，请确认后再使用该功能"];
        }
    }
    
    YYpostCardVC *postCardVC = [[YYpostCardVC alloc]init];
    [self.navigationController pushViewController:postCardVC animated:true];
}
//根据偏移距离设置滚动线的位置

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取偏移量
    CGFloat offSetX = self.cardDetailView.contentOffset.x;
     NSLog(@"%f",offSetX);
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
        make.width.offset(32*kiphone6);
        make.height.offset(2*kiphone6);
        make.bottom.equalTo(self.cardsView);
        make.centerX.offset(res-d);
    }];
    //滑动改变相应btn'的文字颜色
    UIButton *hotBtn = self.cardCategoryButtons[0];
    UIButton *selectBtn = self.cardCategoryButtons[1];
    UIButton *newBtn = self.cardCategoryButtons[2];
    if (offSetX == 0) {
        [hotBtn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [newBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
    }
    if (offSetX == kScreenW) {
        [selectBtn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
        [hotBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [newBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
    }
    if (offSetX == kScreenW*2) {
        [newBtn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [hotBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
    }

}
#pragma refreshDelegate
-(void)transViewController:(YYlearningCircleVC *)learningVC{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *token = userModel.userToken;
    if (learningVC == self.hotCardVC) {
        NSString *hotUrlStr = [NSString stringWithFormat:@"%@/academicpaper/findhot.do?start=0&limit=6&token=%@",mPrefixUrl,token];
        [[HttpClient defaultClient]requestWithPath:hotUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.hotInfos = mArr;
            self.hotCardVC.infos = mArr;
            if (self.hotCardVC.infos.count>0) {
                hotStart = self.hotCardVC.infos.count;
            }
            [learningVC.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_header endRefreshing];
            return ;
        }];
    }else if (learningVC == self.selectCardVC){
        NSString *selectUrlStr = [NSString stringWithFormat:@"%@/academicpaper/Selected.do?start=0&limit=6&token=%@",mPrefixUrl,token];
        [[HttpClient defaultClient]requestWithPath:selectUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.selectInfos = mArr;
            self.selectCardVC.infos = mArr;
            if (self.selectCardVC.infos.count>0) {
                selectStart = self.selectCardVC.infos.count;
            }
            [learningVC.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_header endRefreshing];
            return ;
        }];
        
    }else if (learningVC == self.recentCardVC){
        NSString *recentUrlStr = [NSString stringWithFormat:@"%@/academicpaper/findtime.do?start=0&limit=6&token=%@",mPrefixUrl,token];
        [[HttpClient defaultClient]requestWithPath:recentUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.recentCardVC.infos = mArr;
            self.recentInfos = mArr;
            if (self.recentCardVC.infos.count>0) {
                recentStart = self.recentCardVC.infos.count;
            }
            [learningVC.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_header endRefreshing];
            return ;
        }];
        
    }
}
-(void)transForFootRefreshWithViewController:(YYlearningCircleVC *)learningVC{
    if (learningVC == self.hotCardVC) {
        if (hotStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [learningVC.tableView.mj_footer endRefreshing];
            return;
        }
        NSString *hotUrlStr = [NSString stringWithFormat:@"%@/academicpaper/findhot.do?start=%ld&limit=6&token=%@",mPrefixUrl,hotStart,mDefineToken];
        [[HttpClient defaultClient]requestWithPath:hotUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            if (mArr.count>0) {
                [self.hotCardVC.infos addObjectsFromArray:mArr];
                hotStart = self.hotCardVC.infos.count;
                [learningVC.tableView reloadData];
            }else{
                [learningVC.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [learningVC.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_footer endRefreshing];
            return ;
        }];
    }else if (learningVC == self.selectCardVC){
        if (selectStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [learningVC.tableView.mj_footer endRefreshing];
            return;
        }
        NSString *selectUrlStr = [NSString stringWithFormat:@"%@/academicpaper/Selected.do?start=%ld&limit=6&token=%@",mPrefixUrl,selectStart,mDefineToken];
        [[HttpClient defaultClient]requestWithPath:selectUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            if (mArr.count>0) {
                [self.selectCardVC.infos addObjectsFromArray:mArr];
                selectStart = self.selectCardVC.infos.count;
                [learningVC.tableView reloadData];
            }else{
                [learningVC.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [learningVC.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_footer endRefreshing];
            return ;
        }];
        
    }else if (learningVC == self.recentCardVC){
        if (recentStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [learningVC.tableView.mj_footer endRefreshing];
            return;
        }
        NSString *recentUrlStr = [NSString stringWithFormat:@"%@/academicpaper/findtime.do?start=%ld&limit=6&token=%@",mPrefixUrl,recentStart,mDefineToken];
        [[HttpClient defaultClient]requestWithPath:recentUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCardDetailModel *infoModel = [YYCardDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            if (mArr.count>0) {
                [self.recentCardVC.infos addObjectsFromArray:mArr];
                recentStart = self.recentCardVC.infos.count;
                [learningVC.tableView reloadData];
            }else{
                [learningVC.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [learningVC.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [learningVC.tableView.mj_footer endRefreshing];
            return ;
        }];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    CcUserModel *ccuserModel = [CcUserModel defaultClient];
    
    if([ccuserModel.telephoneNum isEqualToString:@"18511694068"]&&!self.post_if){
    [self showAlertWithMessage:@"发帖功能会使用到你个人的头像和昵称，请确认后再使用该功能"];
    
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
    [SVProgressHUD dismiss];// 动画结束
}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.post_if = false;
        return ;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.post_if = true;
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
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
