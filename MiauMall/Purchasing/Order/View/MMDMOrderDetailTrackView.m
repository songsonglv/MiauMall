//
//  MMDMOrderDetailTrackView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import "MMDMOrderDetailTrackView.h"
#import "MMDMOrderTrackModel.h"

@implementation MMDMOrderDetailTrackView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"orderStatw"] textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(17, 25, WIDTH - 34, 15);
    [self addSubview:titleLa];
}

-(void)setArr:(NSArray *)arr{
    _arr = arr;
    NSArray *arr1 = [MMDMOrderTrackModel mj_objectArrayWithKeyValuesArray:_arr];
    float hei = 44;
    for (int i = 0; i < arr.count; i++) {
        MMDMOrderTrackModel *model = arr1[i];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, 25)];
        [self addSubview:view];
        
        CGSize size = [NSString sizeWithText:model.AddTime font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
        
        CGSize size1 = [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 16 - size.width - 24,MAXFLOAT)];
        view.height = size1.height + 12;
        
        UILabel *lab = [UILabel publicLab:model.AddTime textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.frame = CGRectMake(16, 6, size.width, 13);
        [view addSubview:lab];
        
        UILabel *lab1 = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab1.frame = CGRectMake(CGRectGetMaxX(lab.frame) + 12, 4, size1.width, size.height);
        [view addSubview:lab1];
        
        hei += view.height;
    }
    
}


@end
