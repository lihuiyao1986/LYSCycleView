//
//  LYSCycleView.h
//  LYSCycleView
//
//  Created by jk on 2017/3/8.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PageControlLocation){
    Left,
    Center,
    Right
};

typedef void(^TapBlock)(NSDictionary* item);

typedef void(^SetItemCellInfoBlock)(UICollectionViewCell *cell,NSDictionary* item);

@interface LYSCycleView : UIView

#pragma mark - 数据
@property(nonatomic,copy)NSArray<NSDictionary*> *items;

#pragma mark - 是否自动滚动
@property(nonatomic,assign)BOOL isAutoScroll;

#pragma mark - 时间间隔
@property(nonatomic,assign)NSTimeInterval interval;

#pragma mark - 点击回调
@property(nonatomic,copy)TapBlock tapBlock;

#pragma mark - 是否无限循环,默认Yes
@property (nonatomic,assign) BOOL infiniteLoop;

#pragma mark - 更新itemCell的回调
@property(nonatomic,copy)SetItemCellInfoBlock setItemCellInfoBlock;

#pragma mark - item对应的类
@property(nonatomic,assign)Class itemClazz;

#pragma mark - pageControl选中时的颜色
@property(nonatomic,strong)UIColor *pageSelectedDotColor;

#pragma mark - pageControl未选中时的颜色
@property(nonatomic,strong)UIColor *pageUnselectedDotColor;

#pragma mark - pageControl的高度
@property(nonatomic,assign)CGFloat pageControlH;

#pragma mark - pageControl的方向
@property(nonatomic,assign)PageControlLocation pageLocation;

@end
