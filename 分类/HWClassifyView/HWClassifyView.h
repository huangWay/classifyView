//
//  HWClassifyView.h
//  分类
//
//  Created by 黄伟 on 15/3/22.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWClassifyView;

/**
 * 右侧区域间距类型
 */
typedef NS_OPTIONS(NSInteger, HWMarginType){
    HWMarginTypeTop,   //顶部间距
    HWMarginTypeSide,  //两边间距
    HWMarginTypeInside,//内部间距
};

/**
 * 数据源
 */
@protocol HWClassifyViewDatasource <NSObject>

@required

/**
 * 右侧区域内标签个数
 */
-(NSInteger)numberOfContentsInClassifyView:(HWClassifyView *)classifyView inUnitIndex:(NSInteger)index;
/**
 * 右侧区域标签长什么样
 */
-(UIView *)classifyView:(HWClassifyView *)classifyView cellAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 左侧分类栏内按钮的标题
 */
-(NSString *)classifyView:(HWClassifyView *)classifyView titleAtIndex:(NSInteger)index;
@optional

/**
 * 左侧分类栏按钮个数
 */
-(NSInteger)numberOfUnitInClassifyView:(HWClassifyView *)classifyView;

/**
 * 左侧分类栏宽度
 */
-(CGFloat)widthOfUnitsInClassifyView:(HWClassifyView *)classifyView;

@end

/**
 * 代理
 */
@protocol HWClassifyViewDelegate <NSObject>

@optional

/**
 * 左侧分类栏内按钮的高度
 */
-(CGFloat)heightOfUnitsInClassifyView:(HWClassifyView *)classifyView;

/**
 * 右侧内容区域内标签的高度
 */
-(CGFloat)heightOfContentsInClassifyView:(HWClassifyView *)classifyView;

/**
 * 右侧内容区域标签列数
 */
-(NSInteger)columsOfContentsInClassifyView:(HWClassifyView *)classifyView;

/**
 * 右侧内容区域间隔
 */
-(CGFloat)marginOfContentsInClassifyView:(HWClassifyView *)classifyView withMarginType:(HWMarginType)type;

/**
 * 选中右侧内容区域标签要做的事
 */
-(void)classifyView:(HWClassifyView *)classifyView didSelectContentViewAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HWClassifyView : UIView
/**
 * 数据源
 */
@property(nonatomic,weak) id<HWClassifyViewDatasource> datasource;

/**
 * 代理
 */
@property(nonatomic,weak) id<HWClassifyViewDelegate> delegate;

/**
 * 左侧背景色
 */
@property(nonatomic,strong) UIColor *classBackColor;


@end
