//
//  MMDMOrderTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import "MMDMOrderTopView.h"

@interface MMDMOrderTopView ()
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation MMDMOrderTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
//        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    NSArray *titleArr = @[@"全部",@"审核",@"物流",@"支付",@"售后"];
    float wid = (WIDTH - 20)/titleArr.count;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + wid * i, 20, wid, 14)];
        [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        btn.selected = NO;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        if(i != 0){
            [btn setImage:[UIImage imageNamed:@"smail_down_black"] forState:(UIControlStateNormal)];
            [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:4];
        }
        
        if(i == self.selectIndex){
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
            btn.selected = YES;
            self.selectBtn = btn;
        }
    }
}

-(void)clickBt:(UIButton *)sender{
    NSInteger tag = sender.tag - 100;
    if([sender isEqual:self.selectBtn]){
        
    }else{
        self.selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.selectBtn.selected = NO;
        sender.selected = YES;
        sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
        self.selectBtn = sender;
    }
    self.selectIndexBlock(tag,self.selectBtn);
}


-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self creatUI];
}

@end
