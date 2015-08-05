//
//  HWCar.h
//  汽车
//
//  Created by 黄伟 on 15/3/5.
//  Copyright (c) 2015年 黄伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWCar : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *icon;
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)carWithDic:(NSDictionary *)dic;
@end
