//
//  YYCardCommentDetailModel.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "2017-04-07 14:16:52",
//"updateTimeString": "",
//"contentId": null,
//"pid": null,
//"avatar": "/static/image/L3.jpeg",
//"content": "技术很好",
//"likeNum": 1,
//"trueName": "巢元方",
//"physicianId": null,
//"commentType": null,
//"id": null
#import <Foundation/Foundation.h>

@interface YYCardCommentDetailModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *commentType;
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *physicianId;

@end
