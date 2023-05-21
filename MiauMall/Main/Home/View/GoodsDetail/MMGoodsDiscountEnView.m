//
//  MMGoodsDiscountEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import "MMGoodsDiscountEnView.h"

@interface MMGoodsDiscountEnView ()

@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@property (nonatomic, strong) MMGoodsProInfoModel *moreModel;

@end

@implementation MMGoodsDiscountEnView

-(instancetype)initWithFrame:(CGRect)frame andBaseInfo:(MMGoodsDetailMainModel *)model andMoreInfo:(MMGoodsProInfoModel *)moreModel{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        self.moreModel = moreModel;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
   // NSMutableArray *arr = [NSMutableArray array];
    
    float mido = [self.model.proInfo.Price floatValue]/100;
    NSInteger mido1 = [self.model.proInfo.Price integerValue]/100;
    float sub = mido - mido1;
    NSString *discount;
    if(sub > 0){
        discount = [NSString stringWithFormat:@"+%ld %@",mido1 + 1,[UserDefaultLocationDic valueForKey:@"midou"]];
    }else{
        discount = [NSString stringWithFormat:@"%.f%@",mido,[UserDefaultLocationDic valueForKey:@"midou"]];
    }
    
    if(self.model.proInfo.DiscountName == nil || self.model.proInfo.DiscountName.length == 0){
        
    }else{
        discount = [NSString stringWithFormat:@"%@ | %@",discount,self.model.proInfo.DiscountName];
    }
    
    if(self.model.proInfo.PriceCutName == nil || [self.model.proInfo.PriceCutName isEmpty] || [self.model.proInfo.PriceCutName isEqualToString:@""]){
        
    }else{
        discount = [NSString stringWithFormat:@"%@ | %@",discount,self.model.proInfo.PriceCutName];
    }
    
    if(self.moreModel.OptionalName == nil || self.moreModel.OptionalName.length == 0){
        
    }else{
        discount = [NSString stringWithFormat:@"%@ | %@",discount,self.moreModel.OptionalName];
    }
    
    CGSize size = [NSString sizeWithText:discount font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16] maxSize:CGSizeMake(WIDTH - 32,MAXFLOAT)];
    UILabel *discountLa = [UILabel publicLab:discount textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
    discountLa.frame = CGRectMake(16, 20, WIDTH - 32, size.height);
    [self addSubview:discountLa];
}

@end
