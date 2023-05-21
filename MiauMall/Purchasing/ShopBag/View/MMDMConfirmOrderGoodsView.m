//
//  MMDMConfirmOrderGoodsView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/4.
//

#import "MMDMConfirmOrderGoodsView.h"
#import "MMDMShopCartGoodsModel.h"

@implementation MMDMConfirmOrderGoodsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *tiLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"goodList"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    tiLa.frame = CGRectMake(17, 4, WIDTH - 34, 15);
    [self addSubview:tiLa];
}

-(void)setModel:(MMDMConfirmOrderModel *)model{
    _model = model;
    NSArray *arr = [MMDMShopCartGoodsModel mj_objectArrayWithKeyValuesArray:_model.ProductItems];
    
    float hei = 42;
    for (int i = 0; i < arr.count; i++) {
        MMDMShopCartGoodsModel *model1 = arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 130)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 2, 68, 68)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model1.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        [view addSubview:goodsImage];
        
        UILabel *goodsNameLa = [UILabel publicLab:model1.name textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        goodsNameLa.frame = CGRectMake(94, 6, WIDTH - 106, 15);
        [view addSubview:goodsNameLa];
        
        
        CGSize size = [NSString sizeWithText:model1.attname font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 150,MAXFLOAT)];
        UILabel *specLa = [UILabel publicLab:model1.attname textColor:TCUIColorFromRGB(0xa3a2a2) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        specLa.frame = CGRectMake(94, CGRectGetMaxY(goodsNameLa.frame) + 12,  WIDTH - 150, size.height);
        [view addSubview:specLa];
        
        if(model1.choosesurestr){
            CGSize size1 = [NSString sizeWithText:model1.choosesurestr font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
            if(size1.width > WIDTH - 160){
                size1.width = WIDTH - 160;
            }
            UILabel *serviceLa = [UILabel publicLab:model1.choosesurestr textColor:TCUIColorFromRGB(0x595959) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
            serviceLa.frame = CGRectMake(94, CGRectGetMaxY(specLa.frame) + 12, size1.width + 10, 18);
            serviceLa.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
            serviceLa.layer.masksToBounds = YES;
            serviceLa.layer.cornerRadius = 6;
            [view addSubview:serviceLa];
        }
        
        UILabel *priceLa = [UILabel publicLab:model1.priceshow textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:15];
        priceLa.frame = CGRectMake(94, CGRectGetMaxY(specLa.frame) + 42, WIDTH - 140, 15);
        [view addSubview:priceLa];
        
        UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@",model1.num] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        numLa.frame = CGRectMake(WIDTH - 45, CGRectGetMaxY(specLa.frame) + 43, 33, 13);
        [view addSubview:numLa];
        
        hei += 130;
        
        if(i == arr.count - 1){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(11, 129.5, WIDTH - 22, 0.5)];
            line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
            [view addSubview:line];
        }
    }
}

@end
