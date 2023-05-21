//
//  MMSpecSelectEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/21.
//

#import "MMSpecSelectEnView.h"
#import "MMFeeInfoModel.h"
#import "MMGoodsAttdataModel.h"

@interface MMSpecSelectEnView ()
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@property (nonatomic, strong) UILabel *specLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) NSArray *goodsSpecArr;
@end

@implementation MMSpecSelectEnView

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMGoodsDetailMainModel *)model andGoodsSpecArr:(nonnull NSArray *)goodsSpecArr{
    if(self = [super initWithFrame:frame]){
        self.goodsSpecArr = goodsSpecArr;
        self.model = model;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    NSArray *arr = @[@"Selected:",@"Availability:",@"Shipping:"];
    float hei = 30;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 65)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
        lab.frame = CGRectMake(16, 0, 100, 18);
        [view addSubview:lab];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = WIDTH - 142;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(112);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 142);
        }];
        
        hei += 65;
        
        if(i == 0){
            self.specLa = lab1;
            UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 30, 5, 12, 6)];
            icon.image = [UIImage imageNamed:@"down_black"];
            [view addSubview:icon];
            
            if(self.goodsSpecArr.count > 0){
                MMGoodsAttdataModel *model2 = self.goodsSpecArr[0];
                if(model2.attr != nil){
                   lab1.text = [NSString stringWithFormat:@"%@ x1",model2.attr];
                }else{
                    lab1.text = @"1";
                }
              
            }else{
                lab1.text = @"1";
            }
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 56)];
            [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
        }else if (i == 1){
            self.timeLa = lab1;
            if(self.goodsSpecArr.count > 0){
                MMGoodsAttdataModel *model2 = self.goodsSpecArr[0];
                NSInteger num = [model2.number integerValue];
                NSString *stock;
                if(num > 0){
                    if(num >= 10){
                        stock = [NSString stringWithFormat:@"%@",[UserDefaultLocationDic valueForKey:@"inStock"]];
                    }else{
                       stock = [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"istock"],model2.number,[UserDefaultLocationDic valueForKey:@"ipiece"]];
                    }
                    
                }else{
                    stock = [NSString stringWithFormat:@"%@",self.model.proInfo.ProductSignTimeStr];
                }
                
                [lab1 rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text([NSString stringWithFormat:@"%@,",stock]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
                    confer.text(self.model.proInfo.ProductSignTimeStr).textColor(TCUIColorFromRGB(0x1d1d1d)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
                }];
              
            }else{
                NSInteger realnum = [self.model.proInfo.RealNumber integerValue];
                NSString *stock;
                if(realnum > 0){
                    if(realnum >= 10){
                        stock = [NSString stringWithFormat:@"%@",[UserDefaultLocationDic valueForKey:@"inStock"]];
                    }else{
                        stock = [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"istock"],self.model.proInfo.RealNumber,[UserDefaultLocationDic valueForKey:@"ipiece"]];
                    }
                    [lab1 rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                        confer.text([NSString stringWithFormat:@"%@,",stock]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
                        confer.text(self.model.proInfo.ProductSignTimeStr).textColor(TCUIColorFromRGB(0x1d1d1d)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
                    }];
                    
                }else{
                    lab1.text = self.model.proInfo.ProductSignTimeStr;
                }
                    
               
                
                
                
            }
            
        }else{
            lab1.height = 16;
            lab1.text = @"Japan";
            lab1.textColor = redColor2;
            NSArray *arr = [MMFeeInfoModel mj_objectArrayWithKeyValuesArray:self.model.yunfei];
            if(arr.count > 0){
                MMFeeInfoModel *model1 = arr[0];
                UILabel *lab2 = [UILabel publicLab:model1.MoneyAll textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
                lab2.preferredMaxLayoutWidth = WIDTH - 142;
                [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
                [view addSubview:lab2];
                
                [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(112);
                                    make.top.mas_equalTo(20);
                                    make.width.mas_equalTo(WIDTH - 142);
                }];
            }
            
        }
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, 234.5, WIDTH - 28, 0.5)];
    line.backgroundColor = lineColor2;
    [self addSubview:line];
}

-(void)setShowStr:(NSString *)showStr{
    _showStr = showStr;
    self.specLa.text = _showStr;
}

-(void)setStockStr:(NSString *)stockStr{
    _stockStr = stockStr;
    if(_stockStr != nil && _stockStr.length > 0){
        [self.timeLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text([NSString stringWithFormat:@"%@,",_stockStr]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
                confer.text(self.model.proInfo.ProductSignTimeStr).textColor(TCUIColorFromRGB(0x1d1d1d)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
        }];
    }
    
}


-(void)clickBt{
    self.returnSelectBlock(@"1");
}

@end
