//
//  YYCommentInfoModel.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/7.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//"createTimeString": "2017-04-07 10:40:08",
//"updateTimeString": "",
//"contentId": 4,
//"pid": 23,
//"avatar": "/static/image/N4.jpeg",
//"content": "feifhancgada",
//"likeNum": null,
//"trueName": "张景岳",
//"physicianId": 23,
//"commentType": 1,
//"id": 10

#import <Foundation/Foundation.h>

@interface YYCommentInfoModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *trueName;
//@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) NSString *physicianId;
@property (nonatomic, copy) NSString *commentType;
@property (nonatomic, copy) NSString *info_id;
@end
