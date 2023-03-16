//
//  MMRankList2GoodsView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import "MMRankList2GoodsView.h"
@interface MMRankList2GoodsView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MMRankList2GoodsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 202)];
    scrollView.backgroundColor = UIColor.whiteColor;
    scrollView.contentSize = CGSizeMake(WIDTH, 202);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

-(void)setGoodsArr:(NSArray *)goodsArr{
    _goodsArr = goodsArr;
    for (UIView *subview in self.scrollView.subviews) {
            [subview removeFromSuperview];
        }
    CGFloat wid = (WIDTH - 30)/3;
    self.scrollView.contentSize = CGSizeMake(20 + (wid + 5) * _goodsArr.count - 5, 202);
    for (int i = 0; i < _goodsArr.count; i++) {
        MMHomeRecommendGoodsModel *model = _goodsArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + (wid + 5) * i, 0, wid, 202)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [self.scrollView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoods:)];
        [view addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 200 + i;
        
        UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, wid)];
        [imageIcon sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        imageIcon.layer.masksToBounds = YES;
        imageIcon.layer.cornerRadius = 6;
        [view addSubview:imageIcon];
        
        UILabel *nameLa = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        nameLa.preferredMaxLayoutWidth = wid - 10;
        [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(wid + 7);
            make.width.mas_equalTo(wid - 10);
        }];
        
        CGSize size = [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(wid - 10,MAXFLOAT)];
        if(size.height < 18){
            nameLa.numberOfLines = 1;
        }else{
            nameLa.numberOfLines = 2;
        }
        
        UILabel *priceLa = [UILabel publicLab:model.PriceShow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = wid - 30;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(5);
                    make.bottom.mas_equalTo(-27);
                    make.height.mas_equalTo(12);
        }];
        
        UILabel *oldPriceLa = [UILabel publicLab:model.OldPriceShow textColor:TCUIColorFromRGB(0x696969) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.OldPriceShow attributes:attribtDic];
        oldPriceLa.attributedText = attribtStr;
        oldPriceLa.preferredMaxLayoutWidth = wid - 10;
        [oldPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:oldPriceLa];
        
        [oldPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(5);
                    make.bottom.mas_equalTo(-12);
                    make.height.mas_equalTo(10);
        }];
        
        UIButton *carBt = [[UIButton alloc]init];
        carBt.tag = 100 + i;
        [carBt setImage:[UIImage imageNamed:@"car_nine_icon"] forState:(UIControlStateNormal)];
        [carBt addTarget:self action:@selector(clickCar:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:carBt];
        
        [carBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-8);
                    make.bottom.mas_equalTo(-24);
                    make.width.height.mas_equalTo(17);
        }];
    }
}

-(void)clickGoods:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    MMHomeRecommendGoodsModel *model = self.goodsArr[[tap view].tag - 200];
    self.tapRankList2Goodsblock(model.Url);
}

-(void)clickCar:(UIButton *)sender{
    MMHomeRecommendGoodsModel *model = self.goodsArr[sender.tag - 100];
    self.tapRankList2GoodsCarBlock(model.ID);
}
@end
