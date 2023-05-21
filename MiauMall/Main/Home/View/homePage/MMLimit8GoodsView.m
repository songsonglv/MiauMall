//
//  MMLimit8GoodsView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/24.
//

#import "MMLimit8GoodsView.h"

@interface MMLimit8GoodsView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) NSMutableArray *todayArr;
@property (nonatomic, strong) NSMutableArray *tomorrowArr;
@property (nonatomic, strong) MMHomePageItemModel *model;
@end

@implementation MMLimit8GoodsView

-(NSMutableArray *)todayArr{
    if(!_todayArr){
        _todayArr = [NSMutableArray array];
    }
    return _todayArr;
}

-(NSMutableArray *)tomorrowArr{
    if(!_tomorrowArr){
        _tomorrowArr = [NSMutableArray array];
    }
    return _tomorrowArr;
}

-(instancetype)initWithFrame:(CGRect)frame andTodayData:(nonnull NSArray *)todayArr andTomorrowData:(nonnull NSArray *)tomorrow andModel:(nonnull MMHomePageItemModel *)model{
    if(self = [super initWithFrame:frame]){
        NSArray *arr = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:todayArr];
        NSArray *arr1 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:tomorrow];
        self.todayArr = [NSMutableArray arrayWithArray:arr];
        self.tomorrowArr = [NSMutableArray arrayWithArray:arr1];
        self.model = model;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20 , 220)];
    scrollView.backgroundColor = UIColor.whiteColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.layer.masksToBounds = YES;
    scrollView.layer.cornerRadius = 7.5;
    scrollView.layer.borderColor = TCUIColorFromRGB(0xeeeeee).CGColor;
    scrollView.layer.borderWidth = 0.5;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIScrollView *scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 220)];
    scrollView1.backgroundColor = UIColor.whiteColor;
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.showsHorizontalScrollIndicator = NO;
    scrollView1.layer.masksToBounds = YES;
    scrollView1.layer.cornerRadius = 7.5;
    scrollView1.layer.borderColor = TCUIColorFromRGB(0xeeeeee).CGColor;
    scrollView1.layer.borderWidth = 0.5;
    [self addSubview:scrollView1];
    self.scrollView1 = scrollView1;
    
    [self setScroll];
    [self setScroll1];
}


-(void)setScroll{
    for (int i = 0; i < self.todayArr.count; i++) {
        MMHomeLimitGoodsModel *model = self.todayArr[i];
        UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(8 + 118 * i, 0, 110, 220)];
        goodsView.backgroundColor = TCUIColorFromRGB(0xffffff);
        goodsView.layer.masksToBounds = YES;
        goodsView.layer.cornerRadius = 5;
        [self.scrollView addSubview:goodsView];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 110, 106)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [goodsView addSubview:goodsImage];
        
        UILabel *nameLa = [UILabel publicLab:model.name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        nameLa.frame = CGRectMake(5, CGRectGetMaxY(goodsImage.frame), 90, 13);
        [goodsView addSubview:nameLa];
        
//        NSString *str = [NSString stringWithFormat:@"%@%% off",model.discount];
        CGSize size = [NSString sizeWithText:model.discountshow font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,10)];
        UILabel *tagLa = [UILabel publicLab:model.discountshow textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        tagLa.frame = CGRectMake(5, CGRectGetMaxY(nameLa.frame) + 7, size.width + 7, 14);
        tagLa.backgroundColor = [UIColor colorWithWzx:0xe1391a alpha:0.2];
        tagLa.layer.masksToBounds = YES;
        tagLa.layer.cornerRadius = 3;
        [goodsView addSubview:tagLa];
        
        UILabel *priceLa = [UILabel publicLab:model.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        priceLa.frame = CGRectMake(5, CGRectGetMaxY(tagLa.frame) + 7, 100, 13);
        [goodsView addSubview:priceLa];
        
        NSArray *temp = [model.pricevalue componentsSeparatedByString:@"."];
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(model.pricesign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
                    confer.text([NSString stringWithFormat:@"%@.",temp[0]]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:14]);
            confer.text(temp[1]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
        }];
        
        UILabel *goLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"iClaimed"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        goLa.backgroundColor = TCUIColorFromRGB(0x2a2a2a);
        goLa.layer.masksToBounds = YES;
        goLa.layer.cornerRadius = 10;
        goLa.frame = CGRectMake(5, CGRectGetMaxY(priceLa.frame) + 8, 100, 20);
        [goodsView addSubview:goLa];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(109.5, 14, 0.5, 178)];
        line.backgroundColor = TCUIColorFromRGB(0x949494);
        line.alpha = 0.1;
        [goodsView addSubview:line];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 220)];
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.timeInterval = 2.0;
        [goodsView addSubview:btn];
        
        
        if([self.type isEqualToString:@"1"]){
            goLa.text = [UserDefaultLocationDic valueForKey:@"tobegin"];
            goLa.y = 16;
        }
        
        if(i == self.todayArr.count - 1){
            line.hidden = YES;
        }
    }
    self.scrollView.contentSize = CGSizeMake(8 + 118 * self.todayArr.count, 220);
}

-(void)setScroll1{
    for (int i = 0; i < self.tomorrowArr.count; i++) {
        MMHomeLimitGoodsModel *model = self.tomorrowArr[i];
        UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(8 + 118 * i, 0, 110, 220)];
        goodsView.backgroundColor = TCUIColorFromRGB(0xffffff);
        goodsView.layer.masksToBounds = YES;
        goodsView.layer.cornerRadius = 5;
        [self.scrollView1 addSubview:goodsView];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 110, 106)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [goodsView addSubview:goodsImage];
        
        UILabel *nameLa = [UILabel publicLab:model.name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        nameLa.frame = CGRectMake(5, CGRectGetMaxY(goodsImage.frame), 90, 13);
        [goodsView addSubview:nameLa];
        
        NSString *str = [NSString stringWithFormat:@"%@%% off",model.discount];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,10)];
        UILabel *tagLa = [UILabel publicLab:str textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        tagLa.frame = CGRectMake(5, CGRectGetMaxY(nameLa.frame) + 7, size.width + 7, 13);
        tagLa.backgroundColor = [UIColor colorWithWzx:0xe1391a alpha:0.2];
        [goodsView addSubview:tagLa];
        
        UILabel *priceLa = [UILabel publicLab:model.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        priceLa.frame = CGRectMake(5, CGRectGetMaxY(tagLa.frame) + 7, 100, 13);
        [goodsView addSubview:priceLa];
        
        NSArray *temp = [model.pricevalue componentsSeparatedByString:@"."];
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(model.pricesign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
                    confer.text([NSString stringWithFormat:@"%@.",temp[0]]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:14]);
            confer.text(temp[1]).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
        }];
        
        UILabel *goLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"tobegin"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        goLa.backgroundColor = TCUIColorFromRGB(0x2a2a2a);
        goLa.layer.masksToBounds = YES;
        goLa.layer.cornerRadius = 10;
        goLa.frame = CGRectMake(5, CGRectGetMaxY(priceLa.frame) + 8, 100, 20);
        [goodsView addSubview:goLa];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(109.5, 14, 0.5, 178)];
        line.backgroundColor = TCUIColorFromRGB(0x949494);
        line.alpha = 0.1;
        [goodsView addSubview:line];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 220)];
        [btn addTarget:self action:@selector(clickBt1:) forControlEvents:(UIControlEventTouchUpInside)];
        [goodsView addSubview:btn];
        
       
        
        if([self.type isEqualToString:@"1"]){
            goLa.text = [UserDefaultLocationDic valueForKey:@"tobegin"];
            goLa.y = 16;
        }
        
        if(i == self.tomorrowArr.count - 1){
            line.hidden = YES;
        }
    }
    self.scrollView1.contentSize = CGSizeMake(8 + 118 * self.tomorrowArr.count, 220);
}

-(void)setType:(NSString *)type{
    _type = type;
    if([_type isEqualToString:@"0"]){
        self.scrollView.hidden = NO;
        self.scrollView1.hidden = YES;
    }else{
        self.scrollView.hidden = YES;
        self.scrollView1.hidden = NO;
    }
}

-(void)clickBt:(UIButton *)btn{
    self.clickGoodsBlock(self.model.defin6);
    
}
-(void)clickBt1:(UIButton *)btn{
    self.clickGoodsBlock(self.model.defin6);
}

@end
