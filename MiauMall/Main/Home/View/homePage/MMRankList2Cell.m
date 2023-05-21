//
//  MMRankList2Cell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/6.
//

#import "MMRankList2Cell.h"
#import "MMRankList2GoodsView.h"

@interface MMRankList2Cell ()
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) UIScrollView *scrollView;//top btn背景view
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) MMRankList2GoodsView *goodsView;
@property (nonatomic, strong) UIColor *norBgColor;
@property (nonatomic, strong) UIColor *seleBgColor;
@property (nonatomic, strong) UIColor *norTextColor;
@property (nonatomic, strong) UIColor *seleTextColor;
@property (nonatomic, strong) UIColor *norBorderColor;
@property (nonatomic, strong) UIColor *seleBorderColor;
@end

@implementation MMRankList2Cell

-(MMRankList2GoodsView *)goodsView{
    KweakSelf(self);
    if(!_goodsView){
        _goodsView = [[MMRankList2GoodsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), WIDTH, 202)];
        _goodsView.tapRankList2Goodsblock = ^(NSString * _Nonnull router) {
            weakself.TapRankListTwoGoodsBlock(router);
        };
        _goodsView.tapRankList2GoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapRankListwoGoodsCarBlock(router);
        };
    }
    return _goodsView;
}

-(NSMutableArray *)titleArr{
    if(!_titleArr){
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

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
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 52)];
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(WIDTH, 52);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    [self.contentView addSubview:self.goodsView];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *arr = [MMHotListItemModel mj_objectArrayWithKeyValuesArray:_model.cont.hotlist];
    for (MMHotListItemModel *model1 in arr) {
        NSArray *arr1 = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:model1.list];
        [self.titleArr addObject:model1.SortName];
        [self.goodsArr addObject:arr1];
    }
    NSArray *arr1 = [[NSArray alloc]init];
    if(arr.count > 0){
        arr1 = self.goodsArr[0];
    }
   
    self.goodsView.goodsArr = arr1;
    self.norBgColor = [UIColor colorWithWzxString:_model.defin4];
    self.seleBgColor = [UIColor colorWithWzxString:_model.defin6];
    self.norBorderColor = [UIColor colorWithWzxString:_model.defin3];
    self.seleBorderColor = [UIColor colorWithWzxString:_model.defin6];
    self.norTextColor = [UIColor colorWithWzxString:_model.defin3];
    self.seleTextColor = [UIColor colorWithWzxString:_model.defin5];
    
    
    CGFloat wid = 10;
    for (int i = 0; i < self.titleArr.count; i++) {
        NSString *text = self.titleArr[i];
        CGSize size = [NSString sizeWithText:text font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT,14)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(wid, 14, size.width + 17, 24)];
        btn.tag = 100 + i;
        btn.backgroundColor = self.norBgColor;
        [btn setTitle:text forState:(UIControlStateNormal)];
        [btn setTitleColor:self.seleTextColor forState:(UIControlStateSelected)];
        [btn setTitleColor:self.norTextColor forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = self.norBorderColor.CGColor;
        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollView addSubview:btn];
        
        if(i == 0){
            btn.selected = YES;
            btn.backgroundColor = self.seleBgColor;
            self.selectBt = btn;
        }
        
        wid += btn.size.width + 12;
    }
    
    self.scrollView.contentSize = CGSizeMake(wid, 52);
}

-(void)clickBt:(UIButton *)sender{
    
    if([self.selectBt isEqual:sender]){
        
    }else{
        self.selectBt.selected = NO;
        self.selectBt.backgroundColor = self.norBgColor;
        self.selectBt.layer.borderColor = self.norBorderColor.CGColor;
        sender.backgroundColor = self.seleBgColor;
        sender.layer.borderColor = self.seleBorderColor.CGColor;
        sender.selected = YES;
        self.selectBt = sender;
        NSArray *arr = self.goodsArr[sender.tag - 100];
        self.goodsView.goodsArr = arr;
        
    }
}


@end
