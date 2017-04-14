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
#import "CcUserModel.h"
#import <UShareUI/UShareUI.h>
static NSString *cellId = @"cell_id";
@interface YYCardDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
//发帖btn
@property(weak, nonatomic)BRPlaceholderTextView *commentField;
//
@property(nonatomic,strong)NSMutableArray *commentInfos;
//
@property(nonatomic,strong)YYCardDetailPageModel *infoModel;
@property(nonatomic,weak)UIView *headerView;
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
    [self loadData];
}
- (void)loadData{
//    http://192.168.1.55:8080/yuyi/academicpaper/academicpaperComment.do?start=0&limit=2&id=1
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSString *urlStr = [NSString stringWithFormat:@"%@/academicpaper/academicpaperComment.do?start=0&limit=2&id=%@&token=%@",mPrefixUrl,self.info_id,token];
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
//分享按钮点击事件
- (void)shareBtnClick{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        //        if (platformType == UMSocialPlatformType_Sina) {
        //            [self shareImageAndTextToPlatformType:platformType];
        //        }else{
        //            [self shareTextToPlatformType:platformType];
        //        }
        [self shareTextToPlatformType:platformType];
        
    }];
 
}
//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = self.infoModel.content;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
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
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
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
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)setupUI {
    //添加右侧分享按钮
    UIImage *image = [UIImage imageNamed:@"share"];
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:image forState:UIControlStateNormal];
    [shareBtn sizeToFit];
    UIBarButtonItem *shareBtnItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [self.navigationItem setRightBarButtonItem:shareBtnItem];
    //tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.offset(-20*kiphone6);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.estimatedRowHeight = 150;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    [tableView registerClass:[YYCommentTVCell class] forCellReuseIdentifier:cellId];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, CGFLOAT_MIN)];//解决group样式顶部留白问题
    //输入框背景
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height- 45*kiphone6, self.view.frame.size.width-40*kiphone6, 45*kiphone6)];
    [self.view addSubview:headerView];
    [self.view bringSubviewToFront:headerView];
    self.headerView = headerView;
    //键盘的Frame改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
        
    }];
    //边框宽度
    [commentField.layer setBorderWidth:0.8];
    commentField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;

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
//            http://192.168.1.55:8080/yuyi/comment/AddConment2.do?telephone=18782931355&content_id=1&Content=haha
            NSString *urlStr = [NSString stringWithFormat:@"%@/comment/AddConment2.do?telephone=%@&content_id=%@&Content=%@",mPrefixUrl,telePhoneNumber,self.info_id,[textView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    //更新评论数据源
                    //    http://192.168.1.55:8080/yuyi/academicpaper/academicpaperComment.do?start=0&limit=2&id=1
                    CcUserModel *model = [CcUserModel defaultClient];
                    NSString *token = model.userToken;
                    NSString *urlStr = [NSString stringWithFormat:@"%@/academicpaper/academicpaperComment.do?start=0&limit=2&id=%@&token=%@",mPrefixUrl,self.info_id,token];
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
                        [self.tableView reloadData];
                        self.commentField.text = nil;
                        
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
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
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
        UIView *line = [[UIView alloc]init];//分割线
        line.alpha = 0.6f;
        line.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(0.5*kiphone6);
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    //    if (!self.isSwitchKeyboard) {
    //从userInfo里面取出来键盘最终的位置
    NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rect = [rectValue CGRectValue];
    CGRect rectField = self.headerView.frame;
    CGRect newRect = CGRectMake(rectField.origin.x, rect.origin.y - rectField.size.height-70*kiphone6, rectField.size.width, rectField.size.height) ;
    [UIView animateWithDuration:0.25 animations:^{
        self.headerView.frame = newRect;
    }];
    //    }
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
