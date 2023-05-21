//
//  MMNineImageCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import "MMNineImageCell.h"
#import "MMHomeGoodsModel.h"

@interface MMNineImageCell ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@end

@implementation MMNineImageCell

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
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
    self.scrollView.backgroundColor = UIColor.clearColor;
    self.scrollView.contentSize = CGSizeMake(WIDTH, 300);
    self.scrollView.pagingEnabled = YES;
    [self.contentView addSubview:self.scrollView];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSInteger pagenum = [_model.pagenum integerValue];
    NSInteger row = pagenum/3;
    NSArray *imgArr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist];
    self.goodsArr = [NSMutableArray arrayWithArray:imgArr];
    NSInteger page = imgArr.count/pagenum;
    page = imgArr.count % pagenum > 0 ? page + 1 : page;
    CGFloat wid = (WIDTH - 30)/3;
    self.scrollView.height = 200 * row;
    self.scrollView.contentSize = CGSizeMake(WIDTH * page, 200 * row);
    for (int i = 0; i < imgArr.count; i++) {
        MMHomeGoodsModel *model1 = imgArr[i];
        NSInteger page1 = i/pagenum;//页数
        NSInteger index = i%pagenum;//当页的第几个
        NSInteger row1 = index/3;   // 第几行
        NSInteger column = index%3; //第几列
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + (wid + 5) * column + WIDTH * page1, 200 * row1, wid, 192)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
        [self.scrollView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickGoods:)];
        [view addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 200 + i;
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((wid - 114)/2, 0, 114, 114)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model1.url] placeholderImage:[UIImage imageNamed:@"zhanwief"]];
        imageV.layer.masksToBounds = YES;
        imageV.layer.cornerRadius = 6;
        [view addSubview:imageV];
        
        UILabel *lab = [UILabel publicLab:model1.name textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        lab.preferredMaxLayoutWidth = wid - 16;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(8);
                    make.top.mas_equalTo(114);
                    make.width.mas_equalTo(wid - 16);
        }];
        
        CGSize size = [NSString sizeWithText:model1.name font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(wid - 16,MAXFLOAT)];
        if(size.height < 18){
            lab.numberOfLines = 1;
        }else{
            lab.numberOfLines = 2;
        }
        
        UILabel *priceLa = [UILabel publicLab:model1.priceshow textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = 150;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:priceLa];
        
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(8);
                    make.top.mas_equalTo(lab.mas_bottom).offset(10);
                    make.height.mas_equalTo(13);
        }];
        
        UILabel *oldLa = [UILabel publicLab:model1.oldpriceshow textColor:TCUIColorFromRGB(0x696969) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
        oldLa.preferredMaxLayoutWidth = 120;
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model1.oldpriceshow  attributes:attribtDic];
        oldLa.attributedText = attribtStr;
        [oldLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:oldLa];
        
        [oldLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.top.mas_equalTo(priceLa.mas_bottom).offset(6);
                    make.height.mas_equalTo(9);
        }];
        
        UIButton *carBt = [[UIButton alloc]init];
        [carBt setImage:[UIImage imageNamed:@"car_nine_icon"] forState:(UIControlStateNormal)];
        carBt.tag = 100 + i;
        [carBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [carBt setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        carBt.timeInterval = 2.0;
        [view addSubview:carBt];
        
        [carBt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-6);
                    make.bottom.mas_equalTo(-10);
                    make.width.height.mas_equalTo(17);
        }];
        
        
        
        
    }
}

-(void)clickGoods:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    MMHomeGoodsModel *model = self.goodsArr[[tap view].tag - 200];
    self.TapNineImageBlock(model.link);
}

-(void)clickBt:(UIButton *)sender{
    MMHomeGoodsModel *model = self.goodsArr[sender.tag - 100];
    self.tapNineImageCarBlock(model.ID);
}
@end
