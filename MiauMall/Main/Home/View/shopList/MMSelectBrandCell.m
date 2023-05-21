//
//  MMSelectBrandCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/9.
//

#import "MMSelectBrandCell.h"
@interface MMSelectBrandCell ()


@end

@implementation MMSelectBrandCell


-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self setupUI];
}
    return self;
}


-(void)setupUI{
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab.frame = CGRectMake(15, 10, WIDTH/2 - 30, 12);
    [self.contentView addSubview:lab];
    self.nameLa = lab;
    
   
    
    UIImageView *seleImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2 - 15, 8.5, 15, 15)];
    [self.contentView addSubview:seleImage];
    self.seleImage = seleImage;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH/2, 22)];
//    [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//    [btn setImage:[UIImage imageNamed:@"selected"] forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
}

-(void)setSelected:(BOOL)selected{
    if(selected){
        self.seleImage.image = [UIImage imageNamed:@"selected"];
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }else{
        self.seleImage.image = [UIImage imageNamed:@""];
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
}

-(void)clickBt:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.returnDataBlock(self.model.ID, @"1");
        self.seleImage.image = [UIImage imageNamed:@"selected"];
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }else{
        self.returnDataBlock(self.model.ID, @"0");
        self.seleImage.image = [UIImage imageNamed:@""];
        self.nameLa.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
}


-(void)setModel:(MMBrandModel *)model{
    _model = model;
    self.nameLa.text = _model.Name;
}

//-(void)setModel1:(MMSortModel *)model1{
//    _model1 = model1;
//    self.nameLa.text = _model1.Name;
//}
//
//-(void)setModel2:(MMCollageSortAndBrandModel *)model2{
//    _model2 = model2;
//    self.nameLa.text = _model2.name;
//}
@end
