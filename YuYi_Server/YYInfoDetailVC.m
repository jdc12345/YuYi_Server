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

@interface YYInfoDetailVC ()

@end

@implementation YYInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
- (void)loadData {
    
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
