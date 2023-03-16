//
//  MMProList1Cell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/7.
//

#import "MMProList1Cell.h"
@interface MMProList1Cell ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@end

@implementation MMProList1Cell

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
    scrollView.backgroundColor = UIColor.clearColor;
    scrollView.scrollEnabled = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist];
    self.goodsArr = [NSMutableArray arrayWithArray:arr];
    NSInteger row = arr.count/2;
    row = arr.count % 2 > 0 ? row + 1 : row; //行数
    self.scrollView.height = 325 * row + 10;
    self.scrollView.contentSize = CGSizeMake(WIDTH, 325 * row + 10);
    CGFloat wid = (WIDTH - 30)/2;
    for (int i = 0; i < arr.count; i++) {
        MMHomeGoodsModel *model1 = arr[i];
        NSInteger row1 = i/2;
        NSInteger column = i%2;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + (wid + 10) * column, 10 + 325 * row1, wid, 315)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [self.scrollView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoods:)];
        [view addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 200 + i;
        
        UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, wid)];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:model1.url] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [view addSubview:goodsImage];
        
        UILabel *shorLa = [UILabel publicLab:model1.mark textColor:TCUIColorFromRGB(0x2c2c2c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
        shorLa.preferredMaxLayoutWidth = wid - 14;
        [shorLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:shorLa];
        
        [shorLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(7);
                    make.top.mas_equalTo(wid + 10);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *nameLa = [UILabel publicLab:model1.name textColor:TCUIColorFromRGB(0x2c2c2c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        nameLa.preferredMaxLayoutWidth = wid - 14;
        [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(7);
                    make.top.mas_equalTo(shorLa.mas_bottom).offset(10);
                    make.width.mas_equalTo(wid - 14);
        }];
        
        CGSize size = [NSString sizeWithText:model1.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(wid - 14,MAXFLOAT)];
        if(size.height < 18){
            nameLa.numberOfLines = 1;
        }else{
            nameLa.numberOfLines = 2;
        }
        
        NSInteger realnum = [model1.realnumber integerValue];
        if(realnum > 0){
            CGSize size1 = [NSString sizeWithText:@"48h发货" font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
            UIView *labV = [[UIView alloc]init];
            labV.backgroundColor = UIColor.whiteColor;
            labV.layer.masksToBounds = YES;
            labV.layer.cornerRadius = 2.5;
            labV.layer.borderColor = redColor2.CGColor;
            labV.layer.borderWidth = 0.5;
            [view addSubview:labV];
            
            [labV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(7);
                            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
                            make.width.mas_equalTo(size1.width + 40);
                            make.height.mas_equalTo(15);
            }];
            
            UIView *redV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 15)];
            redV.backgroundColor = redColor2;
            redV.layer.masksToBounds = YES;
            redV.layer.cornerRadius = 2.5;
            [labV addSubview:redV];
            
            UIImageView *lightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lightning"]];
            lightImage.frame = CGRectMake(2, 1.5, 7, 12);
            [labV addSubview:lightImage];
            
            UILabel *shanLa = [UILabel publicLab:@"闪送" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            shanLa.frame = CGRectMake(10, 2, 21, 11);
            [labV addSubview:shanLa];
            
            UILabel *liLa = [UILabel publicLab:@"48h发货" textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            liLa.frame = CGRectMake(36, 2, size1.width, 11);
            [labV addSubview:liLa];
            
            
            
        
        }else{
            CGSize size1 = [NSString sizeWithText:@"预计3-7个工作日发货" font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(MAXFLOAT,11)];
            
            UIView *labV = [[UIView alloc]init];
            labV.backgroundColor = UIColor.whiteColor;
            labV.layer.masksToBounds = YES;
            labV.layer.cornerRadius = 2.5;
            labV.layer.borderColor = greenColor1.CGColor;
            labV.layer.borderWidth = 0.5;
            [view addSubview:labV];
            
            [labV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(7);
                            make.top.mas_equalTo(nameLa.mas_bottom).offset(10);
                            make.width.mas_equalTo(size1.width + 30);
                            make.height.mas_equalTo(15);
            }];
            
            UIView *greenV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 26, 15)];
            [self setView:greenV andCorlors:@[greenColor1,TCUIColorFromRGB(0x87d51c)]];
            greenV.layer.masksToBounds = YES;
            greenV.layer.cornerRadius = 2.5;
            [labV addSubview:greenV];
            
            UILabel *shanLa = [UILabel publicLab:@"预定" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            shanLa.frame = CGRectMake(2, 2, 22, 11);
            [labV addSubview:shanLa];
            
            UILabel *liLa = [UILabel publicLab:@"预计3-7个工作日发货" textColor:greenColor1 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            liLa.frame = CGRectMake(28, 2, size1.width, 11);
            [labV addSubview:liLa];
        }
        
        UILabel *priceLa = [UILabel publicLab:model1.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingfangSC-Medium" size:12 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = wid - 14;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(7);
                        make.bottom.mas_equalTo(-22);
                        make.height.mas_equalTo(14);
        }];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                        confer.text(model1.pricesign).textColor(redColor2).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]);
                        confer.text(model1.pricevalue).textColor(redColor2).font([UIFont fontWithName:@"PingfangSC-SemiBold" size:16]);
        }];
        
        UILabel *oldLa = [UILabel publicLab:model1.oldpriceshow textColor:TCUIColorFromRGB(0x7d7d7d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model1.oldpriceshow attributes:attribtDic];
        oldLa.attributedText = attribtStr;
        oldLa.preferredMaxLayoutWidth = 180;
        [oldLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:oldLa];
        
        [oldLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(7);
                        make.bottom.mas_equalTo(-8);
                        make.height.mas_equalTo(10);
        }];
        
        
    }
}

-(void)clickGoods:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    MMHomeGoodsModel *model = self.goodsArr[[tap view].tag - 200];
    self.tapProlist1Block(model.link2);
}


//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}



@end
