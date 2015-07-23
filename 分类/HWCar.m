//
//  HWCar.m
//  汽车
//
//  Created by 黄伟 on 15/5/5.
//  Copyright (c) 2015年 黄伟. All rights reserved.
//

#import "HWCar.h"

@implementation HWCar
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)carWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}

@end
