//
//  RecardDerailViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "RecardDerailViewController.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

@interface RecardDerailViewController ()

@end

@implementation RecardDerailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubView];
    // Do any additional setup after loading the view.
}

- (void)createSubView{
    
    UILabel *marryLabel = [[UILabel alloc]init];
    marryLabel.text = @"民族：汉族";
    marryLabel.textColor = [UIColor colorWithHexString:@"333333"];
    marryLabel.font = [UIFont systemFontOfSize:12];
    
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = @"病理采集日期：2017-01-12";
    dateLabel.textColor = [UIColor colorWithHexString:@"333333"];
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:marryLabel];
    [self.view addSubview:dateLabel];
    
    [marryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(8);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(marryLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    
    UILabel *topLine = [[UILabel alloc]init];
    topLine.backgroundColor = [UIColor colorWithHexString:@"d6d6d6"];
    
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"d6d6d6"];
    
    [self.view addSubview:bottomLine];
    [self.view addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(28);
        make.left.equalTo(self.view).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1 *kiphone6));
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom).with.offset(28);
        make.left.equalTo(self.view).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1 *kiphone6));
    }];
    
    
    
    // 现病史
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"现病史";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:13];
    //
    
    UITextView *textView = [[UITextView alloc]init];
    textView.text = @"哦啊司机都 i 啊摔手机哦大家啊 iOS 的剧情我觉得期望；离开你们是来看你了；阿克苏呢； 哦 i 请叫我就去问你妈送哦 i 却忘记哦教练卡数据来看";
    textView.textColor = [UIColor colorWithHexString:@"666666"];
    textView.font = [UIFont systemFontOfSize:13];
    textView.editable = NO;
    textView.layer.borderColor = [UIColor colorWithHexString:@"d6d6d6"].CGColor;
    textView.layer.borderWidth = 0.5;
    
    
    
    [self.view addSubview:textView];
    [self.view addSubview:nameLabel];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLine.mas_bottom).with.offset(19 *kiphone6);
        make.left.equalTo(self.view).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(140 *kiphone6, 13));
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10 *kiphone6);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 280 *kiphone6));
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
