//
//  MMSpecView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/20.
//

#import "MMSpecView.h"

@interface MMSpecView ()
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *attributesArray;

@property(nonatomic,strong)UIButton *selectBtn;
@property (nonatomic, strong) MMAttlistItemModel *model;

@property(nonatomic,strong)UIView *packView;
@property(nonatomic,strong)UIView *btnView;
@end

@implementation MMSpecView

-(instancetype)initWithTitle:(NSString *)title andData:(nonnull MMAttlistItemModel *)model andFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.title = title;
        self.model = model;
        NSArray *arr = [MMGoodsSpecItemModel mj_objectArrayWithKeyValuesArray:model.child];
        self.attributesArray = [NSArray arrayWithArray:arr];
        
        [self rankView];
    }
    return self;
}


-(void)rankView{
    
    self.packView = [[UIView alloc] initWithFrame:self.frame];
    self.packView.y = 0;
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
//    line.backgroundColor = TCUIColorFromRGB(0xffffff);
//    [self.packView addSubview:line];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, WIDTH, 25)];
    titleLB.text = self.title;
    titleLB.textColor = TCUIColorFromRGB(0x383838);
    titleLB.font = [UIFont fontWithName:@"PingfangSC-SemiBold" size:14];
    [self.packView addSubview:titleLB];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLB.frame), WIDTH, 40)];
    [self.packView addSubview:self.btnView];
    
    int count = 0;
    float btnWidth = 0;
    float viewHeight = 0;
    for (int i = 0; i < self.attributesArray.count; i++) {
        MMGoodsSpecItemModel *model = self.attributesArray[i];
        NSString *btnName = model.name;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundColor:TCUIColorFromRGB(0xf5f5f5)];
        [btn setTitleColor:TCUIColorFromRGB(0x383838) forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0xe13925) forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:btnName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.75;
        btn.layer.borderColor = TCUIColorFromRGB(0x8a8a8a).CGColor;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:13] forKey:NSFontAttributeName];
        CGSize btnSize = [btnName sizeWithAttributes:dict];
        
        btn.width = btnSize.width + 20;
        btn.height = btnSize.height + 14;
        
        if (i==0)
        {
            btn.x = 12;
            btnWidth += CGRectGetMaxX(btn.frame);
        }
        else{
            btnWidth += CGRectGetMaxX(btn.frame)+12;
            if (btnWidth > WIDTH) {
                count++;
                btn.x = 12;
                btnWidth = CGRectGetMaxX(btn.frame);
            }
            else{
                
                btn.x += btnWidth - btn.width;
            }
        }
        btn.y += count * (btn.height+12)+12;
        
        viewHeight = CGRectGetMaxY(btn.frame)+10;
        
        [self.btnView addSubview:btn];
        
        btn.tag = 10000+i;
        
        if([model.ID isEqualToString:self.model.choose]){
            self.selectBtn = btn;
            self.selectBtn.selected = YES;
            self.selectBtn.layer.borderColor = TCUIColorFromRGB(0xe13925).CGColor;
        }
        
    }
    self.btnView.height = viewHeight;
    self.packView.height = self.btnView.height+CGRectGetMaxY(titleLB.frame);
    
    self.height = self.packView.height;
    
    [self addSubview:self.packView];
}


-(void)btnClick:(UIButton *)btn{
    
    
    if (![self.selectBtn isEqual:btn]) {
        self.selectBtn.selected = NO;
        self.selectBtn.layer.borderColor = TCUIColorFromRGB(0x8a8a8a).CGColor;
    }else{
        
    }
    
    btn.layer.borderColor = TCUIColorFromRGB(0xe13925).CGColor;
    btn.selected = YES;
    self.selectBtn = btn;
    
    
    
    NSInteger tag = btn.tag - 10000;
    MMGoodsSpecItemModel *model = self.attributesArray[tag];
    self.selectSpecBlock(model, model.name);
}

@end
