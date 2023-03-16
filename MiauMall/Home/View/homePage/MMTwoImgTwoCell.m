//
//  MMTwoImgTwoCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/9.
//

#import "MMTwoImgTwoCell.h"

@interface MMTwoImgTwoCell ()
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) float hei;
@end

@implementation MMTwoImgTwoCell

-(NSMutableArray *)imgArr{
    if(!_imgArr){
        _imgArr = [[NSMutableArray alloc]init];
    }
    return _imgArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
}

-(void)setHeiStr:(NSString *)heiStr{
    _heiStr = heiStr;
    self.hei = [_heiStr floatValue];
    [self loadUI];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
   
}

-(void)loadUI{
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    CGFloat wid = (WIDTH - 20)/2;
    CGFloat top = [_model.margin1 floatValue];
    CGFloat height = self.hei;
    CGFloat hei = top;
    for (int i = 0; i < imgArr.count; i++) {
        MMHomeImageModel *imageModel = imgArr[i];
        NSInteger row = i/2;
        NSInteger column = i%2;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5 + (wid + 10) * column,hei + row * (height + 10), wid, height)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        image.userInteractionEnabled = YES;
        [self.contentView addSubview:image];
        
        
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
