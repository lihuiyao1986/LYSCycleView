//
//  MyCell.m
//  LYSCycleView
//
//  Created by jk on 2017/3/8.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "MyCell.h"

@interface MyCell (){
    UILabel *_label;
}

@end

@implementation MyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
    }
    return self;
}

-(void)setItem:(NSDictionary *)item{
    _item = item;
    _label.text = [item objectForKey:@"title"];
}

@end
