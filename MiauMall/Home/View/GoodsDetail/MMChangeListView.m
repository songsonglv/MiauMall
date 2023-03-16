//
//  MMChangeListView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/6.
//

#import "MMChangeListView.h"
@interface MMChangeListView ()
@property (nonatomic, strong) UIButton *similarBt;
@property (nonatomic, strong) UIButton *recommendBt;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation MMChangeListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self setUI];
    }
    return self;
}

-(void)setUI{
    NSArray *arr = @[@"类似商品",@"推荐商品"];
    for (int i = 0; i <arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2 * i, 0, WIDTH/2, 43.5)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:textBlackColor2 forState:(UIControlStateNormal)];
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(changeList:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        if(i == 0){
            self.similarBt = btn;
        }else{
            self.recommendBt = btn;
        }
    }
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, WIDTH/2, 0.5)];
    lineV.backgroundColor = TCUIColorFromRGB(0x000000);
    [self addSubview:lineV];
    self.lineView = lineV;
}

-(void)changeList:(UIButton *)sender{
    if(sender.tag == 100){
        self.changeListBlcok(@"0");
        self.lineView.centerX = self.similarBt.centerX;
    }else{
        self.changeListBlcok(@"1");
        self.lineView.centerX = self.recommendBt.centerX;
    }
}
@end
