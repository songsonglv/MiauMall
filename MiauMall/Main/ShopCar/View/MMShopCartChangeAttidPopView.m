//
//  MMShopCartChangeAttidPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import "MMShopCartChangeAttidPopView.h"
#import "MMSpecView.h"

@interface MMShopCartChangeAttidPopView ()
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MMGoodsSpecModel *model;
@property (nonatomic, strong) MMShopCarGoodsModel *goodsModel;
@property (nonatomic, strong) UIImageView *goodsImage;//商品图片
@property (nonatomic, strong) UILabel *signLa;//货币标识
@property (nonatomic, strong) UILabel *priceLa;//价格label
@property (nonatomic, strong) UILabel *skuLa;
@property (nonatomic, strong) UILabel *numLa;//件数
@property (nonatomic, strong) UILabel *weightLa;//重量
@property (nonatomic, strong) UIButton *sureBt;//确定按钮 点击加入购物车 或者 立即购买显示

@property (nonatomic, strong) NSMutableArray *seleArr;//选中的id数组 需要拼接比对 取出数据
@property (nonatomic, strong) MMGoodsAttdataModel *selectModel;//选中model
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, strong) MMSpecView *selectAttributes;
@end

@implementation MMShopCartChangeAttidPopView

-(NSMutableArray *)seleArr{
    if(!_seleArr){
        _seleArr = [NSMutableArray array];
    }
    return _seleArr;
}

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsSpecModel *)specModel andGoodsModel:(MMShopCarGoodsModel *)goodsModel{
    if (self = [super initWithFrame:frame]) {
        self.model = specModel;
        NSArray *arr = [MMGoodsAttdataModel mj_objectArrayWithKeyValuesArray:self.model.attdatas];
        for (MMGoodsAttdataModel *model1 in arr) {
            if([goodsModel.attid isEqualToString:model1.attid]){
                self.selectModel = model1;
            }
        }
//        self.selectModel = self.model.attbuying;
        self.goodsModel = goodsModel;
        self.numStr = goodsModel.num;
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
    [goodImage sd_setImageWithURL:[NSURL URLWithString:self.model.attbuying.picture]];
    [self.contentView addSubview:goodImage];
    self.goodsImage = goodImage;
    
    [goodImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(102);
    }];
    
    UILabel *signLa = [UILabel publicLab:self.model.attbuying.ActivePriceShowSign textColor:TCUIColorFromRGB(0xe13925) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    signLa.preferredMaxLayoutWidth = 100;
    [signLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:signLa];
    self.signLa = signLa;
    
    [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(34);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *priceLa = [UILabel publicLab:self.selectModel.ActivePrice textColor:TCUIColorFromRGB(0xe13925) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:20 numberOfLines:0];
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
    
    UILabel *skuLa = [UILabel publicLab:self.goodsModel.attname textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    skuLa.preferredMaxLayoutWidth = 200;
    [skuLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:skuLa];
    self.skuLa = skuLa;
    
    [skuLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(selectLa.mas_right).offset(5);
            make.top.mas_equalTo(priceLa.mas_bottom).offset(15);
            make.height.mas_equalTo(13);
    }];
    
    UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@%@",self.goodsModel.num,[UserDefaultLocationDic valueForKey:@"ipiece"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
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
    
    UILabel *weightLa = [UILabel publicLab:[NSString stringWithFormat:@"%.2fkg",[self.goodsModel.weight floatValue]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    weightLa.preferredMaxLayoutWidth = 200;
    [weightLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:weightLa];
    self.weightLa = weightLa;
    
    [weightLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(zhongLa.mas_right).offset(5);
            make.top.mas_equalTo(selectLa.mas_bottom).offset(7);
            make.height.mas_equalTo(13);
    }];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 114, WIDTH, 210)];
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

    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(18, 374, WIDTH - 36, 36)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    sureBt.backgroundColor = TCUIColorFromRGB(0xd64f3e);
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 18;
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [sureBt addTarget:self action:@selector(clickSure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:sureBt];
    self.sureBt = sureBt;
    
    if([self.model.ColumnID isEqualToString:@"828"]){
        [self.sureBt setBackgroundColor:TCUIColorFromRGB(0x333333)];
        
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
}

-(void)clickSure{
    [self hideView];
    self.SkuAndNumBlock(self.selectModel, self.numStr);
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
            
            self.selectModel = model;
        }
    }
    
//    [self blockData];

}

-(void)blockData{
    self.SkuAndNumBlock(self.selectModel, self.numStr);
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
