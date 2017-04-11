//
//  YYCardDetailVC.m
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/29.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import "YYCardDetailVC.h"
#import <Masonry.h>
#import "YYCardDetailTVCell.h"
#import "YYCommentTVCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import "BRPlaceholderTextView.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "YYCardDetailPageModel.h"
#import "YYCardCommentDetailModel.h"

static NSString *cellId = @"cell_id";
@interface YYCardDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
//发帖btn
@property(weak, nonatomic)BRPlaceholderTextView *commentField;
//
@property(nonatomic,strong)NSMutableArray *commentInfos;
//
@property(nonatomic,strong)YYCardDetailPageModel *infoModel;
@end

@implementation YYCardDetailVC
-(instancetype)initWithInfo:(NSString*)info_id{
    if (self = [super init]) {
        self.info_id = info_id;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"帖子详情";
//    self.commentInfos = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    [self loadData];
}
- (void)loadData{
//    http://192.168.1.55:8080/yuyi/academicpaper/academicpaperComment.do?start=0&limit=2&id=1
    NSString *urlStr = [NSString stringWithFormat:@"%@/academicpaper/academicpaperComment.do?start=0&limit=2&id=%@",mPrefixUrl,self.info_id];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject[@"result"];
        YYCardDetailPageModel *infoModel = [YYCardDetailPageModel mj_objectWithKeyValues:dic];
        self.infoModel  = infoModel;//帖子数据
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in infoModel.commentList) {
            YYCardCommentDetailModel *comModel = [YYCardCommentDetailModel mj_objectWithKeyValues:dict];
            [arr addObject:comModel];
        }
        self.commentInfos = arr;//评论数据源
        [self setupUI];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    }
- (void)setupUI {
    //添加右侧消息中心按钮
    UIImage *image = [UIImage imageNamed:@"share"];
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
    [shareBtn setBackgroundImage:image forState:UIControlStateNormal];
    [shareBtn sizeToFit];
    UIBarButtonItem *shareBtnItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [self.navigationItem setRightBarButtonItem:shareBtnItem];
    //tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 150;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[YYCommentTVCell class] forCellReuseIdentifier:cellId];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, CGFLOAT_MIN)];//解决group样式顶部留白问题

}
#pragma tableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.commentInfos.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YYCardDetailTVCell *cell = [[YYCardDetailTVCell alloc]init];
        cell.infoModel = self.infoModel;
        return cell;
    }else{
        YYCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        cell.comModel = self.commentInfos[indexPath.row];
        return cell;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44*kiphone6)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *commentLabel = [UILabel labelWithText:@"评论" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:12];
        [view addSubview:commentLabel];
        [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20*kiphone6);
            make.centerY.equalTo(view);
        }];
        UILabel *countLabel = [UILabel labelWithText:self.infoModel.commentNum andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:12];
        [view addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentLabel.mas_right).offset(5*kiphone6);
            make.centerY.equalTo(view);
        }];
        return view;
 
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5*kiphone6)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        return view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5*kiphone6;
    }else{
        return 0.00001f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001f;
    }else{
        return 44*kiphone6;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //搜索框
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height- 45, self.view.frame.size.width-40, 45)];
    [self.view addSubview:headerView];
    [self.view bringSubviewToFront:headerView];
    //输入框
    BRPlaceholderTextView *commentField = [[BRPlaceholderTextView alloc]init];
    [headerView addSubview:commentField];
    [commentField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(10);
    make.left.right.top.bottom.offset(0);
    }];
    commentField.returnKeyType = UIReturnKeySend;
    commentField.delegate = self;
    self.commentField = commentField;
    commentField.placeholder = @"说点什么吧";
    commentField.imagePlaceholder = @"writing";
    commentField.font=[UIFont boldSystemFontOfSize:14];
    [commentField setBackgroundColor:[UIColor whiteColor]];
    [commentField setPlaceholderFont:[UIFont systemFontOfSize:15]];
    [commentField setPlaceholderColor:[UIColor colorWithHexString:@"999999"]];
    [commentField setPlaceholderOpacity:0.6];
    [commentField addMaxTextLengthWithMaxLength:200 andEvent:^(BRPlaceholderTextView *text) {
        [self.commentField endEditing:YES];
        
        NSLog(@"----------");
    }];
    
    [commentField addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    
    [commentField addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"end");
//        if (!text.text) {
//            self.commentField.frame = CGRectMake(0,0, self.view.frame.size.width-40, 45);
//        }
        
    }];
    //边框宽度
    [commentField.layer setBorderWidth:0.8];
    commentField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma textView
-(void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
        //        textView.scrollEnabled = true;   // 允许滚动
    }else if(size.height>100*kiphone6){
        size.height=100*kiphone6;
        }
    //    textView.scrollEnabled = false;   // 不允许滚动
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y-(size.height-frame.size.height), frame.size.width, size.height);
    textView.scrollEnabled = true;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.commentField removeFromSuperview];
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
