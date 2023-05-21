//
//  MMDMOrderDetailGoodsView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/10.
//

#import "MMDMOrderDetailGoodsView.h"
#import "MMDMOrderGoodsModel.h"

@interface MMDMOrderDetailGoodsView ()

@end

@implementation MMDMOrderDetailGoodsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.whiteColor;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"goodList"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(17, 24, WIDTH - 34, 15);
    [self addSubview:titleLa];
}

-(void)setGoodsArr:(NSArray *)goodsArr{
    _goodsArr = goodsArr;
    NSArray *arr = [MMDMOrderGoodsModel mj_objectArrayWithKeyValuesArray:_goodsArr];
    float hei = 40;
    for (int i = 0; i < arr.count; i++) {
        MMDMOrderGoodsModel *model1 = arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 116)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 13, 67, 67)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model1.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        goodsImage.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
        goodsImage.layer.borderWidth = 0.5;
        [view addSubview:goodsImage];
        
        UILabel *nameLa = [UILabel publicLab:model1.Name textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        nameLa.frame = CGRectMake(94, 16, WIDTH - 120, 15);
        [view addSubview:nameLa];
        if(model1.Attribute.length > 0){
            UILabel *attiLa = [UILabel publicLab:model1.Attribute textColor:TCUIColorFromRGB(0xa3a2a2) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
            attiLa.frame = CGRectMake(94, CGRectGetMaxY(nameLa.frame) + 10, WIDTH - 120, 12);
            [view addSubview:attiLa];
        }
        
        if(model1.SureID){
            CGSize size = [NSString sizeWithText:model1.SureName font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
            UILabel *lab = [UILabel publicLab:model1.SureName textColor:TCUIColorFromRGB(0x595959) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
            lab.frame = CGRectMake(94, CGRectGetMaxY(nameLa.frame) + 34, size.width + 10, 18);
            lab.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
            lab.layer.masksToBounds = YES;
            lab.layer.cornerRadius = 2;
            [view addSubview:lab];
        }
        
        UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
        priceLa.frame = CGRectMake(94, CGRectGetMaxY(nameLa.frame) + 58, WIDTH -120, 15);
        [view addSubview:priceLa];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(model1.PriceShow).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:15]);
        }];
        
        UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@",model1.Number] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        numLa.preferredMaxLayoutWidth = 100;
        [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-14);
                    make.top.mas_equalTo(CGRectGetMaxY(nameLa.frame) + 59);
                    make.height.mas_equalTo(13);
        }];
        
        if(i == arr.count - 1){
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 115.5, WIDTH - 24, 0.5)];
            line.backgroundColor = lineColor2;
            [view addSubview:line];
        }
        
        hei += 116;
    }
}


@end
