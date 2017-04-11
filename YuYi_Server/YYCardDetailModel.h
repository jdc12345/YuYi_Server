//
//  YYCardDetailModel.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//"createTimeString": "2017-04-07 16:57:44",
//"updateTimeString": "",
//"isLike": false,
//"title": "33",
//"shareNum": 33,
//"content": "33",
//"picture": "/static/image/avatar.jpeg",
//"likeNum": 33,
//"commentNum": 33,
//"physicianId": 33,
//"id": 2

#import <Foundation/Foundation.h>

@interface YYCardDetailModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shareNum;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, copy) NSString *physicianId;
@end
