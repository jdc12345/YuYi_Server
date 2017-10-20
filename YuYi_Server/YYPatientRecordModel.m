//
//  YYPatientRecordModel.m
//  YuYi_Server
//
//  Created by 万宇 on 2017/10/20.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPatientRecordModel.h"

@implementation YYPatientRecordModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end
