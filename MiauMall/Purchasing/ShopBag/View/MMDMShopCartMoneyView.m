//
//  MMDMShopCartMoneyView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import "MMDMShopCartMoneyView.h"

@interface MMDMShopCartMoneyView ()
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UILabel *allMoneyLa;
@property (nonatomic, strong) UIButton *allBt;
@property (nonatomic, strong) UILabel *sxfeeLa;//手续费
@property (nonatomic, strong) UILabel *sureGoodsFeeLa;//商品确认费
@end

@implementation MMDMShopCartMoneyView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xbfbfbf) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    lab1.frame = CGRectMake(0, 17, WIDTH, 11);
    [self addSubview:lab1];
    self.titleLa = lab1;
    
    UILabel *allLa = [UILabel publicLab:@"" textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    allLa.preferredMaxLayoutWidth = WIDTH - 52;
    [allLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:allLa];
    self.allMoneyLa = allLa;
    
    [allLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(48);
            make.height.mas_equalTo(14);
    }];
    
    UIButton *seleAllBt = [[UIButton alloc]initWithFrame:CGRectMake(16, 68, 16, 16)];
    [seleAllBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [seleAllBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
    [seleAllBt addTarget:self action:@selector(clickAll:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:seleAllBt];
    self.allBt = seleAllBt;
    
    UILabel *sxfeeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    sxfeeLa.preferredMaxLayoutWidth = WIDTH - 156;
    [sxfeeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:sxfeeLa];
    self.sxfeeLa = sxfeeLa;
    
    [sxfeeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42);
            make.top.mas_equalTo(allLa.mas_bottom).offset(8);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *goodsfeeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    goodsfeeLa.preferredMaxLayoutWidth = WIDTH - 156;
    [goodsfeeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:goodsfeeLa];
    self.sureGoodsFeeLa = goodsfeeLa;
    
    [goodsfeeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42);
            make.top.mas_equalTo(sxfeeLa.mas_bottom).offset(8);
            make.height.mas_equalTo(12);
    }];
    
    UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 102, 65, 88, 36)];
    subBt.layer.masksToBounds = YES;
    subBt.layer.cornerRadius = 18;
    [subBt setBackgroundColor:redColor3];
    [subBt setTitle:[UserDefaultLocationDic valueForKey:@"submitAudit"] forState:(UIControlStateNormal)];
    [subBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    subBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
    [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:subBt];
    
}

-(void)clickSub{
    self.tapOrderBlock(@"1");
}

-(void)clickAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.tapSeleBlock(@"1");
    }else{
        self.tapSeleBlock(@"0");
    }
}


-(void)setModel:(MMDMShopCartModel *)model{
    _model = model;
    self.titleLa.text = [NSString stringWithFormat:@"——————  %@  ——————",_model.RateTips];
    [self.allMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"%@：JPY",[UserDefaultLocationDic valueForKey:@"itotal"]]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]);
        confer.text(_model._total).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
        confer.text([NSString stringWithFormat:@"（%@%@）",[UserDefaultLocationDic valueForKey:@"iabout"],_model._totalsignshow]).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Regular" size:12]);
    }];
    
    self.sxfeeLa.text = [NSString stringWithFormat:@"手续费：%@",_model._totalhandingshow];
    self.sureGoodsFeeLa.text = [NSString stringWithFormat:@"商品确认费：%@",_model._totalsureshow];
    
    if([_model.Num1 isEqualToString:_model.num]){
        self.allBt.selected = YES;
    }else{
        self.allBt.selected = NO;
    }
}

@end
