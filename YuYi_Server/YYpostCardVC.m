//
//  YYpostCardVC.m
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/30.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import "YYpostCardVC.h"
#import "UIColor+colorValues.h"
#import <Masonry.h>
#import "BRPlaceholderTextView.h"
#import "UILabel+Addition.h"
#import "HUImagePickerViewController.h"
#import "YYCardPostPictureCell.h"
#import "AFNetworking.h"
#import "CcUserModel.h"
static NSString *cell_id = @"cell_id";
@interface YYpostCardVC ()<UITextViewDelegate,HUImagePickerViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property(nonatomic,weak)BRPlaceholderTextView *titleView;
@property(nonatomic,weak)BRPlaceholderTextView *contentView;
@property(nonatomic,weak)UIButton *addPictureBtn;
@property(nonatomic,weak)UILabel *addPictureLabel;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIView *lineTwo;

@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, strong) UIImage *chooseImage;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@end

@implementation YYpostCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.title = @"发帖";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
}
- (void)uploadCardInfos:(UIButton*)btn{
    CcUserModel *model = [CcUserModel defaultClient];
    NSString *token = model.userToken;
    NSDictionary *dic = @{@"token":token,@"title":self.titleView.text,@"content":self.contentView.text};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    //添加服务器需要你传的参数 params /academicpaper/AddAcademicpaper.do?token=EA62E69E02FABA4E4C9A0FDC1C7CAE10&title=test&content=test&images=
    NSString *urlStr = [NSString stringWithFormat:@"%@/academicpaper/AddAcademicpaper.do?token=%@",mPrefixUrl,token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //  图片上传
        for (NSInteger i = 0; i < self.imageArr.count; i ++) {
            UIImage *images = self.imageArr[i];
            NSData *picData = UIImageJPEGRepresentation(images, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
            [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"uploadFile%ld",(long)i] fileName:fileName mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
       NSString *message = responseObject[@"message"];
        [message stringByRemovingPercentEncoding];
        NSLog(@"宝宝头像上传== %@,%@", responseObject,message);
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [self showSuccessAlertWithMessage:@"已上传成功，你可以在学术圈最新帖子处查看"];
        }else{
            [self showAlertWithMessage:[NSString stringWithFormat:@"上传失败:%@",message]];
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息=====%@", error.description);
        [self showAlertWithMessage:@"上传失败"];
    }];
//    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        //拼接图片
//        [self.imageArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            NSData *imageData = UIImagePNGRepresentation(image);
//            
//            if (imageData.length >= 1024 * 1024) {
//                //因为我们服务器有限制1M以内   所以我超过1M的进行压缩了
////                imageData = [image resetSizeOfImageData:image maxSize:1000];
//                [formData appendPartWithFileData:imageData name:@"kinta" fileName:@"kinta.jpg" mimeType:@"image/jpg"];
//            }else{
//                
//                [formData appendPartWithFileData:imageData name:@"kinta" fileName:@"kinta.png" mimeType:@"image/png"];
//            }
//            
//        }];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        // 回到主队列刷新UI,用户自定义的进度条
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [SVProgressHUD showProgress:1.0 *
////             uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
//        });
//        
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"上传成功 %@", responseObject);
//        
//        id datalist = responseObject[@"datalist"];
//        
//        NSLog(@"%@",datalist);
//    }else{
//
//    }
//     
//     
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         
//         NSLog(@"上传失败 %@", error);
////         [SVProgressHUD dismiss];
//     }];
    
}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)showSuccessAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setupUI {
    //添加右侧发布按钮
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30*kiphone6, 30*kiphone6)];
    [postBtn setTitle:@"发布" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"25f368"] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [postBtn sizeToFit];
    UIBarButtonItem *postBtnItem = [[UIBarButtonItem alloc]initWithCustomView:postBtn];
    [self.navigationItem setRightBarButtonItem:postBtnItem];
    [postBtn addTarget:self action:@selector(uploadCardInfos:) forControlEvents:UIControlEventTouchUpInside];
    //
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    //    backView.contentSize = self.view.frame.size;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    //    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.bottom.offset(0);
    //    }];
    //    [backView layoutIfNeeded];
    UIView *backView = [[UIView alloc]initWithFrame:self.view.frame];
    [scrollView addSubview:backView];
    //添加标题feild
    //输入框
    BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
    [backView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.bottom.equalTo(backView.mas_top).offset(55*kiphone6);
        make.right.offset(-20*kiphone6);
        make.height.offset(35*kiphone6);
    }];
    [titleView layoutIfNeeded];
    //    titleView.delegate = self;
    self.titleView = titleView;
    titleView.placeholder = @"标题 (不超过20个字)";
    titleView.imagePlaceholder = @"title";
    titleView.font=[UIFont boldSystemFontOfSize:14];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [titleView setPlaceholderFont:[UIFont systemFontOfSize:15]];
    [titleView setPlaceholderColor:[UIColor colorWithHexString:@"6a6a6a"]];
    //    titleField.borderStyle = UITextBorderStyleNone;
    //    //边框宽度
    //    [titleField.layer setBorderWidth:0.01f];
    [titleView setPlaceholderOpacity:0.6];
    [titleView addMaxTextLengthWithMaxLength:20 andEvent:^(BRPlaceholderTextView *text) {
        [self.titleView endEditing:YES];
        
        NSLog(@"----------");
    }];
    
    [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    
    [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"end");
    }];
    //line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
        make.top.equalTo(titleView.mas_bottom);
        make.height.offset(1);
    }];
    [line layoutIfNeeded];
    //添加内容textView
    //输入框
    BRPlaceholderTextView *contentView = [[BRPlaceholderTextView alloc]init];
    [backView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(line.mas_bottom);
        make.right.offset(-20*kiphone6);
        make.height.offset(110*kiphone6);
    }];
    [contentView layoutIfNeeded];
    contentView.textAlignment = NSTextAlignmentLeft;
    contentView.delegate = self;
    self.contentView = contentView;
    contentView.textContainerInset = UIEdgeInsetsMake(8*kiphone6,0, 0, 0);
    contentView.placeholder = @"输入内容";
    contentView.imagePlaceholder = @"content";
    contentView.font=[UIFont boldSystemFontOfSize:13];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setPlaceholderFont:[UIFont systemFontOfSize:13]];
    [contentView setPlaceholderColor:[UIColor colorWithHexString:@"6a6a6a"]];
    [contentView setPlaceholderOpacity:0.6];
    [contentView addMaxTextLengthWithMaxLength:2000 andEvent:^(BRPlaceholderTextView *text) {
        [self.view endEditing:YES];
        
        NSLog(@"----------");
    }];
    
    [contentView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    
    [contentView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"end");
    }];
    //line
    //    UIView *lineTwo = [[UIView alloc]init];
    //    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    //    [backView addSubview:lineTwo];
    //    self.lineTwo = lineTwo;
    //    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset(20*kiphone6);
    //        make.right.offset(-20*kiphone6);
    //        make.top.equalTo(contentView.mas_bottom).offset(8*kiphone6);
    //        make.height.offset(1);
    //    }];
    //    [line layoutIfNeeded];
    UITableView *tableView = [[UITableView alloc]init];
    [backView addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
        make.top.equalTo(contentView.mas_bottom);
        make.width.height.offset(0);
    }];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YYCardPostPictureCell class] forCellReuseIdentifier:cell_id];
    //添加图片
    UIButton *addPictureBtn = [[UIButton alloc]init];
    [addPictureBtn setImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
    [backView addSubview:addPictureBtn];
    self.addPictureBtn = addPictureBtn;
    [addPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(tableView.mas_bottom).offset(50*kiphone6);
        make.width.height.offset(100*kiphone6);
    }];
    [addPictureBtn addTarget:self action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
    //添加图片label
    UILabel *addPictureLabel = [UILabel labelWithText:@"添加图片" andTextColor:[UIColor colorWithHexString:@"cccccc"] andFontSize:15];
    [backView addSubview:addPictureLabel];
    self.addPictureLabel = addPictureLabel;
    [addPictureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addPictureBtn.mas_right).offset(20*kiphone6);
        make.centerY.equalTo(addPictureBtn);
    }];
    
}
#pragma UItableViewDelegate/UItableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self textViewDidChange:self.contentView];
    return self.imageArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCardPostPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    cell.image = self.imageArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenW;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该图片？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.imageArr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [self.tableView reloadData];
    
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
        //        textView.scrollEnabled = true;   // 允许滚动
    }
    //    else{
    //    }
    textView.scrollEnabled = false;   // 不允许滚动
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [self.addPictureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addPictureBtn);
    }];
    //    self.lineTwo.frame = CGRectMake(frame.origin.x, frame.origin.y+size.height, frame.size.width, 1);
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y+size.height, frame.size.width, self.imageArr.count*kScreenW);
    self.addPictureBtn.frame = CGRectMake(frame.origin.x, self.tableView.frame.origin.y+self.imageArr.count*kScreenW+10*kiphone6, 100*kiphone6, 100*kiphone6);
    CGRect labelFrame = self.addPictureLabel.frame;
    self.addPictureLabel.frame = CGRectMake(frame.origin.x+120, self.addPictureBtn.frame.origin.y+45*kiphone6, labelFrame.size.width, labelFrame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, kScreenH-frame.size.height+size.height+self.imageArr.count*kScreenW);
    self.scrollView.scrollEnabled = true;
}
-(NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}
-(void)addPicture:(UIButton *)sender{
    HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
    picker.delegate = self;
    picker.maxAllowedCount = 6-self.imageArr.count;
    picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
    [self presentViewController:picker animated:YES completion:nil];
}
//当选择一张图片后进入这里
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    //    self.imageArr = info[kHUImagePickerThumbnailImage];//缩小图
    NSMutableArray *arr = info[kHUImagePickerOriginalImage];//源图
    self.imageArr = [NSMutableArray arrayWithArray:arr];
    [self.tableView reloadData];
    [self textViewDidChange:self.contentView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
