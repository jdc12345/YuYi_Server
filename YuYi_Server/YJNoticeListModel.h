//
//  YJNoticeListModel.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/10/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "2017-10-18 09:54:37",
//"msgType": 1,
//"updateTimeString": "",
//"targetId": 57,
//"isRead": false,
//"avatar": "",
//"title": "评论",
//"content": "评论",
//"physicianId": 57,
//"referId": 129,
//"id": 7,
//"operation": 1
#import <Foundation/Foundation.h>

@interface YJNoticeListModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long msgType;
@property (nonatomic, assign) long targetId;
@property (nonatomic, assign) long info_id;//和id重名
@property (nonatomic, assign) Boolean isRead;
//@property (nonatomic, assign) long fromId;
@property (nonatomic, assign) long physicianId;
@property (nonatomic, assign) long referId;
@property (nonatomic, assign) long operation;

@end
