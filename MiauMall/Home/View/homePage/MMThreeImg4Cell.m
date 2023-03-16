//
//  MMThreeImg4Cell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/7.
//

#import "MMThreeImg4Cell.h"

@interface MMThreeImg4Cell ()
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) float hei;

@end


@implementation MMThreeImg4Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = UIColor.clearColor;
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
}

-(void)setHeiStr:(NSString *)heiStr{
    _heiStr = heiStr;
    self.hei = [_heiStr floatValue];
    [self loadUI];
}


-(void)loadUI{
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:self.model.cont.imglist];
    
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    CGFloat wid = WIDTH/3;
    CGFloat height = self.hei;
    CGFloat hei = 0;
    for (int i = 0; i < imgArr.count; i++) {
        MMHomeImageModel *imageModel = imgArr[i];
        NSInteger row = i/3;
        NSInteger column = i%3;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(wid * column,hei + row * height, wid, height)];
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
    self.TapThreeImg4Block(imageModel.link2);
}

@end
