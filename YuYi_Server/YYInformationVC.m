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
#import <MJRefresh.h>

static NSString *cellId = @"cell_id";

@interface YYInformationVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YYInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];

}
- (void)loadData {
    
    [self setupUI];
}

-(void)setInfos:(NSMutableArray *)infos{
    _infos = infos;
    [self.tableView reloadData];
}
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (self.delegate && [self.delegate respondsToSelector:@selector(transViewController:)]) {
            //代理存在且有这个transButIndex:方法
            [weakSelf.delegate transViewController:self];
        }
    }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        if (self.delegate && [self.delegate respondsToSelector:@selector(transForFootRefreshWithViewController:)]) {
            //代理存在且有这个transButIndex:方法
            [weakSelf.delegate transForFootRefreshWithViewController:self];
        }
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 150;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[YYInformationTableViewCell class] forCellReuseIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 105*kiphone6H;
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
