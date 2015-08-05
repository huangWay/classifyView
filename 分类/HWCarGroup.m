//
//  HWCarGroup.m
//  汽车
//
//  Created by 黄伟 on 15/3/5.
//  Copyright (c) 2015年 黄伟. All rights reserved.
//

#import "HWCarGroup.h"

@implementation HWCarGroup
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        NSArray *array = [NSArray array];
        array = dic[@"cars"];
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSDictionary *dict in array)
        {
          
            HWCar *car = [HWCar carWithDic:dict];
            [mutArr addObject:car];
        }
        self.cars = mutArr;
        self.title = dic[@"title"];
    }
    return self;
}
+(instancetype)carGroupWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}
@end
