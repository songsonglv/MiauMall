//
//  MMlogictisContentView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//  物流内容view

#import "MMlogictisContentView.h"
#import "MMShipItemModel.h"
@interface MMlogictisContentView ()
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) NSMutableArray *heiArr;

@end

@implementation MMlogictisContentView

-(NSMutableArray *)contentArr{
    if(!_contentArr){
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

-(NSMutableArray *)heiArr{
    if(!_heiArr){
        _heiArr = [NSMutableArray array];
    }
    return _heiArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        
    }
    return self;
}

-(void)creatUI{
    CGFloat hei = 0;
    for (int i = 0; i < self.contentArr.count; i++) {
        MMShipItemModel *model = self.contentArr[i];
        CGSize size = [NSString sizeWithText:model.context font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 196,32)];
        if(i == 0){
            size = [NSString sizeWithText:[NSString stringWithFormat:@"%@(%@)",model.context,model.status] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 196,32)];
        }
        
        NSArray *arr = [model.time componentsSeparatedByString:@" "];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 22 + hei, WIDTH - 20, size.height + 30)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        hei += size.height + 30;
        
        UILabel *contLa = [UILabel publicLab:[NSString stringWithFormat:@"%@(%@)",model.context,model.status] textColor:TCUIColorFromRGB(0x747474) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        contLa.preferredMaxLayoutWidth = WIDTH - 196;
        [contLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:contLa];
        
        [contLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(112);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(WIDTH - 196);
        }];
        
        if(i == 0){
            [contLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text(model.context).textColor(TCUIColorFromRGB(0x747474));
                confer.text([NSString stringWithFormat:@"(%@)",model.status]).textColor(redColor2);
            }];
        }
        
        UILabel *dateLa = [UILabel publicLab:arr[0] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        dateLa.frame = CGRectMake(0, 9, 88, 13);
        [view addSubview:dateLa];
        
        UILabel *timeLa = [UILabel publicLab:arr[1] textColor:TCUIColorFromRGB(0x747474) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        timeLa.frame = CGRectMake(0, CGRectGetMaxY(dateLa.frame) + 8, 88, 12);
        [view addSubview:timeLa];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(93, 0, 1, view.height)];
        line.backgroundColor = TCUIColorFromRGB(0x747474);
        [view addSubview:line];
        
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(88.5, (size.height + 30)/2 - 5, 10, 10)];
        dotView.backgroundColor = TCUIColorFromRGB(0x747474);
        dotView.layer.masksToBounds = YES;
        dotView.layer.cornerRadius = 5;
        [view addSubview:dotView];
        
        
    }
}

-(void)setInfoModel:(MMShipmentInfoModel *)infoModel{
    _infoModel = infoModel;
    NSArray *arr = [MMShipItemModel mj_objectArrayWithKeyValuesArray:_infoModel.data];
    self.contentArr = [NSMutableArray arrayWithArray:arr];
    [self creatUI];
}

@end
