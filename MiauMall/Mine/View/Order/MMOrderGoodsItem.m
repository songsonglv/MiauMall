//
//  MMOrderGoodsItem.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/15.
//

#import "MMOrderGoodsItem.h"
#import "MMOrderListGoodsItemModel.h"
@interface MMOrderGoodsItem ()
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLa;
@property (nonatomic, strong) UILabel *specLa;
@property (nonatomic, strong) UILabel *numLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *acturaPriceLa;
@property (nonatomic, strong) NSMutableArray *goodsArr;

@end

@implementation MMOrderGoodsItem
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return self;
}

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(void)setUI{
    CGFloat hei = 0;
    for (int i = 0; i < self.goodsArr.count; i++) {
        MMOrderListGoodsItemModel *model = self.goodsArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH - 20, 104)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        hei += 124;
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 100, 100)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        goodsImage.layer.borderColor = TCUIColorFromRGB(0xf0f0f0).CGColor;
        goodsImage.layer.borderWidth = 0.5;
        [view addSubview:goodsImage];
        
        UILabel *goodsNameLa = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        goodsNameLa.frame = CGRectMake(118, 7, view.width - 128, 14);
        [view addSubview:goodsNameLa];
        
        if([model.Attribute isEqualToString:@""]){
            
        }else{
            UILabel *AttributeLa = [UILabel publicLab:model.Attribute textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            CGSize size = [AttributeLa sizeThatFits:CGSizeMake(MAXFLOAT,11)];
            AttributeLa.frame = CGRectMake(118, 32, size.width + 20, 18);
            [AttributeLa setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
            AttributeLa.layer.masksToBounds = YES;
            AttributeLa.layer.cornerRadius = 9;
            [view addSubview:AttributeLa];
        }
        
        UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@件",model.Number] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        numLa.frame = CGRectMake(view.width - 45, 35, 35, 13);
        [view addSubview:numLa];
        
        UILabel *priceLa = [UILabel publicLab:model.MoneysShow textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth =  view.width - 128;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.bottom.mas_equalTo(-23);
                    make.height.mas_equalTo(11);
        }];
        
        UILabel *acturaPriceLa = [UILabel publicLab:[NSString stringWithFormat:@"实付款 %@",model.SalesMoneyShow
                                                    ] textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        acturaPriceLa.preferredMaxLayoutWidth = view.width - 128;
        [acturaPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:acturaPriceLa];
        
        [acturaPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(13);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        btn.backgroundColor = UIColor.clearColor;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
    }
}

-(void)clickBt:(UIButton *)sender{
    MMOrderListGoodsItemModel *model = self.goodsArr[sender.tag - 100];
    self.tapGoodsBlock(model.url);
}


-(void)setArr:(NSArray *)arr{
    _arr = arr;
    NSArray *arr1 = [MMOrderListGoodsItemModel mj_objectArrayWithKeyValuesArray:_arr];
    self.goodsArr = [NSMutableArray arrayWithArray:arr1];
    [self setUI];
}




@end
