//
//  EmptyDataView.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "EmptyDataView.h"
#import <Masonry.h>

@implementation EmptyDataView
- (id)initWithFrame:(CGRect)frame AndImageStr:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if ([imageName isEqualToString:@""]) {
            imageName = @"空页面icon";
        }
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:imageName];
        [imageV sizeToFit];
        [self addSubview:imageV];
        
        WS(ws);
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(ws);
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
