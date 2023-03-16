//
//  MMShopCartGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/14.
//

#import "MMShopCartGoodsCell.h"
@interface MMShopCartGoodsCell ()
@property (nonatomic, strong) UILabel *tagLa;//标签
@property (nonatomic, strong) UIImageView *foldLineImg;//降价曲线
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;

@property (nonatomic, strong) UILabel *limitLa;
@property (nonatomic, strong) UILabel *cutPriceLa;
@property (nonatomic, strong) UILabel *priceLa;//价格
@property (nonatomic, strong) UILabel *discountPriceLa;//折后价
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) UIView *attiView;
@property (nonatomic, strong) UILabel *attiLa;
@property (nonatomic, strong) UIImageView *attiIcon;
@property (nonatomic, strong) UIButton *attidBt;//多规格按钮 负责点击 不展示
@end

@implementation MMShopCartGoodsCell

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
    
    UILabel *tagLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    tagLa.backgroundColor = redColor2;
    tagLa.layer.masksToBounds = YES;
    tagLa.layer.cornerRadius = 2.5;
    tagLa.frame = CGRectMake(144, 22, 0, 15);
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
    
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
    bgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bgView];
    
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
    
    [subBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(22);
    }];
    
    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
    numLa.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
    numLa.layer.borderWidth = 1;
    [bgView addSubview:numLa];
    
    self.numLa = numLa;
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(25);
    }];
    
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
    self.limitLa.text = [NSString stringWithFormat:@"｜ 限购%@件/单",_model.limitorderbuy];
    if([_model.ProductSign isEqualToString:@"预定"]){
        self.tagLa.text = _model.ProductSign;
    }else if ([_model.ProductSign isEqualToString:@"自营"]){
        self.tagLa.text = _model.ProductSign;
    }else{
        self.tagLa.text = @"自营";
    }
    
    if([_model.ProductSign isEqualToString:@"自营"]){
        self.tagLa.text = _model.ProductSign;
    }else if ([_model.ProductSign isEqualToString:@"预定"]){
        self.tagLa.text = _model.ProductSign;
    }else if([_model.ProductSign isEqualToString:@""] || !_model.ProductSign || [_model.ProductSign isEmpty]){
        self.tagLa.text = @"自营";
    }else{
        self.tagLa.text = _model.ProductSign;
        self.tagLa.backgroundColor = TCUIColorFromRGB(0x333333);
    }
    
    if(num > 10){
        self.limitLa.hidden = YES;
    }
    
    CGSize size = [NSString sizeWithText:self.tagLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    self.tagLa.frame = CGRectMake(144, 23, size.width + 7, 15);
    
    CGSize size1 = [NSString sizeWithText:_model.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(WIDTH - 168,MAXFLOAT)];
    if(size1.height < 18){
        self.goodsNameLa.numberOfLines = 1;
    }else{
        self.goodsNameLa.numberOfLines = 2;
    }
    self.goodsNameLa.text = [NSString stringWithFormat:@"       %@",_model.name];
    if([_model.ProductSign isEqualToString:@"品牌直供"]){
        self.goodsNameLa.text = [NSString stringWithFormat:@"               %@",_model.name];
    }
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
        self.cutPriceLa.text = [NSString stringWithFormat:@"比加入购物车时降%.2f%%",downRate];
    }
    self.priceLa.text = _model.priceshow;
    self.numLa.text = _model.num;
    self.num = [_model.num integerValue];
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
        self.numLa.text = [NSString stringWithFormat:@"%ld",self.num];
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
