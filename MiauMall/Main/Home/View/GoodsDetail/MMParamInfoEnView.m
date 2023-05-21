//
//  MMParamInfoEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/19.
//

#import "MMParamInfoEnView.h"

@interface MMParamInfoEnView ()
@property (nonatomic, strong) MMGoodsProInfoModel *moreModel;
@end

@implementation MMParamInfoEnView

-(instancetype)initWithFrame:(CGRect)frame andMoreInfo:(MMGoodsProInfoModel *)moreModel{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.moreModel = moreModel;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(WIDTH - 20);
    }];
    
    UILabel *lab = [UILabel publicLab:@"Product Information" textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSc-SemiBold" size:16 numberOfLines:0];
    lab.frame = CGRectMake(12, 16, WIDTH - 44, 16);
    [view addSubview:lab];
    
    UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 35, 17, 5, 10)];
    rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
    [view addSubview:rightIcon];
    
    NSArray *arr = [self.moreModel.GuideParam componentsSeparatedByString:@"\r\n"];
    NSString *str = [arr[0] stringByReplacingOccurrencesOfString:@"|" withString:@":"];
    
    CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(WIDTH - 44,MAXFLOAT)];
    
    UILabel *conLa = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    conLa.frame = CGRectMake(12, 45, WIDTH - 44, size.height);
    [view addSubview:conLa];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
    }];
}

-(void)clickBt{
    self.returnParamBlock(@"1");
}


@end
