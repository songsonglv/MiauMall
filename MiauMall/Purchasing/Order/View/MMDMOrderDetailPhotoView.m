//
//  MMDMOrderDetailPhotoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import "MMDMOrderDetailPhotoView.h"

@interface MMDMOrderDetailPhotoView ()
@property (nonatomic, strong) UIImageView *noneImage;
@property (nonatomic, strong) UILabel *tipsLa;
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation MMDMOrderDetailPhotoView

-(NSMutableArray *)models{
    if(!_models){
        _models = [NSMutableArray array];
    }
    return _models;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:@"订单照片" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(17, 25, WIDTH - 34, 15);
    [self addSubview:titleLa];
    
    UIImageView *noneImage = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 48)/2, 60, 48, 48)];
    noneImage.image = [UIImage imageNamed:@"none_image"];
    [self addSubview:noneImage];
    self.noneImage = noneImage;
 
    UILabel *tipLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xef5e75) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:13 numberOfLines:0];
    tipLa.frame = CGRectMake(0, CGRectGetMaxY(self.noneImage.frame) + 36, WIDTH, 13);
    [self addSubview:tipLa];
    self.tipsLa = tipLa;
}

-(void)setModel:(MMDMOrderDetailModel *)model{
    _model = model;
    if(_model.PhotoPicture.count > 0){
        self.noneImage.hidden = YES;
        self.tipsLa.hidden = YES;
        float hei = 52;
        float wid = (WIDTH - 48)/3;
        
        if(self.models.count == 0){
            for (NSString *str in _model.PhotoPicture) {
                JJDataModel *model = [JJDataModel alloc];
                model.img = str;
                [self.models addObject:model];
            }
        }
        
        for (int i = 0; i < _model.PhotoPicture.count; i++) {
            int j = i % 3;
            int z = i / 3;
            
            UIImageView *photoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12 + (wid + 12) * j, hei + z * (wid + 12), wid, wid)];
            [photoIcon sd_setImageWithURL:[NSURL URLWithString:_model.PhotoPicture[i]] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
            photoIcon.layer.masksToBounds = YES;
            photoIcon.layer.cornerRadius = 6;
            [self addSubview:photoIcon];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (wid + 12) * j, hei + z * (wid + 12), wid, wid)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickShowPic:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btn];
        }
    }else{
        self.tipsLa.text = _model.PhoteTips;
    }
}

-(void)clickShowPic:(UIButton *)sender{
    self.tapImageBlock(self.models, sender.tag - 100);
}
@end
