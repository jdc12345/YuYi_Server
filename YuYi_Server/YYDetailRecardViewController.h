//
//  YYDetailRecardViewController.h
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"

@interface YYDetailRecardViewController : UIViewController
@property (nonatomic, strong) NSString *recardID;
@property (nonatomic, strong) AppointmentModel *appointmentModel;
@end
