//
//  MMDMShopCartGoodsCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/28.
//

#import "MMDMShopCartGoodsCell.h"

@interface MMDMShopCartGoodsCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *selectBt;//选择按钮
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *specLa;
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) UILabel *serviceLa;
@property (nonatomic, strong) UILabel *priceLa;
//@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UIView *conView;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) UITextField *numField;

@end

@implementation MMDMShopCartGoodsCell


-(UIView *)serviceView{
    if(!_serviceView){
        CGSize size = [NSString sizeWithText:self.model.choosesurestr font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        if(size.width > WIDTH - 160){
            size.width = WIDTH - 160;
        }
        _serviceView = [[UIView alloc]initWithFrame:CGRectMake(115, CGRectGetMaxY(self.goodsNameLa.frame) + 32, size.width + 30, 18)];
        _serviceView.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
        _serviceView.layer.masksToBounds = YES;
        _serviceView.layer.cornerRadius = 6;
        
        UILabel *lab = [UILabel publicLab:self.model.choosesurestr textColor:TCUIColorFromRGB(0x595959) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        lab.frame = CGRectMake(10, 3.5, size.width, 11);
        [_serviceView addSubview:lab];
        self.serviceLa = lab;
        
        UIImageView *attiIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_black"]];
        attiIcon.frame = CGRectMake(CGRectGetMaxX(lab.frame) + 5, 7, 8, 4);
        [_serviceView addSubview:attiIcon];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width + 30, 18)];
        [btn addTarget:self action:@selector(clickService) forControlEvents:(UIControlEventTouchUpInside)];
        [_serviceView addSubview:btn];
    }
    return _serviceView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = UIColor.clearColor;
        [self creatUI];
    }
    return self;
}

//120 height
-(void)creatUI{
    
    UIView *conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 120)];
    conView.backgroundColor = TCUIColorFromRGB(0xffffff);
    conView.layer.masksToBounds = YES;
    conView.layer.cornerRadius = 7.5;
    [self.contentView addSubview:conView];
    self.conView = conView;
    
    UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(8, 38, 18, 18)];
    [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
    [seleBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
    [seleBt addTarget:self action:@selector(clickSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.conView addSubview:seleBt];
    self.selectBt = seleBt;
    
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(34, 10, 72, 72)];
    goodsImage.image = [UIImage imageNamed:@"zhanweif"];
    goodsImage.layer.masksToBounds = YES;
    goodsImage.layer.cornerRadius = 6;
    goodsImage.layer.borderColor = TCUIColorFromRGB(0xe6e6e6).CGColor;
    goodsImage.layer.borderWidth = 0.5;
    [self.conView addSubview:goodsImage];
    self.goodsImage = goodsImage;
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSc-Regular" size:15 numberOfLines:0];
    nameLa.frame = CGRectMake(116, 10, WIDTH - 134, 15);
    [self.conView addSubview:nameLa];
    self.goodsNameLa = nameLa;
    
    UILabel *specLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa3a2a2) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    specLa.preferredMaxLayoutWidth = WIDTH - 164;
    [specLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.conView addSubview:specLa];
    self.specLa = specLa;
    
    [specLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(116);
            make.top.mas_equalTo(CGRectGetMaxY(nameLa.frame) + 12);
            make.width.mas_equalTo(WIDTH - 164);
    }];
    
    UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 180;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.conView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(115);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(60);
            make.height.mas_equalTo(13);
    }];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 98, CGRectGetMaxY(nameLa.frame) + 53, 68, 24)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
    bgView.layer.borderWidth = 0.5;
    [self.conView addSubview:bgView];
    
    UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 24)];
    [subBt setTitle:@"-" forState:(UIControlStateNormal)];
    [subBt setTitleColor:TCUIColorFromRGB(0x000000) forState:(UIControlStateNormal)];
    subBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:subBt];
    
//    UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
//    numLa.frame = CGRectMake(22, 0, 26, 24);
//    numLa.layer.masksToBounds = YES;
//    numLa.layer.cornerRadius = 0;
//    numLa.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
//    numLa.layer.borderWidth = 0.5;
//    [bgView addSubview:numLa];
//    self.numLa = numLa;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(22, 0, 26, 24)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 0;
    view.layer.borderColor = TCUIColorFromRGB(0xbfbfbf).CGColor;
    view.layer.borderWidth = 0.5;
    [bgView addSubview:view];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 26, 24)];
    field.delegate = self;
    field.textAlignment = NSTextAlignmentCenter;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.textColor = TCUIColorFromRGB(0x0b0b0b);
    field.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingDidEnd)];
    [view addSubview:field];
    self.numField = field;
    
    UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(47, 0, 21, 24)];
    [addBt setTitle:@"+" forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0x000000) forState:(UIControlStateNormal)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:addBt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(7, 119.5, WIDTH - 34, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
    [self.conView addSubview:line];
    self.line = line;
    
}


-(void)setModel:(MMDMShopCartGoodsModel *)model{
    _model = model;
    if([_model.buy isEqualToString:@"1"]){
        self.selectBt.selected = YES;
    }else{
        self.selectBt.selected = NO;
    }
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.goodsNameLa.text = _model.name;
    self.specLa.text = _model.attname;
    if(_model.choosesurestr.length){
        [self.conView addSubview:self.serviceView];
    }
    
    [self.priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"JPY").textColor(TCUIColorFromRGB(0x030303)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
        confer.text(_model.price).textColor(TCUIColorFromRGB(0x030303)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:15]);
    }];
    
    self.numField.text = _model.num;
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

-(void)textFieldDidChange:(UITextField *)field{
    self.tapUpdateBlock(self.model, field.text);
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
    self.num++;
    NSString *numStr = [NSString stringWithFormat:@"%ld",self.num];
    self.tapAddBlock(numStr, self.model);
}

-(void)clickService{
    self.tapServiceBlock(self.model);
}
@end
