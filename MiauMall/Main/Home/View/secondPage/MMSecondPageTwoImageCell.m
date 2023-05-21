//
//  MMSecondPageTwoImageCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/28.
//

#import "MMSecondPageTwoImageCell.h"

@interface MMSecondPageTwoImageCell ()
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation MMSecondPageTwoImageCell

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
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    for (int i = 0; i < imgArr.count; i++) {
        CGFloat wid = WIDTH/imgArr.count;
        //(WIDTH - 10 * (i + 1))/imgArr.count;
        MMHomeImageModel *imageModel = imgArr[i];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(wid * i, 0, wid, self.contentView.height)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        image.userInteractionEnabled = YES;
        [self.contentView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wid * i);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(wid);
            make.bottom.mas_equalTo(0);
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
    self.TapImgBlock(imageModel.link2);
}

@end
