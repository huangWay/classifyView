//
//  HWCarGroup.h
//  汽车
//
//  Created by 黄伟 on 15/3/5.
//  Copyright (c) 2015年 黄伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWCar.h"
@interface HWCarGroup : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,strong) NSArray *cars;
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)carGroupWithDic:(NSDictionary *)dic;
@end
