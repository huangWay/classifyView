//
//  ViewController.m
//  分类
//
//  Created by 黄伟 on 15/3/22.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "ViewController.h"
#import "HWClassifyView.h"
#import "HWCar.h"
#import "HWCarGroup.h"
@interface ViewController ()<HWClassifyViewDatasource,HWClassifyViewDelegate>
@property(nonatomic,strong) NSArray *carGroups;
@end

@implementation ViewController
-(NSArray *)carGroups
{
    if (_carGroups == 0)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"cars_total.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dic in array)
        {
            HWCarGroup *carGroup = [HWCarGroup carGroupWithDic:dic];
            [tempArr addObject:carGroup];
        }
        _carGroups = tempArr;
    }
    return _carGroups;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    HWClassifyView *classify = [[HWClassifyView alloc]init];
    classify.delegate = self;
    classify.datasource = self;
    classify.frame = self.view.bounds;
    [self.view addSubview:classify];
}
-(NSInteger)numberOfUnitInClassifyView:(HWClassifyView *)classifyView{
    return self.carGroups.count;
}
-(NSInteger)numberOfContentsInClassifyView:(HWClassifyView *)classifyView inUnitIndex:(NSInteger)index{
    HWCarGroup *group = self.carGroups[index];
    NSArray *cars = group.cars;
    return cars.count;
}

-(NSString *)classifyView:(HWClassifyView *)classifyView titleAtIndex:(NSInteger)index{
    HWCarGroup *group = self.carGroups[index];
    return group.title;
}
-(UIView *)classifyView:(HWClassifyView *)classifyView cellAtIndexPath:(NSIndexPath *)indexPath;{
    HWCarGroup *group = self.carGroups[indexPath.section];
    NSArray *cars = group.cars;
    HWCar *car = cars[indexPath.item];
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor redColor];
    label.text = car.name;
    label.textColor = [UIColor blueColor];
    
    return label;
}
-(void)classifyView:(HWClassifyView *)classifyView didSelectContentViewAtIndexPath:(NSIndexPath *)indexPath{
    HWCarGroup *group = self.carGroups[indexPath.section];
    NSArray *cars = group.cars;
    HWCar *car = cars[indexPath.item];
    NSLog(@"%@",car.name);
}
@end
