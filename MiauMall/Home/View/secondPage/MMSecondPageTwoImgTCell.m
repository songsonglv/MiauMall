//
//  MMSecondPageTwoImgTCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import "MMSecondPageTwoImgTCell.h"
@interface MMSecondPageTwoImgTCell ()
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation MMSecondPageTwoImgTCell

-(NSMutableArray *)imgArr{
    if(!_imgArr){
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
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
    CGFloat margin1 = [_model.margin1 floatValue];
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    CGFloat wid = (WIDTH - 20)/2;
    for (int i = 0; i < imgArr.count; i++) {
        //(WIDTH - 10 * (i + 1))/imgArr.count;
        MMHomeImageModel *imageModel = imgArr[i];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5 + i *(wid + 10), margin1, wid, self.contentView.height - margin1)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        image.userInteractionEnabled = YES;
        [self.contentView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5 + (wid + 10) * i);
            make.top.mas_equalTo(margin1);
            make.width.mas_equalTo(wid);
            make.bottom.mas_equalTo(-10);
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
    self.TapImgTBlock(imageModel.link2);
}

@end
