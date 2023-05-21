//
//  MMFootListView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/16.
//

#import "MMFootListView.h"
#import "MMFootOrCollectGoodsModel.h"
@interface MMFootListView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MMFootListView

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 10, 178)];
        _scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return _scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUI];
    }
    return self;
}

-(void)setUI{
    [self addSubview:self.scrollView];
}

-(void)setFootArr:(NSArray *)footArr{
    _footArr = footArr;
    self.scrollView.contentSize = CGSizeMake(96 * self.footArr.count + (self.footArr.count - 1) * 10, 178);
    for (int i = 0; i < self.footArr.count; i++) {
        MMFootOrCollectGoodsModel *model = self.footArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(106 * i, 0, 96, 178)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.scrollView addSubview:view];
        
        UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 96, 96)];
        [ima sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        [view addSubview:ima];
        
        UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 96;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(106);
        }];
        
        CGSize size = [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] maxSize:CGSizeMake(96,11)];
        
        if(size.height > 11){
            lab.numberOfLines = 2;
        }else{
            lab.numberOfLines = 1;
        }
        
        UILabel *priceLa = [UILabel publicLab:[NSString stringWithFormat:@"%@ %@",model.PriceSign,model.PriceValue] textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:10 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = 96;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(12);
        }];
        
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(model.PriceSign).font([UIFont fontWithName:@"PingFangSC-Medium" size:10]);
            confer.text(model.PriceValue).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 10, 178)];
        btn.backgroundColor = UIColor.clearColor;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
    }
    
}

-(void)clickBt:(UIButton *)sender{
    MMFootOrCollectGoodsModel *model = self.footArr[sender.tag - 100];
    self.tapGoodsBlock(model.Url);
}
@end
