//
//  PatientModel.h
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientModel : NSObject
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *trueName;




@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *medicalrecord;

@end
