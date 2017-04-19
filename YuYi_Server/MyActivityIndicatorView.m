//
//  MyActivityIndicatorView.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MyActivityIndicatorView.h"
#define MYCOLOR [UIColor whiteColor]
@implementation MyActivityIndicatorView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 菊花背景的大小
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 80*kiphone6, 80*kiphone6);
        // 菊花的背景色
        self.backgroundColor = MYCOLOR;
        self.layer.cornerRadius = 10*kiphone6;
        // 菊花的颜色和格式（白色、白色大、灰色）
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        // 在菊花下面添加文字
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*kiphone6, 60*kiphone6, 70*kiphone6, 20*kiphone6)];
        label.text = @"loading...";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkTextColor];
        [self addSubview:label];
    }
    return  self;
}

@end
