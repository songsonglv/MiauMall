//
//  MMSelectSKUPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//  选择sku弹窗

#import "MMSelectSKUPopView.h"
#import "MMSpecView.h"
#import "MMAttlistItemModel.h"


@interface MMSelectSKUPopView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MMGoodsSpecModel *model;
@property (nonatomic, strong) UIImageView *goodsImage;//商品图片
@property (nonatomic, strong) UILabel *signLa;//货币标识
@property (nonatomic, strong) UILabel *priceLa;//价格label
@property (nonatomic, strong) UILabel *skuLa;
@property (nonatomic, strong) UILabel *numLa;//件数
@property (nonatomic, strong) UILabel *weightLa;//重量
@property (nonatomic, strong) UILabel *stockLa;//库存展示标签
@property (nonatomic, strong) UITextField *numFeild;//数量 可输入 可按钮加减
@property (nonatomic, strong) UIButton *sureBt;//确定按钮 点击加入购物车 或者 立即购买显示
@property (nonatomic, strong) UIButton *addCarBt;//加入购物车按钮 点击选择sku时显示
@property (nonatomic, strong) UIButton *buyNowBt;//立即购买 点击选择sku时显示
@property (nonatomic, strong) NSMutableArray *seleArr;//选中的id数组 需要拼接比对 取出数据
@property (nonatomic, strong) MMGoodsAttdataModel *selectModel;//选中model
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, strong) MMSpecView *selectAttributes;
@property (nonatomic, strong) UIView *ysView;
@property (nonatomic, strong) UILabel *depositLa;//定金
@property (nonatomic, strong) UILabel *finalLa;//尾款
@end

@implementation MMSelectSKUPopView

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

-(UIView *)ysView{
    if(!_ysView){
        _ysView = [[UIView alloc]initWithFrame:CGRectMake(12, 114, WIDTH - 24, 100)];
        _ysView.backgroundColor = TCUIColorFromRGB(0xf8f8f8);
        _ysView.layer.masksToBounds = YES;
        _ysView.layer.cornerRadius = 10;
        
        UIView *seleV = [[UIView alloc]initWithFrame:CGRectMake(16, 18, 7, 7)];
        seleV.backgroundColor = TCUIColorFromRGB(0xffffff);
        seleV.layer.masksToBounds = YES;
        seleV.layer.cornerRadius = 3.5;
        seleV.layer.borderWidth = 1.5;
        seleV.layer.borderColor = redColor2.CGColor;
        [_ysView addSubview:seleV];
        
        UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"depositMoney"] textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 120;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        UILabel *depositLa = [UILabel publicLab:self.model.ActivePriceShow textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        depositLa.preferredMaxLayoutWidth = 150;
        [depositLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:depositLa];
        
        self.depositLa = depositLa;
        
        [depositLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(16);
                    make.height.mas_equalTo(13);
        }];
        
        UIView *garyV = [[UIView alloc]initWithFrame:CGRectMake(16, 58, 7, 7)];
        garyV.backgroundColor = TCUIColorFromRGB(0xffffff);
        garyV.layer.masksToBounds = YES;
        garyV.layer.cornerRadius = 3.5;
        garyV.layer.borderWidth = 1.5;
        garyV.layer.borderColor = TCUIColorFromRGB(0x333333).CGColor;
        [_ysView addSubview:garyV];
        
        UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"balanceMoney"] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = 120;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(53);
            make.height.mas_equalTo(15);
        }];
        
        
        
        UILabel *finalLa = [UILabel publicLab:self.model.attbuying.ActivePriceShow textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        finalLa.preferredMaxLayoutWidth = 150;
        [finalLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_ysView addSubview:finalLa];
        self.finalLa = finalLa;
        
        [finalLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(53);
                    make.height.mas_equalTo(13);
        }];
        
        NSString *timeStr = [NSString stringWithFormat:@"%@%@",[self setString:self.model.DepositEndTime],[UserDefaultLocationDic valueForKey:@"payBalance"]];
        
        UILabel *timeLa = [UILabel publicLab:timeStr textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        timeLa.preferredMaxLayoutWidth = 150;
        [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [_ysView addSubview:timeLa];
        
        [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab1.mas_right).offset(12);
                    make.top.mas_equalTo(53);
                    make.right.mas_equalTo(finalLa.mas_left).offset(-12);
        }];
        
        
    }
    return _ysView;
}

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsSpecModel *)specModel{
    if (self = [super initWithFrame:frame]) {
        self.model = specModel;
        self.selectModel = self.model.attbuying;
        self.numStr = @"1";
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
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 460, WIDTH, 35)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 17.5;
    [self.view addSubview:self.topView];
    
    
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 446, WIDTH, 446)];
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.contentView addGestureRecognizer:tap1];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 30, 0, 18, 18)];
    [closeBt setImage:[UIImage imageNamed:@"close_icon"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:closeBt];
    
    UIImageView *goodImage = [[UIImageView alloc]init];
    goodImage.layer.masksToBounds = YES;
    goodImage.layer.cornerRadius = 10;
    [goodImage sd_setImageWithURL:[NSURL URLWithString:self.model.attbuying.picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    [self.contentView addSubview:goodImage];
    self.goodsImage = goodImage;
    
    [goodImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(102);
    }];
    
    UILabel *signLa = [UILabel publicLab:self.model.attbuying.priceshowsign textColor:TCUIColorFromRGB(0xe13925) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    signLa.preferredMaxLayoutWidth = 100;
    [signLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:signLa];
    self.signLa = signLa;
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(34);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *priceLa = [UILabel publicLab:self.model.attbuying.priceshowprice textColor:TCUIColorFromRGB(0xe13925) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:20 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 200;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:priceLa];
    self.priceLa = priceLa;
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(signLa.mas_right).offset(5);
            make.top.mas_equalTo(26);
            make.height.mas_equalTo(20);
    }];
    
    UILabel *selectLa = [UILabel publicLab:[NSString stringWithFormat:@"%@: ",[UserDefaultLocationDic valueForKey:@"iselected"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    selectLa.preferredMaxLayoutWidth = 80;
    [selectLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:selectLa];
    
    [selectLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(priceLa.mas_bottom).offset(15);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *skuLa = [UILabel publicLab:self.model.attbuying.attr textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    skuLa.preferredMaxLayoutWidth = 200;
    [skuLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:skuLa];
    self.skuLa = skuLa;
    
    [skuLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(selectLa.mas_right).offset(5);
            make.top.mas_equalTo(priceLa.mas_bottom).offset(15);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x1%@",[UserDefaultLocationDic valueForKey:@"ipiece"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    numLa.preferredMaxLayoutWidth = 150;
    [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:numLa];
    self.numLa = numLa;
    
    [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(priceLa.mas_bottom).offset(15);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *zhongLa = [UILabel publicLab:[NSString stringWithFormat:@"%@: ",[UserDefaultLocationDic valueForKey:@"iweight"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    zhongLa.preferredMaxLayoutWidth = 80;
    [zhongLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:zhongLa];
    
    [zhongLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(selectLa.mas_bottom).offset(7);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *weightLa = [UILabel publicLab:[NSString stringWithFormat:@"%.2fkg",[self.model.Weight floatValue]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    weightLa.preferredMaxLayoutWidth = 200;
    [weightLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:weightLa];
    self.weightLa = weightLa;
    
    [weightLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(zhongLa.mas_right).offset(5);
            make.top.mas_equalTo(selectLa.mas_bottom).offset(7);
            make.height.mas_equalTo(13);
    }];
    
    if([self.model.ColumnID isEqualToString:@"794"]){
        [self.contentView addSubview:self.ysView];
        self.priceLa.text = self.model.ActivePrice;
    }
    
    if([self.model.HaveAttribute isEqualToString:@"1"]){
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 114, WIDTH, 210)];
        if([self.model.ColumnID isEqualToString:@"794"]){
            self.scrollView.y = CGRectGetMaxY(self.ysView.frame) + 18;
        }
        self.scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.scrollView.contentSize = CGSizeMake(0, 210);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:self.scrollView];
        
        CGFloat maxY = 0;
        CGFloat height = 0;
        NSArray *arr = [MMAttlistItemModel mj_objectArrayWithKeyValuesArray:self.model.attlist];
        
        if([self.model.ColumnID isEqualToString:@"794"]){
            
        }
        
        for (int i = 0; i < arr.count; i ++)
        {
            MMAttlistItemModel *model1 = arr[i];
            [self.seleArr addObject:model1.choose];
            self.selectAttributes = [[MMSpecView alloc]initWithTitle:model1.name andData:model1 andFrame:CGRectMake(0, maxY, WIDTH, 40)];
            maxY = CGRectGetMaxY(self.selectAttributes.frame);
            height += self.selectAttributes.height;
            self.selectAttributes.tag = 8000+i;
            self.selectAttributes.selectSpecBlock = ^(MMGoodsSpecItemModel * _Nonnull model2, NSString * _Nonnull title) {
                
                [weakself.seleArr replaceObjectAtIndex:i withObject:model2.ID];
                [weakself changeInfo];
            };
            [self.scrollView addSubview:self.selectAttributes];
        }
        self.scrollView.contentSize = CGSizeMake(0, height);
    }
    
    
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@: ",[UserDefaultLocationDic valueForKey:@"iQuantity"]] font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"%@: ",[UserDefaultLocationDic valueForKey:@"iQuantity"]] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    lab.frame = CGRectMake(12, 332, size.width, 14);
    [self.contentView addSubview:lab];
    
    
    UILabel *stockLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    stockLa.preferredMaxLayoutWidth = 180;
    [stockLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:stockLa];
    self.stockLa = stockLa;
    
    [stockLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CGRectGetMaxX(lab.frame) + 5);
            make.bottom.mas_equalTo(-100);
            make.height.mas_equalTo(13);
    }];
    
    if([self.model.attbuying.number integerValue] == 0)
    {
        stockLa.text = [UserDefaultLocationDic valueForKey:@"noStock"];
        
    }else if ([self.model.attbuying.number integerValue] < 10){
        stockLa.text = [NSString stringWithFormat:@"(%ld%@)",[self.model.attbuying.number integerValue],[UserDefaultLocationDic valueForKey:@"shengyu"]];
    }else{
        stockLa.text = [UserDefaultLocationDic valueForKey:@"inStock"];
    }
    
    UIView *numView = [[UIView alloc]init];
    numView.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    numView.layer.masksToBounds = YES;
    numView.layer.cornerRadius = 13;
    numView.layer.borderColor = TCUIColorFromRGB(0xdcd9d7).CGColor;
    numView.layer.borderWidth = 0.5;
    [self.contentView addSubview:numView];
    
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-100);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(26);
    }];
    
    
    if([self.model.ColumnID isEqualToString:@"828"]){
        lab.y = 302;
        self.signLa.textColor = selectColor;
        self.priceLa.textColor = selectColor;
        [stockLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-130);
        }];
        
        [numView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-130);
        }];
        
        UILabel *lab1 = [UILabel publicLab:self.model.Shipping828 textColor:selectColor textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = WIDTH;
        [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [self.contentView addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-90);
            make.width.mas_equalTo(WIDTH);
        }];
    }
    
    UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 33, 26)];
    [subBt setTitle:@"-" forState:(UIControlStateNormal)];
    [subBt setTitleColor:TCUIColorFromRGB(0xcecece) forState:(UIControlStateNormal)];
    subBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:13];
    [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
    [numView addSubview:subBt];
    
    UITextField *field = [[UITextField alloc]init];
    field.backgroundColor = TCUIColorFromRGB(0xffffff);
    field.delegate = self;
    field.text = @"1";
    field.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:13];
    field.textColor = TCUIColorFromRGB(0x383838);
    field.textAlignment = NSTextAlignmentCenter;
    field.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    [field addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventEditingChanged];
    [numView addSubview:field];
    self.numFeild = field;
    
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(33);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(36);
            make.height.mas_equalTo(26);
    }];
    
    UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(69, 0, 33, 26)];
    [addBt setTitle:@"+" forState:(UIControlStateNormal)];
    [addBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:13];
    [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [numView addSubview:addBt];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 366, WIDTH, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xf3f2f3);
    [self.contentView addSubview:line];
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(line.frame) + 8, WIDTH - 36, 36)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    sureBt.backgroundColor = TCUIColorFromRGB(0xd64f3e);
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:sureBt];
    self.sureBt = sureBt;
    
    CGFloat wid = (WIDTH - 54)/2;
    UIButton *addCarBt = [[UIButton alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(line.frame) + 8, wid, 36)];
    addCarBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    addCarBt.backgroundColor = TCUIColorFromRGB(0xbd9869);
    addCarBt.layer.masksToBounds = YES;
    addCarBt.layer.cornerRadius = 18;
    [addCarBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
    [addCarBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [addCarBt addTarget:self action:@selector(clickAddCar) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:addCarBt];
    self.addCarBt = addCarBt;
    
    UIButton *buyNowBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addCarBt.frame) + 18, CGRectGetMaxY(line.frame) + 8, wid, 36)];
    buyNowBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    buyNowBt.backgroundColor = TCUIColorFromRGB(0xd64f3e);
    buyNowBt.layer.masksToBounds = YES;
    buyNowBt.layer.cornerRadius = 18;
    [buyNowBt setTitle:[UserDefaultLocationDic valueForKey:@"buyNow"] forState:(UIControlStateNormal)];
    [buyNowBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [buyNowBt addTarget:self action:@selector(clickBuyNow) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:buyNowBt];
    self.buyNowBt = buyNowBt;
    
    if([self.model.ColumnID isEqualToString:@"794"]){
        addCarBt.hidden = YES;
        buyNowBt.hidden = YES;
        sureBt.hidden = YES;
        addCarBt.userInteractionEnabled = NO;
        buyNowBt.userInteractionEnabled = NO;
        sureBt.userInteractionEnabled = NO;
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundColor:redColor2];
        btn.frame = CGRectMake(18, CGRectGetMaxY(line.frame) + 8, WIDTH - 36, 36);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 18;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [btn setTitle:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"payDepositNow"],self.model.DepositMoneyShow] forState:(UIControlStateNormal)];
        
        [self.contentView addSubview:btn];
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDate *dateTime = [formatter dateFromString:self.model.DepositEndTime];
        
        NSTimeInterval a = [dateTime timeIntervalSince1970] - 8 * 3600;
        
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSTimeInterval a1 = [datenow timeIntervalSince1970];
        
        if(a1 > a){
            [btn setBackgroundColor:TCUIColorFromRGB(0xcbcbcb)];
            btn.userInteractionEnabled = NO;
            [btn setTitle:[UserDefaultLocationDic valueForKey:@"depositEnd2"] forState:(UIControlStateNormal)];
            [btn setTitleColor:TCUIColorFromRGB(0x000000) forState:(UIControlStateNormal)];
        }else{
            [btn addTarget:self action:@selector(clickPaydeposit) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
//        _ysView.backgroundColor = TCUIColorFromRGB(0xcbcbcb);
//        UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"depositEnd2"] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
//        lab.frame = CGRectMake(0, 0, 216, 40);
//        [_ysView addSubview:lab];
    }
}

-(void)setType:(NSString *)type{
    _type = type;
    if([type isEqualToString:@"0"]){
        self.addCarBt.hidden = NO;
        self.buyNowBt.hidden = NO;
        self.sureBt.hidden = YES;
    }else if ([type isEqualToString:@"1"]){
        self.addCarBt.hidden = YES;
        self.buyNowBt.hidden = YES;
        self.sureBt.hidden = NO;
    }else{
        self.addCarBt.hidden = YES;
        self.buyNowBt.hidden = YES;
        self.sureBt.hidden = NO;
    }
}

-(void)changeInfo{
    NSString *seleStr = [self.seleArr componentsJoinedByString:@","];
    NSArray *arr = [MMGoodsAttdataModel mj_objectArrayWithKeyValuesArray:self.model.attdatas];
    for (MMGoodsAttdataModel *model in arr) {
        if([model.classarr isEqualToString:seleStr]){
            [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.picture]];
            self.signLa.text = model.priceshowsign;
            self.priceLa.text = model.priceshowprice;
            self.skuLa.text = model.attr;
            NSInteger num = [model.number integerValue];
            if(num == 0){
                self.stockLa.text = [UserDefaultLocationDic valueForKey:@"noStock"];
            }else{
                if (num < 10){
                    self.stockLa.text = [NSString stringWithFormat:@"%@(%ld%@)",[UserDefaultLocationDic valueForKey:@"noStock"],num,[UserDefaultLocationDic valueForKey:@"shengyu"]];
                }else{
                    self.stockLa.text = [UserDefaultLocationDic valueForKey:@"inStock"];
                }
            }
            
            self.selectModel = model;
        }
    }
    
    [self blockData];

}

-(void)blockData{
    self.SkuAndNumBlock(self.selectModel, self.numStr);
}

#pragma mark -- 点击事件
-(void)clickSub{
    NSInteger num = [self.numFeild.text integerValue];
    if(num > 1){
        num--;
    }else{
        [ZTProgressHUD showMessage:@"最少要有一件商品"];
    }
    self.numFeild.text = [NSString stringWithFormat:@"%ld",(long)num];
    self.numLa.text = [NSString stringWithFormat:@"x%ld%@",(long)num,[UserDefaultLocationDic valueForKey:@"ipiece"]];
    self.numStr = [NSString stringWithFormat:@"%ld",(long)num];
    
    [self blockData];
}

-(void)clickAdd{
    NSInteger num = [self.numFeild.text integerValue];
    NSInteger maxNum = [self.model.LimtOrderBuy integerValue];//限购
    if(num < maxNum){
        num++;
    }else{
        [ZTProgressHUD showMessage:[NSString stringWithFormat:@"单ID限购%ld%@",(long)maxNum,[UserDefaultLocationDic valueForKey:@"ipiece"]]];
    }
    self.numFeild.text = [NSString stringWithFormat:@"%ld",(long)num];
    self.numLa.text = [NSString stringWithFormat:@"x%ld%@",(long)num,[UserDefaultLocationDic valueForKey:@"ipiece"]];
    self.numStr = [NSString stringWithFormat:@"%ld",(long)num];
    
    [self blockData];
}

-(void)clickSure{
    [self hideView];
    //将选中的data数据传出
    if([self.type isEqualToString:@"1"]){
        self.addCarBlock(@"1");
    }else{
        self.buyNowBlock(@"1");
    }
    
    
}

-(void)clickBuyNow{
    [self hideView];
    //立即购买
    self.buyNowBlock(@"1");
}

-(void)clickPaydeposit{
    [self hideView];
    
    //支付定金
    self.payDepositBlock(@"1");
}

-(void)clickAddCar{
    [self hideView];
    //加入购物车

    self.addCarBlock(@"1");
}

#pragma mark -- fielddelegate
-(void)alueChange:(UITextField *)field{
    NSInteger num = [field.text integerValue];
    NSInteger maxNum = [self.model.LimtOrderBuy integerValue];//限购
    if(num >maxNum){
        [ZTProgressHUD showMessage:[NSString stringWithFormat:@"单ID限购%ld%@",(long)maxNum,[UserDefaultLocationDic valueForKey:@"ipiece"]]];
        num = maxNum;
    }else if(num < 1){
        num = 1;
        [ZTProgressHUD showMessage:@"至少要有一件商品"];
    }
    self.numFeild.text = [NSString stringWithFormat:@"%ld",(long)num];
    self.numLa.text = [NSString stringWithFormat:@"x%ld%@",(long)num,[UserDefaultLocationDic valueForKey:@"ipiece"]];
    self.numStr = [NSString stringWithFormat:@"%ld",(long)num];
    
    [self blockData];
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


//时间格式转换
-(NSString *)setString:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *dateTime = [formatter dateFromString:timeStr];
    
    
    NSString *timeStr1 = [self dateAsString:dateTime];
    //[NSString stringWithFormat:@"%d月%d日  %d:%d",components.month,components.day,components.hour,components.minute];
    return timeStr1;
}

-(NSString*)dateAsString:(NSDate*)date {
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    [formatter setTimeZone:timeZone];
    NSString * timeString = [formatter stringFromDate:date];
    return timeString;
}

@end
