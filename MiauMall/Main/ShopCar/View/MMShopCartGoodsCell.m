//
//  MMShopCartGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/14.
//

#import "MMShopCartGoodsCell.h"
@interface MMShopCartGoodsCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *tagLa;//标签
@property (nonatomic, strong) UIImageView *foldLineImg;//降价曲线
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;

@property (nonatomic, strong) UILabel *limitLa;
@property (nonatomic, strong) UILabel *cutPriceLa;
@property (nonatomic, strong) UILabel *priceLa;//价格
@property (nonatomic, strong) UILabel *discountPriceLa;//折后价
@property (nonatomic, strong) UILabel *ysTipLa;
@property (nonatomic, strong) UIView *ysView;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UILabel *numLa1;//预售的数量
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) UIView *attiView;
@property (nonatomic, strong) UILabel *attiLa;
@property (nonatomic, strong) UIImageView *attiIcon;
@property (nonatomic, strong) UIButton *attidBt;//多规格按钮 负责点击 不展示
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *subBt;
@property (nonatomic, strong) UIButton *addBt;
@end

@implementation MMShopCartGoodsCell

-(UIView *)ysView{
    if(!_ysView){
        _ysView = [[UIView alloc]initWithFrame:CGRectMake(144, CGRectGetMaxY(self.goodsImage.frame) + 14, self.contentView.width - 102, 76)];
        _ysView.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
        _ysView.layer.masksToBounds = YES;
        _ysView.layer.cornerRadius = 4;
        UILabel *desLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"depositMoney"],self.model.DepositMoneyShow] textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        desLa.preferredMaxLayoutWidth = 180;
        [desLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:desLa];
        
        [desLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(12);
        }];
        
        UILabel *payLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"payed"] textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        payLa.preferredMaxLayoutWidth = 120;
        [payLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:payLa];
        
        [payLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.top.mas_equalTo(10);
                    make.height.mas_equalTo(12);
        }];
        
        UILabel *startLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",self.model.FinalPayStartTime,[UserDefaultLocationDic valueForKey:@"startPayBalance"]] textColor:TCUIColorFromRGB(0x3f3f3f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        startLa.frame = CGRectMake(6, 32, _ysView.width - 12, 12);
        [_ysView addSubview:startLa];
        
        UILabel *endLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",self.model.FinalPayEndTime,[UserDefaultLocationDic valueForKey:@"endPayBalance"]] textColor:TCUIColorFromRGB(0x3f3f3f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        endLa.frame = CGRectMake(6, 54, _ysView.width - 12, 12);
        [_ysView addSubview:endLa];
        
        
    }
    return _ysView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(5, 70, 16, 16)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [seleBt setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clickSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:seleBt];
    self.selectBt = seleBt;
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(26, 22, 110, 110)];
    goodsImage.image = [UIImage imageNamed:@"zhanweif"];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 10;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xe5e5e5).CGColor;
    goodsImage.layer.borderWidth = 0.5;
    [self.contentView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UIButton *goodsBt = [[UIButton alloc]initWithFrame:CGRectMake(26, 22, 110, 110)];
    [goodsBt setBackgroundColor:UIColor.clearColor];
    [goodsBt addTarget:self action:@selector(clickGoods) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:goodsBt];
    
    UILabel *tagLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    tagLa.backgroundColor = redColor2;
    tagLa.layer.masksToBounds = YES;
    tagLa.layer.cornerRadius = 2.5;
    tagLa.frame = CGRectMake(144, 22, 0, 15);
    //self.tagLa.hidden = YES;
    [self.contentView addSubview:tagLa];
    self.tagLa = tagLa;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSc-Medium" size:14 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 168;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:nameLa];
    self.goodsNameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(144);
            make.top.mas_equalTo(21);
            make.width.mas_equalTo(WIDTH - 168);
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 9;
    [self.contentView addSubview:view];
    self.attiView = view;

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(144);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(7);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(18);
    }];

    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
    lab.preferredMaxLayoutWidth = 200;
    [lab setContentCompressionResistancePriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [view addSubview:lab];
    self.attiLa = lab;

    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(4);
            make.height.mas_equalTo(10);
    }];
    
    UIImageView *attiIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_black"]];
    
    [view addSubview:attiIcon];
    self.attiIcon = attiIcon;
    
    [attiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab.mas_right).offset(5);
            make.top.mas_equalTo(7);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(4);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = UIColor.clearColor;
    [btn addTarget:self action:@selector(clickAtti) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    self.attidBt = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UILabel *limitLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x807f7f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    limitLa.preferredMaxLayoutWidth = 150;
    [limitLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:limitLa];
    self.limitLa = limitLa;
    
    [limitLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_right).offset(10);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(11);
            make.height.mas_equalTo(10);
    }];
    
    UIImageView *foldlineImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foldline_red"]];
    [self.contentView addSubview:foldlineImg];
    self.foldLineImg = foldlineImg;
    
    [foldlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(144);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(42);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(9);
    }];
    
    UILabel *tipLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
    tipLa.hidden = YES;
    [self.contentView addSubview:tipLa];
    
    self.ysTipLa = tipLa;
    
    [tipLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(144);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(44);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *cutPriceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:9 numberOfLines:0];
    cutPriceLa.preferredMaxLayoutWidth = 200;
    [cutPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:cutPriceLa];
    self.cutPriceLa = cutPriceLa;
    
    [cutPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(164);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(42);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:17 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 200;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(144);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(62);
            make.height.mas_equalTo(15);
    }];
    
    UILabel *numLa1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa7a7a7) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    numLa1.preferredMaxLayoutWidth = 100;
    numLa1.hidden = YES;
    [numLa1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa1];
    self.numLa1 = numLa1;
    
    [numLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(nameLa.mas_bottom).offset(62);
        make.height.mas_equalTo(12);
    }];
    
    
    
    UILabel *discountLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
//    discountLa.preferredMaxLayoutWidth = WIDTH - 147;
//    [discountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [discountLa setBackgroundColor:TCUIColorFromRGB(0xfee6e3)];
    discountLa.layer.masksToBounds = YES;
    discountLa.layer.cornerRadius = 8;
    [self.contentView addSubview:discountLa];
    self.discountPriceLa = discountLa;
    
    [discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(137);
        make.top.mas_equalTo(priceLa.mas_bottom).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(16);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
    bgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(60);
            make.width.mas_equalTo(69);
            make.height.mas_equalTo(24);
    }];
    
    UIButton *subBt = [[UIButton alloc]init];
    [subBt setTitle:@"-" forState:(UIControlStateNormal)];
    [subBt setTitleColor:TCUIColorFromRGB(0x000000) forState:(UIControlStateNormal)];
    subBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:subBt];
    self.subBt = subBt;
    
    [subBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(22);
    }];
    
//    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
//    numLa.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
//    numLa.layer.borderWidth = 1;
//    [bgView addSubview:numLa];
//
//    self.numLa = numLa;
//    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(22);
//            make.top.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(25);
//    }];
    
    UIView *numV = [[UIView alloc]initWithFrame:CGRectMake(22, 0, 25, 24)];
    numV.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
    numV.layer.borderWidth = 1;
    [bgView addSubview:numV];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 25, 24)];
    field.delegate = self;
    field.textAlignment = NSTextAlignmentCenter;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.textColor = TCUIColorFromRGB(0x0b0b0b);
    field.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingDidEnd)];
    [numV addSubview:field];
    self.numField = field;
    
    
    
    UIButton *addBt = [[UIButton alloc]init];
    [addBt setTitle:@"+" forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0x000000) forState:(UIControlStateNormal)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:addBt];
    
    [addBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(47);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(22);
    }];
    
    self.addBt = addBt;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(1);
    }];
}

-(void)setModel:(MMShopCarGoodsModel *)model{
    KweakSelf(self);
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    
    
    if([_model.buy isEqualToString:@"1"]){
        self.selectBt.selected = YES;
    }else{
        self.selectBt.selected = NO;
    }
    if([_model.IsCanSelectPay isEqualToString:@"0"]){
        self.selectBt.userInteractionEnabled = NO;
        self.selectBt.selected = NO;
    }
    NSInteger num = [_model.limitorderbuy integerValue];
    self.limitLa.text = [NSString stringWithFormat:@"｜ %@%@%@",[UserDefaultLocationDic valueForKey:@"restriction"],_model.limitorderbuy,[UserDefaultLocationDic valueForKey:@"ipieces"]];

    if(num > 10){
        self.limitLa.hidden = YES;
    }
    UIColor *col = [_model.columnid isEqualToString:@"828"] ? TCUIColorFromRGB(0x333333) : redColor2;
    self.tagLa.text = _model.ProductSign;
    self.tagLa.backgroundColor = col;
    
    if(_model.ProductSign){
        self.tagLa.hidden = NO;
    }else{
        self.tagLa.hidden = YES;
    }

    CGSize size = [NSString sizeWithText:self.tagLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    self.tagLa.frame = CGRectMake(144, 23, size.width + 7, 15);
    
    
    
    CGSize size1 = [NSString sizeWithText:_model.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(WIDTH - 168,MAXFLOAT)];
    if(size1.height < 18){
        self.goodsNameLa.numberOfLines = 1;
    }else{
        self.goodsNameLa.numberOfLines = 2;
    }
    
    if([_model.buy isEqualToString:@"1"]){
        float salesmoney = [_model.salesmoney floatValue];
        if(salesmoney > 0){
            if([_model.price isEqualToString:_model.salesmoney]){
                self.discountPriceLa.hidden = YES;
            }else{
                self.discountPriceLa.hidden = NO;
                NSArray *temp = [_model.salesmoneyshow componentsSeparatedByString:@" "];
                NSString *str1 = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"discountPrice"],temp[0]];
                NSString *str2 = temp[1];
                CGSize size01 = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Regular" size:10] maxSize:CGSizeMake(MAXFLOAT,10)];
                
                CGSize size02 = [NSString sizeWithText:str2 font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
                
                [self.discountPriceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(str1).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Regular" size:10]);
                    confer.text(str2).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
                }];
                
                [self.foldLineImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(35);
                }];
                
                [self.cutPriceLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(35);
                }];
                
                [self.priceLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(55);
                }];
                
                [self.discountPriceLa mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(weakself.priceLa.mas_bottom).offset(5);
                    make.width.mas_equalTo(size01.width + size02.width + 14);
                }];
                
                if([_model.columnid isEqualToString:@"794"]){
                    [self.ysTipLa mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(40);
                    }];
                }
            }
            
            
        }else{
            self.discountPriceLa.hidden = YES;
        }
       
        
    }else{
        self.discountPriceLa.hidden = YES;
    }
    
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = size.width + 12;//首行缩进
    if([_model.columnid isEqualToString:@"828"]){
        style.firstLineHeadIndent = size.width + 12;//首行缩进
    }
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.name] attributes:@{NSParagraphStyleAttributeName: style}];
    

    self.goodsNameLa.attributedText = attrText;
//    if([_model.columnid isEqualToString:@"828"]){
//        NSLog(@"%@",_model.name);
//        NSLog(@"%@",str);
//    }
//
//    if(_model.ProductSign){
//
//        [self.goodsNameLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
//            confer.text([NSString stringWithFormat:@" %@ ",_model.ProductSign]).textColor(TCUIColorFromRGB(0xffffff)).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]).backgroundColor(col);
//            confer.text([NSString stringWithFormat:@" %@",_model.name]).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:14]);
//        }];
//    }else{
//        self.goodsNameLa.text = [NSString stringWithFormat:@"%@",_model.name];
//    }
    
//    self.goodsNameLa.text = [NSString stringWithFormat:@"       %@",_model.name];
//    if([_model.ProductSign isEqualToString:@"品牌直供"]){
//        self.goodsNameLa.text = [NSString stringWithFormat:@"               %@",_model.name];
//    }
//
    if([_model.attid isEqualToString:@"0"]){
        self.attidBt.hidden = YES;
        self.attiView.hidden = YES;
        self.attiLa.hidden = YES;
        self.attiIcon.hidden = YES;
        [self.limitLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(144);
            make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(7);
            make.height.mas_equalTo(10);
        }];
    }else{
        CGSize size2 = [NSString sizeWithText:_model.attname font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] maxSize:CGSizeMake(MAXFLOAT,10)];
        self.attiLa.text = _model.attname;
        
        [self.attiView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(144);
                    make.top.mas_equalTo(weakself.goodsNameLa.mas_bottom).offset(7);
                    make.width.mas_equalTo(size2.width + 30);
                    make.height.mas_equalTo(18);
        }];
    }
    float downRate = [_model.DownRate floatValue];
    if([_model.DownRate isEqualToString:@"0"]){
        self.cutPriceLa.hidden = YES;
        self.foldLineImg.hidden = YES;
    }else{
        self.cutPriceLa.text = [NSString stringWithFormat:@"%.2f%%",downRate];
    }
    self.priceLa.text = _model.priceshow;
    self.numField.text = _model.num;
    self.num = [_model.num integerValue];
    
    
    if([_model.columnid isEqualToString:@"794"]){
        [self.contentView addSubview:self.ysView];
        self.ysTipLa.hidden = NO;
        self.ysTipLa.text = _model.ShipTimeTips;
        self.numLa1.text = [NSString stringWithFormat:@"x%@",_model.num];
        self.numLa1.hidden = NO;
        self.bgView.hidden = YES;
        self.addBt.hidden = YES;
        self.numLa.hidden = YES;
        self.subBt.hidden = YES;
    }
}

-(void)textFieldDidChange:(UITextField *)field{
    self.tapUpdateBlock(self.model, field.text);
}

-(void)clickGoods{
    self.tapGoodsBlock(self.model);
}

-(void)clickSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        self.tapSeleBlock(self.model, @"1");
    }else{
        self.tapSeleBlock(self.model, @"0");
    }
}



-(void)clickAtti{
    self.tapAttiBlock(self.model);
}

-(void)clickSub{
    if(self.num > 1){
        self.num--;
        self.numField.text = [NSString stringWithFormat:@"%ld",self.num];
        NSString *numStr = [NSString stringWithFormat:@"%ld",self.num];
        self.tapSubBlock(numStr, self.model);
    }else{
        self.tapDeleteBlock(self.model);
    }
    
}

-(void)clickAdd{
    NSInteger limitNum = [_model.limitorderbuy integerValue];
    if(self.num < limitNum){
        self.num++;
//        self.numLa.text = [NSString stringWithFormat:@"%ld",self.num];
        NSString *numStr = [NSString stringWithFormat:@"%ld",self.num];
        self.tapAddBlock(numStr, self.model);
    }else{
        [ZTProgressHUD showMessage:[NSString stringWithFormat:@"商品超过订单限购%@件的限制",_model.limitorderbuy]];
    }
}




@end
