//
//  MMOrderAfterChooseGoodsPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/17.
//  售后选择商品弹窗

#import "MMOrderAfterChooseGoodsPopView.h"

@interface MMOrderAfterChooseGoodsPopView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, strong) NSString *UniversalID;
@property (nonatomic, strong) NSString *WarnMsg;
@property (nonatomic, strong) NSString *isChooseNot;
@property (nonatomic, strong) NSMutableArray *seleGoodsArr;

@end

@implementation MMOrderAfterChooseGoodsPopView

-(NSMutableArray *)seleGoodsArr{
    if(!_seleGoodsArr){
        _seleGoodsArr = [NSMutableArray array];
    }
    return _seleGoodsArr;
}

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDataArr:(NSArray *)dataArr andUniversalID:(nonnull NSString *)UniversalID andWarnMsg:(nonnull NSString *)WarnMsg{
    if(self = [super initWithFrame:frame]){
        self.goodsArr = dataArr;
        self.title = title;
        self.UniversalID = UniversalID;
        self.WarnMsg = WarnMsg;
        self.isChooseNot = @"0";
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 * HEIGHT - 600, WIDTH, 600)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UILabel *titleLa = [UILabel publicLab:self.title textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 28, WIDTH, 16);
    [self.bgView addSubview:titleLa];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 32, 10, 16, 16)];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, WIDTH, 530)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.contentSize = CGSizeMake(WIDTH, 118 * self.goodsArr.count);
    [self.bgView addSubview:scrollView];
    
    for (int i = 0; i < self.goodsArr.count; i++) {
        MMOrderListGoodsItemModel *model = self.goodsArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 118 * i, WIDTH, 118)];
        [scrollView addSubview:view];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(34, 17, 84, 84)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        goodsImage.layer.borderColor = TCUIColorFromRGB(0xf0f0f0).CGColor;
        goodsImage.layer.borderWidth = 0.5;
        [view addSubview:goodsImage];
        
        UILabel *goodsNameLa = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x434343) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        goodsNameLa.frame = CGRectMake(134, 17, view.width - 174, 13);
        [view addSubview:goodsNameLa];
        
        if([model.Attribute isEqualToString:@""]){
            
        }else{
            UILabel *AttributeLa = [UILabel publicLab:model.Attribute textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            CGSize size = [AttributeLa sizeThatFits:CGSizeMake(MAXFLOAT,11)];
            AttributeLa.frame = CGRectMake(132, 42, size.width + 20, 18);
            [AttributeLa setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
            AttributeLa.layer.masksToBounds = YES;
            AttributeLa.layer.cornerRadius = 9;
            [view addSubview:AttributeLa];
        }
        
        UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@%@",model.Number,[UserDefaultLocationDic valueForKey:@"ipiece"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        numLa.frame = CGRectMake(view.width - 85, 45, 60, 13);
        [view addSubview:numLa];
        
        UILabel *priceLa = [UILabel publicLab:model.MoneysShow textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth =  view.width - 128;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-17);
                    make.bottom.mas_equalTo(-36);
                    make.height.mas_equalTo(11);
        }];
        
        UILabel *acturaPriceLa = [UILabel publicLab:[NSString stringWithFormat:@"%@ %@",[UserDefaultLocationDic valueForKey:@"actualPayment"],model.SalesMoneyShow
                                                    ] textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
        acturaPriceLa.preferredMaxLayoutWidth = view.width - 128;
        [acturaPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:acturaPriceLa];
        
        [acturaPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-18);
                    make.bottom.mas_equalTo(-16);
                    make.height.mas_equalTo(12);
        }];
        
        [acturaPriceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text([UserDefaultLocationDic valueForKey:@"actualPayment"]).textColor(TCUIColorFromRGB(0x0b0b0b)).font([UIFont fontWithName:@"PingFangSC-Regular" size:12]);
                    confer.text(model.SalesMoneyShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(22, 117.5, WIDTH - 44, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
        [view addSubview:line];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 52, 14, 14)];
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        btn.selected = NO;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setEnlargeEdgeWithTop:52 right:WIDTH - 24 bottom:52 left:10];
        [view addSubview:btn];
        
        
        
        if(i == self.goodsArr.count - 1){
            line.hidden = YES;
        }
    }
}

-(void)clickBt:(UIButton *)sender{
    
    MMOrderListGoodsItemModel *model = self.goodsArr[sender.tag - 100];
    if([self.isChooseNot isEqualToString:@"1"]){
        sender.selected = !sender.selected;
        if(sender.selected == YES){
            self.returnGoodsBlock(model, @"1");
            [self.seleGoodsArr addObject:sender];
        }else{
            self.returnGoodsBlock(model, @"0");
            [self.seleGoodsArr removeObject:sender];
        }
    }else{
        if([model.IsCanReturn isEqualToString:@"0"]){
            [ZTProgressHUD showMessage:self.WarnMsg];
        }else{
            sender.selected = !sender.selected;
            if(sender.selected == YES){
                self.returnGoodsBlock(model, @"1");
                [self.seleGoodsArr addObject:sender];
            }else{
                self.returnGoodsBlock(model, @"0");
                [self.seleGoodsArr removeObject:sender];
            }
        }
    }
    
    
}

-(void)setTypeModel:(MMOrderAfterTypeModel *)typeModel{
    _typeModel = typeModel;
    if([typeModel.IsChooseNot isEqualToString:@"1"]){
        self.isChooseNot = @"1";
    }else{
        self.isChooseNot = @"0";
    }
}

-(void)setIsClear:(NSString *)isClear{
    _isClear = isClear;
    if([_isClear isEqualToString:@"1"]){
        for ( MMOrderListGoodsItemModel *model in self.goodsArr) {
            self.returnGoodsBlock(model, @"0");
        }
        for (UIButton *btn in self.seleGoodsArr) {
            btn.selected = NO;
        }
    }
    
}

-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY =self.bgView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}

@end
