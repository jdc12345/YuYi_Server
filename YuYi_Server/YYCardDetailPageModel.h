//
//  YYCardDetailPageModel.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"commentList": [],
//"createTimeString": "2017-04-10 15:40:24",
//"updateTimeString": "",
//"isLike": false,
//"avatar": "/static/image/N4.jpeg",
//"title": "医护人员用爱践行:\"有时去治愈 常常去帮助\"",
//"shareNum": 21,
//"content": " “祝你生日快乐，祝你生日快乐……”3月30日上午10点，刚结束每日例行的科室查房，永川区中医院外三科的医生和护士们端着点上蜡烛的蛋糕，捧着鲜花，为患者骆远金唱起了生日歌。
//",
//"picture": "/static/image/avatar.jpeg",
//"likeNum": 1,
//"commentNum": 12,
//"trueName": "张景岳",
//"physicianId": 23,
//"id": 1
#import <Foundation/Foundation.h>

@interface YYCardDetailPageModel : NSObject
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shareNum;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, copy) NSString *physicianId;
@end
