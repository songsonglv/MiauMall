//
//  MMDMOrderKnowView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/5.
//

#import "MMDMOrderKnowView.h"

@implementation MMDMOrderKnowView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
    }
    return self;
}

-(void)setModel:(MMDMConfirmOrderModel *)model{
    _model = model;
    [self creatUI];
}

-(void)creatUI{
    UILabel *tiLa = [UILabel publicLab:@"下单须知" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    tiLa.frame = CGRectMake(17, 15, WIDTH - 34, 15);
    [self addSubview:tiLa];
    
    float hei = 42;
    
    NSArray *arr = self.model.OrderKnowTips;
    for (int i = 0; i < arr.count; i++) {
        NSString *str = arr[i];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 56,MAXFLOAT)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, size.height + 24)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(17, 0, 15, 15)];
        btn.centerY = (size.height + 24)/2;
        btn.tag = 100 + i;
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(clickSelect:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:(view.height - 15)/2 right:HEIGHT - 38 bottom:(view.height - 15)/2 left:17];
        [view addSubview:btn];
        
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(38, 15, WIDTH - 56, size.height);
        [view addSubview:lab];
        
        hei += view.height;
    }
}

-(void)clickSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.clickKnowBlock(self.model.OrderKnowTips[sender.tag - 100], @"1");
    }else{
        self.clickKnowBlock(self.model.OrderKnowTips[sender.tag - 100], @"0");
    }
}

@end
