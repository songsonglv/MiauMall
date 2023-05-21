//
//  MMOrderAfterSalesVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//  订单售后页面和退款公用一个页面

#import "MMOrderAfterSalesVC.h"
#import "MMOrderSubCauseModel.h"
#import "MMOrderSubCauseModel.h"
#import "MMOrderAfterSalesReasonModel.h"
#import "BRStringPickerView.h"
#import "MMRefundMoneyPathView.h"
#import "MMRefundMoneyReasonPopView.h"
#import "MMOrderAfterTypeModel.h"
#import "MMOrderListGoodsItemModel.h"
#import "MMOrderAfterChooseGoodsPopView.h"
#import "MMOrderAfterSelectGoodsCell.h"

#define kMaxTextCount 500 //限制的500个字

@interface MMOrderAfterSalesVC ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *textNumberLabel;
}
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSString *wxAccount;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *typeArr;
@property (nonatomic, strong) NSMutableArray *reasonArr;
@property (nonatomic, strong) NSMutableArray *reasonArr1;
@property (nonatomic, copy) NSArray <NSNumber *> *linkage2SelectIndexs;
@property (nonatomic, strong) UITextField *moneyField;

@property (nonatomic, strong) UIView *tuBgView;//图片文字背景view
@property (nonatomic, strong) UITextView *textView;//输入文本
@property (nonatomic, strong) UILabel *textLa;//textView里面的占位label 提示下文字
@property (nonatomic, strong) NSString *tips;//提示文字
@property (nonatomic,strong) NSData *imageData;//将图片打包成data
@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) NSMutableArray *imageStrArr;//返回的图片地址
@property (nonatomic, strong) NSMutableArray *videoStrArr;//返回的图片地址
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *videoArr;

@property (nonatomic, strong) UITextField *typeField;//类型
@property (nonatomic, strong) UITextField *reasonField;//原因
@property (nonatomic, strong) UITextField *pathField;//路径
@property (nonatomic, strong) UIView *wxView;

@property (nonatomic, strong) UITextField *wxField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UIButton *saveBt;
@property (nonatomic, strong) NSMutableArray *pathArr;//退款路径数组

@property (nonatomic, strong) UIView *typeView;//售后退款类型 view
@property (nonatomic, strong) UIView *reasonView;
@property (nonatomic, strong) UIView *pathView;
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIView *chooseGoodsView;//选择商品view
@property (nonatomic, strong) UITableView *goodsView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *reasonTipsLa;//退款原因提示
@property (nonatomic, strong) UILabel *pathTipsLa;//退款路径提示
@property (nonatomic, strong) NSString *pathTips;

@property (nonatomic, strong) NSString *UniversalID;
@property (nonatomic, strong) NSString *WarnMsg;

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *RefundType;
@property (nonatomic, strong) NSString *isChoose;//是否需要选择商品
@property (nonatomic, strong) NSString *isUpload;//是否要上传图片
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NSMutableArray *seleGoodsArr;

@property (nonatomic, strong) MMRefundMoneyPathView *pathPopView;
@property (nonatomic, strong) MMRefundMoneyReasonPopView *reasonPopView;//原因弹窗
@property (nonatomic, strong) MMRefundMoneyReasonPopView *typePopView;//类型弹窗
@property (nonatomic, strong) MMOrderAfterChooseGoodsPopView *goodsPopView;//选择商品弹窗
@property (nonatomic, strong) MMOrderAfterTypeModel *typeModel;

@end

@implementation MMOrderAfterSalesVC


-(UIView *)typeView{
    if(!_typeView){
        _typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 66)];
        NSString *str = [UserDefaultLocationDic valueForKey:@"refundTypeName"];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab.frame = CGRectMake(13, 24, size.width + 20, 16);
        [_typeView addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(str).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
            confer.text(@"*").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        }];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 28, WIDTH - 60 - CGRectGetMaxX(lab.frame), 18)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"pleaseSelect"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x9b9b9b)}];
        field.delegate = self;
        field.enabled = NO;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0x383838);
        field.textAlignment = NSTextAlignmentRight;
        [_typeView addSubview:field];
        self.typeField = field;
        
        UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 40, 31, 6, 12)];
        rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
        [_typeView addSubview:rightIcon];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 0, WIDTH - 50 - CGRectGetMaxX(lab.frame), 66)];
        [btn addTarget:self action:@selector(SelectType) forControlEvents:(UIControlEventTouchUpInside)];
        [_typeView addSubview:btn];
        
//        UILabel *tipsLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x9b9b9b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
//        tipsLa.frame = CGRectMake(14, 66, WIDTH - 48, 0);
//        [_reasonView addSubview:tipsLa];
//        self.reasonTipsLa = tipsLa;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        [_typeView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 44);
                    make.height.mas_equalTo(0.5);
        }];
        
    }
    return _typeView;
}

-(UIView *)reasonView{
    if(!_reasonView){
        _reasonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeView.frame), WIDTH - 20, 66)];
        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"refundReason"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
        UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"refundReason"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab.frame = CGRectMake(13, 24, size.width + 20, 16);
        [_reasonView addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([UserDefaultLocationDic valueForKey:@"refundReason"]).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
            confer.text(@"*").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        }];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 28, WIDTH - 60 - CGRectGetMaxX(lab.frame), 18)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"pleaseSelect"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x9b9b9b)}];
        field.delegate = self;
        field.enabled = NO;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0x383838);
        field.textAlignment = NSTextAlignmentRight;
        [_reasonView addSubview:field];
        self.reasonField = field;
        
        UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 40, 31, 6, 12)];
        rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
        [_reasonView addSubview:rightIcon];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 0, WIDTH - 50 - CGRectGetMaxX(lab.frame), 66)];
        [btn addTarget:self action:@selector(SelectReason) forControlEvents:(UIControlEventTouchUpInside)];
        [_reasonView addSubview:btn];
        
        UILabel *tipsLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x9b9b9b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        tipsLa.frame = CGRectMake(14, 66, WIDTH - 48, 0);
        [_reasonView addSubview:tipsLa];
        self.reasonTipsLa = tipsLa;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        [_reasonView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 44);
                    make.height.mas_equalTo(0.5);
        }];
    }
    return _reasonView;
}

-(UIView *)pathView{
    if(!_pathView){
        _pathView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reasonView.frame), WIDTH - 20, 58)];
        CGSize size1 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"tklj"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
        UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"tklj"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab.frame = CGRectMake(13, 22, size1.width + 20, 16);
        [_pathView addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([UserDefaultLocationDic valueForKey:@"tklj"]).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
            confer.text(@"*").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        }];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 20, WIDTH - 60 - CGRectGetMaxX(lab.frame), 18)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"pleaseSelect"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x9b9b9b)}];
        field.delegate = self;
        field.enabled = NO;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0x383838);
        field.textAlignment = NSTextAlignmentRight;
        [_pathView addSubview:field];
        self.pathField = field;
        
        UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 40, 22, 6, 12)];
        rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
        [_pathView addSubview:rightIcon];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 0, WIDTH - 50 - CGRectGetMaxX(lab.frame),50)];
        [btn addTarget:self action:@selector(selectPath) forControlEvents:(UIControlEventTouchUpInside)];
        [_pathView addSubview:btn];
        
        CGSize size = [NSString sizeWithText:self.pathTips font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 48,MAXFLOAT)];
        UILabel *tipsLa = [UILabel publicLab:self.pathTips textColor:TCUIColorFromRGB(0x9b9b9b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        tipsLa.frame = CGRectMake(14, 58, WIDTH - 48, size.height);
        [_pathView addSubview:tipsLa];
        self.pathTipsLa = tipsLa;
        
//        NSString *star = [self.pathTips substringToIndex:1];
//        NSString *conStr = [self.pathTips substringWithRange:NSMakeRange(1, self.pathTips.length - 1)];
        [tipsLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(@"*").textColor(redColor2).font([UIFont systemFontOfSize:12]);
                    confer.text(self.pathTips).textColor(TCUIColorFromRGB(0x9b9b9b)).font([UIFont systemFontOfSize:12]);
        }];
        
        _pathView.height = 58 + size.height + 22;
        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        [_pathView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 44);
                    make.height.mas_equalTo(0.5);
        }];
    }
    return _pathView;
}

-(UIView *)moneyView{
    if(!_moneyView){
        _moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pathView.frame), WIDTH - 20, 202)];
        UILabel *lab = [UILabel publicLab:@"退款金额" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab.frame = CGRectMake(13, 22, 90, 16);
        [_moneyView addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"退款金额").textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
            confer.text(@"*").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        }];
        NSArray *temp = [[NSArray alloc]init];
        
        if(self.model){
            temp = [self.model.MoneysShow componentsSeparatedByString:@" "];
        }else{
            temp = [self.model1.MoneysShow componentsSeparatedByString:@" "];
        }
        NSString *sign = temp[0];;
        UILabel *signLa = [UILabel publicLab:sign textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        signLa.preferredMaxLayoutWidth = 100;
        [signLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_moneyView addSubview:signLa];
        
        [signLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.top.mas_equalTo(61);
                make.height.mas_equalTo(13);
        }];
        
        UITextField *field1 = [[UITextField alloc]init];
        field1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入退款金额" attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x9b9b9b)}];
        field1.delegate = self;
        field1.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:18];
        field1.textColor = redColor2;
        field1.keyboardType = UIKeyboardTypeDecimalPad;
        field1.clearButtonMode = UITextFieldViewModeWhileEditing;
        field1.textAlignment = NSTextAlignmentLeft;
        [field1 addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:(UIControlEventEditingChanged)];
        [_moneyView addSubview:field1];
        self.moneyField = field1;
        
        [field1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(signLa.mas_right).offset(2);
                make.top.mas_equalTo(58);
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(20);
        }];
        
        UIButton *editBt = [[UIButton alloc]init];
        [editBt setImage:[UIImage imageNamed:@"edit_address_iocn"] forState:(UIControlStateNormal)];
    //    [editBt addTarget:self action:@selector(clickEdit) forControlEvents:(UIControlEventTouchUpInside)];
        [_moneyView addSubview:editBt];
        
        [editBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-13);
                make.top.mas_equalTo(60);
                make.width.height.mas_equalTo(16);
        }];
        
        UILabel *tipsLa = [UILabel publicLab:[NSString stringWithFormat:@"可修改，最高可退金额%@（%@）",self.model.MoneysShow,self.model.PriceCountRMB] textColor:TCUIColorFromRGB(0x9b9b9b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        [_moneyView addSubview:tipsLa];
        
    
        
        [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(13);
                make.top.mas_equalTo(signLa.mas_bottom).offset(18);
                make.right.mas_equalTo(-14);
                make.height.mas_equalTo(13);
        }];
        
        if(self.model){
            tipsLa.text = [NSString stringWithFormat:@"可修改，最高可退金额%@（%@）",self.model.MoneysShow,self.model.PriceCountRMB];
        }else{
            tipsLa.text = [NSString stringWithFormat:@"可修改，最高可退款%@(%@)",self.model1.OtherPayShow,self.model1.PayMoneyShow];
        }
        
        //有使用优惠就显示没有就隐藏
        UIView *garyV = [[UIView alloc]initWithFrame:CGRectMake(12, 126, WIDTH - 44, 52)];
        garyV.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        garyV.layer.masksToBounds = YES;
        garyV.layer.cornerRadius = 7.5;
        [_moneyView addSubview:garyV];
        
        float discount;
        if(self.model){
            discount = [self.model.Discount floatValue];
        }else{
            discount = [self.model1.Discount floatValue];
        }
        if(discount > 0){
            garyV.hidden = NO;
            _moneyView.height = 202;
        }else{
            garyV.hidden = YES;
            _moneyView.height = 126;
        }
        
        
        
        UILabel *discountLa = [UILabel publicLab:@"满5万日元减5千日元" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        discountLa.preferredMaxLayoutWidth = 150;
        [discountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [garyV addSubview:discountLa];
        
        [discountLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.centerY.mas_equalTo(garyV);
                make.height.mas_equalTo(13);
        }];
        
//        UILabel *aboutDiscountLa = [UILabel publicLab:@"AUD4.5(约jpy1026）" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
//        aboutDiscountLa.preferredMaxLayoutWidth = 200;
//        [aboutDiscountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//        [garyV addSubview:aboutDiscountLa];
//
//        [aboutDiscountLa mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-10);
//                make.centerY.mas_equalTo(garyV);
//                make.height.mas_equalTo(13);
//        }];
        
        
        if(self.model){
            discountLa.text = self.model.DiscountShow;
        }else{
            discountLa.text = self.model1.DiscountShow;
        }
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        [_moneyView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 44);
                    make.height.mas_equalTo(0.5);
        }];
    }
    return _moneyView;
}

-(UIView *)emailView{
    if(!_emailView){
        _emailView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pathView.frame), WIDTH - 20, 58)];
//        //退款1 售后2
//        if([self.isAfter isEqualToString:@"0"]){
//            _emailView.y = CGRectGetMaxY(self.pathView.frame);
//        }else if ([self.isAfter isEqualToString:@"1"]){
//            _emailView.y = CGRectGetMaxY(self.reasonView.frame);
//        }
        
        UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"iemail"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab.frame = CGRectMake(13, 22, 90, 16);
        [_emailView addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([UserDefaultLocationDic valueForKey:@"iemail"]).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
            confer.text(@"*").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        }];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 20, WIDTH - 50 - CGRectGetMaxX(lab.frame), 18)];
        field.attributedPlaceholder = [[NSAttributedString alloc]initWithString:[UserDefaultLocationDic valueForKey:@"plzEnterEmail"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x9b9b9b)}];
        field.delegate = self;
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.textColor = TCUIColorFromRGB(0x383838);
        field.textAlignment = NSTextAlignmentRight;
        [_emailView addSubview:field];
        self.emailField = field;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
        [_emailView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(WIDTH - 44);
                    make.height.mas_equalTo(0.5);
        }];
    }
    return _emailView;
}

-(UIView *)chooseGoodsView{
    if(!_chooseGoodsView){
        _chooseGoodsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emailView.frame), WIDTH - 20, 66)];
        NSString *str = [UserDefaultLocationDic valueForKey:@"refundGoodList"];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab.frame = CGRectMake(13, 24, size.width + 20, 16);
        [_chooseGoodsView addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(str).textColor(TCUIColorFromRGB(0x383838)).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
            confer.text(@"*").textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:16]);
        }];
        
        UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 40, 31, 6, 12)];
        rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
        [_chooseGoodsView addSubview:rightIcon];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 10, 0, WIDTH - 50 - CGRectGetMaxX(lab.frame), 66)];
        [btn addTarget:self action:@selector(SelectGoods) forControlEvents:(UIControlEventTouchUpInside)];
        [_chooseGoodsView addSubview:btn];
    }
    return _chooseGoodsView;
}

-(UITableView *)goodsView{
    if (!_goodsView) {
        _goodsView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chooseGoodsView.frame), WIDTH - 20, 0) style:(UITableViewStylePlain)];
        _goodsView.backgroundColor = UIColor.clearColor;
        _goodsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsView.scrollEnabled = NO;
        _goodsView.delegate = self;
        _goodsView.dataSource = self;
        _goodsView.showsVerticalScrollIndicator = NO;
        _goodsView.showsHorizontalScrollIndicator = NO;
    }
    return _goodsView;
}

-(UIView *)bottomView{
    KweakSelf(self);
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emailView.frame), WIDTH - 20, 234)];
        UILabel *lab1 = [UILabel publicLab:@"补充描述和凭证" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
        lab1.preferredMaxLayoutWidth = WIDTH - 46;
        [_bottomView addSubview:lab1];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(13);
                    make.top.mas_equalTo(20);
                    make.height.mas_equalTo(16);
        }];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(13, 58, WIDTH - 46, 164)];
        bgView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        [_bottomView addSubview:bgView];
        self.tuBgView = bgView;
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(6, 8, WIDTH - 58, 65)];
        textView.delegate = self;
        textView.textColor = TCUIColorFromRGB(0x3c3c3c);
        textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        textView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        textView.tintColor = TCUIColorFromRGB(0x3c3c3c);
        [bgView addSubview:textView];
        self.textView = textView;
        
        UILabel *textLa = [UILabel publicLab:@"补充描述，有助于商家更好的处理售后问题" textColor:TCUIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        textLa.frame = CGRectMake(12, 14, WIDTH - 70, 13);
        [textLa sizeToFit];
        [bgView addSubview:textLa];
        self.textLa = textLa;
        
        //添加下面计数的label
        textNumberLabel = [[UILabel alloc]init];
        textNumberLabel.textAlignment = NSTextAlignmentRight;
        textNumberLabel.font = [UIFont systemFontOfSize:13];
        textNumberLabel.textColor = TCUIColorFromRGB(0xcbcbcb);
        textNumberLabel.text = [NSString stringWithFormat:@"0/%d   ",kMaxTextCount];
        [bgView addSubview:textNumberLabel];
        
        [textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(57);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(13);
        }];
        
        if(textView.text.length > 0){
            textLa.hidden = YES;
        }
        
        CGFloat wid = (WIDTH - 64)/3;
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(0,78, 261, 87) andIsEnter:@"refund"];//退款售后
        mediaView.isfeed = YES;
        mediaView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        [bgView addSubview:mediaView];
        
        //随时获取新高度
        [mediaView observeViewHeight:^(CGFloat mediaHeight) {
            mediaView.height = mediaHeight;
            bgView.height = mediaHeight + 78;
            weakself.bottomView.height = CGRectGetMaxY(bgView.frame) + 12;
            weakself.contentView.height = CGRectGetMaxY(weakself.bottomView.frame) + 20;
            weakself.scrollView.contentSize = CGSizeMake(WIDTH - 20, CGRectGetMaxY(weakself.contentView.frame) + 20);
        }];
        
        //随时获取选取的媒体文件
        [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
            NSLog(@"%@",list);
            [weakself.imageArr removeAllObjects];
            [weakself.imageStrArr removeAllObjects];
            [weakself.videoArr removeAllObjects];
            for (ACMediaModel*model in list) {
                if(model.asset.mediaType == PHAssetMediaTypeVideo){
                    if([weakself.videoArr containsObject:model.asset]){
                        
                    }else{
                        [weakself.videoArr addObject:model.asset];
                    }
                }else{
                    UIImage *image = model.image;
                    if([weakself.imageArr containsObject:image]){
                        
                    }else{
                        [weakself.imageArr addObject:image];
                    }
                }
                
            }
            dispatch_queue_t q = dispatch_queue_create("upload", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
                for (int i = 0; i < weakself.videoArr.count; i++) {
                    PHAsset *asset = weakself.videoArr[i];
                    [self getVideo:asset];
                }
                
                for (int i = 0; i < weakself.imageArr.count; i++) {
                    UIImage *image = weakself.imageArr[i];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                    [weakself requestImage:imageData];
                }
            });
           
        }];
        
    }
    return _bottomView;
}

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(NSMutableArray *)seleGoodsArr{
    if(!_seleGoodsArr){
        _seleGoodsArr = [NSMutableArray array];
    }
    return _seleGoodsArr;
}

-(NSMutableArray *)typeArr{
    if(!_typeArr){
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}

-(NSMutableArray *)pathArr{
    if(!_pathArr){
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}

-(NSMutableArray *)reasonArr{
    if(!_reasonArr){
        _reasonArr = [NSMutableArray array];
    }
    return _reasonArr;
}

-(NSMutableArray *)reasonArr1{
    if(!_reasonArr1){
        _reasonArr1 = [NSMutableArray array];
    }
    return _reasonArr1;
}

-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
-(NSMutableArray *)imageStrArr{
    if(!_imageStrArr){
        _imageStrArr = [NSMutableArray array];
    }
    return _imageStrArr;
}

-(NSMutableArray *)videoArr{
    if(!_videoArr){
        _videoArr = [NSMutableArray array];
    }
    return _videoArr;
}

-(NSMutableArray *)videoStrArr{
    if(!_videoStrArr){
        _videoStrArr = [NSMutableArray array];
    }
    return _videoStrArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"订单售后/退款页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.Email = [self.userDefaults valueForKey:@"Email"];
    self.wxAccount = [self.userDefaults valueForKey:@"WXAccount"];
    
    
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"salesService"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    if(self.model){
        self.ID = self.model.ID;
    }else{
        self.ID = self.model1.ID;
    }
    
    [self requestOrderAfterType];
    
    // Do any additional setup after loading the view.
}

-(void)requestOrderAfterType{
    //LoadSaleReson
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"LoadSaleReson"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMOrderAfterTypeModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            NSArray *paths = jsonDic[@"LuJingsList"];
            weakself.typeArr = [NSMutableArray arrayWithArray:arr];
            NSArray *arr1 = [MMOrderListGoodsItemModel mj_objectArrayWithKeyValuesArray:jsonDic[@"itemlist"]];
            weakself.goodsArr = [NSMutableArray arrayWithArray:arr1];
            
            weakself.pathTips = [NSString stringWithFormat:@"%@",jsonDic[@"LuJingTips"]];
            weakself.UniversalID = [NSString stringWithFormat:@"%@",jsonDic[@"UniversalID"]];
            weakself.WarnMsg = [NSString stringWithFormat:@"%@",jsonDic[@"WarnMsg"]];
            
            weakself.pathArr = [NSMutableArray arrayWithArray:paths];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)SelectType{
    [[UIApplication sharedApplication].keyWindow addSubview:self.typePopView];
    [self.typePopView showView];
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    
    self.pathPopView = [[MMRefundMoneyPathView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:[UserDefaultLocationDic valueForKey:@"tklj"] andDataArr:self.pathArr];
    self.pathPopView.returnPathStr = ^(NSString * _Nonnull path) {
        weakself.pathField.text = path;
    };
    
    self.goodsPopView = [[MMOrderAfterChooseGoodsPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:[UserDefaultLocationDic valueForKey:@"chooseGoods"] andDataArr:self.goodsArr andUniversalID:self.UniversalID andWarnMsg:self.WarnMsg];
    self.goodsPopView.returnGoodsBlock = ^(MMOrderListGoodsItemModel * _Nonnull model, NSString * _Nonnull isSelect) {
        if([isSelect isEqualToString:@"1"]){
            [weakself.seleGoodsArr addObject:model];
        }else{
            [weakself.seleGoodsArr removeObject:model];
        }
        
        [weakself setGoodsView];
    };
    
    self.typePopView = [[MMRefundMoneyReasonPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:[UserDefaultLocationDic valueForKey:@"refundTypeName"] andDataArr:self.typeArr andType:@"1"];
    self.typePopView.returnReasonArrBlock = ^(MMOrderAfterTypeModel * _Nonnull model, NSArray * _Nonnull reasonArr) {
        weakself.typeModel = model;
        weakself.goodsPopView.isClear = @"1";
        weakself.goodsView.height = 0;
        weakself.goodsPopView.typeModel = model;
        weakself.isUpload = model.IsUpload;
        weakself.isChoose = model.IsChoose;
        weakself.RefundType = model.SelectIndex;
        [weakself.reasonArr1 removeAllObjects];
        weakself.reasonArr1 = [NSMutableArray arrayWithArray:reasonArr];
        weakself.typeField.text = model.Name;
        weakself.reasonField.text = @"";
        weakself.reasonTipsLa.text = @"";
        weakself.reasonTipsLa.frame = CGRectMake(14, 58, WIDTH - 48, 0);
        weakself.reasonView.height = 66;
        weakself.pathView.y = CGRectGetMaxY(weakself.reasonView.frame);
        weakself.emailView.y = CGRectGetMaxY(weakself.pathView.frame);
        if([model.IsChoose isEqualToString:@"1"]){
            [weakself.contentView addSubview:weakself.chooseGoodsView];
            [weakself.contentView addSubview:weakself.goodsView];
            weakself.chooseGoodsView.hidden = NO;
            weakself.goodsView.hidden = NO;
            weakself.chooseGoodsView.y = CGRectGetMaxY(weakself.emailView.frame);
            weakself.goodsView.y = CGRectGetMaxY(weakself.chooseGoodsView.frame);
            weakself.bottomView.y = CGRectGetMaxY(weakself.goodsView.frame);
            weakself.contentView.height = CGRectGetMaxY(weakself.bottomView.frame) + 20;
            weakself.scrollView.contentSize = CGSizeMake(WIDTH - 20, CGRectGetMaxY(weakself.contentView.frame) + 20);
        }else{
            
            weakself.chooseGoodsView.hidden = YES;
            weakself.goodsView.hidden = YES;
            weakself.bottomView.y = CGRectGetMaxY(weakself.emailView.frame);
            weakself.contentView.height = CGRectGetMaxY(weakself.bottomView.frame) + 20;
            weakself.scrollView.contentSize = CGSizeMake(WIDTH - 20, CGRectGetMaxY(weakself.contentView.frame) + 20);
        }
        
       
        
        weakself.reasonPopView = [[MMRefundMoneyReasonPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andTitle:[UserDefaultLocationDic valueForKey:@"refundReason"] andDataArr:weakself.reasonArr1 andType:@"0"];
        weakself.reasonPopView.returnReasonStr = ^(NSString * _Nonnull reason, NSString * _Nonnull tips) {
            weakself.reasonField.text = reason;
            CGSize size = [NSString sizeWithText:tips font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 48,MAXFLOAT)];
            weakself.reasonTipsLa.text = [NSString stringWithFormat:@"*%@",tips];
            weakself.reasonTipsLa.frame = CGRectMake(14, 58, WIDTH - 48, size.height);
            weakself.reasonView.height = 66 + size.height + 20;
            weakself.pathView.y = CGRectGetMaxY(weakself.reasonView.frame);
            weakself.emailView.y = CGRectGetMaxY(weakself.pathView.frame);
            if([weakself.isChoose isEqualToString:@"1"]){
                weakself.chooseGoodsView.y = CGRectGetMaxY(weakself.emailView.frame);
                weakself.goodsView.y = CGRectGetMaxY(weakself.chooseGoodsView.frame);
                [weakself setGoodsView];
            }else{
                weakself.bottomView.y = CGRectGetMaxY(weakself.emailView.frame);
                weakself.contentView.height = CGRectGetMaxY(weakself.bottomView.frame) + 20;
                weakself.scrollView.contentSize = CGSizeMake(WIDTH - 20, CGRectGetMaxY(weakself.contentView.frame) + 20);
            }
           
            
        };
    };
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 64, WIDTH, HEIGHT - StatusBarHeight - 64 - 72)];
    scrollView.contentSize = CGSizeMake(WIDTH, 300);
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *contV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 20, 300)];
    contV.backgroundColor = UIColor.whiteColor;
    contV.layer.masksToBounds = YES;
    contV.layer.cornerRadius = 7.5;
    [scrollView addSubview:contV];
    self.contentView = contV;
    
    [contV addSubview:self.typeView];
    [contV addSubview:self.reasonView];
    [contV addSubview:self.pathView];
    [contV addSubview:self.emailView];
    [contV addSubview:self.bottomView];
    contV.height = CGRectGetMaxY(self.bottomView.frame) + 20;
    self.scrollView.contentSize = CGSizeMake(WIDTH - 20, CGRectGetMaxY(contV.frame) + 20);
    
    UIView *saveV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 72, WIDTH, 72)];
    saveV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:saveV];
    
    UIButton *saveBt = [[UIButton alloc]initWithFrame:CGRectMake(17,12, WIDTH - 34, 42)];
    saveBt.timeInterval = 2;
    [saveBt setBackgroundColor:redColor2];
    [saveBt setTitle:[UserDefaultLocationDic valueForKey:@"isubmit"] forState:(UIControlStateNormal)];
    [saveBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    saveBt.layer.masksToBounds = YES;
    saveBt.layer.cornerRadius = 21;
    saveBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [saveBt addTarget:self action:@selector(clickSave) forControlEvents:(UIControlEventTouchUpInside)];
    self.saveBt = saveBt;
    [saveV addSubview:saveBt];
   
}

-(void)setGoodsView{
    if([self.goodsView subviews].count > 0){
        [[[self.goodsView subviews] objectAtIndex:0] removeFromSuperview];
    }
   
    self.goodsView.height = 110 * self.seleGoodsArr.count;
    self.goodsView.hidden = NO;
    
    [self.goodsView reloadData];
 
    self.bottomView.y = CGRectGetMaxY(self.goodsView.frame);
    self.contentView.height = CGRectGetMaxY(self.bottomView.frame) + 20;
    self.scrollView.contentSize = CGSizeMake(WIDTH - 20, CGRectGetMaxY(self.contentView.frame) + 20);
}

-(void)clickEdit{
    [ZTProgressHUD showMessage:@"在哪编辑啊"];
}

//根据asset获取video
-(void)getVideo :(PHAsset *)asset{
    KweakSelf(self);
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
//    options.isNetworkAccessAllowed = YES;
    options.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if([asset isKindOfClass:[AVURLAsset class]]){
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSNumber *size;
            [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
            NSData *videoData = [NSData dataWithContentsOfURL:urlAsset.URL];
            [weakself requestVideo:videoData];
        }
        }];
}
//上传视频
-(void)requestVideo:(NSData *)videoData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",BaseUrl,@"MemUploadVideo"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:videoData forKey:@"file"];
    
    [ZTNetworking FormVideoDataPostRequestUrl:url RequestPatams:param RequestData:videoData ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"][@"Video"]];
            [weakself.videoStrArr addObject:key];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


//上传图片
-(void)requestImage:(NSData *)imageData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",BaseUrl,@"MemPicUpload"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:imageData forKey:@"file"];
    [ZTNetworking FormImageDataPostRequestUrl:url RequestPatams:param RequestData:imageData ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            [weakself.imageStrArr addObject:key];
            if(weakself.imageStrArr.count == weakself.imageArr.count){
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            }
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSave{
    KweakSelf(self);
    BOOL isRight = [ZTBSUtils checkEmail:self.emailField.text];
    
    if(self.typeField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"plzChoooseRefundTypeFirst"]];
    }else if(self.reasonField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputYuanying"]];
    }else if (self.pathField.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"plzChoooseRefundLuJing"]];
    }else if (self.textView.text.length == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"addShenqing"]];
    }else if (isRight == NO){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"inputConMail"]];
    }else if ([self.isChoose isEqualToString:@"1"] && self.seleGoodsArr.count == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"plzChooseGoods"]];
    }else if ([self.isUpload isEqualToString:@"1"] && self.imageStrArr.count == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleaseUpPic"]];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"BuyerRefundMoneyNew"];

        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
        
        
        if([self.isChoose isEqualToString:@"1"]){
            NSMutableArray *arr = [NSMutableArray array];
            for (MMOrderListGoodsItemModel *model in self.seleGoodsArr) {
                [arr addObject:model.ID];
            }
            NSString *ProList = [arr componentsJoinedByString:@","];
            [param setValue:ProList forKey:@"ProList"];
        }
        
        if([self.isUpload isEqualToString:@"1"]){
            if(self.imageStrArr.count > 0){
                NSString *Albums = [self.imageStrArr componentsJoinedByString:@","];
                [param setValue:Albums forKey:@"Albums"];
            }
            
            if(self.videoStrArr.count > 0){
                NSString *Video = [self gs_jsonStringCompactFormatForNSArray:self.videoStrArr];
                [param setValue:Video forKey:@"Video"];
            }

        }
        [param setValue:self.RefundType forKey:@"RefundType"];
        NSString *RefundReason = [NSString stringWithFormat:@"%@%@",self.reasonField.text,self.textView.text];
        
        [param setValue:RefundReason forKey:@"RefundReason"];
        if(self.model){
            [param setValue:self.model.ID forKey:@"id"]; //订单ID
        }else{
            [param setValue:self.model1.ID forKey:@"id"]; //订单ID
        }
        
        
        [param setValue:self.pathField.text forKey:@"LuJing"];
        [param setValue:self.emailField.text forKey:@"Email"];
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refundSuccess" object:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

-(void)SelectGoods{
    //选择商品
    [[UIApplication sharedApplication].keyWindow addSubview:self.goodsPopView];
    [self.goodsPopView showView];
}


//选择原因
-(void)SelectReason{
    if(self.reasonArr1.count > 0){
        [[UIApplication sharedApplication].keyWindow addSubview:self.reasonPopView];
        [self.reasonPopView showView];
    }else{
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"plzChoooseRefundType"]];
    }
    
//    NSString *refundMoney;
//    if(self.model1){
//        if([self.model1.CanRefundMoney isEqualToString:@"1"]){
//            refundMoney = @"1";
//        }else{
//            refundMoney = @"0";
//        }
//    }else{
//        if([self.model.CanRefundMoney isEqualToString:@"1"]){
//            refundMoney = @"1";
//        }else{
//            refundMoney = @"0";
//        }
//    }
//
//    if([refundMoney isEqualToString:@"0"]){
//        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
//        stringPickerView.pickerMode = BRStringPickerComponentLinkage;
//        stringPickerView.dataSourceArr = [self getStagesDataSource];
//
//    //    stringPickerView.title = @"请选择原因";
//        stringPickerView.selectIndexs = self.linkage2SelectIndexs;
//        stringPickerView.numberOfComponents = 2;
//        stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
//            // 1.选择的索引
//            NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
//            // 2.选择的值
//            NSString *selectValue = @"";
//            for (BRResultModel *model in resultModelArr) {
//                [selectIndexs addObject:@(model.index)];
//                if([selectValue isEqualToString:@""]){
//                    selectValue = [NSString stringWithFormat:@"%@", model.value];
//                }else{
//                    selectValue = [NSString stringWithFormat:@"%@-%@", selectValue,model.value];
//                }
//
//            }
//            if ([selectValue hasPrefix:@" "]) {
//                selectValue = [selectValue substringFromIndex:1];
//            }
//            self.linkage2SelectIndexs = selectIndexs;
//            self.reasonField.text = selectValue;
//        };
//
//        // 设置选择器中间选中行的样式
//        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
//        customStyle.selectRowTextFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
//        customStyle.selectRowTextColor = TCUIColorFromRGB(0x000000);
//        stringPickerView.pickerStyle = customStyle;
//        stringPickerView.pickerStyle.pickerColor = TCUIColorFromRGB(0xffffff);
//        stringPickerView.pickerStyle.pickerTextFont = [UIFont fontWithName:@"PingfangSC-Regular" size:14];
//        stringPickerView.pickerStyle.pickerTextColor = TCUIColorFromRGB(0x878787);
//        stringPickerView.pickerStyle.titleBarColor = TCUIColorFromRGB(0xffffff);
//        stringPickerView.pickerStyle.selectRowColor = TCUIColorFromRGB(0xf3f4f4);
//        stringPickerView.pickerStyle.doneTextColor = TCUIColorFromRGB(0x000000);
//        stringPickerView.pickerStyle.cancelTextColor = TCUIColorFromRGB(0x000000);
//        stringPickerView.pickerStyle.hiddenTitleLine = YES;
//        stringPickerView.pickerStyle.clearPickerNewStyle = NO;
//        [stringPickerView show];
//    }else{
//        [[UIApplication sharedApplication].keyWindow addSubview:self.reasonPopView];
//        [self.reasonPopView showView];
//    }
    
}
//改的数据格式 传入数据源
- (NSArray <BRResultModel *>*)getStagesDataSource {
    // 获取网络数据源
    
    NSMutableArray *listModelArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in self.reasonArr) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = @"-1";
        model.parentValue = @"";
        model.key = dic[@"StageID"];
        model.value = dic[@"Name"];
        [listModelArr addObject:model];
        
        for (NSDictionary *param in dic[@"GetGradeInfoDto"]) {
            BRResultModel *model1 = [[BRResultModel alloc]init];
            model1.parentKey = param[@"StageID"];
            model1.parentValue = dic[@"Name"];
            model1.key = param[@"GradeID"];
            model1.value = param[@"Name"];
            [listModelArr addObject:model1];
        }
    }
    return [listModelArr copy];
}

//选择路径、
-(void)selectPath{
    [[UIApplication sharedApplication].keyWindow addSubview:self.pathPopView];
    [self.pathPopView showView];
}

#pragma mark -- uitextfielddelegate
- (void)textFieldEditChanged:(UITextField *)textField
{
    float maxMoney;
    if(self.model){
        maxMoney = [self.model.PayMoney floatValue];
    }else{
        maxMoney = [self.model1.PayMoney floatValue];
    }
    float money;
    money = [textField.text floatValue];
    
    if(money > maxMoney){
        [ZTProgressHUD showMessage:@"退款金额不可超过最大退款金额"];
        textField.text = [NSString stringWithFormat:@"%.2f",maxMoney];
    }
}

#pragma mark -- uitextviewdelegate
//判断开始输入
-(void)textViewDidChange:(UITextView *)textView
{
    
    if(textView.text.length > 0){
        self.textLa.hidden = YES;
    }else{
        self.textLa.hidden = NO;
    }
    
    textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)textView.text.length,kMaxTextCount];
    if(textView.text.length >= kMaxTextCount){
        //截取字符串
        textView.text = [textView.text substringToIndex:500];
        textNumberLabel.text = @"500/500";
    }else{
        
    }
}

#pragma mark -- uitabelviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.seleGoodsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMOrderAfterSelectGoodsCell*cell = [[MMOrderAfterSelectGoodsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.seleGoodsArr.count > 0) {
        cell.model = self.seleGoodsArr[indexPath.row];
    }
    return cell;
}

#pragma mark -- 数组转json字符串

//将数组转换成json格式字符串,不含 这些符号

-(NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson {
    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    strJson = [strJson stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //iOS9.0（包括9.0）以上使用
//    NSString *encodeUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

   
    return strJson;
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"订单售后/退款页面"];
}

@end
