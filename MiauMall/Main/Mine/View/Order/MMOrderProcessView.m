//
//  MMOrderProcessView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//  订单进程view

#import "MMOrderProcessView.h"
#import "MMOrderDetailTrackModel.h"
@interface MMOrderProcessView ()
@property (nonatomic, strong) NSMutableArray *contArr;
@end

@implementation MMOrderProcessView

-(NSMutableArray *)contArr{
    if(!_contArr){
        _contArr = [NSMutableArray array];
    }
    return _contArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return self;
}

-(void)setUI{
    KweakSelf(self);
    CGFloat hei = 0;
    for (int i = 0; i < self.contArr.count; i++) {
        MMOrderDetailTrackModel *model = self.contArr[i];
        NSString *str = [model.Conts stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 145,MAXFLOAT)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,hei, WIDTH - 20, size.height + 50)];
        view.backgroundColor = UIColor.whiteColor;
        [self addSubview:view];
        hei += size.height + 50;
        
        UILabel *lab1 = [UILabel publicLab:model.AddTime1 textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
        lab1.frame = CGRectMake(12, 8, 48, 13);
        [view addSubview:lab1];
        
        UILabel *lab2 = [UILabel publicLab:model.AddTime2 textColor:TCUIColorFromRGB(0x747474) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab2.frame = CGRectMake(17, CGRectGetMaxY(lab1.frame) + 8, 35, 12);
        [view addSubview:lab2];
        
        UILabel *nameLa = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        nameLa.frame = CGRectMake(102, 8, WIDTH - 145, 13);
        [view addSubview:nameLa];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0x383838);
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(83);
                    make.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(1);
        }];
        
        UIView *orangeV = [[UIView alloc]initWithFrame:CGRectMake(78, 18, 10, 10)];
        orangeV.backgroundColor = TCUIColorFromRGB(0xff8844);
        orangeV.layer.masksToBounds = YES;
        orangeV.layer.cornerRadius = 5;
        [view addSubview:orangeV];
        
        UILabel *contLa = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:13 numberOfLines:0];
        contLa.preferredMaxLayoutWidth = WIDTH - 145;
        [contLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        contLa.frame = CGRectMake(102, 28, WIDTH - 145, size.height);
        [contLa sizeToFit];
        [view addSubview:contLa];
        
//        [contLa mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(102);
//            make.top.mas_equalTo(CGRectGetMaxY(nameLa.frame) + 8);
//            make.right.mas_equalTo(-23);
//        }];
    }
    
}



-(void)setTracklist:(NSArray *)tracklist{
    _tracklist = tracklist;
    NSArray *arr = [MMOrderDetailTrackModel mj_objectArrayWithKeyValuesArray:_tracklist];
    self.contArr = [NSMutableArray arrayWithArray:arr];
    [self setUI];
}
@end
