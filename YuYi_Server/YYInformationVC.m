//
//  YYInformationVC.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYInformationVC.h"
#import <Masonry.h>
#import "YYInformationTableViewCell.h"
#import "YYInfoDetailModel.h"
#import "YYInfoDetailVC.h"


static NSString *cellId = @"cell_id";
@interface YYInformationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation YYInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];

}
- (void)loadData {
    
    [self setupUI];
}

-(void)setInfos:(NSArray *)infos{
    _infos = infos;
    [self.tableView reloadData];
}
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 150;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[YYInformationTableViewCell class] forCellReuseIdentifier:cellId];
    
}
#pragma tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infos.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    YYInfoDetailModel *model = self.infos[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    YYInfoDetailVC *infoDetail = [[YYInfoDetailVC alloc]init];
    YYInfoDetailModel *model = self.infos[indexPath.row];
    infoDetail.info_id = model.info_id;
    [self.navigationController pushViewController:infoDetail animated:YES];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*kiphone6;
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
