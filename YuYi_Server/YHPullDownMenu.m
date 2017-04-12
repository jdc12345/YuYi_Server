//
//  YHPullDownMenu.m
//  GrabOnePackage
//
//  Created by maoer on 16/8/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "YHPullDownMenu.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

@interface YHPullDownMenu()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)NSArray<NSString*> *items;
@property(nonatomic,strong)YHPullDownMenuClickIndexBlock block;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIWindow*pdContainerwindow;
@property(nonatomic,strong)UIImageView*bgImageView;
@property(nonatomic,assign)NSInteger  cellHeight;
@property(nonatomic,strong)UIImage*bgImage;
@property (nonatomic, copy) NSArray *totaldData;
@property (nonatomic, strong) NSMutableArray *currentData;
@end

@implementation YHPullDownMenu
- (NSMutableArray *)currentData{
    if (_currentData == nil) {
        _currentData = [[NSMutableArray alloc]initWithCapacity:2];
        
    }
    return _currentData;
}
-(instancetype)initPullDownMenuWithItems:(NSArray*)items
                              cellHeight:(CGFloat)cellHeight
                               menuFrame:(CGRect) menuFrame
                        clickIndexHandle:(YHPullDownMenuClickIndexBlock)handle{
    
    return [self initPullDownMenuWithItems:items
                                cellHeight:cellHeight
                                 menuFrame: menuFrame
                                   bgImage:[UIImage imageNamed:@"avatar"]
                          clickIndexHandle:(YHPullDownMenuClickIndexBlock)[handle copy]];
}

-(instancetype)initPullDownMenuWithItems:(NSArray*)items
                              cellHeight:(CGFloat)cellHeight
                               menuFrame:(CGRect) menuFrame
                                 bgImage:(UIImage*)bgImage
                        clickIndexHandle:(YHPullDownMenuClickIndexBlock)handle{
    self=[super init];
    if(self){
        self.items=items;
        self.frame= [UIScreen mainScreen].bounds;
        self.backgroundColor=[UIColor yellowColor];
        self.block=[handle copy];
        self.bgImage=bgImage;
        [self setupPullDownMenuWithcellHeight:cellHeight
                                    menuFrame: menuFrame];
    }
    return self;
}
-(void)setupPullDownMenuWithcellHeight:(CGFloat)cellHeight
                             menuFrame:(CGRect) menuFrame{
    _pdContentView=[[UIView alloc]initWithFrame:menuFrame];
    _pdContentView.backgroundColor=[UIColor  whiteColor];//设置背景颜色
    [self addSubview: self.pdContentView];
    _pdContentView.layer.shadowColor = [UIColor colorWithHexString:@"d5d5d5"].CGColor;
    _pdContentView.layer.shadowRadius = 1 *kiphone6;
    _pdContentView.layer.shadowOffset = CGSizeMake(1, 1);
    _pdContentView.layer.shadowOpacity = 1;
//    _pdContentView.layer.borderWidth=0.5;//设置边框颜色
//    _pdContentView.layer.borderColor=[UIColor grayColor].CGColor;//设置边框颜色
    self.bgImageView=[[UIImageView alloc]initWithImage:self.bgImage];
    [self.pdContentView addSubview:self.bgImageView];
    self.bgImageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:menuFrame.size.width]];
    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:menuFrame.size.height]];
    
    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pdContentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bgImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.pdContentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
 
    self.cellHeight=cellHeight;
    _tableView=[[UITableView alloc]initWithFrame:menuFrame style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];//设置表格背景颜色
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.sectionFooterHeight = 0;
    [self addSubview:_tableView];
//    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:menuFrame.size.width]];
//    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:menuFrame.size.height]];
//    
//    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pdContentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
//    [self.pdContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.pdContentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    NSLog(@"");

}

/**
 *  /
 *  /如果不想要点击外面的时候，下拉菜单也消失的话，可以去掉该函数
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}


- (void)show{
    
    _pdContainerwindow=[[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];//[UIScreen mainScreen].bounds];
    _pdContainerwindow.windowLevel=UIWindowLevelAlert;
    [_pdContainerwindow becomeKeyWindow];
    _pdContainerwindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [_pdContainerwindow makeKeyAndVisible];
    [_pdContainerwindow addSubview:self];
    
    //  [self setShowAnimation];
    
}

-(void)dismiss{
    _items=nil;
    _tableView=nil;
    _pdContentView = nil;
    [self removeFromSuperview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title;
    if (section == 0) {
        title =  @"资讯";
    }else{
        title = @ "常用药品";
    }
    UIView *sectionHView = [[UIView alloc]init];
    sectionHView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    whiteView.tag = 200 +section;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [whiteView addGestureRecognizer:tapGesture];
    
    UILabel *sectionName = [[UILabel alloc]init];
    sectionName.text = title;
    sectionName.textColor = [UIColor colorWithHexString:@"6a6a6a"];
    sectionName.font = [UIFont systemFontOfSize:14];
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    clickButton.enabled = NO;
    //    [clickButton addTarget:self action:@selector(Actiondo:) forControlEvents:UIControlEventTouchUpInside];
    //    [clickButton addGestureRecognizer:tapGesture];
    
    [whiteView addSubview:sectionName];
    [whiteView addSubview:clickButton];
    
    [sectionName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).with.offset(10 *kiphone6);
        make.left.equalTo(whiteView).with.offset(20 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(64, 14));
    }];
    
    [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).with.offset(0);
        make.right.equalTo(whiteView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(40 *kiphone6, 40 *kiphone6));
    }];
    
    
    
    [sectionHView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionHView).with.offset(4*kiphone6);
        make.left.equalTo(sectionHView);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 40*kiphone6));
    }];
     sectionHView.frame = CGRectMake(0, 0, kScreenW, 44 *kiphone6);
    return sectionHView;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        cell.textLabel.font = [UIFont fontWithName:@"Marion" size:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  self.cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.block) {
        self.block([indexPath row]);
        self.block = nil;
    }
    [self dismiss];
}-(void)setShowAnimation{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [_pdContentView.layer addAnimation:animation forKey:nil];
}
- (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//    ;
//}

@end





///Masonry实现版本
////
////  YHPullDownMenu.m
////  GrabOnePackage
////
////  Created by maoer on 16/8/26.
////  Copyright © 2016年 All rights reserved.
////
//
//#import "YHPullDownMenu.h"
//#import "Masonry.h"
//
//@interface YHPullDownMenu()<UITableViewDelegate,UITableViewDataSource>
//@property(nonatomic, strong)NSArray<NSString*> *items;
//@property(nonatomic,strong)YHPullDownMenuClickIndexBlock block;
//@property(nonatomic,strong)UITableView*tableView;
//@property(nonatomic,strong)UIWindow*pdContainerwindow;
//@property(nonatomic,strong)UIImageView*bgImageView;
//@property(nonatomic,assign)NSInteger  cellHeight;
//@property(nonatomic,strong)UIImage*bgimage;
//@end
//
//@implementation YHPullDownMenu
//
//
//-(instancetype)initPullDownMenuWithItems:(NSArray*)items
//                              cellHeight:(CGFloat)cellHeight
//                               menuFrame:(CGRect) menuFrame
//                        clickIndexHandle:(YHPullDownMenuClickIndexBlock)handle{
//    return [self initPullDownMenuWithItems:items
//                                cellHeight:cellHeight
//                                 menuFrame: menuFrame
//                                   bgImage:[UIImage imageNamed:@"avatar"]
//                          clickIndexHandle:[handle copy]];
//}
//-(instancetype)initPullDownMenuWithItems:(NSArray*)items
//                              cellHeight:(CGFloat)cellHeight
//                               menuFrame:(CGRect) menuFrame
//                                 bgImage:(UIImage*)bgImage
//                        clickIndexHandle:(YHPullDownMenuClickIndexBlock)handle{
//    self=[super init];
//    if(self){
//        self.items=items;
//        self.frame=[UIScreen mainScreen].bounds;
//        self.backgroundColor=[UIColor clearColor];
//        self.block=[handle copy];
//        self.bgimage=bgImage;
//        [self setupPullDownMenuWithcellHeight:cellHeight
//                                    menuFrame: menuFrame];
//    }
//    return self;
//    
//}
//-(void)setupPullDownMenuWithcellHeight:(CGFloat)cellHeight
//                             menuFrame:(CGRect) menuFrame{
//    _pdContentView=[[UIView alloc]initWithFrame:menuFrame];
//    _pdContentView.backgroundColor=[UIColor  clearColor];
//    [self addSubview: self.pdContentView];
//    self.bgImageView=[[UIImageView alloc]initWithImage:self.bgimage];
//    [self addSubview:self.bgImageView];
//    @weakify(self)
//    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.width.mas_equalTo(self.pdContentView.mas_width);
//        make.height.mas_equalTo(self.pdContentView.mas_height);
//        make.center.mas_equalTo(self.pdContentView);
//    }];
//    self.cellHeight=cellHeight;
//    _tableView=[[UITableView alloc]init];
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.backgroundColor=[UIColor clearColor];
//    [self addSubview:_tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.width.mas_equalTo(self.pdContentView.mas_width);
//        make.height.mas_equalTo((cellHeight)*([self.items count]));//需要自己设置
//        make.bottom.mas_equalTo(self.pdContentView.mas_bottom);
//        make.left.and.right.mas_equalTo(self.pdContentView);
//        ;
//    }];
//}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismiss];
//}
//
//
//- (void)show{
//    
//    _pdContainerwindow=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    _pdContainerwindow.windowLevel=UIWindowLevelAlert;
//    [_pdContainerwindow becomeKeyWindow];
//    [_pdContainerwindow makeKeyAndVisible];
//    [_pdContainerwindow addSubview:self];
//    
//    //  [self setShowAnimation];
//    
//}
//
//-(void)dismiss{
//    _items=nil;
//    _tableView=nil;
//    _pdContentView = nil;
//    [self removeFromSuperview];
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.items count];
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
//        cell.textLabel.font = [STStyle fontRegularOfSize:14];
//        cell.textLabel.textColor = [UIColor colorWithRGB:0x666666];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.and.centerY.equalTo(cell.contentView);
//    }];
//    cell.textLabel.text = self.items[indexPath.row];
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return  self.cellHeight;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (self.block) {
//        self.block([indexPath row]);
//        self.block = nil;
//    }
//    [self dismiss];
//}-(void)setShowAnimation{
//    
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.3;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    
//    [_pdContentView.layer addAnimation:animation forKey:nil];
//}
//- (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize
//{
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary * attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
//    
//    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//    labelSize.height = ceil(labelSize.height);
//    labelSize.width = ceil(labelSize.width);
//    return labelSize;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//@end
