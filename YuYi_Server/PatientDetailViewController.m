//
//  PatientDetailViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "UIColor+Extension.h"
#import <Masonry.h>
#import "YYDataAnalyseViewController.h"
#import "RecardDerailViewController.h"

@interface PatientDetailViewController ()
@property (nonatomic, weak) UIButton *recardBtn;
@property (nonatomic, weak) UIButton *trendBtn;
@end

@implementation PatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createHeadView];
    [self createDataView];
    // Do any additional setup after loading the view.
}
- (void)createHeadView{
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 100 *kiphone6)];
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
    nameLabel.text = @"李美丽";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:15];
    //
    UILabel *idName = [[UILabel alloc]init];
    idName.text = @"性别：女";
    idName.textColor = [UIColor colorWithHexString:@"333333"];
    idName.font = [UIFont systemFontOfSize:12];
    
    
    UILabel *ageName = [[UILabel alloc]init];
    ageName.text = @"年龄：27岁";
    ageName.textColor = [UIColor colorWithHexString:@"333333"];
    ageName.font = [UIFont systemFontOfSize:12];
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:idName];
    [personV addSubview:ageName];
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV).with.offset(10);
        make.left.equalTo(personV).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(55 *kiphone6, 55 *kiphone6));
    }];
    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV).with.offset(10 *kiphone6);
        make.left.equalTo(iconV.mas_right).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(140 *kiphone6, 15 *kiphone6));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10 *kiphone6);
        make.left.equalTo(nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(260 *kiphone6, 12 *kiphone6));
    }];
    [ageName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idName.mas_bottom).with.offset(10 *kiphone6);
        make.left.equalTo(nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(260 *kiphone6, 12 *kiphone6));
    }];
    
    UIButton *recardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recardBtn.backgroundColor = [UIColor colorWithHexString:@"25f368"];
    [recardBtn setTitle:@"电子病历" forState:UIControlStateNormal];
    [recardBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [recardBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *trendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trendBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [trendBtn setTitle:@"患者数据" forState:UIControlStateNormal];
    [trendBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [trendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [personV addSubview:recardBtn];
    [personV addSubview:trendBtn];
    self.recardBtn = recardBtn;
    self.trendBtn = trendBtn;
    
    [recardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(personV).with.offset(0);
        make.left.equalTo(personV).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 25 *kiphone6));
    }];
    [trendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(personV).with.offset(0);
        make.left.equalTo(recardBtn.mas_right).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 25 *kiphone6));
    }];
    
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
    dataAnalyseVC.view.frame = CGRectMake(0, 100 +64, kScreenW, kScreenH -100 -64);
    [self.view addSubview:dataAnalyseVC.view];
    
    [self addChildViewController:dataAnalyseVC];
    
    
    RecardDerailViewController *recardVC = [[RecardDerailViewController alloc]init];
    recardVC.view.frame = CGRectMake(0, 100 +64, kScreenW, kScreenH -100 -64);
    [self.view addSubview:recardVC.view];
    [self addChildViewController:recardVC];
    

}

- (void)btnClick:(UIButton *)sender{
    if([sender.currentTitle isEqualToString:@"电子病历"]){
        self.recardBtn.backgroundColor = [UIColor colorWithHexString:@"25f368"];
        [self.recardBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        
        self.trendBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.trendBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        UIViewController *vC = (UIViewController *)self.childViewControllers[0];
        UIViewController *vC2 = (UIViewController *)self.childViewControllers[1];
        vC.view.hidden = YES;
        vC2.view.hidden = NO;
    }else{
        self.trendBtn.backgroundColor = [UIColor colorWithHexString:@"25f368"];
        [self.trendBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        
        self.recardBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.recardBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
