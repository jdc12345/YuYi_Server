//
//  YYChatListViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/7.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYChatListViewController.h"

@interface YYChatListViewController ()

@end

@implementation YYChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"咨询";
    // Do any additional setup after loading the view.
}

//- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
//    
//}
//- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
//- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    
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
