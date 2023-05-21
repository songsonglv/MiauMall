//
//  MMBrandInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/9.
//

#import "MMBrandInfoView.h"
#import "MMBrandInfoModel.h"

@interface MMBrandInfoView ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *goodsNumLa;
@property (nonatomic, strong) UILabel *shortNameLa;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *showBt;//展开收起按钮
@property (nonatomic, strong) MMBrandInfoModel *model;
@property (nonatomic, assign) CGFloat hei;
@property (nonatomic, strong) UILabel *showLa;
@property (nonatomic, strong) UIImageView *showImage;


@end


@implementation MMBrandInfoView

-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shortNameLa.frame), WIDTH, 116)];
        _bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        UILabel *showLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"expandText"] textColor:TCUIColorFromRGB(0x888888) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        CGSize size = [NSString sizeWithText:showLa.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
        showLa.frame = CGRectMake((WIDTH - (size.width + 12))/2, 17, size.width, 12);
        [_bottomV addSubview:showLa];
        self.showLa = showLa;
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(showLa.frame) + 6, 20, 12, 6)];
        image.image = [UIImage imageNamed:@"down_gary"];
        [_bottomV addSubview:image];
        self.showImage = image;
        
        UIButton *showBt = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH - (size.width + 12))/2, 17, size.width + 12, 12)];
        [showBt setBackgroundColor:UIColor.clearColor];
        [showBt addTarget:self action:@selector(clickShow:) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomV addSubview:showBt];
        self.showBt = showBt;
        
        NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"directMail"],[UserDefaultLocationDic valueForKey:@"guarante"],[UserDefaultLocationDic valueForKey:@"falsePays"],[UserDefaultLocationDic valueForKey:@"taxInclusive"]];
        NSArray *arr1 = @[@"direct_icon",@"regular_icon",@"amends_icon",@"tax_icon"];
        
        CGFloat wid = WIDTH/4;
        for (int i = 0; i < arr.count; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 58, wid, 40)];
            view.backgroundColor = TCUIColorFromRGB(0xffffff);
            [_bottomV addSubview:view];
            
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((wid - 22)/2, 0, 22, 22)];
            image.image = [UIImage imageNamed:arr1[i]];
            [view addSubview:image];
            
            UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
            lab.frame = CGRectMake(0, 29, wid, 11);
            [view addSubview:lab];
        }
        
    }
    return _bottomV;
}


-(instancetype)initWithFrame:(CGRect)frame andModel:(MMBrandInfoModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
        self.backgroundColor = TCUIColorFromRGB(0xf3f3f3);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 156)];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:self.model.BackPicture] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
    bgImage.userInteractionEnabled = YES;
    [self addSubview:bgImage];
    self.bgImage = bgImage;
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(15, 60, 10, 20)];
    [returnBt setImage:[UIImage imageNamed:@"back_while"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [returnBt setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self addSubview:returnBt];
    
    UIButton *searchBt = [[UIButton alloc]initWithFrame:CGRectMake(34, 56, WIDTH - 84, 28)];
    [searchBt setBackgroundColor:UIColor.clearColor];
    searchBt.layer.masksToBounds = YES;
    searchBt.layer.cornerRadius = 14;
    searchBt.layer.borderColor = TCUIColorFromRGB(0xf7f7f8).CGColor;
    searchBt.layer.borderWidth = 1;
    [searchBt addTarget:self action:@selector(clickSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:searchBt];
    
    UIButton *shareBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 36, 60, 20, 20)];
    [shareBt setImage:[UIImage imageNamed:@"share_icon_white"] forState:(UIControlStateNormal)];
    [shareBt addTarget:self action:@selector(clickShare) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:shareBt];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(9, 142, 75, 75)];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:self.model.LogoPicture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    logoImage.layer.masksToBounds = YES;
    logoImage.layer.cornerRadius = 8;
    [self addSubview:logoImage];
    self.logoImage = logoImage;
    
    UILabel *nameLa = [UILabel publicLab:self.model.Name textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
    nameLa.frame = CGRectMake(98, 172, WIDTH - 110, 14);
    [self addSubview:nameLa];
    
    UILabel *numLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",self.model.BrandNum,[UserDefaultLocationDic valueForKey:@"itemsSale"]] textColor:TCUIColorFromRGB(0x888888) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    numLa.frame = CGRectMake(98, 192, WIDTH - 110, 12);
    [self addSubview:numLa];
    
    NSString *str = [self.model.ShortName stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    str = [NSString stringWithFormat:@"     %@",str];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];

    UILabel *contLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x484b4e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    contLa.attributedText = attributedStr;
    contLa.frame = CGRectMake(12, 236, WIDTH - 24, 0);
    [contLa sizeToFit];
    [self addSubview:contLa];
    self.shortNameLa = contLa;
    self.hei = contLa.height;
    contLa.height = 80;
    [self addSubview:self.bottomV];
}

-(void)clickShow:(UIButton *)sender{
       sender.selected = !sender.selected;
    
    
    if(self.showBt.selected == YES){
        self.showLa.text = [UserDefaultLocationDic valueForKey:@"clickStow"];
        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"clickStow"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
        self.showLa.frame = CGRectMake((WIDTH - (size.width + 12))/2, 17, size.width, 12);
        self.showImage.image = [UIImage imageNamed:@"up_icon_black"];
        self.showImage.x = CGRectGetMaxX(self.showLa.frame) + 6;
        sender.frame =  CGRectMake((WIDTH - (size.width + 12))/2, 17, size.width + 12, 12);
        self.shortNameLa.height = self.hei;
        self.height = 236 + self.hei + 116;
        self.bottomV.y = 236 + self.hei;
    }else{
        CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"expandText"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
        self.showLa.text = [UserDefaultLocationDic valueForKey:@"expandText"];
        self.showLa.frame = CGRectMake((WIDTH - (size.width + 12))/2, 17, size.width, 12);
        self.showImage.image = [UIImage imageNamed:@"down_gary"];
        self.showImage.x = CGRectGetMaxX(self.showLa.frame) + 6;
        sender.frame =  CGRectMake((WIDTH - (size.width + 12))/2, 17, size.width + 12, 12);
        
        self.shortNameLa.height = 80;
        self.bottomV.y =  316;
        self.height = 432;
    }
    self.returnViewHei(self.height);
}

-(void)clickReturn{
    self.tapReturnBlock(@"1");
}

-(void)clickSearch{
    self.tapSearchBlock(@"1");
}

-(void)clickShare{
    self.tapShareBlock(@"1");
}
@end
