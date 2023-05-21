//
//  MMPartnerOrderDataView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/29.
//

#import "MMPartnerOrderDataView.h"

@interface MMPartnerOrderDataView ()

@property (nonatomic, strong) UILabel *memberNumLa;
@property (nonatomic, strong) UILabel *shouhouLa;
@property (nonatomic, strong) UILabel *daiLa;

@end
@implementation MMPartnerOrderDataView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}


-(void)setUI{
    self.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    
    
    UIView *dataView = [[UIView alloc]initWithFrame:CGRectMake(0,0, WIDTH - 20, 100)];
    dataView.backgroundColor = TCUIColorFromRGB(0xffffff);
    dataView.layer.masksToBounds = YES;
    dataView.layer.cornerRadius = 7.5;
    [self addSubview:dataView];
    
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"totalMember"],[UserDefaultLocationDic valueForKey:@"partnerAfterOrder"],[UserDefaultLocationDic valueForKey:@"unshipedOrder"]];
    CGFloat wid = (WIDTH - 20)/arr.count;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 0, wid, 100)];
        [dataView addSubview:view];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
        [view addSubview:numLa];
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(22);
                    make.height.mas_equalTo(19);
        }];
        
        UILabel *textLa = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x464342) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        textLa.preferredMaxLayoutWidth = wid;
        [textLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:textLa];
        
        [textLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(numLa.mas_bottom).offset(21);
                    make.width.mas_equalTo(wid);
        }];
        
        if(i == 0){
            self.memberNumLa = numLa;
        }else if (i == 1){
            self.shouhouLa = numLa;
        }else{
            self.daiLa = numLa;
        }
    }
}

-(void)setModel:(MMPartnerDataModel *)model{
    _model = model;
    self.memberNumLa.text = _model.TeamNum;
    self.shouhouLa.text = _model.shouhou;
    self.daiLa.text = _model.daifahuo;
}



@end
