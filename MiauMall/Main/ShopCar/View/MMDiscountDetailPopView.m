//
//  MMDiscountDetailPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import "MMDiscountDetailPopView.h"
@interface MMDiscountDetailPopView ()
@property (nonatomic, strong) UILabel *goodsMoneyLa;
@property (nonatomic, strong) UILabel *discountLa;
@property (nonatomic, strong) UILabel *coupunLa;
@property (nonatomic, strong) UILabel *integralLa;
@property (nonatomic, strong) UILabel *allDiscountLa;
@property (nonatomic, strong) UILabel *allMoneyLa;
@property (nonatomic, strong) UILabel *allDsi2La;
@property (nonatomic, strong) UIButton *payBt;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *goodsView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@end

@implementation MMDiscountDetailPopView

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 358 - TabbarSafeBottomMargin - 82, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 15;
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 340 - TabbarSafeBottomMargin - 82, WIDTH, 340 + TabbarSafeBottomMargin + 82)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.contentView addGestureRecognizer:tap1];
 
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"discountDetail"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 15, WIDTH, 15);
    [self.contentView addSubview:titleLa];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 22, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"payDetailMsg"] textColor:TCUIColorFromRGB(0x858585) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    lab.frame = CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 12, WIDTH, 11);
    [self.contentView addSubview:lab];
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame) + 28, WIDTH, 70)];
    scrollview.contentSize = CGSizeMake(WIDTH, 70);
    scrollview.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:scrollview];
    self.goodsView = scrollview;
    
    //iproduct  idiscount
    NSString *goods = [UserDefaultLocationDic valueForKey:@"iproduct"];
    NSArray *arr = @[[NSString stringWithFormat:@"%@%@",goods,[UserDefaultLocationDic valueForKey:@"zongTotal"]],[NSString stringWithFormat:@"%@",[UserDefaultLocationDic valueForKey:@"chooseDiscount"]],[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"idiscount"],[UserDefaultLocationDic valueForKey:@"idiscount1"]],[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"icoupon"],[UserDefaultLocationDic valueForKey:@"idiscount1"]]];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollview.frame) + 12 + 27 * i, WIDTH, 27)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.contentView addSubview:view];
        
        CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(view);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(13);
        }];
        
        UILabel *monLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 120;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:monLa];
        
        [monLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(12);
        }];
        
        if(i == 0){
            self.goodsMoneyLa = monLa;
        }else if (i == 1){
            self.discountLa = monLa; //任选
        }else if (i == 2){
            self.coupunLa = monLa;   //折扣
        }else{
            self.integralLa = monLa; //优惠券
        }
    }
    
    UILabel *lab1 = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"idiscount1"],[UserDefaultLocationDic valueForKey:@"itotal"]] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 180;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(230 + 82);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *allDisLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    allDisLa.preferredMaxLayoutWidth = 150;
    [allDisLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:allDisLa];
    self.allDiscountLa = allDisLa;
    
    [allDisLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(231 + 82);
            make.height.mas_equalTo(12);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 246 + 82, WIDTH, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xf3f2f1);
    [self.contentView addSubview:line];
    
    UILabel *allMoneyLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    allMoneyLa.preferredMaxLayoutWidth = 200;
    [allMoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:allMoneyLa];
    self.allMoneyLa = allMoneyLa;
    
    [allMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(CGRectGetMaxY(line.frame) + 15);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *discountLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    discountLa.preferredMaxLayoutWidth = 200;
    [discountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:discountLa];
    self.allDsi2La = discountLa;
    
    [discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(allMoneyLa.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size1 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"discountDetail"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(72, 40, size1.width + 18, 12)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"discountDetail"] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"down_black"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn layoutButtonWithEdgeInsetsStyle:(GLButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(discountLa.mas_right).offset(8);
            make.top.mas_equalTo(allMoneyLa.mas_bottom).offset(10);
            make.width.mas_equalTo(size1.width + 18);
            make.height.mas_equalTo(12);
    }];
//    self.detailBt = btn;
    
    UIButton *payBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 105, CGRectGetMaxY(line.frame) + 15, 100, 36)];
    [payBt setBackgroundColor:redColor2];
    [payBt setTitle:[UserDefaultLocationDic valueForKey:@"isettlement"] forState:(UIControlStateNormal)];
    [payBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    payBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
    payBt.layer.masksToBounds = YES;
    payBt.layer.cornerRadius = 18;
    [payBt addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:payBt];
    self.payBt = payBt;
}

-(void)setModel:(MMShopCarModel *)model{
    _model = model;
    self.goodsMoneyLa.text = _model._totalshow;
    self.discountLa.text = [NSString stringWithFormat:@"-%@",_model._renxuantotalsalesshow];
    self.coupunLa.text = [NSString stringWithFormat:@"-%@",_model._discounttotalsalesshow];
    float coupon = [_model._coupontotalsales floatValue];
    
    NSArray *temp = [_model._totalshow componentsSeparatedByString:@" "];
    NSString *str = coupon > 0 ? _model._coupontotalsalesshow : [NSString stringWithFormat:@"%@ 0",temp[0]];
    
    self.integralLa.text = [NSString stringWithFormat:@"-%@",str];
    
    self.allDiscountLa.text = [NSString stringWithFormat:@"-%@",_model._totalsalesshow];
    
    if(_model._totalactivepriceshow.length > 0){
        NSArray *temp=[_model._totalactivepriceshow componentsSeparatedByString:@" "];
        NSString *str = temp[0];
        NSString *str1 = temp[1];
        [self.allMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"itotal"],str]).textColor(redColor2).font([UIFont systemFontOfSize:12]);
            confer.text(str1).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:16]);
        }];
    }
   
    
    self.allDsi2La.text = [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"ioverall"],[UserDefaultLocationDic valueForKey:@"idiscount1"],_model._totalsalesshow];
    [self.payBt setTitle:[NSString stringWithFormat:@"%@(%@)",[UserDefaultLocationDic valueForKey:@"isettlement"],_model.Num1] forState:(UIControlStateNormal)];
}


//创建商品view
-(void)setModel1:(MMShopCarModel *)model1{
    _model1 = model1;
    [self.goodsArr removeAllObjects];
    
    if(self.goodsView !=nil){
        while ([self.goodsView.subviews count] > 0) {
            //NSLog(@"subviews Count=%d",[[myScrollView subviews]count]);
            [[[self.goodsView subviews] objectAtIndex:0] removeFromSuperview];
        }
    }
   
    for (NSArray*arr1 in _model1.newitem) {
        NSArray *arr = [MMShopCarGoodsModel mj_objectArrayWithKeyValuesArray:arr1];
        for (MMShopCarGoodsModel *model in arr) {
            if([model.buy isEqualToString:@"1"]){
                [self.goodsArr addObject:model];
            }
        }
    }
    self.goodsView.contentSize = CGSizeMake(10 + 80 * self.goodsArr.count, 70);
    for (int i = 0; i < self.goodsArr.count; i++) {
        MMShopCarGoodsModel *model2 = self.goodsArr[i];
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 80 * i, 0, 70, 70)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model2.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 4;
        goodsImage.layer.borderColor = TCUIColorFromRGB(0xdedede).CGColor;
        goodsImage.layer.borderWidth = 0.5;
        goodsImage.userInteractionEnabled = YES;
        [self.goodsView addSubview:goodsImage];
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(56, 4, 10, 10)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        btn.tag = 100 + i;
        btn.selected = YES;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:4 right:4 bottom:56 left:56];
        [goodsImage addSubview:btn];
    }
}

-(void)clickBt:(UIButton *)sender{
    MMShopCarGoodsModel *model = self.goodsArr[sender.tag - 100];
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.selectGoodsBlock(model, @"1");
    }else{
        self.selectGoodsBlock(model, @"0");
    }
}

-(void)hideView1{
    
}


-(void)hideView{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PopShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentView.centerY =self.contentView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"PopShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentView.centerY =self.contentView.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}

-(void)clickPay{
    [self hideView];
    self.clickPayBlock(@"1");
}
@end
