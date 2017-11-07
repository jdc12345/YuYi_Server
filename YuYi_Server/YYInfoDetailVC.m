//
//  YYInfoDetailVC.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYInfoDetailVC.h"
#import "YYInformationVC.h"
#import "NSObject+Formula.h"
#import <MJExtension.h>
#import "YYInfoDetailModel.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Addition.h"
#import "YYInfoCommentVC.h"
#import <UShareUI/UShareUI.h>
#import "YYInfoCommentTVCell.h"
#import <MJRefresh.h>
#import "BRPlaceholderTextView.h"

static NSString *cell_Id = @"cell_id";
static NSInteger start = 0;
@interface YYInfoDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)YYInfoDetailModel *infoModel;
//@property(nonatomic,weak)UILabel *praiseCountLabel;
//@property(nonatomic,weak)UILabel *shareCountLabel;
@property(nonatomic,weak)UILabel *commentCountLabel;
//@property(nonatomic,weak)UIButton *praiseBtn;
@property(nonatomic,weak)UITableView *tableView;//评论
@property(nonatomic,strong)NSMutableArray *commentInfoModels;//评论数据
@property(nonatomic,strong)NSMutableDictionary *cellHeightCache;
//评论textField
@property(weak, nonatomic)BRPlaceholderTextView *commentField;
@property(nonatomic,weak)UIView *bottomBarView;

@end

@implementation YYInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
//加载资讯详情
- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/get.do?id=%@&token=%@",mPrefixUrl,self.info_id,mDefineToken];
    [SVProgressHUD show];// 动画开始
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
        self.infoModel  = infoModel;
        [SVProgressHUD dismiss];// 动画结束
        [self setUpUI];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

}
- (void)setUpUI {
    //tableView的headerView
    CGSize titleSize = [self.infoModel.title boundingRectWithSize:CGSizeMake(kScreenW-40*kiphone6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil].size;
    CGSize contentSize = [self.infoModel.content boundingRectWithSize:CGSizeMake(kScreenW-30*kiphone6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 189*kiphone6H+45*kiphone6H+titleSize.height+contentSize.height)];
    [self.view addSubview:backView];
    UIImageView *imageView = [[UIImageView alloc]init];
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.infoModel.picture];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    [backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(189*kiphone6H);
    }];
    UILabel *titleLabel = [UILabel labelWithText:self.infoModel.title andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:18];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(25*kiphone6H);
        make.height.offset(titleSize.height);
        make.centerX.offset(0);
        make.width.offset(kScreenW-40*kiphone6);
    }];
    UILabel *contentLabel = [UILabel labelWithText:self.infoModel.content andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:14];
    contentLabel.numberOfLines = 0;
    
//    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [backView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kiphone6);
        make.width.offset(kScreenW-30*kiphone6);
        make.top.equalTo(titleLabel.mas_bottom).offset(20*kiphone6H);
        make.height.offset(contentSize.height);
    }];

    //评论tableview
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
    [tableView registerClass:[YYInfoCommentTVCell class] forCellReuseIdentifier:cell_Id];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = backView;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *urlStr = [NSString stringWithFormat:@"%@/comment/getConmentAll.do?id=%@&start=0&limit=6",mPrefixUrl,weakSelf.info_id];
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCommentInfoModel *infoModel = [YYCommentInfoModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            weakSelf.commentInfoModels  = mArr;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            if (weakSelf.commentInfoModels.count>0) {
                start = weakSelf.commentInfoModels.count;
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
            return ;
        }];
    }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入加载状态后会自动调用这个block
        if (start % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@/comment/getConmentAll.do?id=%@&start=%ld&limit=6",mPrefixUrl,weakSelf.info_id,start];
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YYCommentInfoModel *infoModel = [YYCommentInfoModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            if (mArr.count>0) {
            [weakSelf.commentInfoModels addObjectsFromArray:mArr];
            [weakSelf.tableView reloadData];
            start = weakSelf.commentInfoModels.count;
                if (start % 6 != 0) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
            return ;
        }];
    }];
    //底部工具栏
    UIView *userBar = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height- 45*kiphone6H, kScreenW, 45*kiphone6H)];
    self.bottomBarView = userBar;
    userBar.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.view addSubview:userBar];
    [self.view bringSubviewToFront:userBar];
//    UIView *line = [[UIView alloc]init];//分割线
//    line.backgroundColor = [UIColor colorWithHexString:@"999999"];
//    [userBar addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(userBar);
//        make.height.offset(1);
//    }];
    //分享btn
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"share_infoDetail"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:shareBtn];
    //分享次数
//    表达式 ? 语句1 :语句2
//    NSString *shareNum = self.infoModel.shareNum?self.infoModel.shareNum:@"0";
//    UILabel *shareCountLabel = [UILabel labelWithText:shareNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
//    [userBar addSubview:shareCountLabel];
//    self.shareCountLabel = shareCountLabel;
//    //赞btn
//    UIButton *praiseBtn = [[UIButton alloc]init];
//    NSString *praiseImage = self.infoModel.state?@"Info-heart-icon-select-":@"like";
//    [praiseBtn setImage:[UIImage imageNamed:praiseImage] forState:UIControlStateNormal];
//    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
//    [userBar addSubview:praiseBtn];
//    self.praiseBtn = praiseBtn;
//    //赞次数
//    NSString *praiseNum = self.infoModel.likeNum?self.infoModel.likeNum:@"0";
//    UILabel *praiseCountLabel = [UILabel labelWithText:praiseNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
//    [userBar addSubview:praiseCountLabel];
//    self.praiseCountLabel = praiseCountLabel;
    //回帖btn
    UIButton *repliesBtn = [[UIButton alloc]init];
    [repliesBtn setImage:[UIImage imageNamed:@"comment_infoDetail"] forState:UIControlStateNormal];
    [repliesBtn addTarget:self action:@selector(repliesPlus:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:repliesBtn];
    //回帖次数
    NSString *repliesNum = self.infoModel.commentNum?self.infoModel.commentNum:@"0";
    UILabel *repliesLabel = [UILabel labelWithText:repliesNum andTextColor:[UIColor colorWithHexString:@"ffffff"] andFontSize:12];
    repliesLabel.layer.masksToBounds = true;
    repliesLabel.layer.cornerRadius = 4;
    repliesLabel.backgroundColor = [UIColor redColor];
    repliesLabel.textAlignment = NSTextAlignmentCenter;
    [userBar addSubview:repliesLabel];
    self.commentCountLabel = repliesLabel;
    //约束布局
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-10*kiphone6);
//        make.width.height.offset(20*kiphone6);
    }];
    [repliesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userBar.mas_right).offset(-(kScreenW-245*kiphone6)*0.5);
        make.centerY.offset(0);
//        make.height.width.offset(20*kiphone6);
    }];
    [repliesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(repliesBtn.mas_right).offset(-10);
        make.bottom.equalTo(repliesBtn.mas_top).offset(6);
        make.width.offset(20);
        make.height.offset(13);
    }];
    
    
//    [praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(repliesBtn);
//        make.right.equalTo(repliesBtn.mas_left).offset(-25*kiphone6);
//    }];
//    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(repliesBtn);
//        make.right.equalTo(praiseCountLabel.mas_left).offset(-5*kiphone6);
//        make.width.height.offset(20*kiphone6);
//    }];
//    [shareCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(repliesBtn);
//        make.right.equalTo(praiseBtn.mas_left).offset(-25*kiphone6);
//    }];
    //键盘的Frame改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //输入框
    BRPlaceholderTextView *commentField = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(10*kiphone6,5*kiphone6H, 235*kiphone6, 35*kiphone6H)];
    [userBar addSubview:commentField];
    commentField.delegate = self;
    commentField.returnKeyType = UIReturnKeySend;
    self.commentField = commentField;
    commentField.placeholder = @"写评论";
    commentField.imagePlaceholder = @"writing";
    commentField.font=[UIFont boldSystemFontOfSize:14];
    [commentField setBackgroundColor:[UIColor whiteColor]];
    [commentField setPlaceholderFont:[UIFont systemFontOfSize:15]];
    [commentField setPlaceholderColor:[UIColor colorWithHexString:@"999999"]];
    [commentField setPlaceholderOpacity:0.6];
    commentField.layer.cornerRadius = 17.5;
    commentField.layer.masksToBounds = true;
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
    //加载评论数据
    [self loadCommentDataData];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 500){
        
        if (location != NSNotFound){
            
            [textView resignFirstResponder];
        }
        return NO;
        
    }  else if (location != NSNotFound){
        
        [textView resignFirstResponder];
        if (textView.text!=nil&&![textView.text isEqualToString:@""]) {
            CcUserModel *userModel = [CcUserModel defaultClient];
            NSString *telePhoneNumber = userModel.telephoneNum;
            //            http://192.168.1.55:8080/yuyi/comment/AddConment.do?telephone=18782931355&content_id=1&Content=haha
            NSString *urlStr = [NSString stringWithFormat:@"%@/comment/AddConment.do?telephone=%@&content_id=%@&Content=%@",mPrefixUrl,telePhoneNumber,self.info_id,[textView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [SVProgressHUD show];// 动画开始
            [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    //更新评论数据源
                    NSString *urlStr = [NSString stringWithFormat:@"%@/comment/getConmentAll.do?id=%@&start=0&limit=6",mPrefixUrl,self.info_id];
                    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                        
                    } success:^(NSURLSessionDataTask *task, id responseObject) {
                        [SVProgressHUD dismiss];//结束动画
                        NSArray *arr = responseObject[@"result"];
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (NSDictionary *dic in arr) {
                            YYCommentInfoModel *infoModel = [YYCommentInfoModel mj_objectWithKeyValues:dic];
                            [mArr addObject:infoModel];
                        }
                        self.commentInfoModels  = mArr;
                        if (self.commentInfoModels.count>0) {
                            start = self.commentInfoModels.count;
                        }//更新加载起始位置
                        NSInteger count = [self.commentCountLabel.text integerValue];
                        count += 1;
                        self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",count];//评论数加一
                        [self.tableView reloadData];
                        self.commentField.text = nil;
                        self.commentField.placeholder = @"说点什么吧";
                        self.commentField.imagePlaceholder = @"writing";
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"评论已上传,请下拉刷新"];
                        return ;
                    }];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"评论未成功，请稍后再试"];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"评论未成功，请稍后再试"];
                return ;
            }];
            
        }else{
            [self showAlertWithMessage:@"评论内容不能为空，请重新输入"];
        }
        return NO;
    }
    return YES;
}
//键盘弹出、收回的通知
- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    //从userInfo里面取出来键盘最终的位置
    NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rect = [rectValue CGRectValue];
    CGRect rectField = self.bottomBarView.frame;
    CGRect newRect = CGRectMake(rectField.origin.x, rect.origin.y - rectField.size.height-64*kiphone6, rectField.size.width, rectField.size.height) ;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomBarView.frame = newRect;
    }];
    
}
//评论输入内容变化的代理
-(void)textViewDidChange:(UITextView *)textView{
 
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<35*kiphone6) {
        size.height = 35*kiphone6;
    }
    textView.scrollEnabled = false;   // 不允许滚动
    //背景view
    CGRect bottomFrame = self.bottomBarView.frame;
    self.bottomBarView.frame = CGRectMake(bottomFrame.origin.x, bottomFrame.origin.y-(size.height-frame.size.height), bottomFrame.size.width, size.height+10*kiphone6H);
    
    //textview
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
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
    YYInfoCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id forIndexPath:indexPath];
    cell.infoCommentModel = self.commentInfoModels[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *title = [UILabel labelWithText:@"评论" andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:15];
    [headerView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kiphone6);
        make.top.offset(0);
    }];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*kiphone6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYCommentInfoModel *comModel = self.commentInfoModels[indexPath.row];
    NSString *thisId =comModel.info_id;
    CGFloat cacheHeight = [[self.cellHeightCache valueForKey:thisId] doubleValue];
    if (cacheHeight) {
        return cacheHeight;
    }
    YYInfoCommentTVCell *commentCell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    commentCell.infoCommentModel = comModel;
    [self.cellHeightCache setValue:@(commentCell.cellHeight) forKey:thisId];
    //    NSLog(@"%@",self.cellHeightCache);
    return commentCell.cellHeight;
    
}
#pragma 懒加载
-(NSMutableDictionary *)cellHeightCache{
    if (_cellHeightCache == nil) {
        _cellHeightCache = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightCache;
}
-(NSMutableArray *)commentInfoModels{
    if (_commentInfoModels == nil) {
        _commentInfoModels = [[NSMutableArray alloc]init];
    }
    return _commentInfoModels;
}
//加载评论数据
- (void)loadCommentDataData {
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
        if (self.commentInfoModels.count>0) {
            start = self.commentInfoModels.count;
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载评论数据失败"];
        return ;
    }];
}
//- (void)praisePlus:(UIButton*)sender{
//    
//    //   http://192.168.1.55:8080/yuyi/likes/UpdateLikeNum.do?id=1&token=nwslqlWbk/n5G5Slunydg4uZqhNeP62jUkZowKgPQxvQPCl3PhXaC0zhxG47a1v6SRJoyw9JGYAYhHnDJc+OtmKLXaGqhpXV
//    CcUserModel *model = [CcUserModel defaultClient];
//    NSString *token = model.userToken;
//    NSString *urlStr = [NSString stringWithFormat:@"%@/likes/UpdateLikeNum.do?id=%@&token=%@",mPrefixUrl,self.info_id,token];
//    [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//            
//        }else{
//            //点赞/删除未成功
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    NSInteger count = [self.praiseCountLabel.text integerValue];
//    if (self.infoModel.state) {
//        count -= 1;
//        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
//        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//        self.infoModel.state = false;
//        self.infoModel.likeNum = [NSString stringWithFormat:@"%ld",count];
//            }else{
//        count += 1;
//        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
//        [sender setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
//        self.infoModel.state = true;
//        self.infoModel.likeNum = [NSString stringWithFormat:@"%ld",count];
//                
//    }
//    
//}
- (void)repliesPlus:(UIButton*)sender{
    if (self.commentInfoModels.count > 0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }else{
        [SVProgressHUD showInfoWithStatus:@"这篇资讯还没有评论，你可以成为第一个哦"];
    }
    
//原来的咨询详情页面
//    YYInfoCommentVC *commentVC = [[YYInfoCommentVC alloc]init];
//    commentVC.info_id = self.info_id;
//    commentVC.infoDetailModel = self.infoModel;
//    [self.navigationController pushViewController:commentVC animated:true];

}
- (void)shareBtn:(UIButton*)sender{
    [self.commentField resignFirstResponder];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if (platformType == UMSocialPlatformType_Sina) {
            [self shareTextToPlatformType:platformType];
        }else{
            [self shareWebPageToPlatformType:platformType];
        }
//        [self shareTextToPlatformType:platformType];
        
    }];

}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.infoModel.picture];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.infoModel.title descr:self.infoModel.content thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://59.110.169.148:8080/static/html/sharejump.html";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [SVProgressHUD show];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"分享出了错误"];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD dismiss];
}
//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = self.infoModel.content;
    [SVProgressHUD show];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"分享出了错误"];
        }else{
            NSLog(@"response data is %@",data);
//            NSInteger count = [self.shareCountLabel.text integerValue];
//            count += 1;
//            self.shareCountLabel.text = [NSString stringWithFormat:@"%ld",count];
//        http://192.168.1.55:8080/yuyi/share/AcademicpaperShare.do?id=1&token=CEDA9F4E7D5FEC556E1BB035FA18E54E&shareType=1
            CcUserModel *userModel = [CcUserModel defaultClient];
            NSString *token = userModel.userToken;
            NSInteger type;
            if (platformType == UMSocialPlatformType_WechatTimeLine) {
                type = 1;
            }else if (platformType == UMSocialPlatformType_Sina){
                type = 2;
            }else if (platformType == UMSocialPlatformType_Qzone){
                type = 3;
            }else{
                type = 0;
            }
            NSString *urlStr = [NSString stringWithFormat:@"%@/share/AcademicpaperShare.do?id=%@&token=%@&shareType=%ld",mPrefixUrl,self.info_id,token,type];
            [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                //                NSArray *arr = responseObject[@"result"];
                NSLog(@"%@",responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                return ;
            }];
            [SVProgressHUD dismiss];
        }
    }];
}
//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:@"https://mobile.umeng.com/images/pic/home/social/img-1.png"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [SVProgressHUD show];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"分享出了错误"];
        }else{
            NSLog(@"response data is %@",data);
            [SVProgressHUD dismiss];
        }
    }];
}
//分享图文（新浪支持，微信/QQ仅支持图或文本分享）
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = self.infoModel.content;
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.infoModel.picture]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [SVProgressHUD show];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"分享出了错误"];
        }else{
            NSLog(@"response data is %@",data);
            [SVProgressHUD dismiss];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSString *urlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/get.do?id=%@&token=%@",mPrefixUrl,self.info_id,token];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
        self.infoModel  = infoModel;
//        self.shareCountLabel.text = self.infoModel.shareNum?self.infoModel.shareNum:@"0";
//        self.praiseCountLabel.text = self.infoModel.likeNum?self.infoModel.likeNum:@"0";
        self.commentCountLabel.text = self.infoModel.commentNum?self.infoModel.commentNum:@"0";
//        if (self.infoModel.state) {
//            [self.praiseBtn setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
//        }else{
//            [self.praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//            
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
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
