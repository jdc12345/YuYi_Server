//
//  YYInfoCommentVC.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/7.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYInfoCommentVC.h"
#import "HttpClient.h"
#import "YYCommentInfoModel.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "YYCommentTVCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import "BRPlaceholderTextView.h"
#import "CcUserModel.h"


static NSString *cell_Id = @"cell_id";
@interface YYInfoCommentVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)NSMutableArray *commentInfoModels;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UILabel *praiseCountLabel;
@property(nonatomic,weak)UILabel *shareCountLabel;
@property(nonatomic,weak)UILabel *commentCountLabel;
@property(nonatomic,weak)UITableView *tableView;
//评论
@property(weak, nonatomic)BRPlaceholderTextView *commentField;

@property(nonatomic,weak)UIView *fieldBackView;
@end

@implementation YYInfoCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
//http://192.168.1.55:8080/yuyi/comment/getConmentAll.do?id=4&start=0&limit=6
- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/comment/getConmentAll.do?id=%@&start=0&limit=6",mPrefixUrl,self.info_id];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject[@"result"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            YYCommentInfoModel *infoModel = [YYCommentInfoModel mj_objectWithKeyValues:dic];
            [mArr addObject:infoModel];
        }
        self.commentInfoModels  = mArr;
        [self setUpUI];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)setUpUI {
   //tableView
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-45*kiphone6);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 120;
    tableView.showsVerticalScrollIndicator = false;
    tableView.showsHorizontalScrollIndicator = false;
    self.tableView = tableView;
    [tableView registerClass:[YYCommentTVCell class] forCellReuseIdentifier:cell_Id];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //评论框
    UIView *fieldBackView = [[UIView alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height- 45*kiphone6, self.view.frame.size.width-40*kiphone6, 45*kiphone6)];
    self.fieldBackView = fieldBackView;
    //键盘的Frame改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.view addSubview:fieldBackView];
    [self.view bringSubviewToFront:fieldBackView];
    //输入框
    BRPlaceholderTextView *commentField = [[BRPlaceholderTextView alloc]init];
    [fieldBackView addSubview:commentField];
    [commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    commentField.delegate = self;
    commentField.returnKeyType = UIReturnKeySend;
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
    }];
    //边框宽度
    [commentField.layer setBorderWidth:0.8];
    commentField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
}
- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    
//    if (!self.isSwitchKeyboard) {
        //从userInfo里面取出来键盘最终的位置
        NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
        
        CGRect rect = [rectValue CGRectValue];
        CGRect rectField = self.fieldBackView.frame;
        CGRect newRect = CGRectMake(rectField.origin.x, rect.origin.y - rectField.size.height-70*kiphone6, rectField.size.width, rectField.size.height) ;
        [UIView animateWithDuration:0.25 animations:^{
            self.fieldBackView.frame = newRect;
        }];
//    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        
        if (location != NSNotFound){
            
            [textView resignFirstResponder];
            
            }
        
        return NO;
        
        }  else if (location != NSNotFound){
            
        [textView resignFirstResponder];
    if (textView.text!=nil||![textView.text isEqualToString:@""]) {
        CcUserModel *userModel = [CcUserModel defaultClient];
        NSString *telePhoneNumber = userModel.telephoneNum;
        //            http://192.168.1.55:8080/yuyi/comment/AddConment.do?telephone=18782931355&content_id=1&Content=haha
        NSString *urlStr = [NSString stringWithFormat:@"%@/comment/AddConment.do?telephone=%@&content_id=%@&Content=%@",mPrefixUrl,telePhoneNumber,self.info_id,[textView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{

                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        //更新评论数据源
                        NSString *urlStr = [NSString stringWithFormat:@"%@/comment/getConmentAll.do?id=%@&start=0&limit=6",mPrefixUrl,self.info_id];
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
        YYCommentInfoModel *infoModel = [YYCommentInfoModel mj_objectWithKeyValues:dic];
        [mArr addObject:infoModel];
                }
        self.commentInfoModels  = mArr;
        NSInteger count = [self.commentCountLabel.text integerValue];
        count += 1;
        self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",count];//评论数加一
        [self.tableView reloadData];
        self.commentField.text = nil;
        self.commentField.placeholder = @"说点什么吧";
        self.commentField.imagePlaceholder = @"writing";

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
        }];
        }else{
        [self showAlertWithMessage:@"评论未成功，请稍后再试"];
        }
                    
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];

            }else{
                [self showAlertWithMessage:@"评论内容不能为空，请重新输入"];
            }
        return NO;
         }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
        //        textView.scrollEnabled = true;   // 允许滚动
    }
    else if(size.height>100*kiphone6){
        size.height=100*kiphone6;
    }
//    textView.scrollEnabled = false;   // 不允许滚动
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y-(size.height-frame.size.height), frame.size.width, size.height);
    textView.scrollEnabled = true;   // 允许滚动
}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma UITableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentInfoModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id forIndexPath:indexPath];
    cell.infoCommentModel = self.commentInfoModels[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self layoutSubViews:headerView];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 132*kiphone6;
}
-(void)layoutSubViews:(UIView *)headerView{
    UILabel *titlelabel = [UILabel labelWithText:self.infoDetailModel.title andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:15];
    titlelabel.numberOfLines = 3;
    [headerView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.right.offset(-85*kiphone6);
        make.centerY.equalTo(headerView);
    }];
    self.titleLabel = titlelabel;//标题
    UIView *line = [[UIView alloc]init];//上边分割线
    line.alpha = 0.6f;
    line.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100*kiphone6);
        make.left.right.equalTo(headerView);
        make.height.offset(1*kiphone6);
    }];
    UIView *userBar = [[UIView alloc]init];//底部工具栏
    userBar.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:userBar];
    [self.view bringSubviewToFront:userBar];
    [userBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.equalTo(headerView);
        make.height.offset(30*kiphone6);
    }];
    UIView *downLine = [[UIView alloc]init];//下边分割线
    downLine.alpha = 0.6f;
    downLine.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [headerView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userBar.mas_bottom);
        make.left.right.equalTo(headerView);
        make.height.offset(1*kiphone6);
    }];
    //赞次数
    NSString *praiseNum = self.infoDetailModel.likeNum?self.infoDetailModel.likeNum:@"0";
    UILabel *praiseCountLabel = [UILabel labelWithText:praiseNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [userBar addSubview:praiseCountLabel];
    self.praiseCountLabel = praiseCountLabel;
    //赞btn
    UIButton *praiseBtn = [[UIButton alloc]init];
    NSString *praiseImage = self.infoDetailModel.state?@"Info-heart-icon-select-":@"like";
    [praiseBtn setImage:[UIImage imageNamed:praiseImage] forState:UIControlStateNormal];
    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:praiseBtn];
    //分享次数
    //    表达式 ? 语句1 :语句2
    NSString *shareNum = self.infoDetailModel.shareNum?self.infoDetailModel.shareNum:@"0";
    UILabel *shareCountLabel = [UILabel labelWithText:shareNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [userBar addSubview:shareCountLabel];
    self.shareCountLabel = shareCountLabel;

    //分享btn
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"Info-share-icon-norm-"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:shareBtn];
    //回帖btn
    UIButton *repliesBtn = [[UIButton alloc]init];
    [repliesBtn setImage:[UIImage imageNamed:@"info-comment-icon-"] forState:UIControlStateNormal];
    [repliesBtn addTarget:self action:@selector(repliesPlus:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:repliesBtn];
    //回帖次数
    NSString *repliesNum = self.infoDetailModel.commentNum?self.infoDetailModel.commentNum:@"0";
    UILabel *repliesLabel = [UILabel labelWithText:repliesNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [userBar addSubview:repliesLabel];
    self.commentCountLabel = repliesLabel;
    //约束布局
    [praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBar);
        make.right.offset(-20*kiphone6);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBar);
        make.right.equalTo(praiseCountLabel.mas_left).offset(-5*kiphone6);
        make.width.height.offset(20*kiphone6);
    }];
    [shareCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBar);
        make.right.equalTo(praiseBtn.mas_left).offset(-18*kiphone6);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBar);
        make.right.equalTo(shareCountLabel.mas_left).offset(-5*kiphone6);
        make.width.height.offset(20*kiphone6);
    }];
   
    [repliesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBar);
        make.left.offset(20*kiphone6);
        make.width.height.offset(20*kiphone6);
    }];
    [repliesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBar);
        make.left.equalTo(repliesBtn.mas_right).offset(5*kiphone6);
    }];
    
}
#pragma - btnClick
- (void)praisePlus:(UIButton*)sender{
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSString *urlStr = [NSString stringWithFormat:@"%@/likes/UpdateLikeNum.do?id=%@&token=%@",mPrefixUrl,self.info_id,token];
    [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            
        }else{
            //点赞/删除未成功
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    NSInteger count = [self.praiseCountLabel.text integerValue];
    if (self.infoDetailModel.state) {
        count -= 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        self.infoDetailModel.state = false;
        self.infoDetailModel.likeNum = [NSString stringWithFormat:@"%ld",count];
    }else{
        count += 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        [sender setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
        self.infoDetailModel.state = true;
        self.infoDetailModel.likeNum = [NSString stringWithFormat:@"%ld",count];

    }
    
}
- (void)repliesPlus:(UIButton*)sender{
//    NSInteger count = [self.commentCountLabel.text integerValue];
//    count += 1;
//    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",count];
    
    
}
- (void)shareBtn:(UIButton*)sender{
//    NSInteger count = [self.shareCountLabel.text integerValue];
//    count += 1;
//    self.shareCountLabel.text = [NSString stringWithFormat:@"%ld",count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
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
