//
//  MMGoodsDatailTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/23.
//

#import "MMGoodsDatailTopView.h"

@interface MMGoodsDatailTopView ()

@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIView *lineV;//底部红线

@end

@implementation MMGoodsDatailTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(64, StatusBarHeight, 200, 30)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderColor = TCUIColorFromRGB(0xeeeeee).CGColor;
    view.layer.borderWidth = 0.5;
    [self addSubview:view];
    
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 16, 16)];
    searchImage.image = [UIImage imageNamed:@"homeSearch"];
    [view addSubview:searchImage];
    
    UILabel *lab = [UILabel publicLab:@"搜索" textColor:TCUIColorFromRGB(0x727272) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    lab.frame = CGRectMake(CGRectGetMaxX(searchImage.frame) + 6, 8.5, 100, 13);
    [view addSubview:lab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    
    NSArray *arr = @[@"商品",@"评价",@"详情",@"推荐"];
    CGFloat wid = WIDTH/4;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid * i, CGRectGetMaxY(view.frame) + 15, wid, 35)];
        btn.tag = 1000 + i;
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        if(i == 0){
            self.selectBt = btn;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
            self.btn1 = btn;
        }else if (i == 1){
            self.btn2 = btn;
        }else if (i == 2){
            self.btn3 = btn;
        }else{
            self.btn4 = btn;
        }
    }
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 82, 20, 2)];
    lineV.x = self.btn1.centerX;
    lineV.backgroundColor = redColor2;
    lineV.layer.masksToBounds = YES;
    lineV.layer.cornerRadius = 1;
    [self addSubview:lineV];
    self.lineV = lineV;
}

-(void)clickSearch{
    self.searchBlock(@"1");
}

-(void)clickBtn:(UIButton *)sender{
    if (![self.selectBt isEqual:sender]) {
        self.selectBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    
    sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:15];
    self.selectBt = sender;
    
    
    NSInteger index = sender.tag - 1000;
    self.scrollOnBlock([NSString stringWithFormat:@"%ld",(long)index]);
    [self changeLineX:index];
}

-(void)changeLineX:(NSInteger )index{
    KweakSelf(self);
    if(index == 0){
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn1.centerX;
        } completion:^(BOOL finished) {
        }];
    }else if (index == 1){
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn2.centerX;
        } completion:^(BOOL finished) {
        }];
    }else if (index == 2){
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn3.centerX;
        } completion:^(BOOL finished) {
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn4.centerX;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)setScrollIndex:(NSString *)scrollIndex{
    KweakSelf(self);
    _scrollIndex = scrollIndex;
    NSInteger index = [_scrollIndex integerValue];
    if(index == 0){
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn1.centerX;
        } completion:^(BOOL finished) {
        }];
    }else if (index == 1){
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn2.centerX;
        } completion:^(BOOL finished) {
        }];
    }else if (index == 2){
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn3.centerX;
        } completion:^(BOOL finished) {
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            weakself.lineV.centerX = weakself.btn4.centerX;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
