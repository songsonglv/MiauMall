//
//  MMGoodsDetailBottomView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//

#import "MMGoodsDetailBottomView.h"
#import "MYNumLabel.h"
@interface MMGoodsDetailBottomView ()
@property (nonatomic, strong) MYNumLabel *numLa;
@end

@implementation MMGoodsDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    NSArray *arr = @[@"首页",@"客户",@"购物车"];
    NSArray *imgArr = @[@"home_icon",@"kefu_icon",@"car_icon"];
    
    CGFloat wid = 7;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid, 10, 34, 34)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 24, 20)];
        image.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:image];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x636363) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:9 numberOfLines:0];
        lab.frame = CGRectMake(0, 28, 34, 9);
        [view addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(wid ,10, 34, 34);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        wid += 46;
        
        if(i == 2){
            MYNumLabel *numLa = [[MYNumLabel alloc]initWithFrame:CGRectMake(14, -5, 20, 14)];
            numLa.backgroundColor = redColor2;
            numLa.layer.masksToBounds = YES;
            numLa.layer.cornerRadius = 7;
            numLa.textColor = TCUIColorFromRGB(0xffffff);
            numLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
            numLa.textAlignment = NSTextAlignmentCenter;
            [view addSubview:numLa];
            self.numLa = numLa;
        }
    }
    
    UIButton *buyNowBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 120, 8, 100, 40)];
    buyNowBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    buyNowBt.backgroundColor = TCUIColorFromRGB(0xd64f3e);
    buyNowBt.layer.masksToBounds = YES;
    buyNowBt.layer.cornerRadius = 20;
    [buyNowBt setTitle:@"立即购买" forState:(UIControlStateNormal)];
    [buyNowBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [buyNowBt addTarget:self action:@selector(clickBuyNow) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:buyNowBt];
    self.exchangeBt = buyNowBt;
    
    UIButton *addCarBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 230, 8, 100, 40)];
    addCarBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    addCarBt.backgroundColor = TCUIColorFromRGB(0x333333);
    addCarBt.layer.masksToBounds = YES;
    addCarBt.layer.cornerRadius = 20;
    [addCarBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    [addCarBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [addCarBt addTarget:self action:@selector(clickAddCar) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:addCarBt];
    self.addCarBt = addCarBt;
}

-(void)clickBuyNow{
    self.buyNowTapBlock(@"1");
}

-(void)clickAddCar{
    self.addCarTapBlock(@"1");
}

-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 100){
        self.homeTapBlock(@"1");
    }else if(sender.tag == 101){
        self.kefuTapBlock(@"1");
    }else{
        self.carTapBlock(@"1");
    }
}

-(void)setNum:(NSString *)num{
    _num = num;
    self.numLa.count = _num;
    NSInteger numer = [num integerValue];
    if (numer > 99) {
        self.numLa.width = 26;
        
    }else if (numer > 9){
        self.numLa.width = 20;
        
    }else if (numer > 0) {
        self.numLa.width = 14;
       
    }else{
        self.numLa.hidden = YES;
    }
}

@end
