//
//  YYPInfomartionViewController.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/10/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPInfomartionViewController.h"
#import "UIBarButtonItem+Helper.h"
#import <UIImageView+WebCache.h>

@interface YYPInfomartionViewController ()
@property (nonatomic, weak) UIImageView *iconV;

@end

@implementation YYPInfomartionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.title = @"个人信息";
    [self createSubView];
    // Do any additional setup after loading the view.
}
- (void)createSubView{
    //背景view
    NSArray *titleList  = @[@"姓        名",@"在职医院",@"科        室",@"职        称",@"手  机  号"];
    
    //头像
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    imageV.layer.cornerRadius = 50 *kiphone6;
    imageV.clipsToBounds = YES;
    
    self.iconV = imageV;
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(94 *kiphone6H);
        make.size.mas_equalTo(CGSizeMake(100 *kiphone6 ,100 *kiphone6));
    }];

    //textfield
    for (int i = 0; i < 5; i++) {
        UITextField *inputText = [[UITextField alloc]init];
        inputText.tag = i +200;
        inputText.layer.borderColor = [UIColor colorWithHexString:@"dfdfdf"].CGColor;
        inputText.layer.borderWidth = 0.5;
        inputText.layer.cornerRadius = 4;
        inputText.layer.masksToBounds = true;
        inputText.textColor = [UIColor colorWithHexString:@"333333"];
        inputText.font = [UIFont systemFontOfSize:14];
        //TextField内文字距左边框的内边距
        //方法1.设置左边视图的宽度
        inputText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 0)];
        //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
        inputText.leftViewMode = UITextFieldViewModeAlways;
        //方法2.
//        [inputText setValue:[NSNumber numberWithInt:20] forKey:@"paddingLeft"];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = titleList[i];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.view addSubview:inputText];
        [self.view addSubview:titleLabel];
        
        [inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(104 *kiphone6);
            make.top.equalTo(imageV.mas_bottom).offset(30*kiphone6H +i *69 *kiphone6H);
            make.size.mas_equalTo(CGSizeMake(kScreenW - 146 *kiphone6 ,30 *kiphone6H));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20 *kiphone6);
            make.centerY.equalTo(inputText.mas_centerY);
        }];
    }
    
    
    
    if (self.personalModel) {
        UITextField *textField1 = (UITextField *)[self.view viewWithTag:200];
        UITextField *textField2 = (UITextField *)[self.view viewWithTag:201];
        UITextField *textField3 = (UITextField *)[self.view viewWithTag:202];
        UITextField *textField4 = (UITextField *)[self.view viewWithTag:203];
        UITextField *textField5 = (UITextField *)[self.view viewWithTag:204];
        
        
        textField1.text = self.personalModel.trueName;
        textField2.text = self.personalModel.hospitalName;
        textField3.text = self.personalModel.departmentName;
        textField4.text = self.personalModel.title;
        
        if (![self.personalModel.telephone isEqualToString:@"0"]&&self.personalModel.telephone.length==11) {
//            textField5.secureTextEntry = YES;
            self.personalModel.telephone = [self.personalModel.telephone stringByReplacingCharactersInRange:NSMakeRange(3, 8) withString:@"********"];
            textField5.text = self.personalModel.telephone;
        }
        
        //添加头像
        if (![self.personalModel.avatar isEqualToString:@""]) {
            [self.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]]];
            
        }
        
    }
    
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
