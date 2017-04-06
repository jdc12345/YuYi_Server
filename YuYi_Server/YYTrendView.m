//
//  SPView.m
//  StockPlotting
//
//  Created by  wylt_ios1 on 17-1-12.
//  Copyright (c) 2017年 cactus. All rights reserved.
//

#define NLSystemVersionGreaterOrEqualThan(version)  ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER   NLSystemVersionGreaterOrEqualThan(7.0)
#define GraphColor      [UIColor colorWithHexString:@"6a6a6a" alpha:1]
#define str(index)                                  [NSString stringWithFormat : @"%.f", -[[self.values objectAtIndex:(index)] floatValue] * kYScale]
#define point(x, y)                                 CGPointMake((x) * kXScale +xOffset, yOffset + (y) * kYScale)
#define xPoint(x, y)                                CGPointMake((x) * kXScale , yOffset + (y) * kYScale)

#define kXScale  44.0 *kiphone6
#define kYScale  55.0 *kiphone6
#import "YYTrendView.h"
#import "UIColor+Extension.h"
@interface YYTrendView ()
@property (nonatomic, strong)   dispatch_source_t timer;

@property (strong , nonatomic) NSMutableArray *startPoints;
@property (nonatomic, strong) NSArray *temperatureY;
@property (nonatomic, strong) NSArray *bloodY;
@property (nonatomic, strong) NSArray *dateX;
@end
@implementation YYTrendView
//CGFloat   kXScale = 40.0 *kiphone6;
//CGFloat   kYScale = 55.0 *kiphone6;

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                    CGFloat dx, CGFloat dy)
{
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

- (NSMutableArray *)values{
    if (_values  ==  nil) {
        _values = [[NSMutableArray alloc]initWithCapacity:2];
        //        [UIColor colorWithHexString:@"6a6a6a"];
    }
    return _values;
}
- (NSMutableArray *)valuesforBlood{
    if (_valuesforBlood  ==  nil) {
        _valuesforBlood = [[NSMutableArray alloc]initWithCapacity:2];
        //        [UIColor colorWithHexString:@"6a6a6a"];
    }
    return _valuesforBlood;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.temperatureY = @[@"40",@"60",@"80",@"100",@"120",@"140",@"160",@"180"];
        // Initialization code
// if (self.values.count == 0) {
//        for (int i = 1; i<8; i++) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self updateValues];
//                //                NSLog(@"-----%d",i);
//            });
//            
//        }
//        
//    }
    }
    return self;
}

- (void)awakeFromNib
{
    [self setContentMode:UIViewContentModeRight];
    _values = [NSMutableArray array];
    
    __weak id   weakSelf = self;
    double      delayInSeconds = 0.1;
    //    self.timer =
    //        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
    //            dispatch_get_main_queue());
    //    dispatch_source_set_timer(
    //        _timer, dispatch_walltime(NULL, 0),
    //        (unsigned)(delayInSeconds * NSEC_PER_SEC), 0);
    //    dispatch_source_set_event_handler(_timer, ^{
    //            [weakSelf updateValues];
    //        });
    //    dispatch_resume(_timer);
//    if (self.values.count == 0) {
//        for (int i = 1; i<8; i++) {
//            //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self updateValues];
//            //            NSLog(@"-----%d",i);
//            //        });
//            
//        }
//    }

}

- (void)updateValues
{
    double nextValue = sin(CFAbsoluteTimeGetCurrent())
    + ((double)rand() / (double)RAND_MAX);
    if (nextValue > 0) {
        nextValue *= -1;
    }
    //NSLog(@"%g",(double)rand()/(double)RAND_MAX);
//    NSLog(@"value =  %g",nextValue *kYScale);
    [self.values addObject:
     [NSNumber numberWithDouble:nextValue]];
    //    NSLog(@"%g",self.values.count);
    
    
    CGSize size = self.bounds.size;
    
    /*
     *   UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
     *   if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
     *
     *
     *   }
     */
    CGFloat     maxDimension = size.width; // MAX(size.height, size.width);
    NSUInteger  maxValues =
    (NSUInteger)floorl(maxDimension / kXScale);
    
    if ([self.values count] > maxValues) {
        [self.values removeObjectsInRange:
         NSMakeRange(0, [self.values count] - maxValues)];
    }
    
    [self setNeedsDisplay];
}

- (void)dealloc
{
    //    dispatch_source_cancel(_timer);
}

- (void)drawRect:(CGRect)rect
{
//    NSLog(@"%@",self.values);
    
    //    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    //    [[UIColor blueColor] setFill];
    //    [p fill];
    //    NSLog(@"%@",self.values);

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx,
                                     [[UIColor colorWithHexString:@"6a6a6a"] CGColor]);
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, 2);
    //  画 坐标轴
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat             yOffset = self.bounds.size.height -25;
    CGFloat             xOffset = 10;
    
    
    CGAffineTransform   transform =
    CGAffineTransformMakeScaleTranslate(kXScale, kYScale,
                                        xOffset, yOffset);
    //    CGPathMoveToPoint(path, &transform, 0, 0);
    //    CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0); // self.bounds.size.width其实大了kXScale倍
    //
    //
    //
    //    CGPathMoveToPoint(path, &transform, 0, 0);
    //    CGPathAddLineToPoint(path, &transform, 0, -self.bounds.size.height); // self.bounds.size.width其实大了kXScale倍
    
    // 标刻度
    // CGPathMoveToPoint(path, &transform, 0, 0);
    for (int i = 1; i < 9; i++) {
        if (i == 1) {
            //            [self drawAtPoint:point(0, i) withStr:[NSString stringWithFormat:@"%d",(i *10 +50)]];
            //            CGPathAddLineToPoint(path, &transform, i*0.6, 0);
//            [self zydrawAtPoint:point(i *0.6, 0) withStr:[NSString stringWithFormat:@"%@月%d日",@"1",i]];
            [self zydrawAtPoint:xPoint(i, 0) withStr:self.dateX[i -1]];//[NSString stringWithFormat:@"%d日",i]];

        }else{
            //            [self drawAtPoint:point(0, i) withStr:[NSString stringWithFormat:@"%d",(i *10 +50)]];
            //            CGContextMoveToPoint(ctx, i*, 0)
            if (i != 8) {
                [self zydrawAtPoint:xPoint(i, 0) withStr:self.dateX[i -1]];//[NSString stringWithFormat:@"%d日",i]];
            }
            
        }
        [self zydrawAtPoint:point(0, -i *0.5) withStr:self.temperatureY[i-1]];//[NSString stringWithFormat:@"%d", 20 +(i *20 )]];
    }
    //    for (int i = 1; i < 8; i++) {
    //        if (i == 1) {
    //
    //        }else{
    //                        [self drawAtPoint:point(0, -i) withStr:[NSString stringWithFormat:@"%d",(i *10 +50)]];
    //
    //
    //        }
    //    }
    if ([self.values count] == 0) {
        return;
    }
    
    // 画线 以及写数值
    CGFloat y = [[self.values objectAtIndex:0] floatValue];
    CGPathMoveToPoint(path, &transform, 1, y);
    //    [self drawAtPoint:point(1, y) withStr:str(0)];
    
    for (NSUInteger x = 1; x < [self.values count]; ++x) {
        y = [[self.values objectAtIndex:x] floatValue];
        CGPathAddLineToPoint(path, &transform, x+1, y);
        //        [self drawAtPoint:point(x+1, y) withStr:str(x)];
        //        NSLog(@"value = %@",str(x));
    }
    
    
    // 画点。
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    CGContextStrokePath(ctx);
    
    for (NSUInteger x = 0; x < [self.values count]; ++x) {
        y = [[self.values objectAtIndex:x] floatValue];
        // CGContextAddEllipseInRect(ctx, CGRectMake(x*kXScale, y*kYScale +yOffset, 5, 5));
        // CGContextSetLineWidth(ctx, 10);
        CGContextAddArc(ctx, (x+1)*kXScale +xOffset, y*kYScale +yOffset, 4, 0, M_PI * 2, 0);
        //        CGPathAddArc(path, &transform, x, y, 2, 0, M_PI *2, 0);
        [[UIColor colorWithHexString:@"6a6a6a"] set];//设置颜色  红色
        
        // 3.显示所绘制的东西   FillPath实心
        //        CGContextFillPath(ctx);
        CGContextStrokePath(ctx);
    }
    
    for (NSUInteger x = 0; x < [self.values count]; ++x) {
        y = [[self.values objectAtIndex:x] floatValue];
        // CGContextAddEllipseInRect(ctx, CGRectMake(x*kXScale, y*kYScale +yOffset, 5, 5));
        // CGContextSetLineWidth(ctx, 10);
        CGContextAddArc(ctx, (x+1)*kXScale +xOffset, y*kYScale +yOffset, 3, 0, M_PI * 2, 0);
        //        CGPathAddArc(path, &transform, x, y, 2, 0, M_PI *2, 0);
        [[UIColor colorWithHexString:@"8bfad4"] set];//设置颜色  红色
        
        // 3.显示所绘制的东西   FillPath实心
        CGContextFillPath(ctx);
        //        CGContextStrokePath(ctx);
    }
    CGContextAddArc(ctx, (self.values.count)*kXScale +xOffset, [self.values.lastObject floatValue]*kYScale +yOffset, 2.3, 0, M_PI * 2, 0);
    [[UIColor colorWithHexString:@"6a6a6a"] set];//设置颜色  红色
    CGContextFillPath(ctx);
    
    
    if (self.valuesforBlood.count != 0) {
        //    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
        //    [[UIColor blueColor] setFill];
        //    [p fill];
        if ([self.valuesforBlood count] == 0) {
            return;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx,
                                         [[UIColor colorWithHexString:@"6a6a6a"] CGColor]);
        
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineWidth(ctx, 2);
        //  画 坐标轴
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat             yOffset = self.bounds.size.height -25;
        CGFloat             xOffset = 10;
        
        
        CGAffineTransform   transform =
        CGAffineTransformMakeScaleTranslate(kXScale, kYScale,
                                            xOffset, yOffset);
        //    CGPathMoveToPoint(path, &transform, 0, 0);
        //    CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0); // self.bounds.size.width其实大了kXScale倍
        //
        //
        //
        //    CGPathMoveToPoint(path, &transform, 0, 0);
        //    CGPathAddLineToPoint(path, &transform, 0, -self.bounds.size.height); // self.bounds.size.width其实大了kXScale倍
        
        // 标刻度
        // CGPathMoveToPoint(path, &transform, 0, 0);
        for (int i = 1; i < 9; i++) {
            if (i == 1) {
                //            [self drawAtPoint:point(0, i) withStr:[NSString stringWithFormat:@"%d",(i *10 +50)]];
                //            CGPathAddLineToPoint(path, &transform, i*0.6, 0);
//                [self zydrawAtPoint:point(i *0.6, 0) withStr:[NSString stringWithFormat:@"%@月%d日",@"1",i]];
            }else{
                //            [self drawAtPoint:point(0, i) withStr:[NSString stringWithFormat:@"%d",(i *10 +50)]];
                //            CGContextMoveToPoint(ctx, i*, 0)
                if (i != 8) {
//                    [self zydrawAtPoint:point(i, 0) withStr:[NSString stringWithFormat:@"%d日",i]];
                }
                
            }
//            [self zydrawAtPoint:point(0, -i *0.5) withStr:self.temperatureY[i-1]];//[NSString stringWithFormat:@"%d", 20 +(i *20 )]];
        }
        //    for (int i = 1; i < 8; i++) {
        //        if (i == 1) {
        //
        //        }else{
        //                        [self drawAtPoint:point(0, -i) withStr:[NSString stringWithFormat:@"%d",(i *10 +50)]];
        //
        //
        //        }
        //    }
        
        
        // 画线 以及写数值
        CGFloat y = [[self.valuesforBlood objectAtIndex:0] floatValue];
        CGPathMoveToPoint(path, &transform, 1, y);
        //    [self drawAtPoint:point(1, y) withStr:str(0)];
        
        for (NSUInteger x = 1; x < [self.valuesforBlood count]; ++x) {
            y = [[self.valuesforBlood objectAtIndex:x] floatValue];
            CGPathAddLineToPoint(path, &transform, x+1, y);
            //        [self drawAtPoint:point(x+1, y) withStr:str(x)];
            //        NSLog(@"value = %@",str(x));
        }
        
        
        // 画点。
        CGContextAddPath(ctx, path);
        CGPathRelease(path);
        CGContextStrokePath(ctx);
        
        for (NSUInteger x = 0; x < [self.valuesforBlood count]; ++x) {
            y = [[self.valuesforBlood objectAtIndex:x] floatValue];
            // CGContextAddEllipseInRect(ctx, CGRectMake(x*kXScale, y*kYScale +yOffset, 5, 5));
            // CGContextSetLineWidth(ctx, 10);
            CGContextAddArc(ctx, (x+1)*kXScale +xOffset, y*kYScale +yOffset, 4, 0, M_PI * 2, 0);
            //        CGPathAddArc(path, &transform, x, y, 2, 0, M_PI *2, 0);
            [[UIColor colorWithHexString:@"6a6a6a"] set];//设置颜色  红色
            
            // 3.显示所绘制的东西   FillPath实心
            //        CGContextFillPath(ctx);
            CGContextStrokePath(ctx);
        }
        
        
        // 覆盖的圆
        for (NSUInteger x = 0; x < [self.valuesforBlood count]; ++x) {
            y = [[self.valuesforBlood objectAtIndex:x] floatValue];
            // CGContextAddEllipseInRect(ctx, CGRectMake(x*kXScale, y*kYScale +yOffset, 5, 5));
            // CGContextSetLineWidth(ctx, 10);
            CGContextAddArc(ctx, (x+1)*kXScale +xOffset, y*kYScale +yOffset, 3, 0, M_PI * 2, 0);
            //        CGPathAddArc(path, &transform, x, y, 2, 0, M_PI *2, 0);
            [[UIColor colorWithHexString:@"8bfad4"] set];//设置颜色  红色
           
            // 3.显示所绘制的东西   FillPath实心
             CGContextFillPath(ctx);
            //        CGContextStrokePath(ctx);
            

        }
       
        CGContextAddArc(ctx, (self.valuesforBlood.count)*kXScale +xOffset, [self.valuesforBlood.lastObject floatValue]*kYScale +yOffset, 2.3, 0, M_PI * 2, 0);
        [[UIColor colorWithHexString:@"6a6a6a"] set];//设置颜色  红色
        CGContextFillPath(ctx);
    }
}

- (void)drawAtPoint:(CGPoint)point withStr:(NSString *)str
{
    
    if (IOS7_OR_LATER) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        [str drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9], NSStrokeColorAttributeName:GraphColor}];
#endif
    } else {
        // [str drawAtPoint:point withFont:[UIFont systemFontOfSize:9]];
    }
    
}
- (void)zydrawAtPoint:(CGPoint)point withStr:(NSString *)str
{
    [str drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"6a6a6a" alpha:0.7]}];
}
// 血压走势图
- (void)updateBloodTrendDataList:(NSArray *)highList  lowList:(NSArray *)lowList  dateList:(NSArray *)dateList{
    [self editDate:dateList];
    [self.values removeAllObjects];
    [self.valuesforBlood removeAllObjects];
    for (NSNumber *number  in highList) {
        CGFloat floa = ([number floatValue] -25)/40 *-1;
        [self.values addObject:[NSNumber numberWithFloat:floa]];
        
    }
    
    for (NSNumber *number  in lowList) {
        CGFloat floa = ([number floatValue] -25)/40 *-1;
        [self.valuesforBlood addObject:[NSNumber numberWithFloat:floa]];
        
    }
    [self setNeedsDisplay];
    self.temperatureY = @[@"40",@"60",@"80",@"100",@"120",@"140",@"160",@"180"];
}
// 体温走势图
- (void)updateTempatureTrendDataList:(NSArray *)tempature{
    NSLog(@"刷新数据 123123");
    [self.values removeAllObjects];
    NSMutableArray *dateDate = [[NSMutableArray alloc]initWithCapacity:2];
    for (NSDictionary *dict  in tempature) {
        NSString *str = dict[@"temperaturet"];
        NSString *dateStr = dict[@"createTimeString"];
        CGFloat floa = ([str floatValue] -34) *-0.5;
        [self.values addObject:[NSNumber numberWithFloat:floa]];
        
        [dateDate addObject:dateStr];
    }
    [self editDate:dateDate];
    self.temperatureY = @[@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42"];
//    for(int i = 1 ; i<8 ; i++){
//        [self.values addObject:[NSNumber numberWithFloat:-(i *0.5)]];
//    }
    [self setNeedsDisplay];
}
- (void)editDate:(NSArray *)dateList{
    NSMutableArray *measureDate = [[NSMutableArray alloc]initWithCapacity:2];
    for (NSString *dateStr in dateList) {
        int month= [[dateStr substringWithRange:NSMakeRange(5,2)] intValue];
        int day= [[dateStr substringWithRange:NSMakeRange(8,2)] intValue];
        [measureDate addObject:[NSString stringWithFormat:@"%d月%d日",month,day]];
    }

   
    if (measureDate.count < 7) {
        NSString *lateDate;
        if (measureDate.count == 0) {
            NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24];
            NSString *str = [NSString stringWithFormat:@"%@",nowDate];
            lateDate = [str componentsSeparatedByString:@" "].firstObject;
        }else{
            lateDate = [dateList.lastObject componentsSeparatedByString:@" "].firstObject;
        }
        NSInteger addNum = 7-measureDate.count;
        for (int i = 0; i< addNum; i++) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd "];
            NSDate *myDate = [dateFormatter dateFromString:lateDate];
            
            NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * (i+1)];
            // 转换
            int month= [[[dateFormatter stringFromDate:newDate] substringWithRange:NSMakeRange(5,2)] intValue];
            int day= [[[dateFormatter stringFromDate:newDate] substringWithRange:NSMakeRange(8,2)] intValue];
            [measureDate addObject:[NSString stringWithFormat:@"%d月%d日",month,day]];
        }
    }
    NSLog(@"%@",measureDate);
    self.dateX = measureDate;

    
}
@end
