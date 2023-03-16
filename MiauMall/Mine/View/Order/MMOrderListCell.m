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
@end

@implementation MMOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
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
        _goodsView.arr = self.model.itemlist;
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
    
    UIButton *copyBt = [[UIButton alloc]init];
    [copyBt setTitle:@"复制" forState:(UIControlStateNormal)];
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
            make.width.mas_equalTo(34);
            make.height.mas_equalTo(17);
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
    
    UIButton *payBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 90, contentV.height - 58, 80, 30)];
    [payBt setBackgroundColor:redColor2];
    [payBt setTitle:@"付款" forState:(UIControlStateNormal)];
    [payBt setTitleColor:TCUIColorFromRGB(0xf3f4f4) forState:(UIControlStateNormal)];
    payBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    payBt.layer.masksToBounds = YES;
    payBt.layer.cornerRadius = 15;
    [payBt addTarget:self action:@selector(clickRight:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:payBt];
    payBt.hidden = YES;
    
    self.rightBt = payBt;
    [payBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
    }];
    
    UIButton *changeAddressBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 180, contentV.height - 58, 80, 30)];
    [changeAddressBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [changeAddressBt setTitle:@"修改地址" forState:(UIControlStateNormal)];
    [changeAddressBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    changeAddressBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    changeAddressBt.layer.masksToBounds = YES;
    changeAddressBt.layer.cornerRadius = 15;
    changeAddressBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    changeAddressBt.layer.borderWidth = 0.5;
    [changeAddressBt addTarget:self action:@selector(clickCenter:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:changeAddressBt];
    changeAddressBt.hidden = YES;
    
    self.centerBt = changeAddressBt;
    [changeAddressBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(payBt.mas_left).offset(-10);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
    }];
    
    UIButton *cancleBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 270, contentV.height - 58, 80, 30)];
    [cancleBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [cancleBt setTitle:@"取消订单" forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    cancleBt.layer.masksToBounds = YES;
    cancleBt.layer.cornerRadius = 15;
    cancleBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
    cancleBt.layer.borderWidth = 0.5;
    [cancleBt addTarget:self action:@selector(clickLeft:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentV addSubview:cancleBt];
    cancleBt.hidden = YES;
    
    self.leftBt = cancleBt;
    [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(changeAddressBt.mas_left).offset(-10);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
    }];
    
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
    self.orderNoLa.text = [NSString stringWithFormat:@"订单号：%@",_model.OrderNumber];
    NSString *str1 = [_model.AddTime substringToIndex:10];
    self.timeLa.text = [NSString stringWithFormat:@"下单时间：%@",str1];
    self.stateLa.text = _model.ShowState;
    
    self.goodsView.arr = _model.itemlist;
    [self.contentV addSubview:self.goodsView];
    self.allMoneyLa.text = [NSString stringWithFormat:@"总实付款：%@",_model.PayMoneyShow];
    [self.allMoneyLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        (void)(confer.text(@"总实付款 ").textColor(TCUIColorFromRGB(0x242424)).font([UIFont fontWithName:@"PingFangSC-Medium" size:14])),
        confer.text(self->_model.MoneysShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:19]);
    }];
    self.jMoneyLa.text = _model.PriceCountRMB;
    
    if([_model.EstimatedShipment isEqualToString:@""]){
        self.deliveryTimeView.hidden = YES;
    }else{
        self.deliveryTimeView.frame = CGRectMake(10, self.contentV.height - 186, self.contentV.width - 20, 30);
        [self.contentV addSubview:self.deliveryTimeView];
        self.deliveryTimeLa.text = _model.EstimatedShipment;
    }
    
    if([_model.CanPay isEqualToString:@"1"]){//待支付订单
        self.rightBt.hidden = NO;
        [self.rightBt setTitle:@"付款" forState:(UIControlStateNormal)];
        self.centerBt.hidden = NO;
        [self.centerBt setTitle:@"修改地址" forState:(UIControlStateNormal)];
        self.leftBt.hidden = NO;
        [self.leftBt setTitle:@"取消订单" forState:(UIControlStateNormal)];
    }else{
        if([_model.AllState isEqualToString:@"0"]){//已支付待发货订单
            if([self.model.CanTips isEqualToString:@"1"]){
                self.rightBt.hidden = NO;
                [self.rightBt setTitle:@"提醒发货" forState:(UIControlStateNormal)];
                [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
                [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
                self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
                self.rightBt.layer.borderWidth = 0.5;
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"修改地址" forState:(UIControlStateNormal)];
                self.leftBt.hidden = NO;
                [self.leftBt setTitle:@"申请退款" forState:(UIControlStateNormal)];
            }else{
                self.rightBt.hidden = NO;
                [self.rightBt setTitle:@"修改地址" forState:(UIControlStateNormal)];
                [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
                [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
                self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
                self.rightBt.layer.borderWidth = 0.5;
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"申请退款" forState:(UIControlStateNormal)];
            }
            
        }else if ([_model.AllState isEqualToString:@"20"] || [_model.AllState isEqualToString:@"1"]){//待收货
            if([_model.CanResult isEqualToString:@"1"]){//售后的订单
                self.rightBt.hidden = NO;
                [self.rightBt setTitle:@"处理结果" forState:(UIControlStateNormal)];
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"售后评价" forState:(UIControlStateNormal)];
                self.leftBt.hidden = NO;
                [self.leftBt setTitle:@"删除记录" forState:(UIControlStateNormal)];
            }else{//没有售后的待收货
                self.rightBt.hidden = NO;
                [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
                self.leftBt.hidden = NO;
                [self.leftBt setTitle:@"申请售后" forState:(UIControlStateNormal)];
            }
        }else if ([_model.AllState isEqualToString:@"2"]){//已完成 待评价
            if([_model.CanAssessOrder isEqualToString:@"1"]){
                self.rightBt.hidden = NO;
                [self.rightBt setTitle:@"评价" forState:(UIControlStateNormal)];
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
                self.leftBt.hidden = NO;
                [self.leftBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
            }else{
                self.rightBt.hidden = NO;
                [self.rightBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
                [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
                [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
                self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
                self.rightBt.layer.borderWidth = 0.5;
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
            }
            
        }else if ([_model.AllState isEqualToString:@"3"] || [_model.AllState isEqualToString:@"4"] || [_model.AllState isEqualToString:@"10"]){
            self.rightBt.hidden = NO;
            [self.rightBt setTitle:@"处理结果" forState:(UIControlStateNormal)];
            self.centerBt.hidden = NO;
            [self.centerBt setTitle:@"售后评价" forState:(UIControlStateNormal)];
            self.leftBt.hidden = NO;
            [self.leftBt setTitle:@"删除记录" forState:(UIControlStateNormal)];
            if([_model.CanAfterSalesEvaluation isEqualToString:@"0"]){
                self.centerBt.hidden = NO;
                [self.centerBt setTitle:@"删除记录" forState:(UIControlStateNormal)];
                self.leftBt.hidden = YES;
            }
        }else if ([_model.AllState isEqualToString:@"5"]){
            self.rightBt.hidden = NO;
            [self.rightBt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
            [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
            [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
            self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
            self.rightBt.layer.borderWidth = 0.5;
            self.centerBt.hidden = NO;
            [self.centerBt setTitle:@"删除订单" forState:(UIControlStateNormal)];
        }
    }
    
    
//    if([_model.CanPay isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.rightBt setTitle:@"付款" forState:(UIControlStateNormal)];
//    }else if ([_model.CanAssessOrder isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.rightBt setTitle:@"评价" forState:(UIControlStateNormal)];
//    }else if ([_model.CanReceiptOrder isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
//    }else if ([_model.CanResult isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.rightBt setTitle:@"处理结果" forState:(UIControlStateNormal)];
//    }else if ([_model.CanTips isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.rightBt setTitle:@"提醒发货" forState:(UIControlStateNormal)];
//        [self.rightBt setTitleColor:TCUIColorFromRGB(0x242424) forState:(UIControlStateNormal)];
//        [self.rightBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
//        self.rightBt.layer.borderColor = TCUIColorFromRGB(0x363636).CGColor;
//        self.rightBt.layer.borderWidth = 0.5;
//    }else if ([_model.CanReceiptOrder isEqualToString:@"1"] && [_model.CanResult isEqualToString:@"1"]){
//        self.rightBt.hidden = NO;
//        [self.centerBt setTitle:@"处理结果" forState:(UIControlStateNormal)];
//        [self.leftBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
//        [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
//    }
//    
//    if([_model.CanAddress isEqualToString:@"1"]){
//        self.centerBt.hidden = NO;
//        [self.centerBt setTitle:@"修改地址" forState:(UIControlStateNormal)];
//    }else if ([_model.CanExpress isEqualToString:@"1"]){
//        self.centerBt.hidden = NO;
//        [self.centerBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
//    }else if ([_model.CanReceiptOrder isEqualToString:@"1"] && [_model.CanResult isEqualToString:@"1"]){
//        self.centerBt.hidden = NO;
//        [self.centerBt setTitle:@"处理结果" forState:(UIControlStateNormal)];
//        [self.leftBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
//        [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
//    }
//    
//    //售后评价暂时没有字段去判断
//    
//    if([_model.CanCancel isEqualToString:@"1"]){
//        self.leftBt.hidden = NO;
//        [self.leftBt setTitle:@"取消订单" forState:(UIControlStateNormal)];
//    }else if ([_model.CanRefundItem isEqualToString:@"1"]){
//        self.leftBt.hidden = NO;
//        [self.leftBt setTitle:@"申请售后" forState:(UIControlStateNormal)];
//    }else if ([_model.CanReceiptOrder isEqualToString:@"1"] && [_model.CanResult isEqualToString:@"1"]){
//        self.leftBt.hidden = NO;
//        [self.centerBt setTitle:@"处理结果" forState:(UIControlStateNormal)];
//        [self.leftBt setTitle:@"查看物流" forState:(UIControlStateNormal)];
//        [self.rightBt setTitle:@"确认收货" forState:(UIControlStateNormal)];
//    }
//    //加入购物车 目前没有字段判断
//    
//    if(self.rightBt.hidden == YES){
//        [self.centerBt mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-10);
//                make.bottom.mas_equalTo(-28);
//                make.width.mas_equalTo(80);
//                make.height.mas_equalTo(30);
//        }];
//    }
    
}
//自己定义的一个订单状态 0 待支付 1 待发货 2 代收货 3 待评价 4 售后 5 关闭
-(void)clickRight:(UIButton *)sender{
    if([self.model.CanPay isEqualToString:@"1"]){
        self.tapRigthBlock(@"0");//待付款
    }else if ([self.model.AllState isEqualToString:@"0"]){
        self.tapRigthBlock(@"1");//待发货
    }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
        if([self.model.CanResult isEqualToString:@"1"]){
            self.tapRigthBlock(@"4");//售后
        }else{
            self.tapRigthBlock(@"2");//待收货
        }
    }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"]){
        self.tapRigthBlock(@"4");//售后
    }else if ([self.model.AllState isEqualToString:@"2"]){
        self.tapRigthBlock(@"3");
    }else if ([self.model.AllState isEqualToString:@"10"]){
        self.tapRigthBlock(@"4");
    }else if ([self.model.AllState isEqualToString:@"5"]){// AllState 6 仓库打包中 7 定金已支付
        self.tapRigthBlock(@"5");
    }else{
        self.tapRigthBlock(@"1");
    }
}

//-(void)clickRight{
//    if([self.model.CanPay isEqualToString:@"1"]){
//        self.tapRigthBlock(@"CanPay");
//    }else if ([self.model.CanAssessOrder isEqualToString:@"1"]){
//        self.tapRigthBlock(@"CanAssessOrder");
//    }else if ([self.model.CanReceiptOrder isEqualToString:@"1"]){
//        self.tapRigthBlock(@"CanReceiptOrder");
//    }else if ([self.model.CanResult isEqualToString:@"1"]){
//        self.tapRigthBlock(@"CanResult");
//    }else if ([self.model.CanTips isEqualToString:@"1"]){
//        self.tapRigthBlock(@"CanTips");
//    }else if ([self.model.CanReceiptOrder isEqualToString:@"1"] && [self.model.CanResult isEqualToString:@"1"]){
//        self.tapRigthBlock(@"CanReceiptOrder");
//    }
//}

-(void)clickCenter:(UIButton *)sender{
    if([self.model.CanPay isEqualToString:@"1"]){
        self.tapCenterBlock(@"0");
    }else if ([self.model.AllState isEqualToString:@"0"]){
        self.tapCenterBlock(@"1");//待发货
    }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
        if([self.model.CanResult isEqualToString:@"1"]){
            self.tapCenterBlock(@"4");//售后
        }else{
            self.tapCenterBlock(@"2");//待收货
        }
    }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"]){
        self.tapCenterBlock(@"4");//售后
    }else if ([self.model.AllState isEqualToString:@"2"]){
        self.tapCenterBlock(@"3");
    }else if ([self.model.AllState isEqualToString:@"10"]){
        self.tapCenterBlock(@"4");
    }else if ([self.model.AllState isEqualToString:@"5"]){
        self.tapCenterBlock(@"5");
    }else{// AllState 6 仓库打包中 7 定金已支付
        self.tapCenterBlock(@"1");
    }
}

//-(void)clickCenter{
//    if([self.model.CanAddress isEqualToString:@"1"]){
//        self.tapCenterBlock(@"CanAddress");
//    }else if ([self.model.CanReceiptOrder isEqualToString:@"1"] && [self.model.CanResult isEqualToString:@"1"]){
//        self.tapCenterBlock(@"CanResult");
//    }else if ([self.model.CanExpress isEqualToString:@"1"]){
//        self.tapCenterBlock(@"CanExpress");
//    }else if ([self.model.CanReceiptOrder isEqualToString:@"1"] && [self.model.CanResult isEqualToString:@"1"]){
//        self.tapCenterBlock(@"CanResult");
//    }
//    //还有一个售后评价目前没字段判断
//}

-(void)clickLeft:(UIButton *)sender{
    if([self.model.CanPay isEqualToString:@"1"]){
        self.tapLeftBlock(@"0");
    }else if ([self.model.AllState isEqualToString:@"0"]){
        self.tapLeftBlock(@"1");//待发货
    }else if ([self.model.AllState isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"20"]){
        if([self.model.CanResult isEqualToString:@"1"]){
            self.tapLeftBlock(@"4");//售后
        }else{
            self.tapLeftBlock(@"2");//待收货
        }
    }else if ([self.model.AllState isEqualToString:@"3"] || [self.model.AllState isEqualToString:@"4"]){
        self.tapLeftBlock(@"4");//售后
    }else if ([self.model.AllState isEqualToString:@"2"]){
        self.tapLeftBlock(@"3");
    }else if ([self.model.AllState isEqualToString:@"10"]){
        self.tapLeftBlock(@"4");
    }else if ([self.model.AllState isEqualToString:@"5"]){
        self.tapCenterBlock(@"5");
    }else{// AllState 6 仓库打包中 7 定金已支付
        self.tapLeftBlock(@"1");
    }
}

//-(void)clickLeft{
//    if([self.model.CanCancel isEqualToString:@"1"]){
//        self.tapLeftBlock(@"CanCancel");
//    }else if ([self.model.CanRefundItem isEqualToString:@"1"]){
//        self.tapLeftBlock(@"CanRefundItem");
//    }else if ([self.model.CanReceiptOrder isEqualToString:@"1"] && [self.model.CanResult isEqualToString:@"1"]){
//        self.tapLeftBlock(@"CanExpress");
//    }
//    //还有加入购物车 目前没字段判断
//}

-(void)clickCopyNo{
    self.tapCopyBlock(self.model.OrderNumber);
}

@end
