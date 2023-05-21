//
//  MMDMGoodsInfoViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/25.
//

#import "MMDMGoodsInfoViewController.h"
#import "MMSlider.h"
#import "MMDMSeriverModel.h"
#import "MMDMServiceView.h"
#import "MMDMSpecView.h"
#import "MMDMGoodsSKUModel.h"
#import "MMDMOrderConfirmationVC.h"

@interface MMDMGoodsInfoViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) UIView *topV;//顶部站点
@property (nonatomic, strong) UIView *goodsNameV;//名称
@property (nonatomic, strong) UIView *specV;//规格
@property (nonatomic, strong) UIView *priceV;//价格
@property (nonatomic, strong) UIView *AcceptV;//可接受价格浮动
@property (nonatomic, strong) NSString *floatpricerate;//价格浮动比率
@property (nonatomic, strong) UIView *quantityV;//数量
@property (nonatomic, strong) UIView *goodsImageV;//图片模块
@property (nonatomic, strong) MMDMServiceView *serviceV;//服务模块
@property (nonatomic, strong) UIView *bottomV;//底部view
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UIButton *deleBt;//删除图片按钮
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UIView *serviceSelectionV;//服务选择view
@property (nonatomic, strong) UITextField *nameFiled;
@property (nonatomic, strong) UITextField *specField;//规格
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UILabel *priceLa;//价格
@property (nonatomic, strong) UILabel *valueLa;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *numLa;//数量lab
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) MMDMSeriverModel *seleModel;//选择的服务model
@property (nonatomic, strong) MMDMGoodsSKUModel *seleModel1;//选择的规格model
@property (nonatomic, strong) NSMutableArray *seleValue;//选中的多规格数组
@property (nonatomic, strong) NSMutableArray *paramArr;
@property (nonatomic, strong) MMDMSpecView *specV1;
@property (nonatomic, strong) NSMutableArray *imageStrArr;
@property (nonatomic, strong) NSString *sureid;


@end

@implementation MMDMGoodsInfoViewController

-(NSMutableArray *)imageStrArr{
    if(!_imageStrArr){
        _imageStrArr = [NSMutableArray array];
    }
    return _imageStrArr;
}

-(NSMutableArray *)paramArr{
    if(!_paramArr){
        _paramArr = [NSMutableArray array];
    }
    return _paramArr;
}

-(NSMutableArray *)seleValue{
    if(!_seleValue){
        _seleValue = [NSMutableArray array];
    }
    return _seleValue;
}

-(NSMutableArray *)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(UIView *)topV{
    if(!_topV){
        _topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 84)];
        UIImageView *siteImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 36, 36)];
        siteImage.layer.masksToBounds = YES;
        siteImage.layer.cornerRadius = 6;
        siteImage.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
        siteImage.layer.borderWidth = 0.5;
        [siteImage sd_setImageWithURL:[NSURL URLWithString:self.model.SitePicture] placeholderImage:[UIImage imageNamed:@"dm_site_zhanwei"]];
        [_topV addSubview:siteImage];
        
        NSString *siteName = self.model.SiteName ? self.model.SiteName : @"获取网站链接失败";
        UILabel *lab = [UILabel publicLab:siteName textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
        lab.frame = CGRectMake(64, 22, WIDTH - 76, 16);
        [_topV addSubview:lab];
        
        NSString *siteDetail = self.model.SiteDetail.length > 0 ? self.model.SiteDetail : @"请手动填写相关信息";
        UILabel *lab1 = [UILabel publicLab:siteDetail textColor:TCUIColorFromRGB(0x888888) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.frame = CGRectMake(64, 41, WIDTH - 76, 12);
        [_topV addSubview:lab1];
    }
    return _topV;
}

-(UIView *)goodsNameV{
    if(!_goodsNameV){
        _goodsNameV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topV.frame), WIDTH, 102)];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, WIDTH - 24, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe3e3e3);
        [_goodsNameV addSubview:line];
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xeb4868) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.frame = CGRectMake(18, 17, WIDTH - 36, 15);
        [_goodsNameV addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                    confer.text(@"*").textColor(TCUIColorFromRGB(0xeb4868)).font([UIFont systemFontOfSize:15]);
                    confer.text([UserDefaultLocationDic valueForKey:@"proName"]).textColor(TCUIColorFromRGB(0x030303)).font([UIFont systemFontOfSize:15]);
        }];
        
        if(self.model.ItemList.title){
            CGSize size = [NSString sizeWithText:self.model.ItemList.title font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(WIDTH - 48,MAXFLOAT)];
            _goodsNameV.height = 50 + size.height;
            UILabel *nameLa = [UILabel publicLab:self.model.ItemList.title textColor:TCUIColorFromRGB(0x1d1d1d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
            nameLa.frame = CGRectMake(24, 50, WIDTH - 48, size.height);
            [_goodsNameV addSubview:nameLa];
        }else{
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, 50, WIDTH - 28, 52)];
            bgView.layer.masksToBounds = YES;
            bgView.layer.cornerRadius = 6;
            bgView.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
            bgView.layer.borderWidth = 0.5;
            [_goodsNameV addSubview:bgView];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(12, 15, WIDTH - 52, 22)];
            field.backgroundColor = TCUIColorFromRGB(0xffffff);
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            field.textColor = TCUIColorFromRGB(0x333333);
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [bgView addSubview:field];
            self.nameFiled = field;
        }
    }
    return _goodsNameV;
}

-(UIView *)specV{
    KweakSelf(self);
    if(!_specV){
        _specV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsNameV.frame), WIDTH, 102)];
        
        UILabel *lab = [UILabel publicLab:@"规格型号" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.frame = CGRectMake(18, 17, WIDTH - 36, 15);
        [_specV addSubview:lab];
        
        float hei = 50;
        if(self.model.ItemList.axis.count > 0  && self.model.ItemList.axis){
            for (int i = 0; i < self.model.ItemList.axis.count; i++) {
                NSDictionary *dic1 = self.model.ItemList.axis[i];
//                NSString *name = dic1[@"name"];
                NSArray *arr1 = dic1[@"values"];
                
                int count = 0;
                float btnWidth = 0;
                float viewHeight = 0;
                for (int j = 0; j < arr1.count; j++) {
                    
                    NSString *btnName = arr1[j];
                    if(j == 0){
                        NSDictionary *dic = @{@"name":dic1[@"name"],@"value":btnName};
                        [self.seleValue addObject:dic];
                    }
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [btn setBackgroundColor:TCUIColorFromRGB(0xf5f5f5)];
                    [btn setTitleColor:TCUIColorFromRGB(0x030303) forState:UIControlStateNormal];
                    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:UIControlStateSelected];
                    
                    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
                    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    [btn setTitle:btnName forState:UIControlStateNormal];
//                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btn.layer.cornerRadius = 4;
                    btn.layer.masksToBounds = YES;
                    btn.layer.borderWidth = 0.5;
                    btn.layer.borderColor = TCUIColorFromRGB(0x1d1d1d).CGColor;
                    
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:13] forKey:NSFontAttributeName];
                    CGSize btnSize = [btnName sizeWithAttributes:dict];
                    
                    btn.width = btnSize.width + 28;
                    btn.height = btnSize.height + 14;
                    
                    if (j == 0){
                        btn.x = 24;
                        btnWidth += CGRectGetMaxX(btn.frame);
                    }else{
                        btnWidth += CGRectGetMaxX(btn.frame) + 28;
                        if (btnWidth > WIDTH) {
                            count++;
                            btn.x = 24;
                            btnWidth = CGRectGetMaxX(btn.frame);
                        }
                        else{
                            
                            btn.x += btnWidth - btn.width;
                        }
                    }
                    btn.y += count * (btn.height+10)+28;
                    
                    viewHeight = CGRectGetMaxY(btn.frame)+20;
                    
                }
                hei += viewHeight;
                
                MMDMSpecView *specV1 = [[MMDMSpecView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, hei - 50) andModel:self.model.ItemList];
                specV1.returnModelBlock = ^(MMDMGoodsSKUModel * _Nonnull model) {
                    weakself.seleModel1 = model;
                    NSString *str;
                    for (int z = 0; z < model.info.count; z++) {
                        NSDictionary *infoDic = model.info[z];
                        if(str.length == 0){
                            str = infoDic[@"value"];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,infoDic[@"value"]];
                        }
                    }
                    weakself.specField.text = str;
                    weakself.priceLa.text = [NSString stringWithFormat:@"JPY%@",model.price];
                };
                [_specV addSubview:specV1];
            }
            
            
        }else{
            MMDMGoodsSKUModel *model1 = self.paramArr[0];
            self.priceLa.text = [NSString stringWithFormat:@"JPY%@",model1.price];
        }
        
        
        
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, hei, WIDTH - 28, 52)];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 6;
        bgView.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
        bgView.layer.borderWidth = 0.5;
        [_specV addSubview:bgView];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(12, 15, WIDTH - 52, 22)];
        field.backgroundColor = TCUIColorFromRGB(0xffffff);
        field.delegate = self;
        field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        field.textColor = TCUIColorFromRGB(0x333333);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:field];
        self.specField = field;
        
        if(self.model.ItemList.axis && self.model.ItemList.axis.count > 0){
            for (MMDMGoodsSKUModel *model1 in self.paramArr) {
                if([model1.info isEqual:self.seleValue]){
                    self.seleModel1 = model1;
                    NSString *str;
                    for (int z = 0; z < model1.info.count; z++) {
                        NSDictionary *infoDic = model1.info[z];
                        if(str.length == 0){
                            str = infoDic[@"value"];
                        }else{
                            str = [NSString stringWithFormat:@"%@,%@",str,infoDic[@"value"]];
                        }
                    }
                    self.specField.text = str;
                    self.priceLa.text = [NSString stringWithFormat:@"JPY%@",model1.price];
                }
            }
        }else if(self.model.ItemList.param){
            MMDMGoodsSKUModel *model1 = self.paramArr[0];
            self.seleModel1 = model1;
            NSString *str;
            for (int z = 0; z < model1.info.count; z++) {
                NSDictionary *infoDic = model1.info[z];
                if(str.length == 0){
                    str = infoDic[@"value"];
                }else{
                    str = [NSString stringWithFormat:@"%@,%@",str,infoDic[@"value"]];
                }
            }
            self.specField.text = str;
            self.priceLa.text = [NSString stringWithFormat:@"JPY%@",model1.price];
        }
        
        _specV.height = CGRectGetMaxY(bgView.frame);
    }
    return _specV;
}

-(UIView *)priceV{
    if(!_priceV){
        _priceV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.specV.frame), WIDTH, 102)];
        
        UILabel *lab = [UILabel publicLab:@"规格型号" textColor:TCUIColorFromRGB(0xeb4868) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.frame = CGRectMake(18, 17, WIDTH - 36, 15);
        [_priceV addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"*").textColor(TCUIColorFromRGB(0xeb4868)).font([UIFont systemFontOfSize:15]);
            confer.text([NSString stringWithFormat:@"%@(JPY)",[UserDefaultLocationDic valueForKey:@"iprice"]]).textColor(TCUIColorFromRGB(0x030303)).font([UIFont systemFontOfSize:15]);
        }];
        
        if(self.model.ItemList.param){
            _priceV.height = 75;
            UILabel *lab1 = [UILabel publicLab:[NSString stringWithFormat:@"JPY%@",self.seleModel1.price] textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
            lab1.frame = CGRectMake(24, CGRectGetMaxY(lab.frame) + 22, WIDTH - 48, 18);
            [_priceV addSubview:lab1];
            self.priceLa = lab1;
            
        }else{
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, 50, WIDTH - 28, 52)];
            bgView.layer.masksToBounds = YES;
            bgView.layer.cornerRadius = 6;
            bgView.layer.borderColor = TCUIColorFromRGB(0xe3e3e3).CGColor;
            bgView.layer.borderWidth = 0.5;
            [_priceV addSubview:bgView];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(12, 15, WIDTH - 52, 22)];
            field.backgroundColor = TCUIColorFromRGB(0xffffff);
            field.delegate = self;
            field.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            field.textColor = TCUIColorFromRGB(0x333333);
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentLeft;
            [bgView addSubview:field];
            self.priceField = field;
        }
    }
    return _priceV;
}

-(UIView *)AcceptV{
    if(!_AcceptV){
        _AcceptV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceV.frame), WIDTH, 130)];
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xeb4868) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 80;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//        lab.frame = CGRectMake(18, 17, WIDTH - 36, 15);
        [_AcceptV addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.top.mas_equalTo(17);
                    make.height.mas_equalTo(15);
        }];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"*").textColor(TCUIColorFromRGB(0xeb4868)).font([UIFont systemFontOfSize:15]);
            confer.text(@"可承受价格变动范围").textColor(TCUIColorFromRGB(0x030303)).font([UIFont systemFontOfSize:15]);
        }];
        
        UILabel *valueLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        valueLa.preferredMaxLayoutWidth = 100;
        [valueLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_AcceptV addSubview:valueLa];
        
        self.valueLa = valueLa;
        
        [valueLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lab.mas_right).offset(5);
                    make.top.mas_equalTo(17);
                    make.height.mas_equalTo(15);
        }];
        
        MMSlider *slider = [[MMSlider alloc]initWithFrame:CGRectMake(12, 50, WIDTH - 48, 13)];
        slider.minimumValue = 0;
        slider.maximumValue = 100;
        [slider setThumbImage:[UIImage imageNamed:@"slider_bg"] forState:UIControlStateNormal];
        slider.tintColor = TCUIColorFromRGB(0xe3a5b2);
        slider.minimumTrackTintColor = redColor3;
        slider.maximumTrackTintColor = TCUIColorFromRGB(0xe3a5b2);
        [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:(UIControlEventValueChanged)];
        [_AcceptV addSubview:slider];
        
        UILabel *tipsLa = [UILabel publicLab:@"请选择价格可承受范围，如果超出这个范围将为您取消订单。" textColor:TCUIColorFromRGB(0x797979) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        tipsLa.preferredMaxLayoutWidth = WIDTH - 36;
        [tipsLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
        [_AcceptV addSubview:tipsLa];
        
        [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.top.mas_equalTo(CGRectGetMaxY(slider.frame) + 30);
                    make.width.mas_equalTo(WIDTH - 36);
        }];
        
    }
    return _AcceptV;
}

-(UIView *)quantityV{
    if(!_quantityV){
        _quantityV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.AcceptV.frame), WIDTH, 106)];
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xeb4868) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 80;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//        lab.frame = CGRectMake(18, 17, WIDTH - 36, 15);
        [_quantityV addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.top.mas_equalTo(17);
                    make.height.mas_equalTo(15);
        }];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"*").textColor(TCUIColorFromRGB(0xeb4868)).font([UIFont systemFontOfSize:15]);
            confer.text([UserDefaultLocationDic valueForKey:@"iQuantity"]).textColor(TCUIColorFromRGB(0x030303)).font([UIFont systemFontOfSize:15]);
        }];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, 50, 110, 36)];
        bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 6;
        bgView.layer.borderColor = TCUIColorFromRGB(0xdddddd).CGColor;
        bgView.layer.borderWidth = 0.5;
        [_quantityV addSubview:bgView];
        
        UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36)];
        [subBt setTitle:@"-" forState:(UIControlStateNormal)];
        [subBt setTitleColor:TCUIColorFromRGB(0x0b0b0b) forState:(UIControlStateNormal)];
        subBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
        [subBt addTarget:self action:@selector(clickSub) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:subBt];
        
        UILabel *numLa = [UILabel publicLab:@"1" textColor:TCUIColorFromRGB(0x0b0b0b) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
        numLa.frame = CGRectMake(36, 0, 38, 36);
        numLa.layer.masksToBounds = YES;
        numLa.layer.cornerRadius = 0;
        numLa.layer.borderColor = TCUIColorFromRGB(0xdfdfdf).CGColor;
        numLa.layer.borderWidth = 0.5;
        [bgView addSubview:numLa];
        self.numLa = numLa;
        
        UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(75, 0, 35, 36)];
        [addBt setTitle:@"+" forState:(UIControlStateNormal)];
        [addBt setTitleColor:TCUIColorFromRGB(0x0b0b0b) forState:(UIControlStateNormal)];
        addBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:16];
        [addBt addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:addBt];
        
    }
    return _quantityV;
}

-(UIView *)goodsImageV{
    KweakSelf(self);
    if(!_goodsImageV){
        _goodsImageV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.quantityV.frame), WIDTH, 162)];
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xeb4868) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 80;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//        lab.frame = CGRectMake(18, 17, WIDTH - 36, 15);
        [_goodsImageV addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.top.mas_equalTo(17);
                    make.height.mas_equalTo(15);
        }];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"*").textColor(TCUIColorFromRGB(0xeb4868)).font([UIFont systemFontOfSize:15]);
            confer.text([UserDefaultLocationDic valueForKey:@"upProPic"]).textColor(TCUIColorFromRGB(0x030303)).font([UIFont systemFontOfSize:15]);
        }];
        
        
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc]initWithFrame:CGRectMake(14,38, 104, 104) andIsEnter:@"dm"];
        mediaView.isfeed = YES;
        if(self.model.ItemList.image){
            mediaView.pingUploadUrlString = self.model.ItemList.image;
        }
        mediaView.backgroundColor = TCUIColorFromRGB(0xffffff);
        [_goodsImageV addSubview:mediaView];
        
        //随时获取选取的媒体文件
        [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
            NSLog(@"%@",list);
            [weakself.imageArr removeAllObjects];
            [weakself.imageStrArr removeAllObjects];
            for (ACMediaModel*model in list) {
                UIImage *image = model.image;
                [weakself.imageArr addObject:image];
            }
            
            for (int i = 0; i < weakself.imageArr.count; i++) {
                UIImage *image = weakself.imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [weakself requestImage:imageData];
            }
        }];
        
    }
    return _goodsImageV;
}

-(MMDMServiceView *)serviceV{
    KweakSelf(self);
    if(!_serviceV){
        NSArray *arr1 = [MMDMSeriverModel mj_objectArrayWithKeyValuesArray:self.model.DistributionGuaranteeList];
        float hei = 15;
        for (int i = 0; i < arr1.count; i++) {
            MMDMSeriverModel *model = arr1[i];
            CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@  %@JPY",model.Name,model.Price] font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 60,14)];
            
            CGSize size1 = [NSString sizeWithText:model.Detail font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,12)];
            
            if([self.lang isEqualToString:@"1"]){
                size =  [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 60,14)];
                
            }
            
            hei += size.height + 36;
            
            if(size1.height > 0){
                hei += size1.height + 12;
            }
            
                
            if([self.lang isEqualToString:@"1"]){
                hei += 26;
            }
        }
        _serviceV = [[MMDMServiceView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsImageV.frame), WIDTH, hei) andDataArr:self.model.DistributionGuaranteeList];
        _serviceV.returnModelBlock = ^(MMDMSeriverModel * _Nonnull model) {
            
            if(model){
                weakself.seleModel = model;
                weakself.sureid = model.ID;
            }else{
                weakself.seleModel = nil;
                weakself.sureid = @"0";
            }
            
        };
    }
    return _serviceV;
}

-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.serviceV.frame), WIDTH, 80)];
        _bottomV.backgroundColor = TCUIColorFromRGB(0xffffff);
        float wid = (WIDTH - 30)/2;
        UIButton *addBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, wid, 40)];
        addBt.backgroundColor = TCUIColorFromRGB(0x10131f);
        [addBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
        [addBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        addBt.layer.masksToBounds = YES;
        addBt.layer.cornerRadius = 20;
        addBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBt addTarget:self action:@selector(CartPlus) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomV addSubview:addBt];
        
        UIButton *subBt = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addBt.frame) + 10, 12, wid, 40)];
        subBt.backgroundColor = redColor3;
        [subBt setTitle:[UserDefaultLocationDic valueForKey:@"submitAudit"] forState:(UIControlStateNormal)];
        [subBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        subBt.layer.masksToBounds = YES;
        subBt.layer.cornerRadius = 20;
        subBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [subBt addTarget:self action:@selector(FastAdd) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomV addSubview:subBt];
    }
    return _bottomV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    self.seleModel = [MMDMSeriverModel mj_objectWithKeyValues:self.model.DistributionGuaranteeList[0]];
    self.num = 1;
    self.sureid = @"0";
    self.floatpricerate = @"0";
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = @"商品信息";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    
    if(self.model.ItemList){
        NSArray *arr = [MMDMGoodsSKUModel mj_objectArrayWithKeyValuesArray:self.model.ItemList.param];
        self.paramArr = [NSMutableArray arrayWithArray:arr];
        if(self.model.ItemList.image){
            [self.imageStrArr addObject:self.model.ItemList.image];
        }
    }
    
    
    [self setUI];
    
}

-(void)setUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - StatusBarHeight - 54);
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self.scrollView addSubview:self.topV];
    [self.scrollView addSubview:self.goodsNameV];
    [self.scrollView addSubview:self.specV];
    [self.scrollView addSubview:self.priceV];
    [self.scrollView addSubview:self.AcceptV];
    [self.scrollView addSubview:self.quantityV];
    [self.scrollView addSubview:self.goodsImageV];
    [self.scrollView addSubview:self.serviceV];
    [self.scrollView addSubview:self.bottomV];
    self.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.serviceV.frame) + 80);
}

//上传图片
-(void)requestImage:(NSData *)imageData{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",BaseUrl,@"MemPicUpload"];
    
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:imageData forKey:@"file"];
    [ZTNetworking FormImageDataPostRequestUrl:url RequestPatams:param RequestData:imageData ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            [weakself.imageStrArr addObject:key];
//            [ZTProgressHUD showMessage:@"图片上传完成"];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)clickSub{
    if(self.num == 1){
        [ZTProgressHUD showMessage:@"最少要有一件商品"];
    }else{
        self.num--;
    }
    self.numLa.text = [NSString stringWithFormat:@"%ld",self.num];
}

-(void)clickAdd{
    self.num++;
    self.numLa.text = [NSString stringWithFormat:@"%ld",self.num];
}

//加入购物车
-(void)CartPlus{
    if(self.nameFiled.text.length == 0 && !self.model.ItemList.title){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleProName"]];
    }else if (self.imageStrArr.count == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"upProPic"]];
    }else if (!self.model.ItemList.param && self.priceField.text.length == 0){
        [ZTProgressHUD showMessage:@"请输入商品价格"];
    }else if (self.model.ItemList.param && [self.seleModel1.enable isEqualToString:@"0"]){
        [ZTProgressHUD showMessage:@"此商品缺货"];
    }else if (self.model.ItemList.param && [self.seleModel1.quantity isEqualToString:@"0"]){
        [ZTProgressHUD showMessage:@"此商品缺货"];
    }else{
        KweakSelf(self);
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
        NSDictionary *param1 = @{@"carttype":@"1",@"lang":self.lang,@"cry":self.cry,@"back":@"1",@"site":self.model.SiteName,@"sitelink":self.linkUrl,@"memberToken":self.memberToken};
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:param1];
        if(self.model.ItemList.title){
            [param setValue:self.model.ItemList.title forKey:@"name"];
        }else{
            [param setValue:self.nameFiled.text forKey:@"name"];
        }
        
        if(self.specField.text.length > 0){
            [param setValue:self.specField.text forKey:@"attribute"];
        }
        
        if(self.model.ItemList.param){
            [param setValue:self.seleModel1.price forKey:@"price"];
        }else{
            [param setValue:self.priceField.text forKey:@"price"];
        }
        
        [param setValue:self.imageStrArr[0] forKey:@"picture"];
        [param setValue:self.numLa.text forKey:@"num"];
        [param setValue:self.floatpricerate forKey:@"floatpricerate"];
        [param setValue:self.sureid forKey:@"sureid"];
        
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
   
}

//提交审核
-(void)FastAdd{
    if(self.nameFiled.text.length == 0 && !self.model.ItemList.title){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"pleProName"]];
    }else if (self.imageStrArr.count == 0){
        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"upProPic"]];
    }else if (!self.model.ItemList.param && self.priceField.text.length == 0){
        [ZTProgressHUD showMessage:@"请输入商品价格"];
    }else if (self.model.ItemList.param && [self.seleModel1.enable isEqualToString:@"0"]){
        [ZTProgressHUD showMessage:@"此商品缺货"];
    }else if (self.model.ItemList.param && [self.seleModel1.quantity isEqualToString:@"0"]){
        [ZTProgressHUD showMessage:@"此商品缺货"];
    }else{
        KweakSelf(self);
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"FastAdd"];
        NSDictionary *param1 = @{@"carttype":@"1",@"lang":self.lang,@"cry":self.cry,@"back":@"1",@"site":self.model.SiteName,@"sitelink":self.linkUrl,@"memberToken":self.memberToken};
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:param1];
        if(self.model.ItemList.title){
            [param setValue:self.model.ItemList.title forKey:@"name"];
        }else{
            [param setValue:self.nameFiled.text forKey:@"name"];
        }
        
        if(self.specField.text.length > 0){
            [param setValue:self.specField.text forKey:@"attribute"];
        }
        
        if(self.model.ItemList.param){
            [param setValue:self.seleModel1.price forKey:@"price"];
        }else{
            [param setValue:self.priceField.text forKey:@"price"];
        }
        
        [param setValue:self.imageStrArr[0] forKey:@"picture"];
        [param setValue:self.numLa.text forKey:@"num"];
        [param setValue:self.floatpricerate forKey:@"floatpricerate"];
        [param setValue:self.sureid forKey:@"sureid"];
        
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                MMDMOrderConfirmationVC *confirmVC = [[MMDMOrderConfirmationVC alloc]init];
                [weakself.navigationController pushViewController:confirmVC animated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
   
    
    
    
}

#pragma mark -- uisliderdelegate
-(void)sliderValueChange:(UISlider *)sender{
    UISlider* control = (UISlider*)sender;
    self.valueLa.text = [NSString stringWithFormat:@"%.f%%",control.value];
    self.floatpricerate = [NSString stringWithFormat:@"%.f",control.value];
}


-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}






@end
