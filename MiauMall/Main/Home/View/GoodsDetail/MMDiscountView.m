//
//  MMDiscountView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//  优惠弹窗

#import "MMDiscountView.h"

@interface MMDiscountView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@property (nonatomic, strong) MMGoodsProInfoModel *model1;
@end

@implementation MMDiscountView

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)model andMoreModel:(nonnull MMGoodsProInfoModel *)model1{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        self.model1 = model1;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 730, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 15;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 710, WIDTH, 710)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.contentView addGestureRecognizer:tap1];
    
    float discountPrice = [self.model.proInfo.ActiveDiscountPrice floatValue];
    if(discountPrice > 0){
        self.topView.y = 2 * HEIGHT - 730;
        self.contentView.y = 2 * HEIGHT - 710;
    }else{
        self.topView.y = 2 * HEIGHT - 570;
        self.contentView.y = 2 * HEIGHT - 550;
    }
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 30, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"discountDetail"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(10, 15, WIDTH - 20, 15);
    [self.contentView addSubview:titleLa];
    
    UILabel *handlePrice = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:24 numberOfLines:0];
    [self.contentView addSubview:handlePrice];
    
    CGSize size2 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"daoshoujia"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"daoshoujia"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    lab.backgroundColor = redColor2;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 11;
    [self.contentView addSubview:lab];
    float activePrice = [self.model.proInfo.ActivePrice floatValue];
    
    if([self.model.proInfo.cid isEqualToString:@"794"]){
        //预售
        CGSize size = [NSString sizeWithText:self.model.proInfo.TotalPriceShowSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        CGSize size1 = [NSString sizeWithText:self.model.proInfo.TotalPriceShowPrice font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:24] maxSize:CGSizeMake(MAXFLOAT,24)];
       
        float allWid = size.width + size1.width + size2.width + 16 + 5;
        handlePrice.frame = CGRectMake((WIDTH - allWid)/2, CGRectGetMaxY(titleLa.frame) + 20, size.width + size1.width, 21);
        
        [handlePrice rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(self.model.proInfo.TotalPriceShowSign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:15]);
            confer.text(self.model.proInfo.TotalPriceShowPrice).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:24]);
        }];
        
        lab.frame = CGRectMake(CGRectGetMaxX(handlePrice.frame) + 5, CGRectGetMaxY(titleLa.frame) + 19, size2.width + 16, 22);
        
        
    }else if(activePrice > 0){
        //活动价大于0
        CGSize size = [NSString sizeWithText:self.model.proInfo.ActivePriceShowSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        CGSize size1 = [NSString sizeWithText:self.model.proInfo.ActivePriceShowPrice font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:24] maxSize:CGSizeMake(MAXFLOAT,24)];
        
        float allWid = size.width + size1.width + size2.width + 16 + 5;
        handlePrice.frame = CGRectMake((WIDTH - allWid)/2, CGRectGetMaxY(titleLa.frame) + 20, size.width + size1.width, 21);
        
        [handlePrice rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(self.model.proInfo.ActivePriceShowSign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:15]);
            confer.text(self.model.proInfo.ActivePriceShowPrice).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:24]);
        }];
        
        lab.frame = CGRectMake(CGRectGetMaxX(handlePrice.frame) + 5, CGRectGetMaxY(titleLa.frame) + 19, size2.width + 16, 22);
    }else{
        CGSize size = [NSString sizeWithText:self.model.proInfo.PriceShowSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
        CGSize size1 = [NSString sizeWithText:self.model.proInfo.PriceShowPrice font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:24] maxSize:CGSizeMake(MAXFLOAT,24)];
        
        float allWid = size.width + size1.width + size2.width + 16 + 5;
        handlePrice.frame = CGRectMake((WIDTH - allWid)/2, CGRectGetMaxY(titleLa.frame) + 20, size.width + size1.width, 21);
        
        [handlePrice rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(self.model.proInfo.PriceShowSign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:15]);
            confer.text(self.model.proInfo.PriceShowPrice).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:24]);
        }];
        
        lab.frame = CGRectMake(CGRectGetMaxX(handlePrice.frame) + 5, CGRectGetMaxY(titleLa.frame) + 19, size2.width + 16, 22);
    }
    
    NSString *priceStr = activePrice > 0 ? [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.proInfo.ActivePrice,[UserDefaultLocationDic valueForKey:@"jpYuan"]] : [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.proInfo.Price,[UserDefaultLocationDic valueForKey:@"jpYuan"]];
    
    CGSize size = [NSString sizeWithText:priceStr font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UILabel *aboutLa = [UILabel publicLab:priceStr textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    aboutLa.frame = CGRectMake(0, CGRectGetMaxY(handlePrice.frame) + 10, WIDTH, 13);
    [self.contentView addSubview:aboutLa];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    [self.contentView addSubview:bgImage];
    float wid = (WIDTH - 20)/2;
    if(discountPrice > 0){
        bgImage.image = [UIImage imageNamed:@"red_box_b"];
        bgImage.frame = CGRectMake(10, CGRectGetMaxY(aboutLa.frame) + 10, WIDTH - 20, 160);
        
        UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"dqgmkysydyh"] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.frame = CGRectMake(10, 30, WIDTH - 40, 12);
        [bgImage addSubview:lab1];
        
        UILabel *subLa = [UILabel publicLab:@"一" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:20 numberOfLines:0];
        subLa.frame = CGRectMake(0, 78, 9, 2);
        subLa.centerX = bgImage.width/2;
        [bgImage addSubview:subLa];
        
//        CGSize size = [NSString sizeWithText:self.model.proInfo.PriceShowSign font:[UIFont fontWithName:@"PingFangSC-Regular" size:10] maxSize:CGSizeMake(MAXFLOAT,10)];
//        CGSize size1 = [NSString sizeWithText:self.model.proInfo.PriceShowPrice font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
        
        UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        priceLa.frame = CGRectMake(0, 72, wid, 14);
        [bgImage addSubview:priceLa];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(self.model.proInfo.PriceShowSign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Regular" size:10]);
            confer.text(self.model.proInfo.PriceShowPrice).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
        }];
        
        UILabel *aLab = [UILabel publicLab:[NSString stringWithFormat:@"%@JPY%@",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.proInfo.Price] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        aLab.frame = CGRectMake(0, CGRectGetMaxY(priceLa.frame) + 13, wid, 11);
        [bgImage addSubview:aLab];
        
        UILabel *dqLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"discountOldPrice"] textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
        dqLa.frame = CGRectMake(0, CGRectGetMaxY(aLab.frame) + 12, wid, 12);
        [bgImage addSubview:dqLa];
        
        UILabel *dkLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"iduction"] textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
        dkLa.frame = CGRectMake(wid, 50, wid, 12);
        [bgImage addSubview:dkLa];
        
        
        UILabel *priceLa1 = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        priceLa1.frame = CGRectMake(wid, 72, wid, 14);
        [bgImage addSubview:priceLa1];
        
        [priceLa1 rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(self.model.proInfo.ActiveDiscountPriceShowSign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Regular" size:10]);
            confer.text(self.model.proInfo.ActiveDiscountPriceShowPrice).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
        }];
        
        UILabel *aLab1 = [UILabel publicLab:[NSString stringWithFormat:@"%@JPY%@",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.proInfo.ActiveDiscountPrice] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        aLab1.frame = CGRectMake(wid, CGRectGetMaxY(priceLa.frame) + 13, wid, 11);
        [bgImage addSubview:aLab1];
        
        UILabel *dqLa1 = [UILabel publicLab:self.model.proInfo.DiscountName textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
        dqLa1.frame = CGRectMake(wid, CGRectGetMaxY(aLab.frame) + 12, wid, 12);
        [bgImage addSubview:dqLa1];
        
    }else{
        bgImage.image = [UIImage imageNamed:@"red_box_s"];
        bgImage.frame = CGRectMake(10, CGRectGetMaxY(aboutLa.frame) + 10, WIDTH - 20, 62);
        
        UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"dqgmkyxsdjg"] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.frame = CGRectMake(10, 30, WIDTH - 40, 12);
        [bgImage addSubview:lab1];
    }
    
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr1 addObject:[UserDefaultLocationDic valueForKey:@"midou"]];
    [arr2 addObject:self.model.proInfo.inte];
    
    float activeP1 = [self.model.proInfo.ActivePrice floatValue];
    if(activeP1 > 0){
        [arr1 addObject:[UserDefaultLocationDic valueForKey:@"idiscount"]];
        [arr2 addObject:self.model.proInfo.DiscountTips];
    }
    
    if(self.model.proInfo.PriceCutName == nil || [self.model.proInfo.PriceCutName isEmpty] || [self.model.proInfo.PriceCutName isEqualToString:@""]){
        
    }else{
        [arr1 addObject:[UserDefaultLocationDic valueForKey:@"zhijiang"]];
        [arr2 addObject:self.model.proInfo.PriceCutName];
    }
    
    if(self.model1.OptionalName){
        [arr1 addObject:[UserDefaultLocationDic valueForKey:@"nChoose"]];
        [arr2 addObject:self.model1.OptionalName];
    }
    
    if([self.model1.IsFullGift isEqualToString:@"1"]){
        [arr1 addObject:[UserDefaultLocationDic valueForKey:@"subtotalGifts"]];
        [arr2 addObject:[UserDefaultLocationDic valueForKey:@"subtotalGifts"]];
    }
    
    
    
    for (int i = 0; i < arr1.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgImage.frame) + 30 + 48 * i, WIDTH, 40)];
        [self.contentView addSubview:view];
        CGSize size = [NSString sizeWithText:arr1[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        
        
        UILabel *lab1 = [UILabel publicLab:arr1[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab1.backgroundColor = redColor2;
        lab1.layer.masksToBounds = YES;
        lab1.layer.cornerRadius = 2.5;
        [view addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(size.width + 10);
                    make.height.mas_equalTo(16);
        }];
        
        UILabel *lab2 = [UILabel publicLab:arr2[i] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab2.preferredMaxLayoutWidth = WIDTH - size.width - 42;
        [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab2];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab1.mas_right).offset(8);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 47.5, WIDTH - 24, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
        [view addSubview:line];
        
        if(i == arr1.count - 1){
            line.hidden = YES;
        }
        
        if(i == 0){
            UIImageView *rightIcon = [[UIImageView alloc]init];
            rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
            [view addSubview:rightIcon];
            
            [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(-18);
                            make.centerY.mas_equalTo(view);
                            make.width.mas_equalTo(4);
                            make.height.mas_equalTo(8);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundColor:UIColor.clearColor];
            [btn addTarget:self action:@selector(clickJump) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.top.right.bottom.mas_equalTo(0);
            }];
        }
    }
//    NSArray *arr = @[@"蜜豆",@"折扣"];
//    for (int i = 0; i < arr.count; i++) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 24 + 40 * i, WIDTH, 40)];
//        [self.contentView addSubview:view];
//
//        UILabel *lab1 = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x977447) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
//        lab1.backgroundColor = TCUIColorFromRGB(0xf2eae1);
//        lab1.layer.masksToBounds = YES;
//        lab1.layer.cornerRadius = 2.5;
//        [view addSubview:lab1];
//
//        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(12);
//                    make.centerY.mas_equalTo(view);
//                    make.width.mas_equalTo(32);
//                    make.height.mas_equalTo(15);
//        }];
//
//        UILabel *lab2 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
//        lab2.preferredMaxLayoutWidth = WIDTH - 66;
//        [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//        [view addSubview:lab2];
//
//        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(lab1.mas_right).offset(12);
//                    make.centerY.mas_equalTo(view);
//                    make.height.mas_equalTo(13);
//        }];
//
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 39.5, WIDTH - 24, 0.5)];
//        line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
//        [view addSubview:line];
//
//        if(i == 0){
//            lab2.text = self.model.proInfo.inte;
//
//            UIImageView *rightIcon = [[UIImageView alloc]init];
//            rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
//            [view addSubview:rightIcon];
//
//            [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.right.mas_equalTo(-18);
//                            make.centerY.mas_equalTo(view);
//                            make.width.mas_equalTo(4);
//                            make.height.mas_equalTo(8);
//            }];
//
//            UIButton *btn = [[UIButton alloc]init];
//            [btn setBackgroundColor:UIColor.clearColor];
//            [btn addTarget:self action:@selector(clickJump) forControlEvents:(UIControlEventTouchUpInside)];
//            [view addSubview:btn];
//
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.left.top.right.bottom.mas_equalTo(0);
//            }];
//        }else{
//            lab2.text = self.model.proInfo.DiscountTips;
//        }
//    }
    
//    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"icoupon"] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
//    lab.frame = CGRectMake(18, CGRectGetMaxY(titleLa.frame) + 124, 100, 12);
//    [self.contentView addSubview:lab];
}

-(void)clickJump{
    self.jumpTapBlock(@"1");
}

-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentView.centerY =self.contentView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentView.centerY =self.contentView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
