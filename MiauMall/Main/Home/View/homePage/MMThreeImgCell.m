//
//  MMThreeImgCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/8.
//  三图 一拖二 threeimg2

#import "MMThreeImgCell.h"

@interface MMThreeImgCell ()
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *bottomImage;
@property (nonatomic, strong) NSMutableArray *linkArr;

@end

@implementation MMThreeImgCell

-(NSMutableArray *)linkArr{
    if(!_linkArr){
        _linkArr = [[NSMutableArray alloc]init];
    }
    return _linkArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    double scale1 = 1.43; //左右图片的宽度比
    double scale2 = 0.9; //左边图片的长宽比
    double scale3 = 2.76;  //右边图片的长宽比
    float wid1 = (WIDTH - 30)/(1 + scale1);//左边图片宽度
    float hei1 = wid1 / scale2;//左边图片高度
    float wid2 = wid1 * scale1;//右边图片宽度
    float hei2 = wid2 / scale3;//右边图片高度
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0,wid1, hei1)];
//    image1.image = [UIImage imageNamed:@"three_left"];
    
    [self.contentView addSubview:image1];
    
    self.leftImage = image1;
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, wid1, hei1)];
    [btn1 setBackgroundColor:UIColor.clearColor];
    btn1.tag = 100;
    [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn1];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame) + 10, 0,wid2, hei2)];
//    image2.image = [UIImage imageNamed:@"threeTop"];
    [self.contentView addSubview:image2];
    
    self.topImage = image2;
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame) + 10, 0, wid2, hei2)];
    [btn2 setBackgroundColor:UIColor.clearColor];
    btn2.tag = 101;
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn2];
    
    
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame) +10, CGRectGetMaxY(image2.frame) + 10,wid2, hei2)];
//    image3.image = [UIImage imageNamed:@"threeTop"];
    [self.contentView addSubview:image3];
    
    self.bottomImage = image3;
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame) + 10, CGRectGetMaxY(image2.frame) + 10, wid2, hei2)];
    [btn3 setBackgroundColor:UIColor.clearColor];
    btn3.tag = 102;
    [btn3 addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn3];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *imageArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    MMHomeImageModel *model1 = imageArr[0];
    MMHomeImageModel *model2 = imageArr[1];
    MMHomeImageModel *model3 = imageArr[2];
    
    [self.linkArr addObject:model1.link2];
    [self.linkArr addObject:model2.link2];
    [self.linkArr addObject:model3.link2];
    
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model1.url]];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model2.url]];
    [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model3.url]];
}

-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 100){
        self.TapLeftImgBlock(self.linkArr[0]);
    }else if (sender.tag == 101){
        self.TapTopImgBlock(self.linkArr[1]);
    }else{
        self.TapBottomImgBlock(self.linkArr[2]);
    }
}

@end
