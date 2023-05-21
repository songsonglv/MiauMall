//
//  MMTopBannerView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//  顶部banner

#import "MMTopBannerView.h"

@interface MMTopBannerView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UILabel *pageLabel;//滚动到了第几页
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) UILabel *hasteLa;//48标签
@property (nonatomic, strong) UILabel *reserveLa;//预售标签
@property (nonatomic, strong) UILabel *ppzgLa;//品牌直供
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation MMTopBannerView

-(NSMutableArray *)models{
    if(!_models){
        _models = [NSMutableArray array];
    }
    return _models;
}

-(SDCycleScrollView *)cycle{
    if (!_cycle) {
        _cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height)];
        _cycle.backgroundColor = TCUIColorFromRGB(0xffffff);
        _cycle.delegate = self;
        _cycle.layer.masksToBounds = YES;
        _cycle.placeholderImage = [UIImage imageNamed:@"zhanweic"];
//        _cycle.layer.cornerRadius = 8;
        _cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycle.showPageControl = NO;

    }
    return _cycle;
}

-(UILabel *)reserveLa{
    if(!_reserveLa){
        _reserveLa = [UILabel publicLab:[NSString stringWithFormat:@" %@",[UserDefaultLocationDic valueForKey:@"sdqfh"]] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        _reserveLa.backgroundColor = redColor2;
        _reserveLa.frame = CGRectMake(10, WIDTH - 68, 88, 40);
        _reserveLa.layer.masksToBounds = YES;
        _reserveLa.layer.cornerRadius = 6;
    }
    return _reserveLa;
}

-(UILabel *)hasteLa{
    if(!_hasteLa){
        _hasteLa = [UILabel publicLab:[NSString stringWithFormat:@"48h %@",[UserDefaultLocationDic valueForKey:@"shippingin2"]] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        _hasteLa.backgroundColor = redColor2;
        _hasteLa.frame = CGRectMake(10, WIDTH - 68, 40, 40);
        NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
        if([lang isEqualToString:@"1"]){
            _hasteLa.frame = CGRectMake(10, WIDTH - 68, 100, 32);
        }
        _hasteLa.layer.masksToBounds = YES;
        _hasteLa.layer.cornerRadius = 6;
    }
    return _hasteLa;
}

-(UILabel *)ppzgLa{
    NSString *str = [NSString stringWithFormat:@"%@\n%@",[UserDefaultLocationDic valueForKey:@"brandsend1"],[UserDefaultLocationDic valueForKey:@"brandsend2"]];
    CGSize size1 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"brandsend1"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:19] maxSize:CGSizeMake(MAXFLOAT,19)];
    CGSize size2 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"brandsend2"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:19] maxSize:CGSizeMake(MAXFLOAT,19)];
    float wid = size1.width > size2.width ? size1.width + 20 : size2.width + 20;
    if(!_ppzgLa){
        _ppzgLa = [UILabel publicLab:str textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:19 numberOfLines:0];
        _ppzgLa.frame = CGRectMake(WIDTH - wid - 20, 58, wid, 54);
        _ppzgLa.backgroundColor = TCUIColorFromRGB(0x333333);
        _ppzgLa.layer.masksToBounds = YES;
        _ppzgLa.layer.cornerRadius = 10;
    }
    return _ppzgLa;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
//        [self setUI];
    }
    return self;
}

-(void)setUI{
    [self addSubview:self.cycle];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 42, WIDTH - 28, 28, 14)];
    bgImage.image = [UIImage imageNamed:@"dark_icon"];
    [self addSubview:bgImage];
    self.bgImage = bgImage;
    
    
    UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"1/%ld",self.bannerArr.count] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:9 numberOfLines:0];
    lab.frame = CGRectMake(0, 0, 28, 14);
    [bgImage addSubview:lab];
    self.pageLabel = lab;
}

-(void)setBannerArr:(NSArray *)bannerArr{
    _bannerArr = bannerArr;
    [self setUI];
    self.cycle.imageURLStringsGroup = _bannerArr;
    
    if(self.models.count == 0){
        for (NSString *str in _bannerArr) {
            JJDataModel *model = [JJDataModel alloc];
            model.img = str;
            [self.models addObject:model];
        }
    }
    
    
}

-(void)setModel:(MMGoodsDetailMainModel *)model{
    _model = model;
    NSInteger realnum = [_model.proInfo.RealNumber integerValue];
    if([_model.proInfo.cid isEqualToString:@"828"]){
        self.bgImage.centerX = self.centerX;
        [self addSubview:self.ppzgLa];
    }else{
        if(realnum > 0){
            [self addSubview:self.hasteLa];
        }else{
            [self addSubview:self.reserveLa];
        }
    }
   
}

#pragma mark -- cycleDelegate
//图片滚动回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSString *str = [NSString stringWithFormat:@"%ld/%ld",index + 1,self.bannerArr.count];
    self.pageLabel.text = str;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.tapImageBlock(self.models, index);
}



@end
