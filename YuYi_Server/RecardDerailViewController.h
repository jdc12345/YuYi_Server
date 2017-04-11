//
//  RecardDerailViewController.h
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/4/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientModel.h"
@interface RecardDerailViewController : UIViewController

@property (nonatomic, strong)PatientModel *patientModel;


- (void)createSubView;
@end
