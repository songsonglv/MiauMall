//
//  MMHomeLimitView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/26.
//

#import "MMHomeLimitView.h"
#import "MMHomeLimitGoodsModel.h"

@interface MMHomeLimitView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) NSMutableArray *todayArr;
@property (nonatomic, strong) NSMutableArray *tomorrowArr;
@property (nonatomic, strong) MMHomePageItemModel *model;
@end

@implementation MMHomeLimitView

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
    CGFloat space = (WIDTH - 20 - 327)/4;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20 - 2 * space , 208)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIScrollView *scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20 - 2 * space , 208)];
    scrollView1.backgroundColor = UIColor.clearColor;
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView1];
    self.scrollView1 = scrollView1;
    
    [self setScroll];
    [self setScroll1];
}


-(void)setScroll{
    CGFloat space = (WIDTH - 20 - 327)/4;
    for (int i = 0; i < self.todayArr.count; i++) {
        MMHomeLimitGoodsModel *model = self.todayArr[i];
        UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake((110 + space) * i, 0, 110, 208)];
        goodsView.backgroundColor = TCUIColorFromRGB(0xffffff);
        goodsView.layer.masksToBounds = YES;
        goodsView.layer.cornerRadius = 5;
        [self.scrollView addSubview:goodsView];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 104)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [goodsView addSubview:goodsImage];
        
        UILabel *nameLa = [UILabel publicLab:model.name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:2];
        nameLa.frame = CGRectMake(5, CGRectGetMaxY(goodsImage.frame), 100, 25);
        [goodsView addSubview:nameLa];
        
        UILabel *priceLa = [UILabel publicLab:model.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        priceLa.frame = CGRectMake(5, CGRectGetMaxY(nameLa.frame) + 7, 100, 13);
        [goodsView addSubview:priceLa];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(model.pricesign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
                    confer.text(model.pricevalue).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
        }];
        
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(priceLa.frame) + 7, 100, 46)];
        bgImage.backgroundColor = [UIColor colorWithWzxString:self.model.otherColor];
        bgImage.layer.masksToBounds = YES;
        bgImage.layer.cornerRadius = 4;
        [goodsView addSubview:bgImage];
        
        UILabel *goLa = [UILabel publicLab:@"立即抢购" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        goLa.frame = CGRectMake(0, 10, 100, 14);
        [bgImage addSubview:goLa];
        
       
        float YiQiang = [model.YiQiang floatValue];
        
        
        UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 32, 56, 5)];
        float value = YiQiang/100.0;
        progressView.progress = value;
        progressView.trackTintColor = TCUIColorFromRGB(0xfec749);
        progressView.progressTintColor = TCUIColorFromRGB(0xffffff);
        [bgImage addSubview:progressView];
        
        UILabel *proLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%%",model.YiQiang] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
        proLa.frame = CGRectMake(70, 30, 30, 10);
        [bgImage addSubview:proLa];
        
        if([self.type isEqualToString:@"1"]){
            progressView.hidden = YES;
            proLa.hidden = YES;
            goLa.text = @"即将开始";
            goLa.y = 16;
        }
    }
    self.scrollView.contentSize = CGSizeMake(110 * self.todayArr.count + space * (self.todayArr.count - 1), 208);
}

-(void)setScroll1{
    CGFloat space = (WIDTH - 20 - 327)/4;
    for (int i = 0; i < self.tomorrowArr.count; i++) {
        MMHomeLimitGoodsModel *model = self.tomorrowArr[i];
        UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake((110 + space) * i, 0, 110, 208)];
        goodsView.backgroundColor = TCUIColorFromRGB(0xffffff);
        goodsView.layer.masksToBounds = YES;
        goodsView.layer.cornerRadius = 5;
        [self.scrollView1 addSubview:goodsView];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 104)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [goodsView addSubview:goodsImage];
        
        UILabel *nameLa = [UILabel publicLab:model.name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:2];
        nameLa.frame = CGRectMake(5, CGRectGetMaxY(goodsImage.frame), 100, 25);
        [goodsView addSubview:nameLa];
        
        UILabel *priceLa = [UILabel publicLab:model.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        priceLa.frame = CGRectMake(5, CGRectGetMaxY(nameLa.frame) + 7, 100, 13);
        [goodsView addSubview:priceLa];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(model.pricesign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
                    confer.text(model.pricevalue).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
        }];
        
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(priceLa.frame) + 7, 100, 46)];
        bgImage.backgroundColor = [UIColor colorWithWzxString:self.model.otherColor];
        bgImage.layer.masksToBounds = YES;
        bgImage.layer.cornerRadius = 4;
        [goodsView addSubview:bgImage];
        
        UILabel *goLa = [UILabel publicLab:@"立即抢购" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        goLa.frame = CGRectMake(0, 10, 100, 14);
        [bgImage addSubview:goLa];
           
        goLa.text = @"即将开始";
        goLa.y = 16;
        
    }
    self.scrollView1.contentSize = CGSizeMake(110 * self.tomorrowArr.count + space * (self.tomorrowArr.count - 1), 208);
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
@end
