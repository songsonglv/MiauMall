//
//  MMSecondPageThreeImgThreeCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import "MMSecondPageThreeImgThreeCell.h"

@interface MMSecondPageThreeImgThreeCell ()
@property (nonatomic, strong) NSMutableArray *linkArr;
@property (nonatomic, strong) NSMutableArray *imgArr;

@end

@implementation MMSecondPageThreeImgThreeCell

-(NSMutableArray *)imgArr{
    if(!_imgArr){
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

-(NSMutableArray *)linkArr{
    if(!_linkArr){
        _linkArr = [[NSMutableArray alloc]init];
    }
    return _linkArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = TCUIColorFromRGB(0xffffff);
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    CGFloat wid = (WIDTH - 30)/3;
    
    for (int i = 0; i < imgArr.count; i++) {
        NSInteger row = i/3;
        //(WIDTH - 10 * (i + 1))/imgArr.count;
        MMHomeImageModel *imageModel = imgArr[i];
        UIImageView *image = [[UIImageView alloc]init];
        [image sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        image.userInteractionEnabled = YES;
        [self.contentView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5 + (wid + 10) * i);
            make.top.mas_equalTo(5 + 140 * row);
            make.width.mas_equalTo(wid);
            make.bottom.mas_equalTo(130);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 100 + i;
        [btn setBackgroundColor:UIColor.clearColor];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [image addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.bottom.mas_equalTo(0);
        }];
    }
}

-(void)clickBtn:(UIButton *)sender{
    MMHomeImageModel *imageModel = self.imgArr[sender.tag - 100];
    self.TapThreeImgThreeBlock(imageModel.link2);
}

@end
