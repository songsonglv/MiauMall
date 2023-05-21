//
//  MMLTShipInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/13.
// 乐天发货信息view

#import "MMLTShipInfoView.h"
#import "MMFeeInfoModel.h"

@interface MMLTShipInfoView ()
@property (nonatomic, strong) UILabel *specLa;
@property (nonatomic, strong) UILabel *stockLa;
@property (nonatomic, strong) UILabel *limitLa;//限购label
@property (nonatomic, strong) UILabel *addressLa;//发货地址label
@end

@implementation MMLTShipInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"iselect"],[UserDefaultLocationDic valueForKey:@"istock"],[UserDefaultLocationDic valueForKey:@"shippingin2"]];
    for (int i = 0; i < arr.count; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44 * i, WIDTH - 20, 44)];
        [self addSubview:view];
        
        CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(10, 15, size.width, 13);
        [view addSubview:lab];
        
        UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 280;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(65);
                    make.top.mas_equalTo(15);
                    make.height.mas_equalTo(13);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xeef0f1);
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(8);
                make.top.mas_equalTo(lab1.mas_bottom).offset(12);
                make.right.mas_equalTo(-8);
                make.height.mas_equalTo(0.5);
        }];
        
        if(i == 0){
            self.specLa = lab1;
            self.specLa.text = [NSString stringWithFormat:@"x1%@",[UserDefaultLocationDic valueForKey:@"ipieces"]];
            UIImageView *icon3 = [[UIImageView alloc]init];
            icon3.image = [UIImage imageNamed:@"right_icon_black"];
            [view addSubview:icon3];
            
            [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-18);
                    make.top.mas_equalTo(18);
                    make.width.mas_equalTo(4);
                    make.height.mas_equalTo(8);
            }];
            
            UIButton *selectBt = [[UIButton alloc]init];
            [selectBt setBackgroundColor:UIColor.clearColor];
            [selectBt addTarget:self action:@selector(selectSpec) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:selectBt];

            [selectBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(44);
            }];
            
        }else if (i == 1){
            self.stockLa = lab1;
        }else{
            self.addressLa = lab1;
//            line.hidden = YES;
        }
    }
    
    NSArray *arr1 = @[[UserDefaultLocationDic valueForKey:@"directMail"],[UserDefaultLocationDic valueForKey:@"guarante"],[UserDefaultLocationDic valueForKey:@"falsePays"],[UserDefaultLocationDic valueForKey:@"taxInclusive"],[UserDefaultLocationDic valueForKey:@"bzcwlythh"]];
    CGFloat wid = 12;
    NSInteger z = 0;
    NSInteger j = 0;
    for (int i = 0; i < arr1.count; i++) {
        NSDictionary *attrs1 = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:12]};
        CGSize size1 = [arr1[i] sizeWithAttributes:attrs1];
        UIView *view = [[UIView alloc]init];
        [self addSubview:view];
        
        if((wid + size1.width + 14) > (WIDTH - 45)){
            z += 1;
            wid = 12;
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(wid);
                    make.top.mas_equalTo(150 + z * 20);
                    make.width.mas_equalTo(size1.width + 14);
                    make.height.mas_equalTo(12);
        }];
        
        
        
        
        wid = wid + (14 + size1.width) + 12;
       
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"select_icon_black"];
        [view addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(1);
                    make.width.height.mas_equalTo(10);
        }];
        
        UILabel *lab = [UILabel publicLab:arr1[i] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(icon.mas_right).offset(4);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(size1.width);
                    make.height.mas_equalTo(12);
        }];
    }
    
    UIImageView *icon4 = [[UIImageView alloc]init];
    icon4.image = [UIImage imageNamed:@"right_icon_black"];
    [self addSubview:icon4];
    
    [icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(152);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    UIButton *equityBt = [[UIButton alloc]init];
    [equityBt setBackgroundColor:UIColor.clearColor];
    [equityBt addTarget:self action:@selector(clickEquity) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:equityBt];
    
    [equityBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(132);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
    }];
}




-(void)setProInfo:(MMGoodsDetailMainModel *)proInfo{
    _proInfo = proInfo;
    NSInteger realnum = [_proInfo.proInfo.RealNumber integerValue];
    
    if(realnum > 0){
        if(realnum >= 10){
            self.stockLa.text = [NSString stringWithFormat:@"%@,%@",[UserDefaultLocationDic valueForKey:@"inStock"],_proInfo.proInfo.ProductSignTimeStr];
        }else{
            self.stockLa.text = [NSString stringWithFormat:@"%@%@%@,%@",[UserDefaultLocationDic valueForKey:@"istock"],_proInfo.proInfo.RealNumber,[UserDefaultLocationDic valueForKey:@"ipiece"],_proInfo.proInfo.ProductSignTimeStr];
        }
        
    }else{
        self.stockLa.text = [NSString stringWithFormat:@"%@",_proInfo.proInfo.ProductSignTimeStr];
    }
    
    if(_proInfo.yunfei.count > 0){
        NSDictionary *dic = _proInfo.yunfei[0];
        MMFeeInfoModel *model = [MMFeeInfoModel mj_objectWithKeyValues:dic];
        self.addressLa.text = [NSString stringWithFormat:@"%@ (%@)",[UserDefaultLocationDic valueForKey:@"ijapan"],model.MoneyAll];
    }
}

-(void)setShowStr:(NSString *)showStr{
    _showStr = showStr;
    self.specLa.text = _showStr;
}

-(void)setStockStr:(NSString *)stockStr{
    _stockStr = stockStr;
    self.stockLa.text = _stockStr;
}

-(void)selectSpec{
    self.selectTapBlock(@"1");
}


-(void)clickEquity{
    self.equityTapBlock(@"1");
}
@end
