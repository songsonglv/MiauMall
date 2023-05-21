//
//  MMShopCarEditView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/16.
//

#import "MMShopCarEditView.h"

@interface MMShopCarEditView ()
@property (nonatomic, strong) UIButton *seleBt;
@property (nonatomic, strong) UIButton *collecBt;
@property (nonatomic, strong) UIButton *deleBt;

@end

@implementation MMShopCarEditView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUI];
    }
    return self;
}


-(void)setUI{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 19, 16, 16)];
    [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(clickAll:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setEnlargeEdgeWithTop:5 right:30 bottom:5 left:5];
    [self addSubview:btn];
    self.seleBt = btn;
    
    NSString *str = [UserDefaultLocationDic valueForKey:@"allSelect"];
    UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    lab.frame = CGRectMake(32, 20, 60, 13);
    [self addSubview:lab];
    
    NSString *str1 = [UserDefaultLocationDic valueForKey:@"idelete"];
    NSString *str2 = [UserDefaultLocationDic valueForKey:@"moveCollect"];
    CGSize size = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UIButton *deleBt = [[UIButton alloc]init];
    deleBt.frame = CGRectMake(WIDTH - size.width - 50, 15, size.width + 36, 24);
    [deleBt setTitle:str1 forState:(UIControlStateNormal)];
    [deleBt setTitleColor:TCUIColorFromRGB(0x676767) forState:(UIControlStateNormal)];
    deleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Mdeium" size:12];
    deleBt.layer.masksToBounds = YES;
    deleBt.layer.cornerRadius = 12;
    deleBt.layer.borderColor = TCUIColorFromRGB(0x676767).CGColor;
    deleBt.layer.borderWidth = 0.5;
    [deleBt addTarget:self action:@selector(clickDele) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:deleBt];
    self.deleBt = deleBt;
    
    CGSize size1 = [NSString sizeWithText:str2 font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UIButton *collecBt = [[UIButton alloc]init];
    collecBt.frame = CGRectMake(WIDTH - size.width - size1.width - 105, 15, size1.width + 51, 24);
    [collecBt setTitle:str2 forState:(UIControlStateNormal)];
    [collecBt setTitleColor:TCUIColorFromRGB(0x676767) forState:(UIControlStateNormal)];
    collecBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Mdeium" size:12];
    collecBt.layer.masksToBounds = YES;
    collecBt.layer.cornerRadius = 12;
    collecBt.layer.borderColor = TCUIColorFromRGB(0x676767).CGColor;
    collecBt.layer.borderWidth = 0.5;
    [collecBt addTarget:self action:@selector(clickColl) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:collecBt];
    self.collecBt = collecBt;
}

-(void)setModel:(MMShopCarModel *)model{
    _model = model;
    if([_model.num isEqualToString:_model.Num1]){
        self.seleBt.selected = YES;
    }else{
        self.seleBt.selected = NO;
    }
}

-(void)clickColl{
    self.tapCollBlock(@"1");
}

-(void)clickDele{
    self.tapDeleBlock(@"1");
}

-(void)clickAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.tapSeleBlock(@"1");
    }else{
        self.tapSeleBlock(@"0");
    }
    
}

@end
