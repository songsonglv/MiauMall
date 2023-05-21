//
//  MMOrderDetailGoodsView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/16.
//

#import "MMOrderDetailGoodsView.h"
#import "MMOrderListGoodsItemModel.h"
#import "MMOrderDetailInfoModel.h"
@interface MMOrderDetailGoodsView ()
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) MMOrderDetailInfoModel *mode;

@end

@implementation MMOrderDetailGoodsView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return self;
}

-(NSMutableArray *)arr{
    if(!_arr){
        _arr = [NSMutableArray array];
    }
    return _arr;
}

-(void)setUI{
    self.backgroundColor = TCUIColorFromRGB(0xffffff);
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"proInfo"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab.frame = CGRectMake(14, 16, 200, 16);
    [self addSubview:lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 47, WIDTH - 40, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    [self addSubview:line];
    CGFloat hei = CGRectGetMaxY(line.frame) + 20;
    for (int i = 0; i < self.arr.count; i++) {
        MMOrderListGoodsItemModel *model = self.arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH - 20, 146)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        hei += 162;
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 0, 100, 100)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 6;
        goodsImage.layer.borderColor = TCUIColorFromRGB(0xf0f0f0).CGColor;
        goodsImage.layer.borderWidth = 0.5;
        [view addSubview:goodsImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRouter:)];
        [view addGestureRecognizer:tap];
        UIView *singleTapView = [tap view];
        singleTapView.tag = i + 500;
        
        UILabel *goodsNameLa = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        goodsNameLa.frame = CGRectMake(118, 7, view.width - 128, 14);
        [view addSubview:goodsNameLa];
        
        if([model.Attribute isEqualToString:@""]){
            
        }else{
            UILabel *AttributeLa = [UILabel publicLab:model.Attribute textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            CGSize size = [AttributeLa sizeThatFits:CGSizeMake(MAXFLOAT,11)];
            AttributeLa.frame = CGRectMake(118, 32, size.width + 20, 18);
            [AttributeLa setBackgroundColor:TCUIColorFromRGB(0xf7f7f8)];
            AttributeLa.layer.masksToBounds = YES;
            AttributeLa.layer.cornerRadius = 9;
            [view addSubview:AttributeLa];
        }
        
        UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"x%@%@",model.Number,[UserDefaultLocationDic valueForKey:@"ipiece"]] textColor:TCUIColorFromRGB(0x8a8a8a) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        numLa.frame = CGRectMake(view.width - 45, 35, 35, 13);
        [view addSubview:numLa];
        
        UILabel *priceLa = [UILabel publicLab:model.MoneysShow textColor:TCUIColorFromRGB(0x242424) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth =  view.width - 128;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.top.mas_equalTo(67);
                    make.height.mas_equalTo(11);
        }];
        
        UILabel *acturaPriceLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"actualPayment"],model.SalesMoneyShow] textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        acturaPriceLa.preferredMaxLayoutWidth = view.width - 128;
        [acturaPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:acturaPriceLa];
        
        [acturaPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.top.mas_equalTo(88);
                    make.height.mas_equalTo(13);
        }];
        
        [acturaPriceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([UserDefaultLocationDic valueForKey:@"actualPayment"]).textColor(TCUIColorFromRGB(0x0b0b0b)).font([UIFont systemFontOfSize:13]);
            confer.text(model.SalesMoneyShow).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
        }];
        
        UILabel *stateLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        stateLa.preferredMaxLayoutWidth = view.width - 128;
        [stateLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:stateLa];
        
        [stateLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-10);
                    make.top.mas_equalTo(acturaPriceLa.mas_bottom).offset(12);
                    make.height.mas_equalTo(12);
        }];
        
        if([model.Processing isEqualToString:@"3"]){
            stateLa.text = @"已退款";
        }else if ([model.Processing isEqualToString:@"5"]){
            stateLa.text = @"已取消";
        }else{
            stateLa.text = @"";
        }
        
        UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 112, 116, 80, 30)];
        [applyBtn setTitle:[UserDefaultLocationDic valueForKey:@"refundRequest"] forState:(UIControlStateNormal)];
        [applyBtn setTitleColor:TCUIColorFromRGB(0x0b0b0b) forState:(UIControlStateNormal)];
        applyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        applyBtn.layer.masksToBounds = YES;
        applyBtn.layer.cornerRadius = 15;
        applyBtn.layer.borderColor = TCUIColorFromRGB(0x373737).CGColor;
        applyBtn.layer.borderWidth = 0.5;
        applyBtn.tag = 100 + i;
        applyBtn.hidden = YES;
        [applyBtn addTarget:self action:@selector(clickApply:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:applyBtn];
        
//        [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.mas_equalTo(-12);
//                    make.bottom.mas_equalTo(0);
//                    make.width.mas_equalTo(80);
//                    make.height.mas_equalTo(30);
//        }];
        
        UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 227, 116, 95, 30)];
        [addBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
        [addBt setTitleColor:TCUIColorFromRGB(0x0b0b0b) forState:(UIControlStateNormal)];
        addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        addBt.layer.masksToBounds = YES;
        addBt.layer.cornerRadius = 15;
        addBt.layer.borderColor = TCUIColorFromRGB(0x373737).CGColor;
        addBt.layer.borderWidth = 0.5;
        addBt.tag = 200 + i;
        addBt.hidden = YES;
        [addBt addTarget:self action:@selector(clickAddCar:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:addBt];
        
//        [addBt mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.mas_equalTo(applyBtn.mas_left).offset(-20);
//                    make.bottom.mas_equalTo(0);
//                    make.width.mas_equalTo(95);
//                    make.height.mas_equalTo(30);
//        }];
        
        if([self.model.CanPay isEqualToString:@"1"] || [self.model.AllState isEqualToString:@"2"] || [self.model.AllState isEqualToString:@"5"]){
            applyBtn.hidden = YES;
            addBt.x = WIDTH - 127;
            
        }
    }
}


-(void)clickApply:(UIButton *)sender{
    MMOrderListGoodsItemModel *model = self.arr[sender.tag - 100];
    self.tapApplyBlock(model.ItemID);
}

-(void)clickAddCar:(UIButton *)sender{
    MMOrderListGoodsItemModel *model = self.arr[sender.tag - 200];
    self.tapAddCarBlock(model.ItemID);
}

-(void)clickRouter:(UITapGestureRecognizer *)sender{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    MMOrderListGoodsItemModel *model = self.arr[[singleTap view].tag - 500];
    self.tapGoodsBlock(model.url);
}

-(void)setModel:(MMOrderDetailInfoModel *)model{
    _model = model;
    NSArray *arr = [MMOrderListGoodsItemModel mj_objectArrayWithKeyValuesArray:_model.itemlist];
    self.arr = [NSMutableArray arrayWithArray:arr];
    [self setUI];
}



@end
