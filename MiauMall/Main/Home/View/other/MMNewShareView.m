//
//  MMNewShareView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import "MMNewShareView.h"
#import "MMMemberShowView.h"

@interface MMNewShareView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSArray *regMembers;
@property (nonatomic, strong) NSArray *orderMembers;
@property (nonatomic, strong) MMMemberShowView *showView;
@end

@implementation MMNewShareView

-(MMMemberShowView *)showView{
    if(!_showView){
        NSInteger j = self.regMembers.count/5;
        NSInteger i = self.regMembers.count%5;
        
        _showView = [[MMMemberShowView alloc]initWithFrame:CGRectMake(30, 44, WIDTH - 60, 0)];
        _showView.members = self.regMembers;
        if(self.regMembers.count == 0){
            _showView.height = 0;
        }else{
            if(i > 0){
                j += 1;
            }
            _showView.height = 100 * j;
        }
        
    }
    return _showView;
}


-(instancetype)initWithFrame:(CGRect)frame andImageUrl:(nonnull NSString *)imageUrl andRegMembers:(nonnull NSArray *)members andOrderMembers:(nonnull NSArray *)orderMembers{
    if(self = [super initWithFrame:frame]){
        self.imageUrl = imageUrl;
        self.regMembers = members;
        self.orderMembers = orderMembers;
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    UIImageView *bgImage = [[UIImageView alloc]init];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    bgImage.userInteractionEnabled = YES;
    [self addSubview:bgImage];
    self.bgImage = bgImage;
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(30, 10, 120, 24)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    [self setView:bgView andCorlors:@[TCUIColorFromRGB(0xff975e),TCUIColorFromRGB(0xf53e2a)]];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"invitedSuccess"],[UserDefaultLocationDic valueForKey:@"orderUser"]];
    float leftWid = 40;
    for (int i = 0; i < arr.count; i++) {
        
        CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(leftWid, 10, size.width + 20, 24)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateSelected)];
        [btn setTitleColor:TCUIColorFromRGB(0xf53e2a) forState:(UIControlStateNormal)];
        btn.selected = NO;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        leftWid += size.width + 44;
        
        if(i == 0){
            self.selectBtn = btn;
            self.selectBtn.selected = YES;
            self.bgView.x = 30;
            self.bgView.width = btn.width + 20;
        }
    }
    
    [self addSubview:self.showView];
    
    
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    
}

-(void)clickBt:(UIButton *)sender{
    if([self.selectBtn isEqual:sender]){
        
    }else{
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
        self.bgView.x = sender.x - 10;
        self.bgView.width = sender.width + 20;
    }
    
    if(sender.tag == 100){
        _showView.members = self.regMembers;
        NSInteger j = self.regMembers.count/5;
        NSInteger i = self.regMembers.count%5;
        if(self.regMembers.count == 0){
            _showView.height = 0;
        }else{
            if(i > 0){
                j += 1;
            }
            _showView.height = 100 * j;
        }
    }else{
        _showView.members = self.orderMembers;
        NSInteger j = self.orderMembers.count/5;
        NSInteger i = self.orderMembers.count%5;
        if(self.orderMembers.count == 0){
            _showView.height = 0;
        }else{
            if(i > 0){
                j += 1;
            }
            _showView.height = 100 * j;
        }
    }
    
    self.tapMemberBlock(sender.tag - 100);
}

//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}
@end
