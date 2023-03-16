//
//  MMSecondPageBannerCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//  二级页面bannercell

#import "MMSecondPageBannerCell.h"

@interface MMSecondPageBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *linkArr;
@end

@implementation MMSecondPageBannerCell
-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(NSMutableArray *)linkArr{
    if(!_linkArr){
        _linkArr = [NSMutableArray array];
    }
    return _linkArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self setupUI];
}
    return self;
}

-(void)setupUI{
    self.cycleView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
    self.cycleView.delegate = self;
    self.cycleView.showPageControl = YES;
    self.cycleView.autoScrollTimeInterval = 4.0;
    self.cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleView.placeholderImage = [UIImage imageNamed:@"tu1.jpg"];
    [self.contentView addSubview:self.cycleView];
    
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    
    if(_model.cont.imglist.count > 0){
        NSArray *images = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
        for(int i = 0;i < images.count; i++){
            MMHomeImageModel *imageModel = images[i];
            [self.imageArr addObject:imageModel.url];
            [self.linkArr addObject:imageModel.link2];
        }
    }

    self.cycleView.imageURLStringsGroup = self.imageArr;
}

#pragma mark -- SDCycleScrollViewDelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    KweakSelf(self);
    self.BannerTapBlock(weakself.linkArr[index]);
}
@end
