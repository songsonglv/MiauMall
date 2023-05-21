//
//  MMDMShopCartEditView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMDMShopCartEditView.h"
@interface MMDMShopCartEditView ()
@property (nonatomic, strong) UIButton *seleBt;
@property (nonatomic, strong) UIButton *deleBt;
@end

@implementation MMDMShopCartEditView

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
    
}

-(void)setModel:(MMDMShopCartModel *)model{
    _model = model;
    if([_model.Num1 isEqualToString:_model.num]){
        self.seleBt.selected = YES;
    }else{
        self.seleBt.selected = NO;
    }
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
