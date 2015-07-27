//
//  HWClassifyView.m
//  分类
//
//  Created by 黄伟 on 15/7/22.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "HWClassifyView.h"
//默认 左侧分类栏的宽度
#define Default_ClassViewWidth 60

//默认 左侧分类栏的高度
#define Default_CLassViewHeight 50

//默认 左侧分类栏第一个按钮距离顶部的高度
#define Default_ClassViewTopMargin 10

//默认 左侧分类栏的按钮数目
#define Default_ClassViewUnitNum 5

//默认 右侧内容区域标签高度
#define Default_ContentBtnHeight 30

//默认 右侧内容区域距离顶部间距
#define Default_TopMargin 50

//默认 右侧内容区域距离两侧间距
#define Default_SideMargin 30

//默认 右侧内容区域内部间距
#define Default_InsideMargin 20

//默认 右侧内容区域列数
#define Default_Colums 3

@interface HWClassifyView ()

/**
 * 左侧分类栏
 */
@property(nonatomic,strong) UIScrollView *classView;

/**
 * 左侧分类栏的按钮数组
 */
@property(nonatomic,strong) NSArray *classBtns;

/**
 * 左侧分类栏选中的按钮
 */
@property(nonatomic,strong) UIButton *selectBtn;

/**
 * 左侧分类栏的宽度
 */
@property(nonatomic,assign) CGFloat classWidth;//左侧分类条的宽度

/**
 * 右侧内容区域
 */
@property(nonatomic,strong) UIScrollView *contentView;

/**
 * 右侧内容区域frame
 */
@property(nonatomic,strong) NSMutableArray *contentFrames;

/**
 * 右侧内容区域标签
 */
@property(nonatomic,strong) NSMutableArray *contentBtns;
@end

@implementation HWClassifyView

-(instancetype)init{
    if (self = [super init]) {
        //创建左侧分类栏
        UIScrollView *classView = [[UIScrollView alloc]init];
        classView.showsVerticalScrollIndicator = NO;
        [self addSubview:classView];
        self.classView = classView;
        
        //创建右侧内容区域
        UIScrollView *contentView = [[UIScrollView alloc]init];
        contentView.showsVerticalScrollIndicator = NO;
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentViewTouch:)];
        [self addGestureRecognizer:tap];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}
#pragma mark ---懒加载---
-(NSMutableArray *)contentFrames{
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}
-(NSMutableArray *)contentBtns{
    if (_contentBtns == nil) {
        _contentBtns = [NSMutableArray array];
    }
    return _contentBtns;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //创建左侧分类栏
    [self setUpClassView];
    
    //布局左侧分类栏的按钮
    [self setUpClassButtons];
    
    //创建右侧内容区域
    [self setUpContentView];
    
    //默认左侧分类栏选中第0个按钮
    [self classBtnClick:self.classBtns[0]];
}

#pragma mark ---左侧内容区域布局---
//创建左侧分类栏
-(void)setUpClassView{
    if (!self.classBackColor) {
        //默认淡灰色背景
        self.classBackColor = [UIColor lightGrayColor];
    }
    self.classView.backgroundColor = self.classBackColor;
    
    //如果数据源没有返回左侧分类栏的宽度，那么用 默认 的
    CGFloat width;
    if ([self.datasource respondsToSelector:@selector(widthOfUnitsInClassifyView:)]) {
        width = [self.datasource widthOfUnitsInClassifyView:self];
    }else{
        width = Default_ClassViewWidth;
    }
    self.classWidth = width;
    self.classView.frame = CGRectMake(0, 0, width, self.frame.size.height);
}

//创建左侧分类栏的按钮
-(void)setUpClassButtons{
    
    //如果数据源不返回左侧分类栏按钮个数，那么用 默认 的
    NSInteger buttonNUm;
    if ([self.datasource respondsToSelector:@selector(numberOfUnitInClassifyView:)]) {
        buttonNUm = [self.datasource numberOfUnitInClassifyView:self];
    }else{
        buttonNUm = Default_ClassViewUnitNum;
    }
    
    CGFloat y;
    CGFloat height = 0.0;
    NSMutableArray *temp = [NSMutableArray array];
    
    //布局左侧分类栏的按钮
    for (NSInteger i = 0; i< buttonNUm; i++) {
        
        //如果代理不返回左侧分类栏按钮高度，那么用默认的
        if ([self.delegate respondsToSelector:@selector(heightOfUnitsInClassifyView:)]) {
            height = [self.delegate heightOfUnitsInClassifyView:self];
        }else{
            height = Default_CLassViewHeight;
        }
        y = height*i + Default_ClassViewTopMargin;
        UIButton *btn = [[UIButton alloc]init];
        NSString *title = [self.datasource classifyView:self titleAtIndex:i];
        btn.tag = i;
        [btn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, y, self.classWidth, height);
        [self.classView addSubview:btn];
        [temp addObject:btn];
    }
    self.classBtns = [temp copy];
    
    //根据按钮个数，决定左侧分类栏的contentSize
    self.classView.contentSize = CGSizeMake(self.classWidth, self.classBtns.count*height);
}

//左侧分类栏按钮点击
-(void)classBtnClick:(UIButton *)sender{
    self.selectBtn.selected = NO;
    self.selectBtn.backgroundColor = [UIColor lightGrayColor];
    self.selectBtn = sender;
    sender.selected = YES;
    sender.backgroundColor = [UIColor whiteColor];
    
    //点击按钮，右侧的内容区域就要刷新数据
    [self reloadData];
}

#pragma mark ---右侧内容区域布局---
//创建右侧内容区域
-(void)setUpContentView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = CGRectMake(self.classWidth, 0, self.frame.size.width-self.classWidth, self.frame.size.height);
}

//计算右侧内容区域标签的frame
-(void)setUpContentFrames{
    
    NSInteger contentNum = [self.datasource numberOfContentsInClassifyView:self inUnitIndex:self.selectBtn.tag];
    
    //右侧内容区域里的各种间距
    CGFloat topMargin = [self topMarginWithType:HWMarginTypeTop];
    CGFloat sideMargin = [self sideMarginWithType:HWMarginTypeSide];
    CGFloat insideMargin = [self insideMarginWithType:HWMarginTypeInside];
    
    NSInteger colums;
    NSInteger contentBtnHeight;
    
    //如果代理不返回右侧内容区域的列数，那么默认3列
    if ([self.delegate respondsToSelector:@selector(columsOfContentsInClassifyView:)]) {
        colums = [self.delegate columsOfContentsInClassifyView:self];
    }else{
        colums = Default_Colums;
    }
    
    //如果代理不返回右侧内容区域的高度，那么用默认的
    if ([self.delegate respondsToSelector:@selector(heightOfContentsInClassifyView:)]) {
        contentBtnHeight = [self.delegate heightOfContentsInClassifyView:self];
    }else{
        contentBtnHeight = Default_ContentBtnHeight;
    }
    
    CGFloat contentBtnWidth = (self.contentView.frame.size.width - (colums-1)*insideMargin - 2*sideMargin)/colums;
    
    //计算frame
    for (NSInteger i = 0 ; i<contentNum; i++) {
        NSInteger colum = i%colums;
        NSInteger row = i/colums;
        CGFloat x = sideMargin +(insideMargin + contentBtnWidth)*colum;
        CGFloat y = topMargin + (insideMargin + contentBtnHeight)*row;
        CGRect frm = CGRectMake(x, y, contentBtnWidth, contentBtnHeight);
        [self.contentFrames addObject:[NSValue valueWithCGRect:frm]];
    }
}

//根据选中的按钮，去展示右侧内容区域
-(void)setUpContentBtnsWithClassbtn:(UIButton *)sender{
    //根据右侧内容区域所有标签的frame数组，取到最后那个，它的最大Y值就是scrollView的contentSize的height
    CGRect lastFrm = [[self.contentFrames lastObject] CGRectValue];
    CGFloat maxY = CGRectGetMaxY(lastFrm);
    self.contentView.contentSize = CGSizeMake(self.frame.size.width-self.classWidth, maxY);
    
    NSInteger contentBtnNumber = self.contentFrames.count;
    for (NSInteger i = 0; i < contentBtnNumber; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:sender.tag];
        UIView *contentBtn = [self.datasource classifyView:self cellAtIndexPath:indexPath];
        contentBtn.frame = [self.contentFrames[i] CGRectValue];
        [self.contentView addSubview:contentBtn];
        [self.contentBtns addObject:contentBtn];
    }
}

#pragma mark ---刷新右侧内容---
-(void)reloadData{
    
    //每次刷新，右侧内容区域上的标签就要移除
    if (self.contentBtns) {
        for (UIView *view in self.contentBtns) {
            [view removeFromSuperview];
        }
    }
    
    //相关的frame，标签等都移除
    [self.contentFrames removeAllObjects];
    
    [self.contentBtns removeAllObjects];
    
    //重新计算右侧内容区域所有标签的frame
    [self setUpContentFrames];
    
    //根据选中的按钮，去展示右侧内容区域
    [self setUpContentBtnsWithClassbtn:self.selectBtn];
}

#pragma mark ---点击右侧自按钮---

-(void)contentViewTouch:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self.contentView];
    [self.contentFrames enumerateObjectsUsingBlock:^(NSValue *rectValue, NSUInteger index, BOOL *stop) {
        CGRect frm = [rectValue CGRectValue];
        if (CGRectContainsPoint(frm, touchPoint)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:self.selectBtn.tag];
            if ([self.delegate respondsToSelector:@selector(classifyView:didSelectContentViewAtIndexPath:)]) {
                [self.delegate classifyView:self didSelectContentViewAtIndexPath:indexPath];
            }
            
            *stop = YES;
        }
        
    }];
}


#pragma mark ---私有方法---
//顶部间距，代理不返回就用默认
-(CGFloat)topMarginWithType:(HWMarginType)type{
    if ([self.delegate respondsToSelector:@selector(marginOfContentsInClassifyView:withMarginType:)]) {
        return [self.delegate marginOfContentsInClassifyView:self withMarginType:HWMarginTypeTop];
    }
    return Default_TopMargin;
}

//两侧间距，代理不返回就用默认
-(CGFloat)sideMarginWithType:(HWMarginType)type{
    if ([self.delegate respondsToSelector:@selector(marginOfContentsInClassifyView:withMarginType:)]) {
        return [self.delegate marginOfContentsInClassifyView:self withMarginType:HWMarginTypeSide];
    }
    return Default_SideMargin;
}

//内部间距，代理不返回就用默认
-(CGFloat)insideMarginWithType:(HWMarginType)type{
    if ([self.delegate respondsToSelector:@selector(marginOfContentsInClassifyView:withMarginType:)]) {
        return [self.delegate marginOfContentsInClassifyView:self withMarginType:HWMarginTypeInside];
    }
    return Default_InsideMargin;
}
@end
