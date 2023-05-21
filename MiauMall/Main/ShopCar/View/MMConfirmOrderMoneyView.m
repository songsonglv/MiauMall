//
//  MMConfirmOrderMoneyView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/20.
//

#import "MMConfirmOrderMoneyView.h"
@interface MMConfirmOrderMoneyView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *myIntegralLa;//我的积分
@property (nonatomic, strong) UILabel *goodsMoneyLa;
@property (nonatomic, strong) UILabel *feeMoneyLa;
@property (nonatomic, strong) UILabel *discoundCodeLa;
@property (nonatomic, strong) UILabel *couponLa;
@property (nonatomic, strong) UILabel *integralLa;
@property (nonatomic, strong) UILabel *giftLa;//赠言
@property (nonatomic, strong) NSString *type; //0 没有赠言 1 有赠言
@property (nonatomic, strong) UITextField *discoundCodeField;//折扣码输入
@property (nonatomic, strong) UILabel *selectLa;//选择优惠券label
@property (nonatomic, strong) UILabel *selectInLa;//选择蜜豆la
@end

@implementation MMConfirmOrderMoneyView

-(instancetype)initWithFrame:(CGRect)frame andType:(nonnull NSString *)type{
    if(self = [super initWithFrame:frame]){
        self.type = type;
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    NSArray *arr;
    if([self.type isEqualToString:@"0"]){
        arr = @[[UserDefaultLocationDic valueForKey:@"proAmount"],[UserDefaultLocationDic valueForKey:@"proFreight"],[UserDefaultLocationDic valueForKey:@"idiscount"],[UserDefaultLocationDic valueForKey:@"icoupon"],[UserDefaultLocationDic valueForKey:@"midou"]];
    }else{
        arr = @[[UserDefaultLocationDic valueForKey:@"proAmount"],[UserDefaultLocationDic valueForKey:@"proFreight"],[UserDefaultLocationDic valueForKey:@"idiscount"],[UserDefaultLocationDic valueForKey:@"icoupon"],[UserDefaultLocationDic valueForKey:@"midou"],[UserDefaultLocationDic valueForKey:@"giftWord"]];
    }
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 12 + 30 * i, WIDTH - 10, 30)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 200;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *conLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        conLa.preferredMaxLayoutWidth = 200;
        [conLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:conLa];
        
        [conLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.centerY.mas_equalTo(view);
            make.height.mas_equalTo(12);
        }];
        
        if(i != 0 && i != 1){
            UIImageView *rightIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon_gary"]];
            [view addSubview:rightIcon];
            
            [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(-12);
                            make.centerY.mas_equalTo(view);
                            make.width.mas_equalTo(4);
                            make.height.mas_equalTo(8);
            }];
            
            [conLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(rightIcon.mas_left).offset(-8);
                make.centerY.mas_equalTo(view);
                make.height.mas_equalTo(12);
            }];
            
            conLa.textColor = redColor2;
            
            
              
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 10, 30)];
            btn.backgroundColor = UIColor.clearColor;
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            if(i == 2){
                btn.frame = CGRectMake(WIDTH - 150, 0, 150, 30);
            }
            
        }
        
        if(i == 0){
            self.goodsMoneyLa = conLa;
        }else if (i == 1){
            self.feeMoneyLa = conLa;
        }else if (i == 2){
            self.discoundCodeLa = conLa;
            UITextField *field = [[UITextField alloc]init];
            field.borderStyle = UITextBorderStyleNone;
            field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"pleCode"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xa9a9a9)}];
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
            field.textColor = redColor2;
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [view addSubview:field];
            self.discoundCodeField = field;
            
            [field mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lab.mas_right).offset(8);
                            make.centerY.mas_equalTo(view);
                            make.width.mas_equalTo(120);
                            make.height.mas_equalTo(16);
            }];
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = TCUIColorFromRGB(0x1e1e1e);
            [view addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lab.mas_right).offset(8);
                            make.top.mas_equalTo(field.mas_bottom).offset(0);
                            make.width.mas_equalTo(120);
                            make.height.mas_equalTo(0.5);
            }];
            
        }else if (i == 3){
            self.couponLa = conLa;
            UILabel *copLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
            copLa.preferredMaxLayoutWidth = 150;
            [copLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view addSubview:copLa];
            self.selectLa = copLa;
            
            [copLa mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lab.mas_right).offset(8);
                            make.centerY.mas_equalTo(view);
                            make.height.mas_equalTo(10);
            }];
        }else if (i == 4){
            self.integralLa = conLa;
            self.myIntegralLa = lab;
            UILabel *copLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa9a9a9) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
            copLa.preferredMaxLayoutWidth = 150;
            [copLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [view addSubview:copLa];
            self.selectInLa = copLa;
            
            [copLa mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lab.mas_right).offset(8);
                            make.centerY.mas_equalTo(view);
                            make.height.mas_equalTo(11);
            }];
        }
        
        if([self.type isEqualToString:@"1"]){
            if(i == 5){
                self.giftLa = conLa;
                conLa.textColor = redColor2;
            }
        }
        
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + 30 * arr.count + 16, WIDTH - 34, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xeeeeee);
    [self addSubview:line];
    
    UILabel *tipsLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"noteCouponOrDiscountCode"] textColor:TCUIColorFromRGB(0xa5844d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    tipsLa.preferredMaxLayoutWidth = WIDTH - 34;
    [tipsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:tipsLa];
    
    [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(CGRectGetMaxY(line.frame) + 32);
            make.width.mas_equalTo(WIDTH - 34);
    }];
    
}

-(void)setModel:(MMConfirmOrderModel *)model{
    _model = model;
    
    self.myIntegralLa.text = [NSString stringWithFormat:@"%@（%@%@%@）",[UserDefaultLocationDic valueForKey:@"midou"],[UserDefaultLocationDic valueForKey:@"ioverall"],_model.MyIntegral,[UserDefaultLocationDic valueForKey:@"ige"]];
    
    NSArray *temp=[_model.ItemMoneyShow componentsSeparatedByString:@" "];
    [self.goodsMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(temp[0]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:10]);
        confer.text(temp[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
    }];
    
    NSArray *temp1=[_model.FreightShow componentsSeparatedByString:@" "];
    [self.feeMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(temp1[0]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:10]);
        confer.text(temp1[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
    }];
    
    NSArray *temp2=[_model.DiscountMoneysShow componentsSeparatedByString:@" "];
    [self.discoundCodeLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(temp2[0]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:10]);
        confer.text(temp2[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
    }];
    
    NSArray *temp3=[_model.DiscountShow componentsSeparatedByString:@" "];
    [self.couponLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(temp3[0]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:10]);
        confer.text(temp3[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
    }];
    
    NSArray *temp4=[_model.IntegMoneysShow componentsSeparatedByString:@" "];
    [self.integralLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(temp4[0]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:10]);
        confer.text(temp4[1]).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
    }];
    
    self.selectLa.text = _model.CouponName;
    
    if([_model.UseInteg isEqualToString:@"0"]){
        self.selectInLa.hidden = YES;
    }else{
        self.selectInLa.hidden = NO;
        self.selectInLa.text = [NSString stringWithFormat:@"已选择%@个积分",_model.UseInteg];
    }
    
    self.giftLa.text = @"0";
    
}

-(void)setDateModel:(MMConfirmShipDateModel *)dateModel{
    _dateModel = dateModel;
    self.discoundCodeField.text = _dateModel.DiscountCode;
}

#pragma mark -- uitextfielddelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.inputDiscoundCodeBlock(textField.text);
}


-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 103){
        self.selectCouponBlock(@"1");
    }else if (sender.tag == 104){
        self.selectInteBlock(@"1");
    }else if(sender.tag == 105){
        self.selecGiftBlock(@"1");
    }else if (sender.tag == 102){
        self.inputDiscoundCodeBlock(self.discoundCodeField.text);
    }
}

@end
