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

static NSString *cellId = @"cell_id";
@interface YYCardDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *tableView;
//发帖btn
@property(weak, nonatomic)UITextField *commentField;
//
@property(nonatomic,strong)NSMutableArray *commentInfos;
@end

@implementation YYCardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentInfos = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    [self setupUI];
}

- (void)setupUI {
    //添加右侧消息中心按钮
    UIImage *image = [UIImage imageNamed:@"share"];
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
    [shareBtn setBackgroundImage:image forState:UIControlStateNormal];
    [shareBtn sizeToFit];
    UIBarButtonItem *shareBtnItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [self.navigationItem setRightBarButtonItem:shareBtnItem];
    //tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 150;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[YYCommentTVCell class] forCellReuseIdentifier:cellId];

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
        return cell;
    }else{
        
        YYCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        return cell;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *commentLabel = [UILabel labelWithText:@"评论" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:12];
        [view addSubview:commentLabel];
        [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.equalTo(view);
        }];
        UILabel *countLabel = [UILabel labelWithText:@"65" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:12];
        [view addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentLabel.mas_right).offset(5);
            make.centerY.equalTo(view);
        }];
        return view;
 
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        return view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 0.00001f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001f;
    }else{
        return 44;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //搜索框
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height- 45, self.view.frame.size.width-40, 45)];
    [[UIApplication sharedApplication].keyWindow addSubview:headerView];
    //输入框
    UITextField *commentField = [[UITextField alloc]init];
    [headerView addSubview:commentField];
    [commentField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(10);
        make.left.right.top.bottom.offset(0);
    }];
    commentField.delegate = self;
    self.commentField = commentField;
    commentField.placeholder = @"说点什么吧";
    commentField.clearButtonMode = UITextFieldViewModeAlways;//删除内容的❎
    [commentField setBackgroundColor:[UIColor whiteColor]];
    //输入框左侧✏️
    UIImage *image = [UIImage imageNamed:@"writing"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [imageView sizeToFit];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width+10, imageView.frame.size.height)];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.bottom.offset(0);
    }];
    commentField.leftView = view;
    commentField.leftViewMode = UITextFieldViewModeAlways;
    //边框宽度
    [commentField.layer setBorderWidth:0.8];
    commentField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *searchString = [self.commentField text];
    [self.commentInfos addObject:searchString];
    [self.tableView reloadData];
    return true;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return true;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.commentField removeFromSuperview];
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
