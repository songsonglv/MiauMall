//
//  MMZhongCaoInfoCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/8.
//

#import "MMZhongCaoInfoCell.h"
#import <WebKit/WebKit.h>

@interface MMZhongCaoInfoCell ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) UIView *goodsListView;

@end

@implementation MMZhongCaoInfoCell

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
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1000)];
    self.webView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.opaque = NO;
//    [self.webView sizeToFit];
    self.webView.scrollView.scrollEnabled = NO;
    [self.contentView addSubview:self.webView];
        //WKWebView

    
    UIView *goodsListV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), WIDTH, 0)];
    [self.contentView addSubview:goodsListV];
    self.goodsListView = goodsListV;
}

-(void)setModel:(MMZhongCaoInfoItemModel *)model{
    _model = model;
    [self.webView loadHTMLString:_model.Conts baseURL:nil];
    NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:_model.ProductList];
    self.goodsListView.height = arr.count > 0 ? 26 + arr.count * 126 : 0;
    self.goodsArr = [NSMutableArray arrayWithArray:arr];
    CGFloat hei = 26;
    for (int i = 0; i < arr.count; i++) {
        MMHomeRecommendGoodsModel * model1 = arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 18 + 126 * i, WIDTH - 20, 116)];
        view.backgroundColor = TCUIColorFromRGB(0xf3f2f1);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [self.goodsListView addSubview:view];
        
        UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(8, 7, 102, 102)];
        imageIcon.layer.masksToBounds = YES;
        imageIcon.layer.cornerRadius = 4;
        [imageIcon sd_setImageWithURL:[NSURL URLWithString:model1.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [view addSubview:imageIcon];
        
        UILabel *nameLa = [UILabel publicLab:model1.Name textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        CGSize size = [NSString sizeWithText:model1.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] maxSize:CGSizeMake(WIDTH - 147,MAXFLOAT)];
        nameLa.preferredMaxLayoutWidth = WIDTH - 147;
        [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(117);
                        make.top.mas_equalTo(15);
                        make.width.mas_equalTo(WIDTH - 147);
        }];
        
        if(size.height < 18){
            nameLa.numberOfLines = 1;
        }else{
            nameLa.numberOfLines = 2;
        }
        
        UILabel *markLa = [UILabel publicLab:model1.ShortName textColor:TCUIColorFromRGB(0x7d7d7d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        markLa.preferredMaxLayoutWidth = WIDTH - 147;
        [markLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:markLa];
        
        [markLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(117);
                        make.top.mas_equalTo(nameLa.mas_bottom).offset(8);
                        make.width.mas_equalTo(WIDTH - 147);
        }];
        
        UILabel *priceLa = [UILabel publicLab:model1.PriceShow textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = WIDTH - 147;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-10);
                        make.bottom.mas_equalTo(-16);
                        make.height.mas_equalTo(14);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 116)];
//        btn.backgroundColor = UIColor.redColor;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        hei += 126;
    }
    
    
}

-(void)setHeiStr:(NSString *)heiStr{
    _heiStr = heiStr;
    self.webView.height = [_heiStr floatValue];
    self.webView.scrollView.contentSize = CGSizeMake(WIDTH, [_heiStr floatValue]);
    self.goodsListView.y = CGRectGetMaxY(self.webView.frame);
}



-(void)clickBt:(UIButton *)sender{
    NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:_model.ProductList];
    MMHomeRecommendGoodsModel *model = arr[sender.tag - 100];
    self.tapGoodsBlock(model.Url);
}

@end
