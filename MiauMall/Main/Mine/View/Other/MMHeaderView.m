//
//  MMHeaderView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/6.
//

#import "MMHeaderView.h"

@interface MMHeaderView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *contLa;
@end

@implementation MMHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _open = NO;
        CGFloat titleFont = 15;
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:backView];
        self.backView = backView;
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:titleFont numberOfLines:0];
        [backView addSubview:lab];
        self.contLa = lab;
        
        UIButton *btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(doSelect) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:20 right:10 bottom:20 left:WIDTH - 50];
        [btn setImage:[UIImage imageNamed:@"down_black"] forState:(UIControlStateNormal)];
        [backView addSubview:btn];
        self.backBt = btn;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, 59.5, WIDTH - 36, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
        [backView addSubview:line];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    self.contLa.frame = CGRectMake(27, 23, WIDTH - 100, 14);
    [self.backBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-28);
        make.top.mas_equalTo(27);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(6);
        }];
}


-(void)setModel:(MMQuestionFirstModel *)model{
    _model = model;
    self.contLa.text = _model.Name;
}

-(void)doSelect{
    if(_delegate && [_delegate respondsToSelector:@selector(selectWidth:)]){
        [_delegate selectWidth:self];
    }
}
@end
