//
//  MMOrderListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/15.
//

#import "MMOrderListCell.h"


@interface MMOrderListCell ()
@property (nonatomic, strong) UILabel *orderNoLa;//订单编号
@property (nonatomic, strong) UILabel *timeLa;//下单时间
@property (nonatomic, strong) UILabel *stateLa;//订单状态
@property (nonatomic, strong) UILabel *allMoneyLa;//实付款总额
@property (nonatomic, strong) UILabel *jMoneyLa;//日元的实付金额

@property (nonatomic, strong) UIView *deliveryTimeView;//预计发货时间
@property (nonatomic, strong) UILabel *deliveryTimeLa;//预计发货时间
@property (nonatomic, strong) UIView *refundView;//退款view

//合成一个了
@property (nonatomic, strong) UILabel *refundStateLa;//退款状态 待处理 or 退款成功
@property (nonatomic, strong) UILabel *refundLa;//待处理的展示 商家将在72h内处理 成功的展示 已退款金额（约JPY）


@property (nonatomic, strong) UIButton *rightBt;//付款按钮
@property (nonatomic, strong) UIButton *centerBt;//修改地址按钮
@property (nonatomic, strong) UIButton *leftBt;//取消订单按钮
@property (nonatomic, strong) UIButton *leftBt1;//最左侧按钮
@property (nonatomic, strong) MMOrderGoodsItem *goodsView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIButton *coBt;
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UILabel *showLa;
@property (nonatomic, strong) UIImageView *showIcon;
@property (nonatomic, strong) UIButton *showBt;

@property (nonatomic, strong) UIButton *receiptBt;//确认收货
@property (nonatomic, strong) UIButton *chaidanBt;//拆单文案由后端返回{{item.chaidanName}}
@property (nonatomic, strong) UIButton *resultBt;//处理结果
@property (nonatomic, strong) UIButton *refundBt;//申请退款
@property (nonatomic, strong) UIButton *logisticsBt;//查看物流
@property (nonatomic, strong) UIButton *salesServiceBt;//申请售后
@property (nonatomic, strong) UIButton *ievaluateBt;//去评价
@property (nonatomic, strong) UIButton *txfhBt;//提醒发货
@property (nonatomic, strong) UIButton *UpaddressBt;//修改地址
@property (nonatomic, strong) UIButton *addCarBt;//加购物车
@property (nonatomic, strong) UIButton *cancleBt;//取消
@property (nonatomic, strong) UIButton *deleteBt;//删除
@end

@implementation MMOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(UIView *)showView{
    if(!_showView){
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = TCUIColorFromRGB(0xffffff);
        NSString *str = [NSString stringWithFormat:@"%@%@,%@",[UserDefaultLocationDic valueForKey:@"sumorder"],[UserDefaultLocationDic valueForKey:@"countProduct"],[UserDefaultLocationDic valueForKey:@"clickToggle"]];
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x989898) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        lab.frame = CGRectMake((WIDTH - size.width - 42)/2, 10, size.width + 30, 11);
        [_showView addSubview:lab];
        self.showLa = lab;
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame), 14, 12, 4)];
        icon.image = [UIImage imageNamed:@"down_gary"];
        [_showView addSubview:icon];
        self.showIcon = icon;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 32)];
        [btn addTarget:self action:@selector(clickShow) forControlEvents:(UIControlEventTouchUpInside)];
        [_showView addSubview:btn];
        self.showBt = btn;
    }
    return _showView;
}

-(UIView *)deliveryTimeView{
    if(!_deliveryTimeView){
        _deliveryTimeView = [[UIView alloc]init];
        _deliveryTimeView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        _deliveryTimeView.layer.masksToBounds = YES;
        _deliveryTimeView.layer.cornerRadius = 4;
        UIImageView *remindimage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 15, 15)];
        remindimage.image = [UIImage imageNamed:@"remind_icon"];
        [_deliveryTimeView addSubview:remindimage];
        
        UILabel *deliveryTimeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        deliveryTimeLa.frame = CGRectMake(27, 8, WIDTH - 70, 14);
        [_deliveryTimeView addSubview:deliveryTimeLa];
        self.deliveryTimeLa = deliveryTimeLa;
    }
    return _deliveryTimeView;
}

-(UIView *)refundView{
    if(_refundView){
        _refundView = [[UIView alloc]init];
        _refundView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        _refundView.layer.masksToBounds = YES;
        _refundView.layer.cornerRadius = 4;
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Medium" size:14 numberOfLines:0];
        lab.frame =CGRectMake(10, 8, _refundView.width - 20, 14);
        [_refundView addSubview:lab];
        self.refundLa = lab;
        
    }
    return _refundView;
}

-(MMOrderGoodsItem *)goodsView{
    KweakSelf(self);
    if(!_goodsView){
        _goodsView = [[MMOrderGoodsItem alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLa.frame) + 20, WIDTH - 20, 124 * self.model.itemlist.count)];
        NSDictionary *dic = self.model.itemlist[0];
        if([self.model.isShow isEqualToString:@"1"]){
            _goodsView.arr = self.model.itemlist;
        }else{
            _goodsView.dic = dic;
            _goodsView.height = 124;
        }
       
        _goodsView.tapGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapGoodsBlock(router);
        };
    }
    return _goodsView;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    UIView *contentV = [[UIView alloc]init];
    contentV.backgroundColor = TCUIColorFromRGB(0xffffff);
    contentV.layer.masksToBounds = YES;
    contentV.layer.cornerRadius = 7.5;
    [self.contentView addSubview:contentV];
    self.contentV = contentV;
    
    [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
    }];
    
//    [self layoutIfNeeded];
    
    UILabel *orderLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    orderLa.preferredMaxLayoutWidth = 250;
    [orderLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentV addSubview:orderLa];
    self.orderNoLa = orderLa;
    
    [orderLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(9);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(13);
    }];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"fzCopy"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    UIButton *copyBt = [[UIButton alloc]init];
    [copyBt setTitle:[UserDefaultLocationDic valueForKey:@"fzCopy"] forState:(UIControlStateNormal)];
    [copyBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    copyBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    copyBt.layer.masksToBounds = YES;
    copyBt.layer.cornerRadius = 2.5;
    copyBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
    copyBt.layer.borderWidth = 0.5;
    [copyBt addTarget:self action:@selector(clickCopyNo) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:copyBt];
    self.coBt = copyBt;
      
    [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(orderLa.mas_right).offset(5);
            make.top.mas_equalTo(14);
            make.width.mas_equalTo(size.width + 8);
            make.height.mas_equalTo(17);
    }];
    
    UIButton *kefuBt = [[UIButton alloc]init];
    [kefuBt setImage:[UIImage imageNamed:@"kefu_icon"] forState:(UIControlStateNormal)];
    [kefuBt addTarget:self action:@selector(clickKeFu) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:kefuBt];
    
    [kefuBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(copyBt.mas_right).offset(5);
            make.top.mas_equalTo(12);
            make.width.height.mas_equalTo(21);
    }];
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x747474) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    timeLa.frame = CGRectMake(10, 38, 150, 11);
    [contentV addSubview:timeLa];
    self.timeLa = timeLa;
    
    UILabel *stateLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    stateLa.preferredMaxLayoutWidth = 150;
    [stateLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentV addSubview:stateLa];
    self.stateLa = stateLa;
    
    [stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(13);
    }];
    
//    [self.contentView addSubview:self.showView];
//    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(-226);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(32);
//    }];
    
    [self.contentView addSubview:self.deliveryTimeView];
    [self.deliveryTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-156);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
    }];
    
    UILabel *allMoneyLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    allMoneyLa.preferredMaxLayoutWidth = WIDTH - 40;
    [allMoneyLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentV addSubview:allMoneyLa];
    
    self.allMoneyLa = allMoneyLa;
    [allMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-114);
            make.height.mas_equalTo(17);
    }];
    
   
    UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    lab.preferredMaxLayoutWidth = WIDTH - 40;
    [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [contentV addSubview:lab];
    self.jMoneyLa = lab;
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-88);
            make.height.mas_equalTo(12);
    }];
    
    
    float wid = (WIDTH - 40)/4;
    //CGSize size1 = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
    
    NSString *str1 = [UserDefaultLocationDic valueForKey:@"confirmReceipt"];
    //确认收货
    
    UIButton *receiptBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 22.5 - wid, contentV.height - 58, wid, 30)];
    [receiptBt setBackgroundColor:redColor2];
    [receiptBt setTitle:[UserDefaultLocationDic valueForKey:@"confirmReceipt"] forState:(UIControlStateNormal)];
    [receiptBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    receiptBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    receiptBt.titleLabel.numberOfLines = 0;
    receiptBt.layer.masksToBounds = YES;
    receiptBt.layer.cornerRadius = 15;
    [receiptBt addTarget:self action:@selector(clickReceipt) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:receiptBt];
    self.receiptBt = receiptBt;
    
       
    [receiptBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //支付
    
    UIButton *chaidanBt = [[UIButton alloc]initWithFrame:CGRectMake(receiptBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [chaidanBt setBackgroundColor:redColor2];
    [chaidanBt setTitle:[UserDefaultLocationDic valueForKey:@"payMoney"] forState:(UIControlStateNormal)];
    [chaidanBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    chaidanBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    chaidanBt.titleLabel.numberOfLines = 0;
    chaidanBt.layer.masksToBounds = YES;
    chaidanBt.layer.cornerRadius = 15;
    [chaidanBt addTarget:self action:@selector(clickPay) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:chaidanBt];
    self.chaidanBt = chaidanBt;
    
    [chaidanBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(receiptBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //查看结果
    UIButton *resultBt = [[UIButton alloc]initWithFrame:CGRectMake(chaidanBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [resultBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [resultBt setTitle:[UserDefaultLocationDic valueForKey:@"proResults"] forState:(UIControlStateNormal)];
    [resultBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    resultBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    resultBt.titleLabel.numberOfLines = 0;
    resultBt.layer.masksToBounds = YES;
    resultBt.layer.cornerRadius = 15;
    resultBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    resultBt.layer.borderWidth = 0.5;
    [resultBt addTarget:self action:@selector(clickResult) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:resultBt];
    self.resultBt = resultBt;
    
    [resultBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chaidanBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //退款
    
    UIButton *refundBt = [[UIButton alloc]initWithFrame:CGRectMake(resultBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [refundBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [refundBt setTitle:[UserDefaultLocationDic valueForKey:@"refundRequest"] forState:(UIControlStateNormal)];
    [refundBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    refundBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    refundBt.titleLabel.numberOfLines = 0;
    refundBt.layer.masksToBounds = YES;
    refundBt.layer.cornerRadius = 15;
    refundBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    refundBt.layer.borderWidth = 0.5;
    [refundBt addTarget:self action:@selector(clickRefund) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:refundBt];
    self.refundBt = refundBt;
    
    [refundBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(resultBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //查看物流
    
    UIButton *viewLogisticBt = [[UIButton alloc]initWithFrame:CGRectMake(refundBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [viewLogisticBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [viewLogisticBt setTitle:[UserDefaultLocationDic valueForKey:@"viewLogistics"] forState:(UIControlStateNormal)];
    [viewLogisticBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    viewLogisticBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    viewLogisticBt.titleLabel.numberOfLines = 0;
    viewLogisticBt.layer.masksToBounds = YES;
    viewLogisticBt.layer.cornerRadius = 15;
    viewLogisticBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    viewLogisticBt.layer.borderWidth = 0.5;
    [viewLogisticBt addTarget:self action:@selector(clickLogistics) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:viewLogisticBt];
    self.logisticsBt = viewLogisticBt;
    
    [viewLogisticBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(refundBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //售后服务
    UIButton *saleServiceBt = [[UIButton alloc]initWithFrame:CGRectMake(viewLogisticBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [saleServiceBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [saleServiceBt setTitle:[UserDefaultLocationDic valueForKey:@"viewLogistics"] forState:(UIControlStateNormal)];
    [saleServiceBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    saleServiceBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    saleServiceBt.titleLabel.numberOfLines = 0;
    saleServiceBt.layer.masksToBounds = YES;
    saleServiceBt.layer.cornerRadius = 15;
    saleServiceBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    saleServiceBt.layer.borderWidth = 0.5;
    [saleServiceBt addTarget:self action:@selector(clickSalesService) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:saleServiceBt];
    self.salesServiceBt = saleServiceBt;
    
    [saleServiceBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewLogisticBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //评价
    UIButton *assessBt = [[UIButton alloc]initWithFrame:CGRectMake(saleServiceBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [assessBt setBackgroundColor:redColor2];
    [assessBt setTitle:[UserDefaultLocationDic valueForKey:@"ievaluate"] forState:(UIControlStateNormal)];
    [assessBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    assessBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    assessBt.titleLabel.numberOfLines = 0;
    assessBt.layer.masksToBounds = YES;
    assessBt.layer.cornerRadius = 15;
    [assessBt addTarget:self action:@selector(clickAssess) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:assessBt];
    self.ievaluateBt = assessBt;
    
    [assessBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(saleServiceBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //提醒发货
 
    UIButton *tixingBt = [[UIButton alloc]initWithFrame:CGRectMake(assessBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [tixingBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [tixingBt setTitle:[UserDefaultLocationDic valueForKey:@"tiXifaH"] forState:(UIControlStateNormal)];
    [tixingBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    tixingBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    tixingBt.titleLabel.numberOfLines = 0;
    tixingBt.layer.masksToBounds = YES;
    tixingBt.layer.cornerRadius = 15;
    tixingBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    tixingBt.layer.borderWidth = 0.5;
    [tixingBt addTarget:self action:@selector(clickTiXing) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:tixingBt];
    self.txfhBt = tixingBt;
    
    [tixingBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(assessBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //修改地址
    UIButton *changeAddressBt = [[UIButton alloc]initWithFrame:CGRectMake(tixingBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [changeAddressBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [changeAddressBt setTitle:[UserDefaultLocationDic valueForKey:@"upaddress"] forState:(UIControlStateNormal)];
    [changeAddressBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    changeAddressBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    changeAddressBt.titleLabel.numberOfLines = 0;
    changeAddressBt.layer.masksToBounds = YES;
    changeAddressBt.layer.cornerRadius = 15;
    changeAddressBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    changeAddressBt.layer.borderWidth = 0.5;
    [changeAddressBt addTarget:self action:@selector(clickAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:changeAddressBt];
    self.UpaddressBt = changeAddressBt;
    
    [changeAddressBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tixingBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //加入购物车
    UIButton *addCartBt = [[UIButton alloc]initWithFrame:CGRectMake(changeAddressBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [addCartBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [addCartBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
    [addCartBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    addCartBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    addCartBt.titleLabel.numberOfLines = 0;
    addCartBt.layer.masksToBounds = YES;
    addCartBt.layer.cornerRadius = 15;
    addCartBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    addCartBt.layer.borderWidth = 0.5;
    [addCartBt addTarget:self action:@selector(clickAddCart) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:addCartBt];
    self.addCarBt = addCartBt;
    
    [addCartBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeAddressBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //取消
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(addCartBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"cleanOrder"] forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    cancleBt.titleLabel.numberOfLines = 0;
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    cancleBt.layer.borderWidth = 0.5;
    [cancleBt addTarget:self action:@selector(clickCancle) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:cancleBt];
    self.cancleBt = cancleBt;
    
    [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addCartBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    //删除
    UIButton *deleteBt = [[UIButton alloc]initWithFrame:CGRectMake(cancleBt.x - 2.5 - wid, contentV.height - 58, wid, 30)];
    [deleteBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [deleteBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
    [deleteBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    deleteBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    deleteBt.titleLabel.numberOfLines = 0;
    deleteBt.layer.masksToBounds = YES;
    deleteBt.layer.cornerRadius = 15;
    deleteBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    deleteBt.layer.borderWidth = 0.5;
    [deleteBt addTarget:self action:@selector(clickDelete) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:deleteBt];
    self.deleteBt = deleteBt;
    
    [deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cancleBt.mas_left).offset(-2.5);
        make.bottom.mas_equalTo(-28);
        make.width.mas_equalTo(wid);
        make.height.mas_equalTo(36);
    }];
    
    
    
//    UIButton *payBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 110, contentV.height - 58, 100, 30)];
//    [payBt setBackgroundColor:redColor2];
//    [payBt setTitle:[UserDefaultLocationDic valueForKey:@"payMoney"] forState:(UIControlStateNormal)];
//    [payBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
//    payBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    payBt.titleLabel.numberOfLines = 0;
//    payBt.layer.masksToBounds = YES;
//    payBt.layer.cornerRadius = 15;
//    [payBt addTarget:self action:@selector(clickRight:) forControlEvents:(UIControlEventTouchUpInside)];
//    [contentV addSubview:payBt];
//    payBt.hidden = YES;
//
//    self.rightBt = payBt;
//    [payBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-10);
//            make.bottom.mas_equalTo(-28);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(36);
//    }];
//
//    UIButton *changeAddressBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 180, contentV.height - 58, 80, 30)];
//    [changeAddressBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//    [changeAddressBt setTitle:[UserDefaultLocationDic valueForKey:@"upaddress"] forState:(UIControlStateNormal)];
//    [changeAddressBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//    changeAddressBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    changeAddressBt.titleLabel.numberOfLines = 0;
//    changeAddressBt.layer.masksToBounds = YES;
//    changeAddressBt.layer.cornerRadius = 15;
//    changeAddressBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//    changeAddressBt.layer.borderWidth = 0.5;
//    [changeAddressBt addTarget:self action:@selector(clickCenter:) forControlEvents:(UIControlEventTouchUpInside)];
//    [contentV addSubview:changeAddressBt];
//    changeAddressBt.hidden = YES;
//
//    self.centerBt = changeAddressBt;
//    [changeAddressBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(payBt.mas_left).offset(-10);
//            make.bottom.mas_equalTo(-28);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(36);
//    }];
//
//    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 270, contentV.height - 58, 80, 30)];
//    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//    [cancleBt setTitle:[UserDefaultLocationDic valueForKey:@"cleanOrder"] forState:(UIControlStateNormal)];
//    [cancleBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    cancleBt.titleLabel.numberOfLines = 0;
//    cancleBt.layer.masksToBounds = YES;
//    cancleBt.layer.cornerRadius = 15;
//    cancleBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//    cancleBt.layer.borderWidth = 0.5;
//    [cancleBt addTarget:self action:@selector(clickLeft:) forControlEvents:(UIControlEventTouchUpInside)];
//    [contentV addSubview:cancleBt];
//    cancleBt.hidden = YES;
//
//    self.leftBt = cancleBt;
//    [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(changeAddressBt.mas_left).offset(-10);
//            make.bottom.mas_equalTo(-28);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(36);
//    }];
    
//    UIButton *addCarBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 360, contentV.height - 58, 80, 30)];
//    [addCarBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//    [addCarBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
//    [addCarBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//    addCarBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    addCarBt.layer.masksToBounds = YES;
//    addCarBt.layer.cornerRadius = 15;
//    addCarBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//    addCarBt.layer.borderWidth = 0.5;
//    [addCarBt addTarget:self action:@selector(clickLeft:) forControlEvents:(UIControlEventTouchUpInside)];
//    [contentV addSubview:addCarBt];
//    addCarBt.hidden = YES;
//
//    self.leftBt1 = addCarBt;
//    [addCarBt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(cancleBt.mas_left).offset(-10);
//            make.bottom.mas_equalTo(-28);
//            make.width.mas_equalTo(80);
//            make.height.mas_equalTo(30);
//    }];
    
    
}

-(void)setModel:(MMOrderListModel *)model{
    _model = model;
    KweakSelf(self);
    self.orderNoLa.text = [NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"oderHao"],_model.OrderNumber];
    NSString *str1 = [_model.AddTime substringToIndex:10];
    self.timeLa.text = [NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"oderTime"],str1];
    self.stateLa.text = _model.ShowState;
    
//    self.goodsView.arr = _model.itemlist;
    
    
    if(_model.itemlist.count > 1){
        [self.contentView addSubview:self.showView];
        
       
        
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-196);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(32);
        }];
        if([_model.isShow isEqualToString:@"1"]){
            self.showLa.text = [NSString stringWithFormat:@"%@%@%@%@",[UserDefaultLocationDic valueForKey:@"sumorder"],_model.BuyNum,[UserDefaultLocationDic valueForKey:@"countProduct"],[UserDefaultLocationDic valueForKey:@"clickStow"]];
            self.showIcon.image = [UIImage imageNamed:@"up_icon_black"];
        }else{
            self.showLa.text = [NSString stringWithFormat:@"%@%@%@%@",[UserDefaultLocationDic valueForKey:@"sumorder"],_model.BuyNum,[UserDefaultLocationDic valueForKey:@"countProduct"],[UserDefaultLocationDic valueForKey:@"clickToggle"]];
            self.showIcon.image = [UIImage imageNamed:@"down_gary"];
        }
    }
    
    [self.contentV addSubview:self.goodsView];
    
    
    self.allMoneyLa.text = [NSString stringWithFormat:@"%@：%@",[UserDefaultLocationDic valueForKey:@"actualPayment"],_model.PayMoneyShow];
    [self.allMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        (void)(confer.text([UserDefaultLocationDic valueForKey:@"actualPayment"]).textColor(TCUIColorFromRGB(0x242424)).font([UIFont fontWithName:@"PingFangSC-Medium" size:14])),
        confer.text(self->_model.MoneysShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:19]);
    }];
    self.jMoneyLa.text = [NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"iabout"],_model.MoneysShow];
    
   
    
    if([_model.EstimatedShipment isEqualToString:@""]){
        self.deliveryTimeView.hidden = YES;
    }else{
        self.deliveryTimeView.frame = CGRectMake(10, self.contentV.height - 186, self.contentV.width - 20, 30);
        [self.contentV addSubview:self.deliveryTimeView];
        self.deliveryTimeLa.text = _model.EstimatedShipment;
    }
    
    if([_model.CanReceiptOrder isEqualToString:@"1"]){
        self.receiptBt.hidden = NO;
    }else{
        self.receiptBt.hidden = YES;
        self.receiptBt.x = WIDTH - 20;
        self.receiptBt.width = 0;
    }
    
    if([_model.CanPay isEqualToString:@"1"] && ([_model.PackNum isEqualToString:@"1"] || [_model.PackNum isEqualToString:@"0"])){
        self.chaidanBt.hidden = NO;
    }else{
        self.chaidanBt.hidden = YES;
        self.chaidanBt.x = self.receiptBt.x;
        self.chaidanBt.width = 0;
    }
    
    if([_model.CanResult isEqualToString:@"0"] || [_model.AllState isEqualToString:@"2"]){
        self.resultBt.hidden = YES;
        self.resultBt.x = self.chaidanBt.x;
        self.resultBt.width = 0;
    }else{
        self.resultBt.hidden = NO;
    }
    
    if([_model.CanRefundMoney isEqualToString:@"1"] && [_model.Processing isEqualToString:@"6"]){
        self.refundBt.hidden = NO; //多请求一个接口 请求弹窗
    }else if ([_model.CanRefundMoney isEqualToString:@"1"]){
        self.refundBt.hidden = NO;
    }else{
        self.refundBt.hidden = YES;
        self.refundBt.x = self.resultBt.x;
        self.refundBt.width = 0;
    }
    
    if([_model.Processing isEqualToString:@"0"] || [_model.Processing isEqualToString:@"6"] || [_model.Processing isEqualToString:@"5"] ){
        self.logisticsBt.hidden = YES;
        self.logisticsBt.x = self.refundBt.x;
        self.logisticsBt.width = 0;
    }else{
        self.logisticsBt.hidden = NO;
    }
    
    if([_model.CanRefundItem isEqualToString:@"1"]){
        self.salesServiceBt.hidden = NO;
    }else{
        self.salesServiceBt.hidden = YES;
        self.salesServiceBt.x = self.logisticsBt.x;
        self.salesServiceBt.width = 0;
    }
    
    if([_model.CanAssessOrder isEqualToString:@"1"]){
        self.ievaluateBt.hidden = NO;
    }else{
        self.ievaluateBt.hidden = YES;
        self.ievaluateBt.x = self.salesServiceBt.x;
        self.ievaluateBt.width = 0;
    }
    
    if([_model.CanTips isEqualToString:@"1"] && [_model.Processing isEqualToString:@"0"]){
        self.txfhBt.hidden = NO;
    }else{
        self.txfhBt.hidden = YES;
        self.txfhBt.x = self.ievaluateBt.x;
        self.txfhBt.width = 0;
    }
    
    if([_model.CanAddress isEqualToString:@"0"] || [_model.ColumnID isEqualToString:@"804"]){
        self.UpaddressBt.hidden = YES;
        self.UpaddressBt.x = self.txfhBt.x;
        self.UpaddressBt.width = 0;
    }else{
        self.UpaddressBt.hidden = NO;
    }
    
    if([_model.ColumnID isEqualToString:@"804"]){
        self.addCarBt.hidden = YES;
        self.addCarBt.x = self.UpaddressBt.x;
        self.addCarBt.width = 0;
    }else{
        self.addCarBt.hidden = NO;
    }
    
    NSInteger packnum = [_model.PackNum integerValue];
    if([_model.CanCancel isEqualToString:@"1"] && packnum < 2){
        self.cancleBt.hidden = NO;
    }else{
        self.cancleBt.hidden = YES;
        self.cancleBt.x = self.addCarBt.x;
        self.cancleBt.width = 0;
    }
    
    if([_model.AllState isEqualToString:@"5"]){
        self.deleteBt.hidden = NO;
    }else{
        self.deleteBt.hidden = YES;
        self.deleteBt.x = self.cancleBt.x;
        self.deleteBt.width = 0;
    }
    
    float wid = (WIDTH - 40)/4;
    
    if(self.receiptBt.hidden == YES){
        [self.chaidanBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-2.5);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.chaidanBt.hidden == YES){
        [self.resultBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.chaidanBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.resultBt.hidden == YES){
        [self.refundBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.resultBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.refundBt.hidden == YES){
        [self.logisticsBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.refundBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.logisticsBt.hidden == YES){
        [self.salesServiceBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.logisticsBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.salesServiceBt.hidden == YES){
        [self.ievaluateBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.salesServiceBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.ievaluateBt.hidden == YES){
        [self.txfhBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.ievaluateBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.txfhBt.hidden == YES){
        [self.UpaddressBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.txfhBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.UpaddressBt.hidden == YES){
        [self.addCarBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.UpaddressBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.addCarBt.hidden == YES){
        [self.cancleBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.addCarBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(self.cancleBt.hidden == YES){
        [self.deleteBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.cancleBt.mas_right);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(36);
        }];
    }
    
//    if([_model.ColumnID isEqualToString:@"804"] && [_model.CanPay isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"payMoney"] forState:(UIControlStateNormal)];
//        self.centerBt.hidden = NO;
//        [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"cleanOrder"] forState:(UIControlStateNormal)];
//        self.leftBt.hidden = YES;
//        [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"cleanOrder"] forState:(UIControlStateNormal)];
//    }else{
//        if([_model.CanPay isEqualToString:@"1"]){//待支付订单
//            self.rightBt.hidden = NO;
//            [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"payMoney"] forState:(UIControlStateNormal)];
//            self.centerBt.hidden = NO;
//            [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"upaddress"] forState:(UIControlStateNormal)];
//            self.leftBt.hidden = NO;
//            [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"cleanOrder"] forState:(UIControlStateNormal)];
//        }else{
//            if([_model.AllState isEqualToString:@"0"]){//已支付待发货订单
//                if([self.model.CanTips isEqualToString:@"1"]){
//                    self.rightBt.hidden = NO;
//                    [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"tiXifaH"] forState:(UIControlStateNormal)];
//                    [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//                    [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//                    self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//                    self.rightBt.layer.borderWidth = 0.5;
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"upaddress"] forState:(UIControlStateNormal)];
//                    self.leftBt.hidden = NO;
//                    [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"refundRequest"] forState:(UIControlStateNormal)];
//                }else{
//                    self.rightBt.hidden = NO;
//                    [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"upaddress"] forState:(UIControlStateNormal)];
//                    [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//                    [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//                    self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//                    self.rightBt.layer.borderWidth = 0.5;
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"refundRequest"] forState:(UIControlStateNormal)];
//                }
//
//            }else if ([_model.AllState isEqualToString:@"20"] || [_model.AllState isEqualToString:@"1"]){//待收货
//                if([_model.CanResult isEqualToString:@"1"]){//售后的订单
//                    self.rightBt.hidden = NO;
//                    [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"proRes"] forState:(UIControlStateNormal)];
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"afterSales"],[UserDefaultLocationDic valueForKey:@"ievaluate"]] forState:(UIControlStateNormal)];
//                    self.leftBt.hidden = NO;
//                    [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
//                }else{//没有售后的待收货
//                    self.rightBt.hidden = NO;
//                    [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"confirmReceipt"] forState:(UIControlStateNormal)];
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"ckanWuliu"] forState:(UIControlStateNormal)];
//                    self.leftBt.hidden = NO;
//                    [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"salesService"] forState:(UIControlStateNormal)];
//                }
//            }else if ([_model.AllState isEqualToString:@"2"]){//已完成 待评价
//                if([_model.CanAssessOrder isEqualToString:@"1"]){
//                    self.rightBt.hidden = NO;
//                    //afterSales
//                    [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"ievaluate"] forState:(UIControlStateNormal)];
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"ckanWuliu"] forState:(UIControlStateNormal)];
//                    self.leftBt.hidden = NO;
//                    [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
//                }else{
//                    self.rightBt.hidden = NO;
//                    [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"ckanWuliu"] forState:(UIControlStateNormal)];
//                    [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//                    [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//                    self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//                    self.rightBt.layer.borderWidth = 0.5;
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
//                }
//
//            }else if ([_model.AllState isEqualToString:@"3"] || [_model.AllState isEqualToString:@"4"] || [_model.AllState isEqualToString:@"10"]){
//                self.rightBt.hidden = NO;
//                [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"proRes"] forState:(UIControlStateNormal)];
//                self.centerBt.hidden = NO;
//                [self.centerBt setTitle:@"售后评价" forState:(UIControlStateNormal)];
//                self.leftBt.hidden = NO;
//                [self.leftBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
//                if([_model.CanAfterSalesEvaluation isEqualToString:@"0"]){
//                    self.centerBt.hidden = NO;
//                    [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
//                    self.leftBt.hidden = YES;
//                }
//            }else if ([_model.AllState isEqualToString:@"5"]){
//                self.rightBt.hidden = NO;
//                [self.rightBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
//                [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//                [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//                self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//                self.rightBt.layer.borderWidth = 0.5;
//                self.centerBt.hidden = NO;
//                [self.centerBt setTitle:[UserDefaultLocationDic valueForKey:@"idelete"] forState:(UIControlStateNormal)];
//            }
//        }
//    }
//
    if([_model.ColumnID isEqualToString:@"804"] && [_model.AllState isEqualToString:@"7"]){
        self.leftBt.hidden = YES;
        self.centerBt.hidden = YES;
        self.rightBt.hidden = YES;
        [self.jMoneyLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-28);
        }];

        [self.allMoneyLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-54);
        }];
    }
    
}

-(void)clickReceipt{
    self.tapReceiptBlock(self.model);
}

-(void)clickPay{
    self.tapPayBlock(self.model);
}

-(void)clickResult{
    self.tapResultBlock(self.model);
}

-(void)clickRefund{
    self.tapRefundBlock(self.model);
}

-(void)clickLogistics{
    self.tapLogisticBlock(self.model);
}

-(void)clickSalesService{
    self.tapSaleServiceBlock(self.model);
}

-(void)clickAssess{
    self.tapAssessBlock(self.model);
}

-(void)clickTiXing{
    self.tapTxfhBlock(self.model);
}

-(void)clickAddress{
    self.tapAddressBlock(self.model);
}

-(void)clickAddCart{
    self.tapAddCartBlock(self.model);
}

-(void)clickCancle{
    self.tapCancleBlock(self.model);
}

-(void)clickDelete{
    self.tapDeleteBlock(self.model);
}

-(void)clickKeFu{
    self.tapKefuBlock(self.model);
}

-(void)clickCopyNo{
    self.tapCopyBlock(self.model.OrderNumber);
}


-(void)clickShow{
    if([self.model.isShow isEqualToString:@"1"]){
        self.model.isShow = @"0";
        self.tapShowBlock(self.model);
    }else{
        self.model.isShow = @"1";
        self.tapShowBlock(self.model);
    }
}
@end
