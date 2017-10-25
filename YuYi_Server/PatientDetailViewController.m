//
//  PatientDetailViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "YYDataAnalyseViewController.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "YYPatientRecordModel.h"
#import "YYRecardViewController.h"
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })//处理数据中NSNULL值
@interface PatientDetailViewController ()
@property (nonatomic, weak) UIButton *recardBtn;
@property (nonatomic, weak) UIButton *trendBtn;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *ageLabel;
@property (nonatomic, weak) UIImageView *genderIcon;
@property (nonatomic, weak) UIImageView *iconImageV;
@property (nonatomic, weak) CAGradientLayer *gradientLayer;//按钮渐变色图层
@property (nonatomic, strong) NSMutableArray *recordArr;//病人记录数据
@end

@implementation PatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self httpRequestForRecord];
    [self createHeadView];

    // Do any additional setup after loading the view.
}
- (void)createHeadView{
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 130 *kiphone6H)];
    personV.backgroundColor = [UIColor whiteColor];
    
    
//    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
//    [personV addGestureRecognizer:tapGest];
    
    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
//    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    
//    [personV addSubview:headerView];
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconV.layer.cornerRadius = 27.5;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = self.patientModel.trueName;
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    
    //
    UIImageView *genderIcon = [[UIImageView alloc]init];
    if ([self.patientModel.gender isEqualToString:@"1"]) {
        genderIcon.image = [UIImage imageNamed:@"gender_boy"];
    }else{
        genderIcon.image = [UIImage imageNamed:@"gender_girl"];
    }
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.patientModel.avatar]]];
    
    UILabel *ageName = [[UILabel alloc]init];
    ageName.text = [NSString stringWithFormat:@"年龄：%@",self.patientModel.age];
    ageName.textColor = [UIColor colorWithHexString:@"333333"];
    ageName.font = [UIFont systemFontOfSize:14];
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:genderIcon];
    [personV addSubview:ageName];
    
    self.nameLabel = nameLabel;
    self.ageLabel = ageName;
    self.iconImageV = iconV;
    self.genderIcon = genderIcon;
    
    
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(55 *kiphone6, 55 *kiphone6));
    }];
    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconV.mas_centerY).offset(-2.5 *kiphone6);
        make.left.equalTo(iconV.mas_right).offset(15 *kiphone6);
    }];
    //
    [genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(5);
    }];
    [ageName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.left.equalTo(nameLabel.mas_left);
    }];
    //电子病历
    UIButton *recardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recardBtn setTitle:@"电子病历" forState:UIControlStateNormal];
    recardBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [recardBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    recardBtn.backgroundColor = [UIColor colorWithHexString:@"1ebeec"];

    [recardBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //患者数据
    UIButton *trendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trendBtn setTitle:@"患者数据" forState:UIControlStateNormal];
    trendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [trendBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    trendBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [trendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [personV addSubview:recardBtn];
    [personV addSubview:trendBtn];
    self.recardBtn = recardBtn;
    self.trendBtn = trendBtn;
    
    [recardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 55 *kiphone6H));
    }];
    [trendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 55 *kiphone6H));
    }];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"2feaeb"].CGColor, (__bridge id)[UIColor colorWithHexString:@"1ebeec"].CGColor];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenW*0.5, 55*kiphone6H);
    [recardBtn.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
    
    UILabel *topLine = [[UILabel alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    [personV addSubview:topLine];
    [personV addSubview:bottomLine];
    
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recardBtn.mas_top).with.offset(0);
        make.left.equalTo(personV).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1 *kiphone6));
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(recardBtn.mas_bottom).with.offset(0);
        make.left.equalTo(personV).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1 *kiphone6));
    }];
    
    
    [self.view addSubview:personV];
}
- (void)createDataView{
    
    YYDataAnalyseViewController *dataAnalyseVC = [[YYDataAnalyseViewController alloc]init];
//    dataAnalyseVC.view.frame = CGRectMake(0, 100 +64, kScreenW, kScreenH -100 -64);
    dataAnalyseVC.userHome_id = self.patientModel.info_id;
    [self.view addSubview:dataAnalyseVC.view];
    [dataAnalyseVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.recardBtn.mas_bottom);
    }];
    [dataAnalyseVC httpRequest];
    
    [self addChildViewController:dataAnalyseVC];
    
    
    YYRecardViewController *recardVC = [[YYRecardViewController alloc]init];
//    recardVC.view.frame = CGRectMake(0, 100 +64, kScreenW, kScreenH -100 -64);
    recardVC.dataSource = self.recordArr;
    [self.view addSubview:recardVC.view];
    [self addChildViewController:recardVC];
    [recardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.recardBtn.mas_bottom);
    }];
    if (self.recordArr.count == 0) {
        EmptyDataView *emptyView =[[EmptyDataView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64) AndImageStr:@"没有消息"];
        [recardVC.view addSubview:emptyView];
    }


}

- (void)btnClick:(UIButton *)sender{
    //从原来的按钮移除渐变色
    [self.gradientLayer removeFromSuperlayer];
    //添加新的渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"2feaeb"].CGColor, (__bridge id)[UIColor colorWithHexString:@"1ebeec"].CGColor];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kScreenW*0.5, 55*kiphone6H);
    [sender.layer insertSublayer:gradientLayer atIndex:0];
    //重新赋值
    self.gradientLayer = gradientLayer;
    
    [sender setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    if([sender.currentTitle isEqualToString:@"电子病历"]){
    
        [self.trendBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        UIViewController *vC = (UIViewController *)self.childViewControllers[0];
        UIViewController *vC2 = (UIViewController *)self.childViewControllers[1];
        vC.view.hidden = YES;
        vC2.view.hidden = NO;
    }else{
        [self.recardBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        
        UIViewController *vC = (UIViewController *)self.childViewControllers[0];
        UIViewController *vC2 = (UIViewController *)self.childViewControllers[1];
        vC.view.hidden = NO;
        vC2.view.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpRequestForRecord{
//    NSLog(@"asdasd%@",self.patientModel.info_id);
    [SVProgressHUD show];
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@id=%@",mRecardDetail,self.patientModel.info_id] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        if (NULL_TO_NIL(responseObject[@"result"]) ) {//不为空
            NSArray *arr = responseObject[@"result"];
            for (NSDictionary *dict in arr) {
                YYPatientRecordModel *patient = [YYPatientRecordModel mj_objectWithKeyValues:dict];
                [self.recordArr addObject:patient];
            }
//            //数据view
//            [self createDataView];
            
    }
        //数据view
        [self createDataView];
   
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}
//懒加载
-(NSMutableArray *)recordArr{
    if (_recordArr == nil) {
        _recordArr = [NSMutableArray array];
    }
    return _recordArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = true;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = false;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
