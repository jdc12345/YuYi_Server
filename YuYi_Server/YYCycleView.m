//
//  YYCycleView.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYCycleView.h"
#import <SDCycleScrollView.h>
#import <Masonry.h>
#import "UIColor+Extension.h"
#import "ZYPageControl.h"
#import "HttpClient.h"
#import "YYCycleViewModel.h"
#import <MJExtension.h>


@interface YYCycleView()<UIScrollViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, assign)CGFloat maxY;

@property (nonatomic, strong) ZYPageControl *pageCtrl;
@property (nonatomic, strong) NSMutableArray *imagesList;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *imagesModels;
@property (nonatomic, strong) NSMutableArray *bloodpressureList;
@property (nonatomic, strong) NSMutableArray *temperatureList;

@property (nonatomic, strong) NSArray *listlist;

@property (nonatomic, weak) UILabel *statusLabel;

@property (nonatomic, strong) UIView *iconBanner;

@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, strong) NSMutableArray *labelArray;

//@property (nonatomic, assign) NSInteger userCount;


@end

@implementation YYCycleView
- (NSMutableArray *)imagesModels{
    if (_imagesModels == nil) {
        _imagesModels = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _imagesModels;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self loadData];
        
    }
    return self;
}
- (void)loadData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/doctorlyinformation/getall.do",mPrefixUrl];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"result"];
        NSMutableArray *imageList = [[NSMutableArray alloc]initWithCapacity:2];
        for (NSDictionary *dict in array) {
            YYCycleViewModel *headModel = [YYCycleViewModel mj_objectWithKeyValues:dict];
        [self.imagesModels addObject:headModel];
        [imageList addObject:[NSString stringWithFormat:@"%@%@",mPrefixUrl,headModel.picture]];
        }
        self.imagesList  = imageList;
        [self setCycleView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)setCycleView{
    WS(ws);
    // 图片轮播器
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc]init];
    cycleScrollView.showPageControl = true;
    cycleScrollView.delegate = self;
    cycleScrollView.imageURLStringsGroup  = self.imagesList;
    
    self.cycleScrollView = cycleScrollView;
    
    //创建UIPageControl
    _pageCtrl = [[ZYPageControl alloc] init];  //创建UIPageControl，位置在下方。
    _pageCtrl.numberOfPages = self.imagesList.count;//总的图片页数
    _pageCtrl.currentPage = 0; //当前页
    _pageCtrl.dotImage = [UIImage imageNamed:@"pageControl-normal"];
    _pageCtrl.currentDotImage = [UIImage imageNamed:@"pageControl-select"];
    _pageCtrl.dotSize = CGSizeMake(0, 0);
    [_pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    //
    [self addSubview:cycleScrollView];
    
    [self addSubview:_pageCtrl];
    
    
    // 页面自动布局
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(40);
        make.centerX.equalTo(ws.mas_centerX).offset(20);
        make.size.mas_equalTo(CGSizeMake(40 *kiphone6, 10 *kiphone6));
    }];
    
    [self bringSubviewToFront:_pageCtrl];

}
- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    //    CGSize viewSize = helpScrView.frame.size;
    //    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    //    [helpScrView scrollRectToVisible:rect animated:YES];
}
#pragma mark -
#pragma mark ------------scroll delegate----------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_pageCtrl setCurrentPage:offset.x / bounds.size.width];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    YYCycleViewModel *headModel = self.imagesModels [index];
    self.itemClick(headModel.info_id);
}
-(NSArray *)listlist{
    if (_listlist == nil) {
        _listlist = [[NSArray alloc]initWithObjects:@"pageControl-normal",@"pageControl-select", nil];
    }
    return _listlist;
}
@end
