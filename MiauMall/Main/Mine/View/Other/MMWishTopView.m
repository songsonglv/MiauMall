//
//  MMWishTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import "MMWishTopView.h"
@interface MMWishTopView ()
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) UIButton *bt2;
@property (nonatomic, strong) NSString *type;
@end

@implementation MMWishTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = UIColor.clearColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12.5;
    self.layer.borderColor = TCUIColorFromRGB(0xffffff).CGColor;
    self.layer.borderWidth = 0.5;
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"wdxy"],[UserDefaultLocationDic valueForKey:@"xygc"]];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.width/2 * i, 0, self.width/2, 25)];
        btn.backgroundColor = UIColor.clearColor;
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x10024c) forState:(UIControlStateSelected)];
        btn.tag = 100 + i;
        btn.selected = NO;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        if(i == 0){
            self.selectBt = btn;
            btn.backgroundColor = TCUIColorFromRGB(0xffffff);
            btn.selected = YES;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 12.5;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            
        }
    }
}

-(void)clickBtn:(UIButton *)sender{
    if([self.selectBt isEqual:sender]){
        
    }else{
        sender.selected = YES;
        self.selectBt.selected = NO;
        sender.backgroundColor = TCUIColorFromRGB(0xffffff);
        sender.selected = YES;
        sender.layer.masksToBounds = YES;
        sender.layer.cornerRadius = 12.5;
        sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        
        self.selectBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        self.selectBt.backgroundColor = UIColor.clearColor;
    }
    
    self.selectBt = sender;
    
    if(sender.tag == 100){
        self.typeBlcok(@"0");
    }else{
        self.typeBlcok(@"1");
    }
}

@end
