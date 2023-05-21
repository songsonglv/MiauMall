//
//  MMOrderDetailInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import "MMOrderDetailInfoView.h"
@interface MMOrderDetailInfoView ()
@property (nonatomic, strong) UILabel *orderNoLa;
@property (nonatomic, strong) UILabel *businessModeLa;
@property (nonatomic, strong) UILabel *payMethodLa;
@property (nonatomic, strong) UILabel *addTimeLa;
@property (nonatomic, strong) UILabel *orderStateLa;//订单状态
@end

@implementation MMOrderDetailInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return self;
}

-(void)setUI{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, WIDTH - 44, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    [self addSubview:line];
    
    NSArray *arr;
    if([self.model.PayStatus isEqualToString:@"1"]){
        arr = @[[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"orderNumber"]],[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"imethod"]],[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"playFanshi"]],[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"orderTime"]],[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"orderStatw"]]];
    }else{
        arr = @[[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"orderNumber"]],[NSString stringWithFormat:@"%@：",[UserDefaultLocationDic valueForKey:@"orderTime"]],[UserDefaultLocationDic valueForKey:@"orderStatw"]];
    }
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 25 + 25 * i, WIDTH - 20, 25)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 180;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(14);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *conLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        conLa.preferredMaxLayoutWidth = 200;
        [conLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:conLa];
        
        [conLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab.mas_right).offset(5);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UIButton *copyBt = [[UIButton alloc]init];
        [copyBt setTitle:[UserDefaultLocationDic valueForKey:@"fzCopy"] forState:(UIControlStateNormal)];
        [copyBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        copyBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        copyBt.layer.masksToBounds = YES;
        copyBt.layer.cornerRadius = 2.5;
        copyBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
        copyBt.layer.borderWidth = 0.5;
        [copyBt addTarget:self action:@selector(clickCopyNo) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:copyBt];
        copyBt.hidden = YES;
        
        [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(34);
                    make.height.mas_equalTo(17);
        }];
        
        
        
        if([self.model.PayStatus isEqualToString:@"1"]){
            if(i == 0){
                self.orderNoLa = conLa;
                copyBt.hidden = NO;
            }else if (i == 1){
                self.businessModeLa = conLa;
            }else if (i == 2){
                self.payMethodLa = conLa;
            }else if (i == 3){
                self.addTimeLa = conLa;
            }else{
                conLa.textColor = redColor2;
                self.orderStateLa = conLa;
            }
        }else{
            if(i == 0){
                self.orderNoLa = conLa;
                copyBt.hidden = NO;
            }else if (i == 1){
                self.addTimeLa = conLa;
            }else if (i == 2){
                self.orderStateLa = conLa;
                conLa.textColor = redColor2;
            }
        }
    }
    
    self.orderNoLa.text = self.model.OrderNumber;
    self.businessModeLa.text = self.model.Transactions;
    self.payMethodLa.text = self.model.Payment;
    self.addTimeLa.text = self.model.AddTime;
    self.orderStateLa.text = self.model._Processing;
    
}

-(void)clickCopyNo{
    self.tapCopyBlock(self.model.OrderNumber);
}


-(void)setModel:(MMOrderDetailInfoModel *)model{
    _model = model;
    [self setUI];
}
@end
