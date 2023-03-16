//
//  MMRefundGoodsInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/19.
//

#import "MMRefundGoodsInfoView.h"
#import "MMOrderListGoodsItemModel.h"

@interface MMRefundGoodsInfoView ()
@property (nonatomic, strong) MMOrderGoodsItem *goodsView;
@end

@implementation MMRefundGoodsInfoView

-(MMOrderGoodsItem *)goodsView{
    KweakSelf(self);
    if(!_goodsView){
        _goodsView = [[MMOrderGoodsItem alloc]initWithFrame:CGRectMake(0, 68, WIDTH - 20, 124 * self.model.itemlist.count)];
        _goodsView.arr = self.model.itemlist;
        _goodsView.tapGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapGoodsBlock(router);
        };
    }
    return _goodsView;
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
    UILabel *lab1 = [UILabel publicLab:@"商品信息" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab1.frame = CGRectMake(14, 16, 70, 16);
    [self addSubview:lab1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 47, WIDTH - 44, 1)];
    line.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    [self addSubview:line];
    
    [self addSubview:self.goodsView];
    
    NSArray *arr = @[@"退款原因",@"退款金额",@"申请时间",@"退款编号"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsView.frame) + 30 * i, WIDTH - 20, 30)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 150;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(14);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(14);
        }];
        
        UILabel *conLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        conLa.preferredMaxLayoutWidth = 280;
        [conLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:conLa];
        
        [conLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab.mas_right).offset(30);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(14);
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
        [view addSubview:copyBt];
        copyBt.hidden = YES;
          
        [copyBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-12);
                make.centerY.mas_equalTo(view);
                make.width.mas_equalTo(34);
                make.height.mas_equalTo(17);
        }];
        
        if(i == 0){
            conLa.text = self.model.RefundReason;
        }else if (i == 1){
            conLa.text = @"目前没有此字段";
        }else if (i == 2){
            conLa.text = [self.model.HandleTime substringToIndex:10];;
        }else{
            conLa.text = self.model.OrderNumber;
            copyBt.hidden = NO;
        }
    }
    
}

-(void)setModel:(MMRefundResultModel *)model{
    _model = model;
    [self creatUI];
}

-(void)clickCopyNo{
    
}

@end
