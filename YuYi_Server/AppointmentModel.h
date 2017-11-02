//
//  AppointmentModel.h
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentModel : NSObject

@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *visitTimeString;
@property (nonatomic, copy) NSString *info_id;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *clinicName;
@property (nonatomic, copy) NSString *physicianTrueName;
@property (nonatomic, copy) NSString *hospitalName;
@end
