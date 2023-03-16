//
//  MMThreeImgThreeCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import "MMThreeImgThreeCell.h"

@interface MMThreeImgThreeCell ()
@property (nonatomic, strong) NSMutableArray *linkArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation MMThreeImgThreeCell

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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
}

-(void)setHeiStr:(NSString *)heiStr{
    _heiStr = heiStr;
    [self loadUI];
    
}

-(void)loadUI{
    
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    self.imgArr = [NSMutableArray arrayWithArray:imgArr];
    CGFloat wid = (WIDTH - 30)/3;
    
    NSInteger row = self.model.cont.imglist.count/3;
    row = self.model.cont.imglist.count % 3 > 0 ? row + 1: row;
    CGFloat bottom = [self.model.margin3 floatValue];
    CGFloat top = [self.model.margin1 floatValue];
    CGFloat allHei = [self.heiStr floatValue];
    CGFloat hei;
    
    if(allHei > 0){
        hei = (allHei - bottom - top)/row - 10;
    }
    
    int row1 = 0;
    int column = 0;
    for (int i = 0; i < imgArr.count; i++) {
         row1 = i/3;
        column = i % 3;
       
        MMHomeImageModel *imageModel = imgArr[i];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5 + (wid + 10) * column, 5 + row1 * (10 + hei), wid, hei)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        image.contentMode = UIViewContentModeScaleToFill;
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
    self.TapThreeImgThreeBlock(imageModel.link2);
}





@end
