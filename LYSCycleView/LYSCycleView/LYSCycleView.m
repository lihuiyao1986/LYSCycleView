//
//  LYSCycleView.m
//  LYSCycleView
//
//  Created by jk on 2017/3/8.
//  Copyright © 2017年 ;. All rights reserved.
//

#import "LYSCycleView.h"

@interface LYSCycleView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSUInteger _totalItemsCount;
}

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation LYSCycleView


#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - 初始化配置
-(void)initConfig{
    _itemClazz = [UICollectionViewCell class];
    _pageUnselectedDotColor = [UIColor lightGrayColor];
    _pageSelectedDotColor = [UIColor blackColor];
    _interval = 3.0f;
    _pageControlH = 35.f;
    _pageLocation = Left;
    _isAutoScroll = YES;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

#pragma mark - 生成页码视图
-(UIPageControl*)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = _pageUnselectedDotColor;
        _pageControl.currentPageIndicatorTintColor = _pageSelectedDotColor;
        _pageControl.hidesForSinglePage= YES;
    }
    return _pageControl;
}

#pragma mark - 设置
-(void)setPageUnselectedDotColor:(UIColor *)pageUnselectedDotColor{
    _pageUnselectedDotColor = pageUnselectedDotColor;
    _pageControl.pageIndicatorTintColor = pageUnselectedDotColor;
}

-(void)setPageSelectedDotColor:(UIColor *)pageSelectedDotColor{
    _pageSelectedDotColor = pageSelectedDotColor;
    _pageControl.currentPageIndicatorTintColor = _pageSelectedDotColor;
}

#pragma mark - 创建定时器
- (void)setupTimer{
    
    [self invalidateTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

#pragma mark - 解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    [self invalidateTimer];
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - 重写layoutSubviews方法
-(void)layoutSubviews{
    [super layoutSubviews];
    _flowLayout.itemSize = self.bounds.size;
    _collectionView.frame = self.bounds;
    if (_collectionView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    CGSize size = CGSizeMake(self.items.count * 10 * 1.2, self.pageControlH);
    CGFloat x = (self.bounds.size.width - size.width) * 0.5;
    if (self.pageLocation == Right) {
        x = _collectionView.frame.size.width - size.width - 10;
    }else if(self.pageLocation == Left){
        x = _collectionView.frame.size.width - 10;
    }else{
        x = (_collectionView.frame.size.width - size.width)/2;

    }
    CGFloat y = _collectionView.frame.size.height - size.height - 10;
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
}

#pragma mark - 自动滚动
-(void)automaticScroll{
    if (self.items.count == 0) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - 设置是否可以自动滚动
-(void)setIsAutoScroll:(BOOL)isAutoScroll{
    _isAutoScroll = isAutoScroll;
    [self invalidateTimer];
    if (_isAutoScroll) {
        [self setupTimer];
    }
}


#pragma mark - 结束定时器
- (void)invalidateTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(UICollectionView*)collectionView{
    if (!_collectionView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView =[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = true;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        [self.collectionView registerClass:_itemClazz forCellWithReuseIdentifier:NSStringFromClass(_itemClazz)];
        [self addSubview:_collectionView];

    }
    return _collectionView;
}

#pragma mark - 设置itemCell类型
-(void)setItemClazz:(Class)itemClazz{
    NSAssert([itemClazz isSubclassOfClass:[UICollectionViewCell class]],@"类型错误");
    _itemClazz = itemClazz;
    [self.collectionView registerClass:_itemClazz forCellWithReuseIdentifier:NSStringFromClass(_itemClazz)];
}

#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemsCount;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tapBlock) {
        self.tapBlock(self.items[indexPath.row % self.items.count]);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(_itemClazz) forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.items.count;;
    if (self.setItemCellInfoBlock) {
        self.setItemCellInfoBlock(cell,self.items[itemIndex]);
    }
    return cell;
}

#pragma mark - 设置数据
-(void)setItems:(NSArray<NSDictionary *> *)items{
    _items = items;
    _totalItemsCount = self.infiniteLoop ? _items.count * 100 : _items.count;
    self.pageControl.numberOfPages = _items.count;
    if (_items.count != 1) {
        _collectionView.scrollEnabled = YES;
        [self setIsAutoScroll:self.isAutoScroll];
    }else{
        [self invalidateTimer];
        _collectionView.scrollEnabled = NO;
    }
}

#pragma mark - public actions
- (void)adjustWhenControllerViewWillAppera{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.items.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = itemIndex % self.items.count;
    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.isAutoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.isAutoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:_collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    if (!self.items.count) return; // 解决清除timer时偶尔会出现的问题
//    int itemIndex = [self currentIndex];
//    int indexOnPageControl = itemIndex % self.items.count;
}

#pragma mark - 获取当前的index
- (int)currentIndex{
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

@end
