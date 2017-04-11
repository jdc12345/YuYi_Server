//
//  YYConnectViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYConnectViewController.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

@interface YYConnectViewController ()

@end

@implementation YYConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"连接设备";
    
    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [connectBtn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    connectBtn.backgroundColor = [UIColor colorWithHexString:@"25f368"];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    connectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.textColor = [UIColor colorWithHexString:@"999999"];
    promptLabel.font = [UIFont systemFontOfSize:15];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"扫描二维码连接设备";
    
    [self.view addSubview:connectBtn];
    [self.view addSubview:promptLabel];
    
    WS(ws);
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(115 *kiphone6 ,40 *kiphone6));
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(connectBtn.mas_top).with.offset(-15 *kiphone6);
        make.left.equalTo(ws.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW  ,15 *kiphone6));
    }];
    // Do any additional setup after loading the view.
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
