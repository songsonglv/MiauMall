//
//  MMSpecificationView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/19.
//  规格参数

#import "MMSpecificationView.h"

@interface MMSpecificationView ()
@property (nonatomic, strong) NSMutableArray *specArr;
@property (nonatomic, strong) UIView *showView;//显示展开收起
@property (nonatomic, strong) UILabel *showLa;
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, strong) NSMutableArray *arrArr;
@end

@implementation MMSpecificationView

-(NSMutableArray *)arrArr{
    if(!_arrArr){
        _arrArr = [NSMutableArray array];
    }
    return _arrArr;
}

-(NSMutableArray *)specArr{
    if(!_specArr){
        _specArr = [NSMutableArray array];
    }
    return _specArr;
}

-(UIView *)showView{
    if(!_showView){
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = TCUIColorFromRGB(0xffffff);
        UILabel *lab = [UILabel publicLab:@"展开" textColor:TCUIColorFromRGB(0x989898) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        lab.frame = CGRectMake((self.width - 45)/2, 10, 22, 11);
        [_showView addSubview:lab];
        self.showLa = lab;
        
        UIImageView *showImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 5, 24, 8, 4)];
        showImg.image = [UIImage imageNamed:@"down_icon_black"];
        [_showView addSubview:showImg];
        self.showImage = showImg;
    }
    return _showView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"spec_icon_black"];
    [self addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(12);
    }];
    
    UILabel *lab = [UILabel publicLab:@"规格参数" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    [self addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.top.mas_equalTo(15);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(12);
    }];
    
//    [self addSubview:self.showView];
//
//    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(32);
//    }];
    
    
}

//-(void)setIsShow:(NSString *)isShow{
//    _isShow = isShow;
//    if([_isShow isEqualToString:@"0"]){
//        self.showView.hidden = NO;
//    }else{
//        self.showView.hidden = YES;
//    }
//}

-(void)setProModel:(MMGoodsProInfoModel *)proModel{
    _proModel = proModel;
//    NSString *strUrl = [_proModel.GuideParam stringByReplacingOccurrencesOfString:@"\n" withString:@","];
//    NSString *str1 = [strUrl substringFromIndex: strUrl.length - 1];
//    if([str1 isEqualToString:@","]){
//        strUrl = [strUrl substringToIndex:[strUrl length] - 1];
//    }
//    strUrl = [self removeSpaceAndNewline:strUrl];
    NSArray *arr = [_proModel.GuideParam componentsSeparatedByString:@"\r\n"];
    self.specArr = [NSMutableArray arrayWithArray:arr];

    CGFloat h1 = 0;
    for (int i = 0; i < self.specHArr.count; i++) {
        CGFloat hei = [self.specHArr[i] floatValue];
        h1 += hei;
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 38, self.width - 24, h1)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    bgView.layer.borderColor = TCUIColorFromRGB(0xeeeeee).CGColor;
    bgView.layer.borderWidth = 0.5;
    [self addSubview:bgView];
    
    CGFloat h2 = 0;
    for (int i = 0; i < self.specArr.count; i++) {
        NSString *str = self.specArr[i];
        NSArray *array;
        NSRange range = [str rangeOfString:@"|"];
        if(range.location != NSNotFound){
            NSString *str1 = [str substringToIndex:range.location];
            NSString *str2 = [str substringFromIndex:range.location + 1];
            array = @[str1,str2];
        }
        CGFloat hei = [_specHArr[i] floatValue];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, h2, self.width - 24, hei)];
        [bgView addSubview:view];
        
        UILabel *la1 = [UILabel publicLab:array[0] textColor:TCUIColorFromRGB(0x989898) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        la1.frame = CGRectMake(12, 11, 55, 12);
        [view addSubview:la1];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(82, 0, 0.5, hei)];
        line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
        [view addSubview:line];
        NSString *valueStr = array[1];
        valueStr = [valueStr stringByReplacingOccurrencesOfString:@"" withString:@""];
        valueStr = [valueStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        valueStr = [valueStr stringByReplacingOccurrencesOfString:@"\n  " withString:@""];
        UILabel *la2 = [UILabel publicLab:valueStr textColor:TCUIColorFromRGB(0x989898) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        la2.preferredMaxLayoutWidth = self.width - 134;
        [la2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:la2];
        
        [la2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(100);
                    make.top.mas_equalTo(11);
                    make.width.mas_equalTo(self.width - 134);
        }];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, hei - 0.5, self.width - 24, 0.5)];
        line1.backgroundColor = TCUIColorFromRGB(0xeeeeee);
        [view addSubview:line1];
        
        h2 += hei;
    }
}

-(void)setSpecHArr:(NSArray *)specHArr{
    _specHArr = specHArr;
   
}

#pragma mark -- 去除字符串空格换行
- (NSString *)removeSpaceAndNewline:(NSString *)str
{
NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
return temp;

}

@end
