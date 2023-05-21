//
//  MMAssureEnView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/21.
//

#import "MMAssureEnView.h"

@implementation MMAssureEnView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"directMail"],[UserDefaultLocationDic valueForKey:@"guarante"],[UserDefaultLocationDic valueForKey:@"falsePays"],[UserDefaultLocationDic valueForKey:@"taxInclusive"],[UserDefaultLocationDic valueForKey:@"bzcwlythh"]];
    float hei = 22;
    for (int i = 0; i < arr.count; i++) {
        CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 52,MAXFLOAT)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, size.height + 12)];
        [self addSubview:view];
        
        UIView *dotV = [[UIView alloc]initWithFrame:CGRectMake(15, 8, 4, 4)];
        dotV.backgroundColor = TCUIColorFromRGB(0x1d1d1d);
        dotV.layer.masksToBounds = YES;
        dotV.layer.cornerRadius = 2;
        [view addSubview:dotV];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(26, 0, WIDTH - 52, size.height);
        [view addSubview:lab];
        
        hei += size.height + 12;
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, hei + 9.5, WIDTH - 28, 0.5)];
    line.backgroundColor = lineColor2;
    [self addSubview:line];
    
    
}

@end
