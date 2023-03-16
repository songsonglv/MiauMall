//
//  MMZhongCaoWebItemView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/3.
//

#import "MMZhongCaoWebItemView.h"
#import <WebKit/WebKit.h>


@interface MMZhongCaoWebItemView ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *scrollView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) UIView *goodsListView;

@end

@implementation MMZhongCaoWebItemView

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
//    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
//    self.webView.backgroundColor = TCUIColorFromRGB(0xffffff);
//    self.webView.navigationDelegate = self;
//    self.webView.UIDelegate = self;
//    self.webView.opaque = NO;
//    self.webView.scrollView.scrollEnabled = NO;
//    [self addSubview:self.webView];
//    //WKWebView
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    UIView *scrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *goodsListV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), WIDTH, 0)];
    [self addSubview:goodsListV];
    self.goodsListView = goodsListV;
}

-(void)setModel:(MMZhongCaoInfoItemModel *)model{
    _model = model;
    
    NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:_model.ProductList];
    if(arr.count > 0){
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
//            btn.backgroundColor = UIColor.redColor;
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:btn];
            
            hei += 126;
        }
        self.height = hei;
        self.goodsListView.height = hei;
    }else{
        
    }
    
}

-(void)setHeiArr:(NSArray *)heiArr{
    _heiArr = heiArr;
    [self setUI];
}

-(void)setUI{
    CGFloat hei = 0;
    NSArray *arr = [self.model.ContsStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < self.heiArr.count; i++) {
        NSString *heistr = self.heiArr[i];
        float hei1 = [heistr floatValue];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, hei1)];
        image.userInteractionEnabled = YES;
        [image sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
        [self.scrollView addSubview:image];
        hei += hei1;
    }
    self.scrollView.height = hei;
    self.goodsListView.y = hei;
}

-(void)clickBt:(UIButton *)sender{
    NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:_model.ProductList];
    MMHomeRecommendGoodsModel *model = arr[sender.tag - 100];
    self.tapGoodsBlock(model.Url);
}

#pragma mark webView delegate
//WKWebView
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    KweakSelf(self);
//    [webView evaluateJavaScript:@"document.body.scrollHeight"
//              completionHandler:^(id result, NSError *_Nullable error) {
//        CGFloat hei = [result floatValue];
//        weakself.webView.height = hei;
//        weakself.goodsListView.y = CGRectGetMaxY(weakself.webView.frame);
//        weakself.returnHeiBlock(CGRectGetMaxY(weakself.webView.frame));
//    }];
//}

//监听高度变化
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        NSLog(@"%.f",self.webView.scrollView.contentSize.height);
//        self.webView.height = self.webView.scrollView.contentSize.height;
//        self.goodsListView.y = CGRectGetMaxY(self.webView.frame);
////        self.returnHeiBlock(CGRectGetMaxY(self.webView.frame));
//        self.hei = CGRectGetMaxY(self.webView.frame);
//    }
//}
@end
