//
//  MMShopInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/18.
//。品牌信息

#import "MMShopInfoView.h"
#import "MMHomeRecommendGoodsModel.h"

@interface MMShopInfoView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *numLa;//在售商品数量
@property (nonatomic, strong) UIView *line;//线
@property (nonatomic, strong) UILabel *recommendLa;
@property (nonatomic, strong) UIScrollView *goodsScrollView;//推荐商品
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *scView;
@property (nonatomic, strong) NSMutableArray *goodsArr;

@end

@implementation MMShopInfoView

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

//-(UIPageControl *)pageControl{
//    if(!_pageControl){
//        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 322, 28, 4)];
//        _pageControl.centerX = self.centerX;
//        _pageControl.layer.masksToBounds = YES;
//        _pageControl.layer.cornerRadius = 2;
//        _pageControl.currentPage = 0;
//        _pageControl.numberOfPages = 3.0f;
//        _pageControl.pageIndicatorTintColor = redColor2;
//        //TCUIColorFromRGB(0xd5d5d5);
//        _pageControl.currentPageIndicatorTintColor = redColor2;
//        [_pageControl addTarget:self action:@selector(pageChange:)
//
//              forControlEvents:UIControlEventValueChanged];
//    }
//    return _pageControl;
//
//}

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 322, 28, 4)];
        _bgView.centerX = self.centerX;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 2;
        _bgView.backgroundColor = TCUIColorFromRGB(0xd5d5d5);
        
        UIView *seleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 4)];
        seleV.backgroundColor = redColor2;
        seleV.layer.masksToBounds = YES;
        seleV.layer.cornerRadius = 2;
        [_bgView addSubview:seleV];
        self.scView = seleV;
    }
    return _bgView;
}


-(UIImageView *)logoImage{
    if(!_logoImage){
        _logoImage = [[UIImageView alloc]init];
        _logoImage.layer.masksToBounds = YES;
        _logoImage.layer.cornerRadius = 7.5;
        _logoImage.layer.borderColor = TCUIColorFromRGB(0xf3f0ef).CGColor;
        _logoImage.layer.borderWidth = 0.5;
    }
    return _logoImage;
}

-(UILabel *)nameLa{
    if(!_nameLa){
        _nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        [_nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _nameLa;
}

-(UILabel *)numLa{
    if(!_numLa){
        _numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x6c6c6c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        [_numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _numLa;
}

-(UIView *)line{
    if(!_line){
        _line = [[UIView alloc]init];
        _line.backgroundColor = lineColor;
    }
    return _line;
}

-(UIScrollView *)goodsScrollView{
    if(!_goodsScrollView){
        _goodsScrollView = [[UIScrollView alloc]init];
        _goodsScrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _goodsScrollView.showsVerticalScrollIndicator = NO;
        _goodsScrollView.showsHorizontalScrollIndicator = NO;
        _goodsScrollView.pagingEnabled = YES;
        _goodsScrollView.delegate = self;
    }
    return _goodsScrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    KweakSelf(self);
    [self addSubview:self.logoImage];
    
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(54);
            make.height.mas_equalTo(54);
    }];
    
    [self addSubview:self.nameLa];
    
    [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.logoImage.mas_right).offset(10);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(13);
    }];
    
    [self addSubview:self.numLa];
    
    [self.numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.logoImage.mas_right).offset(12);
            make.top.mas_equalTo(weakself.nameLa.mas_bottom).offset(12);
            make.height.mas_equalTo(12);
    }];
    
    [self addSubview:self.line];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(74);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"right_icon_black"];
    [self addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(36);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(clickBrand) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(74);
    }];
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"recGood"] textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    [self addSubview:lab];
    self.recommendLa = lab;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(weakself.line.mas_bottom).offset(18);
            make.width.mas_equalTo(253);
            make.height.mas_equalTo(13);
    }];
    
//    self.goodsScrollView.pagingEnabled = YES;
    [self addSubview:self.goodsScrollView];
    [self.goodsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(lab.mas_bottom).offset(14);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(170);
    }];
    
    [self addSubview:self.bgView];
    
    
}

-(void)setBrandInfoModel:(MMBrandInfoModel *)brandInfoModel{
    _brandInfoModel = brandInfoModel;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:_brandInfoModel.LogoPicture]];
    self.nameLa.text = _brandInfoModel.Name;
    self.numLa.text = [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"onSale"],_brandInfoModel.BrandNum,[UserDefaultLocationDic valueForKey:@"ipiece"]];
}

-(void)setListModel:(MMBrandListModel *)listModel{
    _listModel = listModel;
    NSArray *goodsArr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:_listModel.list];
    self.goodsArr = [NSMutableArray arrayWithArray:goodsArr];
    NSInteger s = self.goodsArr.count/3;
    
    
    CGFloat wid = (self.width - 30)/3;
    if(self.goodsArr.count > 9){
        self.goodsScrollView.contentSize = CGSizeMake(self.width * 3, 170);
        self.scView.width = self.bgView.width/3;
        for (int i = 0; i < 9; i++) {
            MMHomeRecommendGoodsModel *model = self.goodsArr[i];
//            NSInteger index = i/3;
//            NSInteger index1 = i%3;
//            NSLog(@"%ld--%ld",index,index1);
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + i/3 * self.width + (wid + 5) *(i%3), 0, wid, 170)];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 6;
            view.layer.borderColor = TCUIColorFromRGB(0xf2f2f2).CGColor;
            view.layer.borderWidth = 0.5;
            [self.goodsScrollView addSubview:view];
            
            UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, 112)];
            [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture]];
            [view addSubview:goodsImage];
            
            UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x090b09) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:2];
            lab.preferredMaxLayoutWidth = wid;
            [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
//            lab.frame = CGRectMake(0, 117, wid, 25);
            [view addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(117);
                make.width.mas_equalTo(wid);
//                make.height.mas_equalTo(25);
            }];
            
            
            UILabel *lab1 = [UILabel publicLab:model.ActivePriceSign textColor:TCUIColorFromRGB(0x090b09) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
            lab1.preferredMaxLayoutWidth = 30;
            [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view addSubview:lab1];
            
            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(5);
                            make.bottom.mas_equalTo(-7);
                            make.height.mas_equalTo(10);
            }];
            
            UILabel *priceLa = [UILabel publicLab:model.ActivePriceValue textColor:TCUIColorFromRGB(0x090b09) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
            priceLa.preferredMaxLayoutWidth = 100;
            [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view addSubview:priceLa];
            
            [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lab1.mas_right).offset(4);
                            make.bottom.mas_equalTo(-7);
                            make.height.mas_equalTo(14);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundColor:UIColor.clearColor];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.top.right.bottom.mas_equalTo(0);
            }];
        }
    }else if(self.goodsArr.count > 3 && self.goodsArr.count <= 9){
        
        for (int i = 0; i < self.goodsArr.count; i++) {
            NSInteger num = self.goodsArr.count%3;
            if(num > 0){
                self.goodsScrollView.contentSize = CGSizeMake((self.goodsArr.count / 3 + 1) * self.width, 170);
            }else{
                self.goodsScrollView.contentSize = CGSizeMake(self.goodsArr.count / 3 * self.width, 170);
            }
            
            if(self.goodsArr.count > 6){
                self.scView.width = self.bgView.width/3;
            }else{
                self.scView.width = self.bgView.width/2;
            }
            
            MMHomeRecommendGoodsModel *model = self.goodsArr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + i/3 * self.width + (wid + 5) *(i%3), 0, wid, 170)];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 6;
            view.layer.borderColor = TCUIColorFromRGB(0xf2f2f2).CGColor;
            view.layer.borderWidth = 0.5;
            [self.goodsScrollView addSubview:view];
            
            UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, 112)];
            [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture]];
            [view addSubview:goodsImage];
            
            UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x090b09) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
            lab.preferredMaxLayoutWidth = wid;
            [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
//            lab.frame = CGRectMake(0, 117, wid, 25);
            [view addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(117);
                make.width.mas_equalTo(wid);
                 make.height.mas_equalTo(25);
            }];
            
            UILabel *lab1 = [UILabel publicLab:model.ActivePriceSign textColor:TCUIColorFromRGB(0x090b09) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
            lab1.preferredMaxLayoutWidth = 30;
            [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view addSubview:lab1];
            
            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(5);
                            make.bottom.mas_equalTo(-7);
                            make.height.mas_equalTo(10);
            }];
            
            UILabel *priceLa = [UILabel publicLab:model.ActivePriceValue textColor:TCUIColorFromRGB(0x090b09) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
            priceLa.preferredMaxLayoutWidth = 100;
            [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view addSubview:priceLa];
            
            [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lab1.mas_right).offset(4);
                            make.bottom.mas_equalTo(-7);
                            make.height.mas_equalTo(14);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn setBackgroundColor:UIColor.clearColor];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.top.right.bottom.mas_equalTo(0);
            }];
        }
    }else{
        self.goodsScrollView.hidden = YES;
        self.recommendLa.hidden = YES;
        self.bgView.hidden = YES;
//        self.pageControl.hidden = YES;
    }
}

#pragma mark -- scrollviewdelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//        //ensure that the end of scroll is fired.
//
//    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.3];
//        //NSLog(@"滑动中");
////    _isScrolling = YES ;
//
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    BOOL scrollviewStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if(scrollviewStop == YES){
        float current = scrollView.contentOffset.x/scrollView.width;
        
        if(scrollView.contentSize.width/scrollView.width == 3){
            [UIView animateWithDuration:0.25 animations:^{
                self.scView.x = (current/3)*28;
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self.scView.x = (current/2)*28;
            }];
        }
        
    }
}


-(void)clickBrand{
    self.brandTapBlock(self.brandInfoModel.ID);
}

-(void)clickBtn:(UIButton *)sender{
    MMHomeRecommendGoodsModel *model = self.goodsArr[sender.tag - 100];
    self.goodsTapBlock(model.Url);
}

@end
