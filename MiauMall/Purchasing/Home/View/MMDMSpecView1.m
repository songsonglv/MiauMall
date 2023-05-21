//
//  MMDMSpecView1.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/27.
//

#import "MMDMSpecView1.h"

@interface MMDMSpecView1 ()
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UIButton *selectBtn;//选中按钮
@end

@implementation MMDMSpecView1

-(instancetype)initWithFrame:(CGRect)frame andData:(nonnull NSDictionary *)dic{
    if(self = [super initWithFrame:frame]){
        self.dataDic = dic;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    NSString *name = self.dataDic[@"name"];
    NSArray *arr1 = self.dataDic[@"values"];
    
    float hei = 0;
    
    UILabel *titleLa = [UILabel publicLab:name textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    titleLa.frame = CGRectMake(26, hei, WIDTH - 52, 14);
    [self addSubview:titleLa];
    
    hei += 28;
    
    int count = 0;
    float btnWidth = 0;
    float viewHeight = 0;
    for (int j = 0; j < arr1.count; j++) {
        NSString *btnName = arr1[j];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        [btn setTitleColor:TCUIColorFromRGB(0x030303) forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
            self.selectBtn = btn;
            self.selectBtn.selected = YES;
            [self.selectBtn setBackgroundColor:TCUIColorFromRGB(0x1d1d1d)];
        }else{
            btnWidth += CGRectGetMaxX(btn.frame) + 10;
            if (btnWidth > WIDTH) {
                count++;
                btn.x = 24;
                btnWidth = CGRectGetMaxX(btn.frame);
            }else{
                btn.x += btnWidth - btn.width;
            }
        }
        btn.y += count * (btn.height+10)+ hei;
        
        viewHeight = CGRectGetMaxY(btn.frame)+20;
        
        [self addSubview:btn];
    }
    hei += viewHeight;
}


-(void)btnClick:(UIButton *)btn{
    if ([self.selectBtn isEqual:btn]) {
        
    }else{
        self.selectBtn.selected = NO;
        self.selectBtn.backgroundColor = TCUIColorFromRGB(0xffffff);
        btn.selected = YES;
        btn.backgroundColor = TCUIColorFromRGB(0x1d1d1d);
        self.selectBtn = btn;
    }
    
    
   
    
    self.returnSelealue(self.dataDic[@"name"],btn.titleLabel.text);
    
    
    
}


@end
