//
//  MMCretPosterView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/26.
//

#import "MMCretPosterView.h"
@interface MMCretPosterView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@property (nonatomic, strong) MMGoodsProInfoModel *proInfo;
@property (nonatomic, strong) UIImage *image;
@end

@implementation MMCretPosterView

-(instancetype)initWithFrame:(CGRect)frame andData:(MMGoodsDetailMainModel *)mode andGoodsInfo:(MMGoodsProInfoModel *)proInfo{
    if(self = [super initWithFrame:frame]){
        self.model = mode;
        self.proInfo = proInfo;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 218, WIDTH, 35)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 17.5;
    [self.view addSubview:self.topView];
    
    self.contentV = [[UIView alloc]initWithFrame:CGRectMake(0, 2 *HEIGHT - 200, WIDTH, 200)];
    self.contentV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentV];
    
    UILabel *lab = [UILabel publicLab:@"分享图片到" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    lab.frame = CGRectMake(0, 6, WIDTH, 15);
    [self.contentV addSubview:lab];
    
    NSArray *arr = @[@"微信好友",@"朋友圈",@"新浪微博",@"下载海报"];
    NSArray *imgArr = @[@"wx_share_icon",@"wx_friend_icon",@"sina_icon",@"down_poster_icon"];
    CGFloat wid = WIDTH/arr.count;
    
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid * i, 42, wid, 74)];
        [self.contentV addSubview:view];
        
        UIImageView *ima = [[UIImageView alloc]init];
        ima.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:ima];
        
        [ima mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(view);
                    make.top.mas_equalTo(0);
                    make.width.height.mas_equalTo(50);
        }];
        
        UILabel *la = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        [view addSubview:la];
        
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(ima.mas_bottom).offset(10);
                    make.height.mas_equalTo(14);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 74)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
    }
    
    UIButton *cancleBt = [[UIButton alloc]init];
    [cancleBt setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
    cancleBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [cancleBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentV addSubview:cancleBt];
    
    [cancleBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(140);
            make.height.mas_equalTo(20);
    }];
    
    self.imageView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 230)/2,2 * HEIGHT - 700, 230, 430)];
    self.imageView.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 12.5;
    [self.view addSubview:self.imageView];
    
    UILabel *titleLa = [UILabel publicLab:@"推荐一个好物给您，请查收" textColor:TCUIColorFromRGB(0x161616) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 14, 230, 10);
    [self.imageView addSubview:titleLa];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34, 230, 230)];
    [image sd_setImageWithURL:[NSURL URLWithString:self.proInfo.ShareImg] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    [self.imageView addSubview:image];
    
    UILabel *unitLa = [UILabel publicLab:self.model.proInfo.PriceShowSign textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:2];
    unitLa.preferredMaxLayoutWidth = 120;
    [unitLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.imageView addSubview:unitLa];
    
    [unitLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(CGRectGetMaxY(image.frame) + 25);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *priceLa = [UILabel publicLab:self.model.proInfo.PriceShowPrice textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:20 numberOfLines:0];
    priceLa.preferredMaxLayoutWidth = 200;
    [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.imageView addSubview:priceLa];
    
    [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(unitLa.mas_right).offset(3);
            make.top.mas_equalTo(CGRectGetMaxY(image.frame) + 15);
            make.height.mas_equalTo(20);
    }];
    
    UILabel *tipsLa = [UILabel publicLab:@"此价格具有时效性" textColor:TCUIColorFromRGB(0x8b8b8b) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:9 numberOfLines:0];
    tipsLa.preferredMaxLayoutWidth = 120;
    [tipsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.imageView addSubview:tipsLa];
    
    [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceLa.mas_right).offset(3);
            make.top.mas_equalTo(CGRectGetMaxY(image.frame) + 26);
            make.height.mas_equalTo(9);
    }];
    
    UILabel *nameLa = [UILabel publicLab:self.proInfo.ShareTitle textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:2];
    nameLa.frame = CGRectMake(12, CGRectGetMaxY(image.frame) + 50, 206, 30);
//    nameLa.preferredMaxLayoutWidth = 206;
//    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.imageView addSubview:nameLa];
    
//    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(12);
//            make.top.mas_equalTo(priceLa.mas_bottom).offset(16);
//            make.width.mas_equalTo(206);
//           // make.height.mas_equalTo(30);
//    }];
    
    UIImageView *codeImage = [[UIImageView alloc]init];
    [codeImage sd_setImageWithURL:[NSURL URLWithString:self.proInfo.WxCode] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    [self.imageView addSubview:codeImage];
    
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(14);
            make.width.height.mas_equalTo(58);
    }];
    
    UILabel *lab1 = [UILabel publicLab:@"扫描二维码" textColor:TCUIColorFromRGB(0x161616) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 200;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.imageView addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(codeImage.mas_right).offset(8);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(30);
            make.height.mas_equalTo(10);
    }];
    
    UILabel *lab2 = [UILabel publicLab:@"下载MiauMall App" textColor:TCUIColorFromRGB(0x161616) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = 200;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.imageView addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(codeImage.mas_right).offset(8);
            make.top.mas_equalTo(lab1.mas_bottom).offset(5);
            make.height.mas_equalTo(10);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"logo_icon"];
    [self.imageView addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.bottom.mas_equalTo(-28);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(36);
    }];
    
    
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230, 450)];
//    bgImage.image = image1;
//    [self.imageView addSubview:bgImage];
}

-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 103){
        [self saveImageToPhotos:[self convertViewToImage:self.imageView]];
    }else{
        self.tapNumBlock(sender.tag - 100);
        [self hideView];
    }
   
}

-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.imageView.centerY = self.imageView.centerY + HEIGHT;
        self.topView.centerY =self.topView.centerY+HEIGHT;
        self.contentV.centerY =self.contentV.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.imageView.centerY = self.imageView.centerY - HEIGHT;
        self.topView.centerY =self.topView.centerY - HEIGHT;
        self.contentV.centerY =self.contentV.centerY - HEIGHT;
         
     } completion:^(BOOL fin){}];
}




//使用该方法不会模糊，根据屏幕密度计算
- (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
    
}

#pragma mark 保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark 系统的完成保存图片的方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if (error != NULL) {
        msg = @"保存图片失败" ;
    } else {
        msg = @"保存图片成功" ;
        [self hideView];
    }
    [ZTProgressHUD showMessage:msg];
}


@end
