//
//  YYInfoDetailModel.h
//  YuYi_Server
//
//  Created by 万宇 on 2017/4/6.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"summary": "",
//"smallTitle": "",
//"createTimeString": "2017-04-06 10:37:12",
//"updateTimeString": "",
//"author": "",
//"oid": 3,
//"title": "【新闻】全军普通外科中心程龙博士 当选中华医学会外科分会青年委员后",
//"shareNum": null,
//"content": "为全面贯彻北京市医药分开综合改革相关政策及精神，落实医院医药分开综合改革动员部署会的具体要求，我院通过召开科室动员部署会，进行专题培训、集体学习，张贴发放宣传品等形式，积极传达、贯彻、落实相关政策及精神。
//3月24日起，我院各科室分别组织召开了专题培训，通过观看《北京市医药分开综合改革电视视频精编》，学习《首都医科大学宣武医院医药分开综合改革动员部署会》PPT及《北京市属医院推进医药分开综合改革宣传问答口袋书》等重要资料，学习相关政策及精神，统一员工思想，汇聚改革力量。
//3月28日，我院门急诊已在显要位置悬挂宣传横幅，告知广大患者，我院将于4月8日起实施医药分开综合改革。
//截至3月28日",
//"picture": "/static/image/464421_m.jpg",
//"likeNum": null,
//"commentNum": null,
//"id": 3
//"state":true
#import <Foundation/Foundation.h>

@interface YYInfoDetailModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shareNum;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) BOOL state;
@end
