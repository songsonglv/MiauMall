//
//  MMStackBannerCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/8.
//  堆叠轮博

#import "MMStackBannerCell.h"
@interface MMStackBannerCell ()<GKCycleScrollViewDataSource,GKCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *imgArr;//model数组
@property (nonatomic, strong) NSMutableArray *imageArr;//url数组
@property (nonatomic, strong) GKCycleScrollView *cycleScrollView;
@property (nonatomic, assign) BOOL                  isClickCategory;
@property (nonatomic, assign) BOOL                  isSelectCategory;

@end

@implementation MMStackBannerCell

-(GKCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[GKCycleScrollView alloc]initWithFrame:CGRectMake(0,0, WIDTH, 200)];
        _cycleScrollView.dataSource = self;
        _cycleScrollView.delegate = self;
        _cycleScrollView.isChangeAlpha = NO;
        _cycleScrollView.isAutoScroll = NO;
        _cycleScrollView.isInfiniteLoop = YES;
        _cycleScrollView.leftRightMargin = -10;
        _cycleScrollView.topBottomMargin = 30;
    }
    return _cycleScrollView;
}

-(NSMutableArray *)imgArr{
    if(!_imgArr){
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.contentView addSubview:self.cycleScrollView];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
   
    
}

-(void)setHeiStr:(NSString *)heiStr{
    _heiStr = heiStr;
    [self loadUI];
}



-(void)loadUI{
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:self.model.cont.imglist];
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    for (MMHomeImageModel *model1 in imgArr) {
        [self.imageArr addObject:model1.url];
    }
    self.cycleScrollView.height = [self.heiStr floatValue];
    [self.cycleScrollView reloadData];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.imageArr.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    NSString *url = self.imageArr[index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(250, [self.heiStr floatValue]);
}


-(void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index{
    MMHomeImageModel *model = self.imgArr[index];
    self.tapImageBlock(model.link2);
}

@end
