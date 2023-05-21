//
//  MMDMJiaGuView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import "MMDMJiaGuView.h"

@interface MMDMJiaGuView ()
@property (nonatomic, strong) MMDMChooseLogisticsModel *model;
@end

@implementation MMDMJiaGuView

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMDMChooseLogisticsModel *)model{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.model = model;
        [self creatUI];
    }
    return self;
}

  
-(void)creatUI{
    KweakSelf(self);
    UILabel *titleLa = [UILabel publicLab:@"附加费用" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    
    titleLa.frame = CGRectMake(17, 24, WIDTH - 34, 15);
    
    [self addSubview:titleLa];
    
//    CGSize size = [NSString sizeWithText:self.model.ReinforcementTitle font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,12)];
    
    CGSize size1 = [NSString sizeWithText:self.model.ReinforcementTips font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, size1.height + 47)];
    view.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self addSubview:view];
    
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [seleBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
    [seleBt setEnlargeEdgeWithTop:0 right:200 bottom:size1.height left:15];
    seleBt.selected = NO;
    [view addSubview:seleBt];
    
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab.frame = CGRectMake(40, 1, WIDTH - 60, 14);
    [view addSubview:lab];
    
    [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(weakself.model.ReinforcementTitle).textColor(TCUIColorFromRGB(0x030303)).font([UIFont fontWithName:@"PingFangSC-Semibold" size:14]);
        confer.text([NSString stringWithFormat:@" %@:%@",@"附加费",weakself.model.ReinforcementMoneyShow]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-Semibold" size:14]);
    }];
    
    UILabel *lab1 = [UILabel publicLab:self.model.ReinforcementTips textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab1.frame = CGRectMake(38, 27, WIDTH - 60, size1.height);
    [view addSubview:lab1];
}

-(void)clickBt:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.selectJiaguBlock(@"1");
    }else{
        self.selectJiaguBlock(@"0");
    }
}


@end
