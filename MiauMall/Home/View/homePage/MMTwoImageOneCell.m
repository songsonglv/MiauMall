//
//  MMTwoImageOneCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/8.
//  双图组合样式1 twoimg1 带有间距的10

#import "MMTwoImageOneCell.h"

@interface MMTwoImageOneCell ()
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation MMTwoImageOneCell

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
