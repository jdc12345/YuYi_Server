//
//  ReciveAppointmentViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "ReciveAppointmentViewController.h"
//#import "YYHomeNewTableViewCell.h"
#import "YYRecardTableViewCell.h"
#import "YYDetailRecardViewController.h"
#import "RecardModel.h"
#import <MJExtension.h>
#import "YHPullDownMenu.h"
#import "AppointmentModel.h"
#import "DeparmentModel.h"

static NSInteger tempMon = 0;
@interface ReciveAppointmentViewController ()<UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *appointmentDataSource;//挂号数据源
@property (nonatomic, strong) NSMutableArray *dapartDataSource;//科室分类数据源
@property (nonatomic, strong) NSMutableArray *clinicDataSource;//门诊分类数据源
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, weak) UILabel *nameLabel;//科室门诊名字label
@property (nonatomic, weak) UILabel *dateLabel;//挂号时间label
@property(nonatomic,weak)UIPickerView *timePickerView;
@property(nonatomic,weak)UIToolbar * topView;//时间选择器工具栏
@property(nonatomic,weak)UIView *coverView;//时间选择器背景蒙布
@property(nonatomic,strong)NSArray *ampmArr;
@property(nonatomic,strong)NSMutableArray *dayArr;
@property(nonatomic,strong)NSMutableArray *monthArr;
@property(nonatomic,strong)NSString *day;
@property(nonatomic,strong)NSString *amPm;
@property(nonatomic,strong)NSString *month;
@property(nonatomic,strong)NSString *year;
//@property(nonatomic,strong)NSString *currentUrlStr;//当前数据请求的url
@end

@implementation ReciveAppointmentViewController


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.bounces = NO;
        // _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[YYRecardTableViewCell class] forCellReuseIdentifier:@"YYRecardTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        
//        [self createMeau];
        // [self.view sendSubviewToBack:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuView.mas_bottom);
            make.left.right.bottom.offset(0);
        }];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (NSMutableArray *)dapartDataSource{
    if (_dapartDataSource == nil) {
        _dapartDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dapartDataSource;
}
- (NSMutableArray *)appointmentDataSource{
    if (_appointmentDataSource == nil) {
        _appointmentDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _appointmentDataSource;
}
- (NSMutableArray *)clinicDataSource{
    if (_clinicDataSource == nil) {
        _clinicDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _clinicDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挂号接收";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //头部视图
    [self createMeau];
    //产生timePickerView数据
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.AMSymbol = @"上午";
    format.PMSymbol = @"下午";
    format.dateFormat = @"aaa";
    NSString *ampmStr = [format stringFromDate:now];
    self.dateLabel.text = [NSString stringWithFormat:@"%ld月%ld日%@",(long)month,(long)day,ampmStr];
    self.year = [NSString stringWithFormat:@"%ld",year];
    self.month = [NSString stringWithFormat:@"%ld",month];
    self.day = [NSString stringWithFormat:@"%ld",day];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDate *curDate = [calendar dateFromComponents:dateComponent];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    //设定时间取值范围两个月
    [comps2 setDay:31];
    if (month<11) {
        [comps2 setMonth:month+2];
        [comps2 setYear:year];
    }else if(month==11){
        [comps2 setMonth:1];
        [comps2 setYear:year+1];
    }else{
        [comps2 setMonth:2];
        [comps2 setYear:year+1];
    }
    NSDate *endDate = [calendar dateFromComponents:comps2];
    self.monthArr = [NSMutableArray array];
    self.dayArr = [NSMutableArray array];
    tempMon = month;
    [self.monthArr addObject:[NSString stringWithFormat:@"%ld",tempMon]];
    while([curDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]) //you can also use the earlier-method
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //月
        dateFormatter.dateFormat = @"MM";
        NSString *monStr = [dateFormatter stringFromDate:curDate];
        NSInteger mon = [monStr integerValue];
        if (mon > tempMon) {//确保每个月份只存一次
            tempMon = mon;
            [self.monthArr addObject:monStr];
        }
        //日
        dateFormatter.dateFormat = @"dd";
        NSString *dayStr = [dateFormatter stringFromDate:curDate];
        //        NSString *dayTitle = [NSString stringWithFormat:@"%@ %@",dayStr,weekDayStr];
        NSString *dayTitle = [NSString stringWithFormat:@"%@ ",dayStr];
        [self.dayArr addObject:dayTitle];
        curDate = [NSDate dateWithTimeInterval:86400 sinceDate:curDate];
    }

    [self httpRequest];
    [self httpRequestForDepartment];
    
    self.ampmArr = @[@"上午",@"下午"];
   
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        
//        NSString *urlStr = [NSString stringWithFormat:@"%@/academicpaper/academicpaperComment.do?start=0&limit=6&id=%@&token=%@",mPrefixUrl,self.info_id,mDefineToken];
//        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSDictionary *dic = responseObject[@"result"];
//            YYCardDetailPageModel *infoModel = [YYCardDetailPageModel mj_objectWithKeyValues:dic];
//            weakSelf.infoModel  = infoModel;//帖子数据
//            NSMutableArray *arr = [NSMutableArray array];
//            for (NSDictionary *dict in infoModel.commentList) {
//                YYCardCommentDetailModel *comModel = [YYCardCommentDetailModel mj_objectWithKeyValues:dict];
//                [arr addObject:comModel];
//            }
//            weakSelf.commentInfos = arr;//评论数据源
//            [weakSelf.tableView reloadData];
//            [weakSelf.tableView.mj_header endRefreshing];
//            if (weakSelf.commentInfos.count>0) {
//                start = weakSelf.commentInfos.count;
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [weakSelf.tableView.mj_header endRefreshing];
//            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
//            return ;
//        }];
//    }];
//    //设置上拉加载更多
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入加载状态后会自动调用这个block
//        if (weakSelf.commentInfos.count==0) {
//            [weakSelf.tableView.mj_footer endRefreshing];
//            return ;
//        }
//        if (start % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
//            [weakSelf.tableView.mj_footer endRefreshing];
//            return;
//        }
//        NSString *urlStr = [NSString stringWithFormat:@"%@/academicpaper/academicpaperComment.do?start=%ld&limit=6&id=%@&token=%@",mPrefixUrl,start,self.info_id,mDefineToken];
//        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            [weakSelf.tableView.mj_footer endRefreshing];
//            NSDictionary *dic = responseObject[@"result"];
//            YYCardDetailPageModel *infoModel = [YYCardDetailPageModel mj_objectWithKeyValues:dic];
//            weakSelf.infoModel  = infoModel;//帖子数据
//            NSMutableArray *arr = [NSMutableArray array];
//            for (NSDictionary *dict in infoModel.commentList) {
//                YYCardCommentDetailModel *comModel = [YYCardCommentDetailModel mj_objectWithKeyValues:dict];
//                [arr addObject:comModel];
//                [weakSelf.commentInfos addObject:comModel];
//            }
//            if (arr.count>0) {
//                [weakSelf.commentInfos addObjectsFromArray:arr];//评论数据源
//                start = weakSelf.commentInfos.count;
//                [weakSelf.tableView reloadData];
//                if (start % 6 != 0) {//显示没有更多数据了
//                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }else{
//                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            
//            //            if (weakSelf.commentInfos.count>0) {
//            //                start = weakSelf.commentInfos.count;
//            //            }
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [weakSelf.tableView.mj_footer endRefreshing];
//            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
//            return ;
//        }];
//    }];

}
- (void)createMeau{
    UIView *meauView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 86*kiphone6H)];
    meauView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:meauView];
    self.menuView = meauView;

    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    cardView.layer.shadowColor = [UIColor colorWithHexString:@"d5d5d5"].CGColor;
    cardView.layer.shadowRadius = 1 *kiphone6;
    cardView.layer.shadowOffset = CGSizeMake(1, 1);
    cardView.layer.shadowOpacity = 1;

    [meauView addSubview:cardView];

    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10*kiphone6H);
        make.left.offset(46*kiphone6);
        make.right.offset(-10*kiphone6);
        make.height.offset(30*kiphone6H);
    }];

    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"全部";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel = nameLabel;
    [cardView addSubview:nameLabel];

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView);
        make.left.offset(10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(100 , 13 ));
    }];

    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"Appointment_open"];
    [imageV sizeToFit];

    [cardView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView);
        make.right.offset(-10 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"科室";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    [meauView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView);
        make.left.offset(10 *kiphone6);
    }];
    
    //分割线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [meauView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(cardView.mas_bottom).offset(10*kiphone6H);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = @"X月X日X午";
    dateLabel.textColor = [UIColor colorWithHexString:@"333333"];
    dateLabel.font = [UIFont systemFontOfSize:15];
    self.dateLabel = dateLabel;
    [meauView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_bottom).offset(18*kiphone6H);
        make.left.offset(10 *kiphone6);
        //        make.size.mas_equalTo(CGSizeMake(100 , 13 ));
    }];
    
    UIButton *timeSelectBtn = [[UIButton alloc]init];
    [timeSelectBtn setImage:[UIImage imageNamed:@"Appointment_calendar"] forState:UIControlStateNormal];
    [meauView addSubview:timeSelectBtn];
    [timeSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateLabel);
        make.right.offset(-10 *kiphone6);
        //        make.size.mas_equalTo(CGSizeMake(30 , 13 ));
    }];
    [timeSelectBtn addTarget:self action:@selector(selectTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
    [cardView addGestureRecognizer:tapGest];
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppointmentModel *recardModel = self.dataSource[indexPath.row];
    YYDetailRecardViewController *detailRecardVC = [[YYDetailRecardViewController alloc]init];
    detailRecardVC.appointmentModel = recardModel;
    [self.navigationController pushViewController:detailRecardVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataSource.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85 *kiphone6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYRecardTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYRecardTableViewCell" forIndexPath:indexPath];
    AppointmentModel *recardModel = self.dataSource[indexPath.row];
    homeTableViewCell.model = recardModel;
    return homeTableViewCell;
}
#pragma mark - btnClick
- (void)headViewClick{
    YHPullDownMenu *pd=[[YHPullDownMenu alloc]initPullDownMenuWithItems:self.dapartDataSource clinicLisy:self.clinicDataSource cellHeight:30*kiphone6H menuFrame:CGRectMake(50, 144*kiphone6H, kScreenW -60, 300*kiphone6H) clickIndexHandle:^(NSInteger index ,NSInteger section) {
        if (index == -1) {
            self.nameLabel.text = self.dapartDataSource[section];
            [self httpRequestForSection:section];
        }else{
            self.nameLabel.text = self.clinicDataSource[section][index];
            [self httpRequestForClasses:index AndSection:section];
        }
    }];
    pd.backgroundColor=[UIColor clearColor];
    [pd show];
    //    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
    //    pInfoVC.personalModel = self.personalModel;
    //    [self.navigationController pushViewController:pInfoVC animated:YES];
}
//日期选择按钮点击事件
-(void)selectTimeBtnClick:(UIButton*)sender{
        if (!self.timePickerView) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
        //大蒙布View
        UIView *coverView = [[UIView alloc]init];
        coverView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        coverView.alpha = 0.3;
        [self.view.window addSubview:coverView];
        self.coverView = coverView;
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        coverView.userInteractionEnabled = YES;
        //添加tap手势：
        //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        //    [backView addGestureRecognizer:tapGesture];
        
        UIPickerView *pickView = [[UIPickerView alloc]init];
        [self.view.window addSubview:pickView];
        [self.view.window bringSubviewToFront:pickView];
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(215*kiphone6H);
        }];
        pickView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.showsSelectionIndicator = YES;
        self.timePickerView = pickView;
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 52*kiphone6H)];
        [topView setBarStyle:UIBarStyleDefault];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(2, 5, 50, 25);
        [closeBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
        UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *middelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        middelBtn.frame = CGRectMake(2, 5, 75, 25);
        //        [middelBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [middelBtn setTitle:@"就诊时间" forState:UIControlStateNormal];
//        self.nowSelectBtn = middelBtn;
        [middelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        UIBarButtonItem *titleBtn = [[UIBarButtonItem alloc]initWithCustomView:middelBtn];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 5, 50, 25);
        [btn addTarget:self action:@selector(conformDate) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
        NSArray * buttonsArray = [NSArray arrayWithObjects:cancleBtn,btnSpace1,titleBtn,btnSpace,doneBtn,nil];
        [topView setItems:buttonsArray];
        [self.view.window addSubview:topView];
        [self.view.window bringSubviewToFront:topView];
        self.topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.equalTo(pickView.mas_top);
            //            make.height.offset(200*kiphone6);
        }];
        
        //            设置初始默认值
        [self pickerView:self.timePickerView didSelectRow:0 inComponent:0];
        [self.timePickerView selectRow:0 inComponent:0 animated:true];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        format.AMSymbol = @"上午";
        format.PMSymbol = @"下午";
        format.dateFormat = @"aaa";
        NSString *timeStr = [format stringFromDate:now];
        if ([timeStr isEqualToString:@"上午"]) {
            [self pickerView:self.timePickerView didSelectRow:0 inComponent:2];
        }else{
            [self pickerView:self.timePickerView didSelectRow:1 inComponent:2];
        
            }
//        format.dateFormat = @"HH";
//        NSString *timeStr = [format stringFromDate:now];
//        NSInteger row = [timeStr integerValue];
//        [self pickerView:self.timePickerView didSelectRow:row inComponent:1];
//        [self.timePickerView selectRow:row inComponent:1 animated:true];
//        format.dateFormat = @"mm";
//        timeStr = [format stringFromDate:now];
//        row = [timeStr integerValue];
//        [self pickerView:self.timePickerView didSelectRow:row inComponent:2];
//        [self.timePickerView selectRow:row inComponent:2 animated:true];
    }
}
-(void)resignFirstResponderText {
    [self.view endEditing:true];
    [self.timePickerView removeFromSuperview];
    [self.coverView removeFromSuperview];
    [self.topView removeFromSuperview];
}
-(void)conformDate{
    NSString *selectTime = [NSString stringWithFormat:@"%@月%@日%@",self.month,self.day,self.amPm];
    self.dateLabel.text = selectTime;
    [self resignFirstResponderText];
}
#pragma mark - pickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
    {
        return self.monthArr.count;
    }else if (component == 1)
    {
        return self.dayArr.count;
    }else
    {
        return self.ampmArr.count;
    }
    
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return kScreenW*0.3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 70.0*kiphone6H;
    
}
// 返回选中的行内容
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        self.month = self.monthArr[row];
        
    }else if (component == 1){
        self.day = self.dayArr[row];
    }else if (component == 2){
        self.amPm = self.ampmArr[row];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        NSString *month = [NSString stringWithFormat:@"%@月",self.monthArr[row]];
        return month;
        
    } else if (component == 1){
        NSString *day = [NSString stringWithFormat:@"%@日",self.dayArr[row]];
        return day;
        
    }else {
        NSString *ampm = self.ampmArr[row];
        return ampm;
        
    }
    
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
//    if (component == 0) {
//        [label setText:[self.dayArr objectAtIndex:row]];
//        //    }else if (component == 1){
//        //        [label setText:[self.monthArr objectAtIndex:row]];
//    }
//    else if (component == 1){
//        [label setText:[NSString stringWithFormat:@"%@时",self.hourArr[row]]];
//    }
//    else if (component == 2){
//        [label setText:[NSString stringWithFormat:@"%@分",self.ampmArr[row]]];
//    }
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    return label;
//}
#pragma mark -
#pragma mark ------------Http client----------------------

- (void)httpRequest{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&start=0&limit=10",mAllAppointment,[CcUserModel defaultClient].userToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *rowArray = responseObject[@"rows"];
//        NSLog(@"%@",responseObject);
        for (NSDictionary *dict in rowArray) {
            
            AppointmentModel *recardModel = [AppointmentModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:recardModel];
        }
        if (self.dataSource.count != 0) {
            [self tableView];
        }
        
        //        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//科室门诊分类数据源
- (void)httpRequestForDepartment{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mDepartment,[CcUserModel defaultClient].userToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *rowArray = responseObject[@"result"];
        NSLog(@"%@",responseObject);
        for (NSDictionary *dict in rowArray) {
            DeparmentModel *recardModel = [DeparmentModel mj_objectWithKeyValues:dict];
            [self.appointmentDataSource addObject:recardModel];
            [self.dapartDataSource addObject:dict[@"departmentName"]];
            
            NSMutableArray *sectionList = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *clinicDict in recardModel.clinicList) {
                [sectionList addObject:clinicDict[@"clinicName"]];
            }
            [self.clinicDataSource addObject:sectionList];
        }
        NSLog(@"depart = %@  \n  clinic = %@",self.dapartDataSource,self.clinicDataSource);
        if (self.dapartDataSource.count != 0) {
            
        }
        [SVProgressHUD dismiss];
        
        //        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
//不同门诊的挂号数据源
- (void)httpRequestForClasses:(NSInteger )row
                   AndSection:(NSInteger )section{
    DeparmentModel *appointmentModel = self.appointmentDataSource[section];
    
    NSDictionary *clinicDict = appointmentModel.clinicList[row];
    //时间
    NSString *date = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
    NSInteger isAm = 0;
    if ([self.amPm isEqualToString:@"上午"]) {
        isAm = 1;
    }else{
        isAm = 0;
    }
    [SVProgressHUD show];
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&start=0&limit=10&departmentId=%@&clinicId=%@&visitTime=%@&isAm=%ld",mAllAppointment,mDefineToken,appointmentModel.info_id,clinicDict[@"id"],date,(long)isAm] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSArray *rowArray = responseObject[@"rows"];
                NSLog(@"%@",responseObject);
        [self.dataSource removeAllObjects];
        for (NSDictionary *dict in rowArray) {
            
            AppointmentModel *recardModel = [AppointmentModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:recardModel];
        }
        if (self.dataSource.count != 0) {
            [self tableView];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}- (void)httpRequestForSection:(NSInteger )section{
    DeparmentModel *appointmentModel = self.appointmentDataSource[section];

    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&start=0&limit=10&departmentId=%@",mAllAppointment,[CcUserModel defaultClient].userToken,appointmentModel.info_id] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *rowArray = responseObject[@"rows"];
        NSLog(@"%@",responseObject);
        [self.dataSource removeAllObjects];
        for (NSDictionary *dict in rowArray) {
            
            AppointmentModel *recardModel = [AppointmentModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:recardModel];
        }
        if (self.dataSource.count != 0) {
            [self tableView];
        }
        
        [self.tableView reloadData];
        
        //        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

@end
