//
//  MMFootCollectionCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/15.
//

#import "MMFootCollectionCell.h"
#import "MMFootOrCollectGoodsModel.h"
#import "MMFootListView.h"

@interface MMFootCollectionCell ()
@property (nonatomic, strong) MMFootListView *footView;


@end

@implementation MMFootCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    self.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
    [self setupUI];
}
    return self;
}

-(MMFootListView *)footView{
    KweakSelf(self);
    if(!_footView){
        _footView = [[MMFootListView alloc]initWithFrame:CGRectMake(0, 55, WIDTH - 10, 178)];
        _footView.tapGoodsBlock = ^(NSString * _Nonnull router) {
            [weakself clickBt:router];
        };
    }
    return _footView;
}


-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    self.footView.footArr = _dataArr;
   
}

-(void)setupUI{
    UIView *contView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, WIDTH - 10, 234)];
    contView.backgroundColor = TCUIColorFromRGB(0xffffff);
    contView.layer.masksToBounds = YES;
    contView.layer.cornerRadius = 7.5;
    [self addSubview:contView];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"browseRecord"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(8, 14, 200, 16);
    [contView addSubview:titleLa];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 26, 18, 5, 10)];
    icon.image = [UIImage imageNamed:@"right_icon_gary"];
    [contView addSubview:icon];
    
    UILabel *moreLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"imore"] textColor:TCUIColorFromRGB(0x807f7f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    CGSize size = [NSString sizeWithText:moreLa.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    moreLa.frame = CGRectMake(WIDTH - 30 - size.width, 17, size.width, 12);
    [contView addSubview:moreLa];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 10, 42)];
    [btn addTarget:self action:@selector(clickMore) forControlEvents:(UIControlEventTouchUpInside)];
    [contView addSubview:btn];
    
    [contView addSubview:self.footView];
    
}

-(void)clickMore{
    self.tapMoreBlock(@"/member/home/zuji");
}

-(void)clickBt:(NSString *)router{
    self.tapGoodsBlock(router);
}
@end
