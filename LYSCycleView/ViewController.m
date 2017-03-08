//
//  ViewController.m
//  LYSCycleView
//
//  Created by jk on 2017/3/8.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"
#import "LYSCycleView.h"
#import "MyCell.h"
@interface ViewController ()

@property(nonatomic,strong)LYSCycleView *cycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cycleView.items = @[@{@"title":@"李焱生1"},@{@"title":@"李焱生2"},@{@"title":@"李焱生3"},@{@"title":@"李焱生4"}];
//    self.cycleView.items = @[@{@"title":@"李焱生1"}];
   
    [self.view addSubview:self.cycleView];
}


-(LYSCycleView*)cycleView{
    if (!_cycleView) {
        _cycleView = [[LYSCycleView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 100)];
        _cycleView.pageSelectedDotColor = [UIColor redColor];
        _cycleView.pageUnselectedDotColor = [UIColor grayColor];
        _cycleView.itemClazz = [MyCell class];
        _cycleView.pageLocation = Center;
        _cycleView.infiniteLoop = YES;
        _cycleView.isAutoScroll = YES;
        _cycleView.tapBlock = ^(NSDictionary* item){
            NSLog(@"您点击的是%@",item);
        };
        _cycleView.setItemCellInfoBlock = ^(UICollectionViewCell *cell,NSDictionary* item){
//            cell.backgroundColor = [UIColor lightGrayColor];
            ((MyCell *)cell).item = item;
        };
        _cycleView.layer.borderWidth = 2;
    }
    return _cycleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
