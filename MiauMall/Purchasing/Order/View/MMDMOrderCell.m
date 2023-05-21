//
//  MMDMOrderCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/5.
//

#import "MMDMOrderCell.h"
#import "MMDMOrderGoodsModel.h"

@interface MMDMOrderCell ()
@property (nonatomic, strong) UIView *conV;
@property (nonatomic, strong) UILabel *stateLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *orderNoLa;
@property (nonatomic, strong) UIButton *cancleBt;//取消
@property (nonatomic, strong) UIButton *firstPayBt;//首次支付
@property (nonatomic, strong) UIButton *photoBt;//拍照
@property (nonatomic, strong) UIButton *refundMoneyBt;//退款 改为删除
@property (nonatomic, strong) UIButton *assessBt;//评价
@property (nonatomic, strong) UIButton *lastPayBt;//最后支付
@property (nonatomic, strong) UIButton *resultBt;//结果按钮
@property (nonatomic, strong) UIButton *expressBt;//物流
@property (nonatomic, strong) UIButton *kefuBt;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, strong) UIView *goodsView;
@end

@implementation MMDMOrderCell
//116

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIView *contView = [[UIView alloc]init];
    contView.backgroundColor = TCUIColorFromRGB(0xffffff);
    contView.layer.masksToBounds = YES;
    contView.layer.cornerRadius = 7.5;
    [self.contentView addSubview:contView];
    self.conV = contView;
    
    [contView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(WIDTH - 20);
            make.bottom.mas_equalTo(0);
    }];
    
    UILabel *lab1 = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 130;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contView addSubview:lab1];
    self.stateLa = lab1;
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(14);
            make.height.mas_equalTo(13);
    }];
   
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x747474) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    timeLa.frame = CGRectMake(11, 40, WIDTH - 42, 10);
    [contView addSubview:timeLa];
    self.timeLa = timeLa;
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"fzCopy"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    UIButton *copyBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 20 - size.width - 16, 12, size.width + 8, 16)];
    [copyBt setTitle:[UserDefaultLocationDic valueForKey:@"fzCopy"] forState:(UIControlStateNormal)];
    [copyBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    copyBt.titleLabel.font = [UIFont systemFontOfSize:12];
    copyBt.layer.masksToBounds = YES;
    copyBt.layer.cornerRadius = 2.5;
    copyBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
    copyBt.layer.borderWidth = 0.5;
    [copyBt addTarget:self action:@selector(clickCopy) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:copyBt];
    
    UILabel *orderNoLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    orderNoLa.preferredMaxLayoutWidth = 200;
    [orderNoLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contView addSubview:orderNoLa];
    self.orderNoLa = orderNoLa;
    
    [orderNoLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-44);
            make.top.mas_equalTo(14);
            make.height.mas_equalTo(12);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 65, WIDTH - 30, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
    [contView addSubview:line];
    
    UIView *goodsV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 7, WIDTH - 20, 10)];
    [contView addSubview:goodsV];
    self.goodsView = goodsV;
    
    float wid = (WIDTH - 40)/4;
    
    NSString *str1 = @"选择物流";
    CGSize size1 = [NSString sizeWithText:str1 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *lastPayBt = [[UIButton alloc]init];
                           //WithFrame:CGRectMake(WIDTH - 30, contView.height - 56, size1.width + 26, 30)];
    [lastPayBt setBackgroundColor:redColor3];
    [lastPayBt setTitle:str1 forState:(UIControlStateNormal)];
    [lastPayBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    lastPayBt.titleLabel.font = [UIFont systemFontOfSize:14];
    lastPayBt.titleLabel.numberOfLines = 0;
    lastPayBt.layer.masksToBounds = YES;
    lastPayBt.layer.cornerRadius = 15;
    lastPayBt.hidden = YES;
    [lastPayBt addTarget:self action:@selector(clickLastPay) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:lastPayBt];
    self.lastPayBt = lastPayBt;
    
    [lastPayBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str2 = @"支付订单";
    CGSize size2 = [NSString sizeWithText:str2 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *payOrderBt = [[UIButton alloc]init];
    [payOrderBt setBackgroundColor:redColor3];
    [payOrderBt setTitle:str2 forState:(UIControlStateNormal)];
    [payOrderBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    payOrderBt.titleLabel.font = [UIFont systemFontOfSize:14];
    payOrderBt.titleLabel.numberOfLines = 0;
    payOrderBt.layer.masksToBounds = YES;
    payOrderBt.layer.cornerRadius = 15;
    payOrderBt.hidden = YES;
    [payOrderBt addTarget:self action:@selector(clickPayOrder) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:payOrderBt];
    self.firstPayBt = payOrderBt;
    
    // 前一个控件的左边缘约束
//    MASConstraintMaker *lastLeftConstraint1 = [lastPayBt mas_left];
//
//    // 当前控件的右边缘约束
//    MASConstraintMaker *currentRightConstraint1 = [payOrderBt mas_right];

    // 将当前控件的左边缘约束与前一个控件的右边缘约束相等，这样当前控件就会占据前一个控件的位置
//    currentRightConstraint.equalTo(lastLeftConstraint);
    
    [payOrderBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastPayBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str3 = [UserDefaultLocationDic valueForKey:@"confirmReceipt"];
    CGSize size3 = [NSString sizeWithText:str3 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *kefuBt = [[UIButton alloc]init];
    [kefuBt setBackgroundColor:redColor3];
    [kefuBt setTitle:str3 forState:(UIControlStateNormal)];
    [kefuBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    kefuBt.titleLabel.font = [UIFont systemFontOfSize:14];
    kefuBt.titleLabel.numberOfLines = 0;
    kefuBt.layer.masksToBounds = YES;
    kefuBt.layer.cornerRadius = 15;
    kefuBt.hidden = YES;
    [kefuBt addTarget:self action:@selector(clickReceipt) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:kefuBt];
    self.kefuBt = kefuBt;
    
    [kefuBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(payOrderBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str4 = @"拍照申请";
    CGSize size4 = [NSString sizeWithText:str4 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *photoBt = [[UIButton alloc]init];
    [photoBt setBackgroundColor:TCUIColorFromRGB(0x333333)];
    [photoBt setTitle:str4 forState:(UIControlStateNormal)];
    [photoBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    photoBt.titleLabel.font = [UIFont systemFontOfSize:14];
    photoBt.titleLabel.numberOfLines = 0;
    photoBt.layer.masksToBounds = YES;
    photoBt.layer.cornerRadius = 15;
    photoBt.hidden = YES;
    [photoBt addTarget:self action:@selector(clickPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:photoBt];
    self.photoBt = photoBt;
    
    [photoBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(kefuBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str5 = [UserDefaultLocationDic valueForKey:@"cleanOrder"];
    CGSize size5 = [NSString sizeWithText:str5 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *cancleBt = [[UIButton alloc]init];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [cancleBt setTitle:str5 forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont systemFontOfSize:14];
    cancleBt.titleLabel.numberOfLines = 0;
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    cancleBt.layer.borderWidth = 0.5;
    cancleBt.hidden = YES;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:cancleBt];
    self.cancleBt = cancleBt;
    
    // 前一个控件的左边缘约束
    MASConstraintMaker *lastLeftConstraint4 = [photoBt mas_left];
    
    // 当前控件的右边缘约束
    MASConstraintMaker *currentRightConstraint4 = [cancleBt mas_right];

    // 将当前控件的左边缘约束与前一个控件的右边缘约束相等，这样当前控件就会占据前一个控件的位置
//    currentRightConstraint.equalTo(lastLeftConstraint);
    
    [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(photoBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str6 = [UserDefaultLocationDic valueForKey:@"proResults"];
    CGSize size6 = [NSString sizeWithText:str6 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *resultBt = [[UIButton alloc]init];
    [resultBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [resultBt setTitle:str6 forState:(UIControlStateNormal)];
    [resultBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    resultBt.titleLabel.font = [UIFont systemFontOfSize:14];
    resultBt.titleLabel.numberOfLines = 0;
    resultBt.layer.masksToBounds = YES;
    resultBt.layer.cornerRadius = 15;
    resultBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    resultBt.layer.borderWidth = 0.5;
    resultBt.hidden = YES;
    [resultBt addTarget:self action:@selector(clickResult) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:resultBt];
    self.resultBt = resultBt;
    
    // 前一个控件的左边缘约束
  //  MASConstraintMaker *lastLeftConstraint5 = [cancleBt mas_left];
    
    // 当前控件的右边缘约束
//    MASConstraintMaker *currentRightConstraint5 = [resultBt mas_right];

    // 将当前控件的左边缘约束与前一个控件的右边缘约束相等，这样当前控件就会占据前一个控件的位置
//    currentRightConstraint.equalTo(lastLeftConstraint);
    
    [resultBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cancleBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str7 = [UserDefaultLocationDic valueForKey:@"idelete"];
    CGSize size7 = [NSString sizeWithText:str7 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *refundBt = [[UIButton alloc]init];
    [refundBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [refundBt setTitle:str7 forState:(UIControlStateNormal)];
    [refundBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    refundBt.titleLabel.font = [UIFont systemFontOfSize:14];
    refundBt.titleLabel.numberOfLines = 0;
    refundBt.layer.masksToBounds = YES;
    refundBt.layer.cornerRadius = 15;
    refundBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    refundBt.layer.borderWidth = 0.5;
    refundBt.hidden = YES;
    [refundBt addTarget:self action:@selector(clickRefund) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:refundBt];
    self.refundMoneyBt = refundBt;
    
    // 前一个控件的左边缘约束
    MASConstraintMaker *lastLeftConstraint6 = [resultBt mas_left];
    
    // 当前控件的右边缘约束
    MASConstraintMaker *currentRightConstraint6 = [resultBt mas_right];

    // 将当前控件的左边缘约束与前一个控件的右边缘约束相等，这样当前控件就会占据前一个控件的位置
//    currentRightConstraint.equalTo(lastLeftConstraint);
    
    [refundBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(resultBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    NSString *str8 = [UserDefaultLocationDic valueForKey:@"ckanWuliu"];
    CGSize size8 = [NSString sizeWithText:str7 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    UIButton *viewLogiticsBt = [[UIButton alloc]init];
    [viewLogiticsBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [viewLogiticsBt setTitle:str8 forState:(UIControlStateNormal)];
    [viewLogiticsBt setTitleColor:TCUIColorFromRGB(0x030303) forState:(UIControlStateNormal)];
    viewLogiticsBt.titleLabel.font = [UIFont systemFontOfSize:14];
    viewLogiticsBt.titleLabel.numberOfLines = 0;
    viewLogiticsBt.layer.masksToBounds = YES;
    viewLogiticsBt.layer.cornerRadius = 15;
    viewLogiticsBt.layer.borderColor = TCUIColorFromRGB(0x030303).CGColor;
    viewLogiticsBt.layer.borderWidth = 0.5;
    viewLogiticsBt.hidden = YES;
    [viewLogiticsBt addTarget:self action:@selector(clickExpress) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:viewLogiticsBt];
    self.expressBt = viewLogiticsBt;
    
    [refundBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(refundBt.mas_left).offset(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
    }];
    
    UIButton *kefuBt1 = [[UIButton alloc]init];
    [kefuBt1 setImage:[UIImage imageNamed:@"kefu_icon"] forState:(UIControlStateNormal)];
    [kefuBt1 addTarget:self action:@selector(clickKefu) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:kefuBt1];
    
    [kefuBt1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-31);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(20);
    }];
    
    UILabel *moneyLa = [UILabel publicLab:@"" textColor:redColor3 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    moneyLa.preferredMaxLayoutWidth = WIDTH - 40;
    [moneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contView addSubview:moneyLa];
    self.moneyLa = moneyLa;
    
    [moneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-90);
            make.height.mas_equalTo(15);
    }];
    
}

-(void)setModel:(MMDMOrderListModel *)model{
    KweakSelf(self);
    _model = model;
    self.stateLa.text = _model.ProcessingState;
    self.timeLa.text = _model.AddTime;
    self.orderNoLa.text = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"odrNumber"],_model.ID];
    self.moneyLa.text = _model.ItemMoneyShow;
    
    if([_model.CanLastPay isEqualToString:@"1"]){
        self.lastPayBt.hidden = NO;
    }else{
        self.lastPayBt.hidden = YES;
    }
    
    if([_model.CanFirstPay isEqualToString:@"1"]){
        self.firstPayBt.hidden = NO;
    }else{
        self.firstPayBt.hidden = YES;
    }
    
    if([_model.CanCompleteOrder isEqualToString:@"1"]){
        self.kefuBt.hidden = NO;
    }else{
        self.kefuBt.hidden = YES;
    }
    
    
    if([_model.CanPhoto isEqualToString:@"1"]){
        self.photoBt.hidden = NO;
    }else{
        self.photoBt.hidden = YES;
    }
    
    if([_model.CanCancel isEqualToString:@"1"]){
        self.cancleBt.hidden = NO;
    }else{
        self.cancleBt.hidden = YES;
    }
    
    if([_model.CanResult isEqualToString:@"1"]){
        self.resultBt.hidden = NO;
    }else{
        self.resultBt.hidden = YES;
    }
    
    if([_model.CanDeleteOrder isEqualToString:@"1"]){
        self.refundMoneyBt.hidden = NO;
    }else{
        self.refundMoneyBt.hidden = YES;
    }
    
    if([_model.CanShowTrack isEqualToString:@"1"]){
        self.expressBt.hidden = NO;
    }else{
        self.expressBt.hidden = YES;
    }
    
    float wid = (WIDTH - 40)/4;
    
    NSString *str2 = @"支付订单";
    CGSize size2 = [NSString sizeWithText:str2 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    
    NSString *str3 = [UserDefaultLocationDic valueForKey:@"confirmReceipt"];
    CGSize size3 = [NSString sizeWithText:str3 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
   
    NSString *str4 = @"拍照申请";
    CGSize size4 = [NSString sizeWithText:str4 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    
    NSString *str5 = [UserDefaultLocationDic valueForKey:@"cleanOrder"];
    CGSize size5 = [NSString sizeWithText:str5 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
   
    NSString *str6 = [UserDefaultLocationDic valueForKey:@"proResults"];
    CGSize size6 = [NSString sizeWithText:str6 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
   
   
    NSString *str7 = [UserDefaultLocationDic valueForKey:@"dOrderState15"];
    CGSize size7 = [NSString sizeWithText:str7 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    
    NSString *str8 = [UserDefaultLocationDic valueForKey:@"ckanWuliu"];
    CGSize size8 = [NSString sizeWithText:str7 font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    
    
    if(self.lastPayBt.hidden == YES){
        [self.firstPayBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }
    
    if(self.firstPayBt.hidden == YES){
        [self.kefuBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.firstPayBt.mas_right);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }

    if(self.kefuBt.hidden == YES){
        [self.photoBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.kefuBt.mas_right);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }

    if(self.photoBt.hidden == YES){
        [self.cancleBt mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(weakself.photoBt.mas_right);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }

    if(self.cancleBt.hidden == YES){
        [self.resultBt mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(weakself.cancleBt.mas_right);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }

    if(self.resultBt.hidden == YES){
        [self.refundMoneyBt mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(weakself.resultBt.mas_right);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }
    
    if(self.refundMoneyBt.hidden == YES){
        [self.expressBt mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(weakself.refundMoneyBt.mas_right);
            make.bottom.mas_offset(-26);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(30);
        }];
    }
    
    
    
    if(_model.OrderProducts.count > 0){
        self.goodsView.height = 116 * _model.OrderProducts.count;
        NSArray *arr = [MMDMOrderGoodsModel mj_objectArrayWithKeyValuesArray:_model.OrderProducts];
        float hei = 0;
        for (int i = 0; i < arr.count; i++) {
            MMDMOrderGoodsModel *model1 = arr[i];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH - 20, 116)];
            view.backgroundColor = TCUIColorFromRGB(0xffffff);
            [self.goodsView addSubview:view];
            
            UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 67, 67)];
            [goodsImage sd_setImageWithURL:[NSURL URLWithString:model1.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
            goodsImage.layer.masksToBounds = YES;
            goodsImage.layer.cornerRadius = 6;
            goodsImage.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
            goodsImage.layer.borderWidth = 0.5;
            [view addSubview:goodsImage];
            
            UILabel *nameLa = [UILabel publicLab:model1.Name textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
            nameLa.frame = CGRectMake(87, 16, WIDTH - 120, 15);
            [view addSubview:nameLa];
            if(model1.Attribute.length > 0){
                UILabel *attiLa = [UILabel publicLab:model1.Attribute textColor:TCUIColorFromRGB(0xa3a2a2) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
                attiLa.frame = CGRectMake(88, CGRectGetMaxY(nameLa.frame) + 10, WIDTH - 120, 12);
                [view addSubview:attiLa];
            }
            
            if(model1.SureID){
                CGSize size = [NSString sizeWithText:model1.SureName font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
                UILabel *lab = [UILabel publicLab:model1.SureName textColor:TCUIColorFromRGB(0x595959) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
                lab.frame = CGRectMake(86, CGRectGetMaxY(nameLa.frame) + 34, size.width + 10, 18);
                lab.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
                lab.layer.masksToBounds = YES;
                lab.layer.cornerRadius = 2;
                [view addSubview:lab];
            }
            
            UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
            priceLa.frame = CGRectMake(86, CGRectGetMaxY(nameLa.frame) + 58, WIDTH -120, 15);
            [view addSubview:priceLa];
            
            NSArray *temp = [model1.PriceShow componentsSeparatedByString:@" "];
            
            [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                            confer.text(temp[0]).textColor(TCUIColorFromRGB(0x030303)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:12]);
                            confer.text(temp[1]).textColor(TCUIColorFromRGB(0x030303)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:15]);
                            confer.text([NSString stringWithFormat:@" x%@",model1.Number]).textColor(TCUIColorFromRGB(0x8a8a8a)).font([UIFont systemFontOfSize:13]);
            }];
            
            
            hei += 116;
        }
    }
    
}


-(void)clickLastPay{
    self.clickLastBlock(self.model);
}

-(void)clickPayOrder{
    self.clickPayBlock(self.model);
}

-(void)clickKefu{
    self.clickKeFuBlock(self.model);
}


-(void)clickPhoto{
    self.clickPhotoBlock(self.model);
}

-(void)clickCancle{
    self.clickCancleBlock(self.model);
}

-(void)clickResult{
    self.clickResultBlock(self.model);
}

-(void)clickRefund{
    self.clickRefundBlock(self.model);
}

-(void)clickReceipt{
    self.clickReceiptBlock(self.model);
}

-(void)clickExpress{
    self.clickExpresstBlock(self.model);
}


-(void)clickCopy{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.ID;
    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"copySucess"]];
}

@end
