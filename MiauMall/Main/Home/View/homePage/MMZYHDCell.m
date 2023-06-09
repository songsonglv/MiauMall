//
//  MMZYHDCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import "MMZYHDCell.h"
@interface MMZYHDCell ()
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MMZYHDCell

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 440)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.contentSize = CGSizeMake(WIDTH, 440);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist];
    self.goodsArr = [NSMutableArray arrayWithArray:arr];
    NSInteger column = (arr.count%2) < 1 ?arr.count/2 : arr.count/2 + 1;
    CGFloat wid = (WIDTH - 30)/3;
    self.scrollView.contentSize = CGSizeMake(15 + (wid + 5) * column, 440);
    for (int i = 0; i < arr.count ; i++) {
        NSInteger row = i/column;
        NSInteger column1 = i % column;
        MMHomeGoodsModel *model1 = arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5 + (wid + 5) * column1, row * 223, wid, 217)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.scrollView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoods:)];
        [view addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 200 + i;
        
        UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, wid)];
        [imageIcon sd_setImageWithURL:[NSURL URLWithString:model1.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        imageIcon.layer.masksToBounds = YES;
        imageIcon.layer.cornerRadius = 6;
        [view addSubview:imageIcon];
        
        UILabel *shortLa = [UILabel publicLab:model1.mark textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
        shortLa.frame = CGRectMake(5, wid + 8, wid - 10, 11);
        [view addSubview:shortLa];
        
        UILabel *nameLa = [UILabel publicLab:model1.name textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        nameLa.preferredMaxLayoutWidth = wid - 10;
        [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(5);
                    make.top.mas_equalTo(wid + 25);
                    make.width.mas_equalTo(wid - 10);
        }];
        
        CGSize size = [NSString sizeWithText:model1.name font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(wid - 10,MAXFLOAT)];
        if(size.height < 18){
            nameLa.numberOfLines = 1;
        }else{
            nameLa.numberOfLines = 2;
        }
        
        UILabel *priceLa = [UILabel publicLab:model1.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = wid - 30;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(5);
                    make.bottom.mas_equalTo(-22);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *oldPriceLa = [UILabel publicLab:model1.oldpriceshow textColor:TCUIColorFromRGB(0x696969) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model1.oldpriceshow attributes:attribtDic];
        oldPriceLa.attributedText = attribtStr;
        oldPriceLa.preferredMaxLayoutWidth = wid - 10;
        [oldPriceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:oldPriceLa];
        
        [oldPriceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(5);
                    make.bottom.mas_equalTo(-7);
                    make.height.mas_equalTo(10);
        }];
        
        UIButton *carBt = [[UIButton alloc]init];
        carBt.tag = 100 + i;
        [carBt setImage:[UIImage imageNamed:@"car_nine_icon"] forState:(UIControlStateNormal)];
        [carBt addTarget:self action:@selector(clickCar:) forControlEvents:(UIControlEventTouchUpInside)];
        carBt.timeInterval = 2.0;
        [view addSubview:carBt];
        
        [carBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-8);
                    make.bottom.mas_equalTo(-20);
                    make.width.height.mas_equalTo(17);
        }];
    }
}



-(void)clickGoods:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    MMHomeGoodsModel *model = self.goodsArr[[tap view].tag - 200];
    self.TapZYHDGoodsBlock(model.link);
}

-(void)clickCar:(UIButton *)sender{
    MMHomeGoodsModel *model = self.goodsArr[sender.tag - 100];
    self.tapZYHDGoodsCarBlock(model.ID);
}

@end
