//
//  MMTopBannerView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/16.
//  顶部banner

#import "MMTopBannerView.h"

@interface MMTopBannerView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UILabel *pageLabel;//滚动到了第几页
@property (nonatomic, strong) SDCycleScrollView *cycle;
@property (nonatomic, strong) UILabel *hasteLa;//48标签
@property (nonatomic, strong) UILabel *reserveLa;//预售标签
@end

@implementation MMTopBannerView

-(SDCycleScrollView *)cycle{
    if (!_cycle) {
        _cycle = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height)];
        _cycle.backgroundColor = TCUIColorFromRGB(0xffffff);
        _cycle.delegate = self;
        _cycle.layer.masksToBounds = YES;
//        _cycle.layer.cornerRadius = 8;
        _cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycle.showPageControl = NO;

    }
    return _cycle;
}

-(UILabel *)reserveLa{
    if(!_reserveLa){
        _reserveLa = [UILabel publicLab:@"预定 3-7个 工作日发货" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        _reserveLa.backgroundColor = redColor2;
        _reserveLa.frame = CGRectMake(10, WIDTH - 68, 78, 40);
        _reserveLa.layer.masksToBounds = YES;
        _reserveLa.layer.cornerRadius = 6;
    }
    return _reserveLa;
}

-(UILabel *)hasteLa{
    if(!_hasteLa){
        _hasteLa = [UILabel publicLab:@"48h 发货" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        _hasteLa.backgroundColor = redColor2;
        _hasteLa.frame = CGRectMake(10, WIDTH - 68, 40, 40);
        _hasteLa.layer.masksToBounds = YES;
        _hasteLa.layer.cornerRadius = 6;
    }
    return _hasteLa;
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
    
    
    UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"1/%ld",self.bannerArr.count] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:9 numberOfLines:0];
    lab.frame = CGRectMake(0, 0, 28, 14);
    [bgImage addSubview:lab];
    self.pageLabel = lab;
}

-(void)setBannerArr:(NSArray *)bannerArr{
    _bannerArr = bannerArr;
    [self setUI];
    self.cycle.imageURLStringsGroup = _bannerArr;
}

-(void)setModel:(MMGoodsDetailMainModel *)model{
    _model = model;
    NSInteger realnum = [_model.proInfo.RealNumber integerValue];
    if(realnum > 0){
        [self addSubview:self.hasteLa];
    }else{
        [self addSubview:self.reserveLa];
    }
}

#pragma mark -- cycleDelegate
//图片滚动回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSString *str = [NSString stringWithFormat:@"%ld/%ld",index + 1,self.bannerArr.count];
    self.pageLabel.text = str;
}




@end
