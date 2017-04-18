//
//  learningCircleVC.m
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/27.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import "YYlearningCircleVC.h"
#import <Masonry.h>
#import "YYCardTableViewCell.h"
#import "YYCardDetailVC.h"
#import <MJRefresh.h>

@interface YYlearningCircleVC ()<UITableViewDelegate,UITableViewDataSource>


@end

static NSString *cellId = @"cell_id";
@implementation YYlearningCircleVC

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
    [tableView registerClass:[YYCardTableViewCell class] forCellReuseIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    cell.model = self.infos[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     YYCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YYCardDetailVC *cardVC = [[YYCardDetailVC alloc]initWithInfo:cell.model.info_id];
   
//    cardVC.info_id = cell.model.info_id;
    [self.navigationController pushViewController:cardVC animated:true];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150*kiphone6;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = false;

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
