//
//  YYInfoDetailVC.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYInfoDetailVC.h"
#import <Masonry.h>
#import "YYInformationVC.h"
#import "YYInformationTableViewCell.h"
#import "NSObject+Formula.h"
#import "UIColor+colorValues.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "YYInfoDetailModel.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import "CcUserModel.h"
#import "YYInfoCommentVC.h"
#import <UShareUI/UShareUI.h>
#import "CcUserModel.h"
@interface YYInfoDetailVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)YYInfoDetailModel *infoModel;
@property(nonatomic,weak)UILabel *praiseCountLabel;
@property(nonatomic,weak)UILabel *shareCountLabel;
@property(nonatomic,weak)UILabel *commentCountLabel;
@property(nonatomic,weak)UIButton *praiseBtn;
@end

@implementation YYInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
- (void)loadData {
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.55:8080/yuyi/doctorlyinformation/get.do?id=%@&token=%@",self.info_id,token];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
        self.infoModel  = infoModel;
        [self setUpUI];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
- (void)setUpUI {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64.5*kiphone6)];
    scrollView.delegate = self;
    scrollView.scrollEnabled = true;
    [self.view addSubview:scrollView];
    UIView *backView = [[UIView alloc]initWithFrame:scrollView.frame];
    [scrollView addSubview:backView];
    UIImageView *imageView = [[UIImageView alloc]init];
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.infoModel.picture];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    [backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(200*kiphone6);
    }];
    UILabel *titleLabel = [UILabel labelWithText:self.infoModel.title andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:15];
    titleLabel.numberOfLines = 2;
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(imageView.mas_bottom).offset(25);
        make.right.offset(-10);
    }];
    UILabel *contentLabel = [UILabel labelWithText:self.infoModel.content andTextColor:[UIColor colorWithHexString:@"666666"] andFontSize:13];
    contentLabel.numberOfLines = NSNotFound;
//    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [backView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.right.offset(-10*kiphone6);
    }];
    [backView layoutSubviews];
    scrollView.contentSize = CGSizeMake(kScreenW,contentLabel.frame.origin.y+contentLabel.frame.size.height+54*kiphone6);
    UIView *userBar = [[UIView alloc]init];//底部工具栏
    userBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userBar];
    [self.view bringSubviewToFront:userBar];
    [userBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(44.5*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//分割线
    line.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [userBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(userBar);
        make.height.offset(1);
    }];
    //分享btn
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"Info-share-icon-norm-"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:shareBtn];
    //分享次数
//    表达式 ? 语句1 :语句2
    NSString *shareNum = self.infoModel.shareNum?self.infoModel.shareNum:@"0";
    UILabel *shareCountLabel = [UILabel labelWithText:shareNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [userBar addSubview:shareCountLabel];
    self.shareCountLabel = shareCountLabel;
    //赞btn
    UIButton *praiseBtn = [[UIButton alloc]init];
    NSString *praiseImage = self.infoModel.state?@"Info-heart-icon-select-":@"like";
    [praiseBtn setImage:[UIImage imageNamed:praiseImage] forState:UIControlStateNormal];
    [praiseBtn addTarget:self action:@selector(praisePlus:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:praiseBtn];
    self.praiseBtn = praiseBtn;
    //赞次数
    NSString *praiseNum = self.infoModel.likeNum?self.infoModel.likeNum:@"0";
    UILabel *praiseCountLabel = [UILabel labelWithText:praiseNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [userBar addSubview:praiseCountLabel];
    self.praiseCountLabel = praiseCountLabel;
    //回帖btn
    UIButton *repliesBtn = [[UIButton alloc]init];
    [repliesBtn setImage:[UIImage imageNamed:@"info-comment-icon-"] forState:UIControlStateNormal];
    [repliesBtn addTarget:self action:@selector(repliesPlus:) forControlEvents:UIControlEventTouchUpInside];
    [userBar addSubview:repliesBtn];
    //回帖次数
    NSString *repliesNum = self.infoModel.commentNum?self.infoModel.commentNum:@"0";
    UILabel *repliesLabel = [UILabel labelWithText:repliesNum andTextColor:[UIColor colorWithHexString:@"999999"] andFontSize:12];
    [userBar addSubview:repliesLabel];
    self.commentCountLabel = repliesLabel;
    //约束布局
    [repliesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.bottom.offset(-12*kiphone6);
    }];
    [repliesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10*kiphone6);
        make.right.equalTo(repliesLabel.mas_left).offset(-5*kiphone6);
        make.height.width.offset(20*kiphone6);
    }];
    [praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(repliesBtn);
        make.right.equalTo(repliesBtn.mas_left).offset(-25*kiphone6);
    }];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(repliesBtn);
        make.right.equalTo(praiseCountLabel.mas_left).offset(-5*kiphone6);
        make.width.height.offset(20*kiphone6);
    }];
    [shareCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(repliesBtn);
        make.right.equalTo(praiseBtn.mas_left).offset(-25*kiphone6);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(repliesBtn);
        make.right.equalTo(shareCountLabel.mas_left).offset(-5*kiphone6);
        make.width.height.offset(20*kiphone6);
    }];

}
- (void)praisePlus:(UIButton*)sender{
    
    //   http://192.168.1.55:8080/yuyi/likes/UpdateLikeNum.do?id=1&token=nwslqlWbk/n5G5Slunydg4uZqhNeP62jUkZowKgPQxvQPCl3PhXaC0zhxG47a1v6SRJoyw9JGYAYhHnDJc+OtmKLXaGqhpXV
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
    if (self.infoModel.state) {
        count -= 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        self.infoModel.state = false;
        self.infoModel.likeNum = [NSString stringWithFormat:@"%ld",count];
            }else{
        count += 1;
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld",count];
        [sender setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
        self.infoModel.state = true;
        self.infoModel.likeNum = [NSString stringWithFormat:@"%ld",count];
                
    }
    
}
- (void)repliesPlus:(UIButton*)sender{

    YYInfoCommentVC *commentVC = [[YYInfoCommentVC alloc]init];
    commentVC.info_id = self.info_id;
    commentVC.infoDetailModel = self.infoModel;
    [self.navigationController pushViewController:commentVC animated:true];

}
- (void)shareBtn:(UIButton*)sender{
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
            NSInteger count = [self.shareCountLabel.text integerValue];
            count += 1;
            self.shareCountLabel.text = [NSString stringWithFormat:@"%ld",count];
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
            }
            NSString *urlStr = [NSString stringWithFormat:@"%@/share/AcademicpaperShare.do?id=%@&token=%@&shareType=%ld",mPrefixUrl,self.info_id,token,type];
            [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                //                NSArray *arr = responseObject[@"result"];
                NSLog(@"%@",responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.55:8080/yuyi/doctorlyinformation/get.do?id=%@&token=%@",self.info_id,token];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        YYInfoDetailModel *infoModel = [YYInfoDetailModel mj_objectWithKeyValues:dic];
        self.infoModel  = infoModel;
        self.shareCountLabel.text = self.infoModel.shareNum?self.infoModel.shareNum:@"0";
        self.praiseCountLabel.text = self.infoModel.likeNum?self.infoModel.likeNum:@"0";
        self.commentCountLabel.text = self.infoModel.commentNum?self.infoModel.commentNum:@"0";
        if (self.infoModel.state) {
            [self.praiseBtn setImage:[UIImage imageNamed:@"Info-heart-icon-select-"] forState:UIControlStateNormal];
        }else{
            [self.praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

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
