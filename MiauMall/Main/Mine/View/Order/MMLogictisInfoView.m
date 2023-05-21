//
//  MMLogictisInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//

#import "MMLogictisInfoView.h"
@interface MMLogictisInfoView ()
@property (nonatomic, strong) UILabel *companyLa;
@property (nonatomic, strong) UILabel *orderNoLa;
@property (nonatomic, strong) UILabel *addressLa;
@property (nonatomic, strong) UILabel *linkLa;
@property (nonatomic, strong) UILabel *phoneLa;
@end

@implementation MMLogictisInfoView

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
    NSArray *arr = @[@"物流公司",@"订单编号",@"收货地址",@"物流查询",@"物流电话"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 15 + 28 * i, WIDTH - 20, 28)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab.frame = CGRectMake(12, 7, 80, 14);
//        lab.centerY = view.centerY;
        [view addSubview:lab];
        
        UILabel *contentLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        contentLa.preferredMaxLayoutWidth = WIDTH - 144;
        [contentLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:contentLa];
        
        [contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(112);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(WIDTH - 144);
        }];
        
        if(i == 0){
            self.companyLa = contentLa;
        }else if (i == 1){
            self.orderNoLa = contentLa;
//            [contentLa mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(112);
//                make.centerY.mas_equalTo(view);
//                make.width.mas_equalTo(WIDTH - 204);
//            }];
            
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
            
            [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-13);
                        make.centerY.mas_equalTo(view);
                        make.width.mas_equalTo(34);
                        make.height.mas_equalTo(15);
            }];
        }else if (i == 2){
            self.addressLa = contentLa;
        }else if (i == 3){
            self.linkLa = contentLa;
        }else{
            self.phoneLa = contentLa;
            contentLa.textColor = redColor2;
        }
    }
}

-(void)setModel:(MMOrderLogisticsInfoModel *)model{
    KweakSelf(self);
    _model = model;
    NSString *str = [_model.ExpressCompany stringByReplacingOccurrencesOfString:@"--电话" withString:@""];
    NSArray *arr = [str componentsSeparatedByString:@"："];
    self.companyLa.text = arr[0];
    self.phoneLa.text = arr[1];
    self.orderNoLa.text = _model.ExpressNumber;
    self.linkLa.text = _model.ExpressLink;
    self.addressLa.text = _model.Address;
    CGSize  lableSize = [self.addressLa sizeThatFits:CGSizeMake(WIDTH - 144, MAXFLOAT)];
    //每行文字的高度
    CGFloat lineHeight = self.addressLa.font.lineHeight;
    //    float rate1 = tipLable2.frame.size.width / lableSize.width;
    float rate2 = self.addressLa.frame.size.height / lableSize.height;
    //lable高度比要显示的文字所需的高度小，改变文字的字体大小来适应lable
    if ( rate2 < 1 ){
        self.addressLa.font = [UIFont systemFontOfSize:11.0];
    }
    
    [self.linkLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(self->_model.ExpressLink).textColor(TCUIColorFromRGB(0x07beaf)).font([UIFont fontWithName:@"PingFangSC-Regular" size:14]).tapActionByLable(@"1");
    }];
    [self.linkLa rz_tapAction:^(UILabel * _Nonnull label, NSString * _Nonnull tapActionId, NSRange range) {
        if([tapActionId isEqualToString:@"1"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self->_model.ExpressLink]];
        }
    }];
    
    [self.phoneLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(_model.ExpressPhone).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:14]).tapActionByLable(@"1");
    }];
    
    [self.phoneLa rz_tapAction:^(UILabel * _Nonnull label, NSString * _Nonnull tapActionId, NSRange range) {
        NSString *phoneNumber = weakself.model.ExpressPhone;
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", phoneNumber];
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:str];
        if (@available(iOS 10.0, *)) {
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                // OpenSuccess=选择 呼叫 为 1  选择 取消 为0
                NSLog(@"OpenSuccess=%d",success);
            }];
        }
        else {
        // Fallback on earlier versions
        }
    }];
}

-(void)clickCopyNo{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.ExpressNumber;
    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
}


@end
