//
//  MMDMSpecView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/27.
//

#import "MMDMSpecView.h"
#import "MMDMSpecView1.h"


@interface MMDMSpecView ()
@property (nonatomic, strong) MMDMGoodsInfoModel *model;
@property (nonatomic, strong) NSMutableArray *seleValue;
@property (nonatomic, strong) NSString *seleStr;//选择的规格字符串
@property (nonatomic, strong) NSMutableArray *paramArr;//所有的规格配对数组
@end

@implementation MMDMSpecView

-(NSMutableArray *)seleValue{
    if(!_seleValue){
        _seleValue = [NSMutableArray array];
    }
    return _seleValue;
}

-(instancetype)initWithFrame:(CGRect)frame andModel:(MMDMGoodsInfoModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        NSArray *arr = [MMDMGoodsSKUModel mj_objectArrayWithKeyValuesArray:model.param];
        self.paramArr = [NSMutableArray arrayWithArray:arr];
        self.seleStr = @"";
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    KweakSelf(self);
    float hei = 0;
    for (int i = 0; i < self.model.axis.count; i++) {
        NSDictionary *dic1 = self.model.axis[i];
//        NSString *name = dic1[@"name"];
        NSArray *arr1 = dic1[@"values"];
        
        int count = 0;
        float btnWidth = 0;
        float viewHeight = 0;
        for (int j = 0; j < arr1.count; j++) {
            NSString *btnName = arr1[j];
            if(j == 0){
                if(self.seleStr.length == 0){
                    self.seleStr = btnName;
                }else{
                    self.seleStr = [NSString stringWithFormat:@"%@,%@",self.seleStr,btnName];
                }
                
                NSDictionary *dic = @{@"name":dic1[@"name"],@"value":btnName};
                [self.seleValue addObject:dic];
                
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [btn setBackgroundColor:TCUIColorFromRGB(0xf5f5f5)];
            [btn setTitleColor:TCUIColorFromRGB(0x030303) forState:UIControlStateNormal];
            [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:UIControlStateSelected];
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:btnName forState:UIControlStateNormal];
//                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = TCUIColorFromRGB(0x1d1d1d).CGColor;
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:13] forKey:NSFontAttributeName];
            CGSize btnSize = [btnName sizeWithAttributes:dict];
            
            btn.width = btnSize.width + 28;
            btn.height = btnSize.height + 14;
            
            if (j == 0){
                btn.x = 24;
                btnWidth += CGRectGetMaxX(btn.frame);
            }else{
                btnWidth += CGRectGetMaxX(btn.frame) + 28;
                if (btnWidth > WIDTH) {
                    count++;
                    btn.x = 24;
                    btnWidth = CGRectGetMaxX(btn.frame);
                }
                else{
                    
                    btn.x += btnWidth - btn.width;
                }
            }
            btn.y += count * (btn.height+10)+28;
            
            viewHeight = CGRectGetMaxY(btn.frame)+20;
        }
        MMDMSpecView1 *specV1 = [[MMDMSpecView1 alloc]initWithFrame:CGRectMake(0, hei, WIDTH, viewHeight) andData:dic1];
        specV1.returnSelealue = ^(NSString * _Nonnull name, NSString * _Nonnull str) {
            NSDictionary *dic = @{@"name":name,@"value":str};
            
            for (int z = 0; z < weakself.seleValue.count; z++) {
                NSDictionary *dic1 = weakself.seleValue[z];
                if([dic1[@"name"] isEqualToString:name]){
                    [weakself.seleValue removeObjectAtIndex:i];
                    [weakself.seleValue insertObject:dic atIndex:i];
                }
            }
            for (MMDMGoodsSKUModel *model in weakself.paramArr) {
                if([model.info isEqual:self.seleValue]){
                    weakself.returnModelBlock(model);
                }
            }
            
        };
        [self addSubview:specV1];
        
        hei += viewHeight;
    }
    
    NSLog(@"选择规格是:%@ 规格数组是：%@",self.seleStr,self.seleValue);
    
   
    
    
       
}






@end
