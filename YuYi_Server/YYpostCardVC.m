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
@interface YYpostCardVC ()<UITextViewDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,weak)BRPlaceholderTextView *titleView;
@property(nonatomic,weak)BRPlaceholderTextView *contentView;
@property(nonatomic,weak)UIButton *addPictureBtn;
@property(nonatomic,weak)UILabel *addPictureLabel;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIView *lineTwo;

@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, strong) UIImage *chooseImage;

@end

@implementation YYpostCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.title = @"发帖";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
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
    UIView *lineTwo = [[UIView alloc]init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:lineTwo];
    self.lineTwo = lineTwo;
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
        make.top.equalTo(contentView.mas_bottom).offset(8*kiphone6);
        make.height.offset(1);
    }];
    [line layoutIfNeeded];
    //添加图片
    UIButton *addPictureBtn = [[UIButton alloc]init];
    [addPictureBtn setImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
    [backView addSubview:addPictureBtn];
    self.addPictureBtn = addPictureBtn;
    [addPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(contentView.mas_bottom).offset(50*kiphone6);
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
    self.lineTwo.frame = CGRectMake(frame.origin.x, frame.origin.y+size.height, frame.size.width, 1);
    self.addPictureBtn.frame = CGRectMake(frame.origin.x, frame.origin.y+size.height+50*kiphone6, 100*kiphone6, 100*kiphone6);
    CGRect labelFrame = self.addPictureLabel.frame;
    self.addPictureLabel.frame = CGRectMake(frame.origin.x+120, frame.origin.y+size.height+80*kiphone6, labelFrame.size.width, labelFrame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y+size.height+300*kiphone6);
    self.scrollView.scrollEnabled = true;
}
-(void)addPicture:(UIButton *)sender{
//    NSString *str = self.contentView.text;
//    str = [str stringByAppendingString:@"@@@@@@图片@@@@@@"];
//    self.contentView.placeholder = @"输入内容";
//    [self.contentView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
//        //滑到文章最后
//        [text becomeFirstResponder];
//    }];
//    self.contentView.text = str;
//    [self textViewDidChange:self.contentView];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        self.chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(self.chooseImage) == nil){
            data = UIImageJPEGRepresentation(self.chooseImage, 1.0);
        }else{
            data = UIImagePNGRepresentation(self.chooseImage);
        }
        UIImage *image = [UIImage imageWithData:data];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentView.attributedText];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image = image; //要添加的图片
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        [string insertAttributedString:textAttachmentString atIndex:0];//index为用户指定要插入图片的位置
        self.contentView.attributedText = string;
//        self.content.text=@"1111";
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        _filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        /****图片本地持久化*******/
        
        
        
        //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //        NSString *myfilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"picture.png"]];
        //        // 保存文件的名称
        //        [UIImagePNGRepresentation(self.chooseImage)writeToFile: myfilePath  atomically:YES];
        //        NSUserDefaults *userDef= [NSUserDefaults standardUserDefaults];
        //        [userDef setObject:myfilePath forKey:kImageFilePath];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        self.userIcon.image = [self.chooseImage  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
}
//
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    
//    NSLog(@"您取消了选择图片");
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//-(void)sendInfo
//{
//    NSLog(@"图片的路径是：%@", _filePath);
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
