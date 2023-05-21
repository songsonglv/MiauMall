//
//  MMShopCarBottomView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/15.
//

#import "MMShopCarBottomView.h"
@interface MMShopCarBottomView ()
@property (nonatomic, strong) UILabel *contLa;
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UIButton *couBt;
@end

@implementation MMShopCarBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithWzx:0xa5844d alpha:0.2];
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"coudanFreeShip"] textColor:TCUIColorFromRGB(0xa5844d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
    CGSize size = [NSString sizeWithText:titleLa.text font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    titleLa.frame = CGRectMake(12, 12, size.width, 12);
    [self addSubview:titleLa];
    self.titleLa = titleLa;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:TCUIColorFromRGB(0xa5844d)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"goCoudan"] forState:(UIControlStateNormal)];
    CGSize size1 = [NSString sizeWithText:btn.titleLabel.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    btn.frame = CGRectMake(WIDTH - 30 - size1.width, 6, size1.width + 20, 24);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 12;
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    self.couBt = btn;
    
    UILabel *conLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa5844d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    conLa.frame = CGRectMake(CGRectGetMaxX(titleLa.frame) + 12,12, 0, 12);
    [self addSubview:conLa];
    self.contLa = conLa;
}

-(void)clickBt{
    self.goListBlock(@"1");
}

-(void)setModel:(MMShopCarModel *)model{
    _model = model;
    
    NSString *str = _model.freefreightStr;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] isEqualToString:@"1"]){
        str = [NSString stringWithFormat:@"%@\n %@",_model.freefreightStr,_model.freefreightStr2];
        
        
        CGSize size0 = [NSString sizeWithText:self.titleLa.text font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:12] maxSize:CGSizeMake(WIDTH - self.couBt.width - 40,MAXFLOAT)];
        self.titleLa.frame = CGRectMake(12, 12, size0.width, size0.height);
    }else{
        str = _model.freefreightStr;
        
    }
    
    self.contLa.text = str;
    
    
    
    CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(WIDTH - self.couBt.width - 10,MAXFLOAT)];
    if(CGRectGetMaxX(self.titleLa.frame) + 12 + size.width > self.couBt.x){
        self.contLa.frame = CGRectMake(12, CGRectGetMaxY(self.titleLa.frame) + 12, WIDTH - 24, size.height);
    }else{
        self.contLa.frame = CGRectMake(CGRectGetMaxX(self.titleLa.frame) + 12, 12, size.width, 12);
    }
    self.height = CGRectGetMaxY(self.contLa.frame) + 12;
    [self layoutIfNeeded];
    self.hei = self.height;
   
    
}




@end
