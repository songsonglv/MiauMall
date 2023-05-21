//
//  MMRefundDetailTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/19.
//

#import "MMRefundDetailTopView.h"

@interface MMRefundDetailTopView ()
@property (nonatomic, strong) UIImageView *stepImage1;
@property (nonatomic, strong) UIImageView *stepImage2;
@property (nonatomic, strong) UIImageView *stepImage3;
@property (nonatomic, strong) UILabel *stepLa1;
@property (nonatomic, strong) UILabel *stepLa2;
@property (nonatomic, strong) UILabel *stepLa3;
@property (nonatomic, strong) UILabel *nameLa1;
@property (nonatomic, strong) UILabel *nameLa2;
@property (nonatomic, strong) UILabel *nameLa3;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@end
@implementation MMRefundDetailTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    CGFloat spac = (WIDTH - 320)/6;
    NSArray *arr = @[@"1",@"2",@"3"];
    NSArray *nameArr = @[[UserDefaultLocationDic valueForKey:@"submitapp"],[UserDefaultLocationDic valueForKey:@"agreeRefund"],[UserDefaultLocationDic valueForKey:@"refundleted"]];
//    UILabel *lab = [UILabel publicLab:@"1" textColor:TCUIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    for (int i = 0; i < arr.count; i++) {
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.frame = CGRectMake(spac + (spac * 2 + 120) * i + 17.5, 28, 25, 25);
        lab.layer.masksToBounds = YES;
        lab.layer.cornerRadius = 12.5;
        lab.layer.borderColor = TCUIColorFromRGB(0xa5a5a5).CGColor;
        lab.layer.borderWidth = 1;
        [self addSubview:lab];
        
        CGSize size = [NSString sizeWithText:nameArr[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
        
        UILabel *nameLa = [UILabel publicLab:nameArr[i] textColor:TCUIColorFromRGB(0xa5a5a5) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        nameLa.frame = CGRectMake(0, 63, size.width, 12);
        nameLa.centerX = lab.centerX;
        [self addSubview:nameLa];
        
        if(i == 0){
            self.stepLa1 = lab;
            nameLa.centerX = lab.centerX + 15;
            self.nameLa1 = nameLa;
        }else if (i == 1){
            self.stepLa2 = lab;
            self.nameLa2 = nameLa;
        }else{
            self.stepLa3 = lab;
            self.nameLa3 = nameLa;
            nameLa.centerX = lab.centerX - 15;
        }
    }
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(spac * 2 + 60, 41, 60, 1)];
    line1.backgroundColor = TCUIColorFromRGB(0xa5a5a5);
    [self addSubview:line1];
    self.line1 = line1;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(spac * 4 + 180, 41, 60, 1)];
    line2.backgroundColor = TCUIColorFromRGB(0xa5a5a5);
    [self addSubview:line2];
    self.line2 = line2;
    
    UIImageView *iconImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.stepLa1.x, 28, 25, 25)];
    iconImage1.image = [UIImage imageNamed:@"select_yes"];
    [self addSubview:iconImage1];
    self.stepImage1 = iconImage1;
    
    UIImageView *iconImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.stepLa2.x, 28, 25, 25)];
    iconImage2.image = [UIImage imageNamed:@"select_yes"];
    [self addSubview:iconImage2];
    self.stepImage2 = iconImage2;
    iconImage2.hidden = YES;
    
    UIImageView *iconImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.stepLa3.x, 28, 25, 25)];
    iconImage3.image = [UIImage imageNamed:@"select_yes"];
    [self addSubview:iconImage3];
    self.stepImage3 = iconImage3;
    iconImage3.hidden = YES;
}

-(void)setModel:(MMRefundResultModel *)model{
    _model = model;
    if([_model.Steps isEqualToString:@"0"]){
        self.line1.backgroundColor = redColor2;
        self.nameLa1.textColor = TCUIColorFromRGB(0x383838);
    }else if ([_model.Steps isEqualToString:@"1"]){
        self.stepImage2.hidden = NO;
        self.line1.backgroundColor = redColor2;
        self.line2.backgroundColor = redColor2;
        self.nameLa1.textColor = TCUIColorFromRGB(0x383838);
        self.nameLa2.textColor = TCUIColorFromRGB(0x383838);
    }else{
        self.stepImage2.hidden = NO;
        self.stepImage3.hidden = NO;
        self.line1.backgroundColor = redColor2;
        self.line2.backgroundColor = redColor2;
        self.nameLa1.textColor = TCUIColorFromRGB(0x383838);
        self.nameLa2.textColor = TCUIColorFromRGB(0x383838);
        self.nameLa3.textColor = TCUIColorFromRGB(0x383838);
    }
}
@end
