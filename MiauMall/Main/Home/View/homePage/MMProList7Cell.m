//
//  MMProList7Cell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/7.
//

#import "MMProList7Cell.h"

@interface MMProList7Cell ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *goodsArr;

@end

@implementation MMProList7Cell

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.scrollEnabled = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
}


-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist];
    self.goodsArr = [NSMutableArray arrayWithArray:arr];
    self.scrollView.height = 134 * arr.count;
    self.scrollView.contentSize = CGSizeMake(WIDTH, 134 * arr.count);
    CGFloat hei = 0;
    for (int i = 0; i < arr.count; i++) {
        MMHomeGoodsModel *model1 = arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, hei, WIDTH - 20, 122)];
        view.backgroundColor = TCUIColorFromRGB(0xf6f6f6);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 7.5;
        [self.scrollView addSubview:view];
        
        hei += 134;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoods:)];
        [view addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 200 + i;
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 122, 122)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model1.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        goodsImage.layer.masksToBounds = YES;
        goodsImage.layer.cornerRadius = 7.5;
        [view addSubview:goodsImage];
        
        UILabel *nameLa = [UILabel publicLab:model1.name textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        CGSize size = [NSString sizeWithText:model1.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(WIDTH - 165,MAXFLOAT)];
        nameLa.preferredMaxLayoutWidth = WIDTH - 165;
        [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(133);
                    make.top.mas_equalTo(14);
                    make.width.mas_equalTo(WIDTH - 165);
        }];
        
        if(size.height < 18){
            nameLa.numberOfLines = 1;
        }else{
            nameLa.numberOfLines = 2;
        }
        
        UILabel *shortLa = [UILabel publicLab:model1.mark textColor:TCUIColorFromRGB(0x8c8c8c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Regular" size:12 numberOfLines:0];
        shortLa.preferredMaxLayoutWidth = WIDTH - 165;
        [shortLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:shortLa];
        
        [shortLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(133);
                    make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
                    make.height.mas_equalTo(12);
        }];
        
        UILabel *priceLa = [UILabel publicLab:model1.priceshow textColor:TCUIColorFromRGB(0xfd6522) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Semibold" size:16 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = WIDTH - 227;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(133);
                    make.bottom.mas_equalTo(-17);
                    make.height.mas_equalTo(14);
        }];
        
        UILabel *payLa = [UILabel publicLab:@"马上抢" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        payLa.backgroundColor = TCUIColorFromRGB(0xfd6522);
        payLa.layer.masksToBounds = YES;
        payLa.layer.cornerRadius = 4;
        [view addSubview:payLa];
        
        [payLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.bottom.mas_equalTo(-14);
                    make.width.mas_equalTo(60);
                    make.height.mas_equalTo(20);
        }];
        
        
    }
}

-(void)clickGoods:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    MMHomeGoodsModel *model = self.goodsArr[[tap view].tag - 200];
    self.TapPro7GoodsBlock(model.link2);
}
@end
