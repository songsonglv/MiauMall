//
//  MMCycleTableViewCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//  首页  banner

#import "MMCycleTableViewCell.h"
@interface MMCycleTableViewCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *linksArr;

@end

@implementation MMCycleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xc53d2b);
//    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.contentView.height)];
//    [self.contentView addSubview:bgImageV];
    
//    self.bgImageView = bgImageV;
    
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

-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}

-(NSMutableArray *)linksArr{
    if(!_linksArr){
        _linksArr = [[NSMutableArray alloc]init];
    }
    return _linksArr;
}


//-(SDCycleScrollView *)cycleView{
//    if (!_cycleView) {
//        _cycleView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.contentView.height)];
////        _cycleView.backgroundColor = TCUIColorFromRGB(0xffffff);
//        _cycleView.delegate = self;
//        _cycleView.pageControlAliment = SDCycleScrollViewPageContolStyleClassic;
//        _cycleView.pageControlRightOffset = -150;
////        _cycleView.layer.masksToBounds = YES;
////        _cycleView.layer.cornerRadius = 7;
//    }
//    return _cycleView;
//}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_model.bgImage]];
    
    if(_model.cont.imglist.count > 0){
        NSArray *images = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
        for(int i = 0;i < images.count; i++){
            MMHomeImageModel *imageModel = images[i];
            [self.imageArr addObject:imageModel.url];
            [self.linksArr addObject:imageModel.link2];
        }
    }

    self.cycleView.imageURLStringsGroup = self.imageArr;
}

#pragma mark -- SDCycleScrollViewDelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    KweakSelf(self);
    self.BannerTapBlock(weakself.linksArr[index]);
}


@end
