//
//  MMDMUseIntegView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMDMUseIntegView.h"

@interface MMDMUseIntegView ()
@property (nonatomic, strong) UILabel *myLa;
@property (nonatomic, strong) UILabel *dkLa;
@property (nonatomic, strong) UILabel *seleLa;
@end

@implementation MMDMUseIntegView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(17, 11, 16, 16)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [seleBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clickSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:seleBt];
    
    UILabel *pointLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    pointLa.preferredMaxLayoutWidth = WIDTH - 100;
    [pointLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:pointLa];
    self.myLa = pointLa;
    
    [pointLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *seleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa9a9a9) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    seleLa.frame = CGRectMake(40, 37, WIDTH - 52, 11);
    [self addSubview:seleLa];
    self.seleLa = seleLa;

    UILabel *dkLa= [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    dkLa.preferredMaxLayoutWidth = 100;
    [dkLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:dkLa];
    self.dkLa = dkLa;
    
    [dkLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(13);
    }];
}

-(void)setModel:(MMDMConfirmOrderModel *)model{
    _model = model;
    [self.myLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"%@(%@%@%@)",[UserDefaultLocationDic valueForKey:@"midou"],[UserDefaultLocationDic valueForKey:@"ioverall"],_model.MyIntegral,[UserDefaultLocationDic valueForKey:@"ige"]]).textColor(TCUIColorFromRGB(0x1e1e1e)).font([UIFont systemFontOfSize:13]);
    }];
    [self.seleLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"%@%@%@%@",[UserDefaultLocationDic valueForKey:@"haveSelected"],_model.UseIntegral,[UserDefaultLocationDic valueForKey:@"ige"],[UserDefaultLocationDic valueForKey:@"integral"]]).textColor(TCUIColorFromRGB(0xa9a9a9)).font([UIFont systemFontOfSize:11]);
    }];
    self.dkLa.text = _model.UseIntegralShow;
}

-(void)clickSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.returnUseBlock(@"1");
    }else{
        self.returnUseBlock(@"0");
    }
}

@end
