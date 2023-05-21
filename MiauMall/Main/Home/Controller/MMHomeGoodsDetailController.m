//
//  MMHomeGoodsDetailController.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/12.
//  首页商品详情

#import "MMHomeGoodsDetailController.h"
#import "MMSearchViewController.h"
#import "MMGoodsDetailMainModel.h"
#import "MMGoodsProInfoModel.h"
#import "MMGoodsSpecModel.h"
#import "MMTopBannerView.h"
#import "MMGoodsInfoView.h"
#import "MMAssessView.h"
#import "MMRotationPicModel.h"
#import "MMAddressModel.h"
#import "MMAttlistItemModel.h"
#import "MMGoodsSpecItemModel.h"
#import "MMAttlistItemModel.h"
#import "MMAssessTagsModel.h"
#import "MMGoodsDetailAssessModel.h"
#import "MMAssessView.h"
#import "MMShopInfoView.h"
#import "MMPromiseView.h"
#import "MMSpecificationView.h"
#import "MMDetailImgView.h"
#import "MMBrandListModel.h"
#import "MMDiscountView.h"//优惠弹窗
#import "MMSelectSKUPopView.h"//sku选择弹窗
#import "MMServiceDesPopView.h"
#import "MMGoodsDatailTopView.h"
#import "MMGoodsDetailBottomView.h"
#import "MMAssessListViewController.h"
#import "MMPromiseVC.h"
#import "MMSharePopView.h"
#import "MMCretPosterView.h"
#import "MMGoodsPriceView.h"
#import "MMChangeListView.h"
#import "MMBrandDetailVC.h"
#import <WebKit/WebKit.h>

#import "MMKeFuModel.h"
#import "MMCustomerServiceVC.h"

#import "MMPayResultModel.h"
#import "MMPayViewController.h"

//乐天
#import "MMLTProgressView.h"
#import "MMLTShipInfoView.h"
#import "MMLTGoodsInfoView.h"

//英文版
#import "MMGoodsNameEnView.h"
#import "MMGoodsPriceEnView.h"
#import "MMGoodsDiscountEnView.h"
#import "MMParamInfoEnView.h"
#import "MMGoodsDetailParamEnPopView.h"
#import "MMSpecSelectEnView.h"
#import "MMPrecautionsTipEnView.h"
#import "MMAssureEnView.h"

@interface MMHomeGoodsDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UIButton *collectionBt;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家

@property (nonatomic, strong) NSMutableArray *similarArr;//类似商品数组
@property (nonatomic, strong) NSMutableArray *recommendArr;//推荐商品数组

@property (nonatomic, strong) NSMutableArray *goodsArr;//推荐商品列表
@property (nonatomic, strong) NSMutableArray *evaluateArr;//评价列表
@property (nonatomic, strong) NSMutableArray *evaluateTags;//评价标签列表

@property (nonatomic, strong) NSMutableArray *goodsSpecArr;//规格数组
@property (nonatomic, strong) NSMutableArray *goodsSpecShowArr;//规格展示数组

@property (nonatomic, strong) NSMutableArray *addressArr;//地址数组
@property (nonatomic, strong) NSMutableArray *rotationArr;//可滚动的图片数组

@property (nonatomic, strong) NSMutableArray *goodsImageHArr;//商品详情图片高度数组
@property (nonatomic, strong) NSMutableArray *specStrArr;//规格参数字符串数组
@property (nonatomic, assign) CGFloat specifiHei;//规格参数整体高度
@property (nonatomic, strong) NSMutableArray *specHArr;//每个规格参数的高度数组

@property (nonatomic, assign) float headerViewHeight;//列表头部视图高度

@property (nonatomic, strong) MMGoodsDetailMainModel *homeModel;//主要信息
@property (nonatomic, strong) MMGoodsProInfoModel *proInfoModel;//次要信息
@property (nonatomic, strong) MMGoodsSpecModel *goodsSpecInfo;//商品规格信息
@property (nonatomic, strong) MMAttlistItemModel *attlistModel; //规格层级显示数据
@property (nonatomic, strong) MMBrandListModel *brandListModel;//品牌推荐商品列表

@property (nonatomic, strong) NSString *attid;//商品规格ID 加入购物车和购买时要用到
@property (nonatomic, strong) NSString *numStr;//商品数量  加入购物车和购买时要用到
@property (nonatomic, strong) NSString *attid1;//商品规格ID 加入购物车和购买时要用到
@property (nonatomic, strong) NSString *numStr1;//商品数量  加入购物车和购买时要用到

@property (nonatomic, strong) NSString *goodsId;//商品ID


@property (nonatomic, strong) MMAddressModel *normalAddressModel;//默认收货信息 没有请添加收货地址
//承诺图片高度
@property (nonatomic, assign) CGFloat tkynHeight;
//详情图片高度
@property (nonatomic, assign) CGFloat detailH;

@property (nonatomic, strong) MMGoodsAttdataModel *attModel; //默认选择的规格属性
 
//UI模块

//乐天 cid 828
@property (nonatomic, strong) NSString *bgImageUrl;//品牌直供流程图
@property (nonatomic, strong) MMLTProgressView *ltProgressView; //流程view
@property (nonatomic, strong) MMLTGoodsInfoView *ltGoodsInfoView;//商品信息
@property (nonatomic, strong) MMLTShipInfoView *ltShipView; //规格库存等


@property (nonatomic, strong) MMTopBannerView *bannerView;
@property (nonatomic, strong) UIImageView *limitImage;
@property (nonatomic, strong) MMGoodsPriceView *priceView;
@property (nonatomic, strong) MMGoodsInfoView *goodsInfoView;//商品信息
@property (nonatomic, strong) MMAssessView *assessView;//评价模块
@property (nonatomic, strong) MMShopInfoView *shopInfoView;//店铺信息
@property (nonatomic, strong) MMPromiseView *promiseView; //蜜柚承诺view
@property (nonatomic, strong) MMSpecificationView *specificationView;//规格参数view
@property (nonatomic, strong) WKWebView *detailImgView;//详情图片view
@property (nonatomic, strong) WKWebView *otherWebView;//otherWebview
@property (nonatomic, assign) CGFloat otherViewHei;//otherView高度
@property (nonatomic, assign) CGFloat detailImgHei;//详情图片高度
@property (nonatomic, strong) MMChangeListView *recommendView;//推荐商品头部view
@property (nonatomic, strong) UIButton *similarBt;//类似
@property (nonatomic, strong) UIButton *recommendBt;//推荐
@property (nonatomic, strong) UIView *linView;
@property (nonatomic, strong) MMGoodsDatailTopView *topView;//顶部topview
@property (nonatomic, strong) MMGoodsDetailBottomView *bottomView;//底部view
@property (nonatomic, strong) MMDiscountView *discountPopView;//点击优惠弹窗
@property (nonatomic, strong) MMSelectSKUPopView *skuPopView; //sku弹窗 详情商品
@property (nonatomic, strong) MMSelectSKUPopView *skuPopView1; //sku弹窗 列表商品
@property (nonatomic, strong) MMServiceDesPopView *servicePopView;//服务说明弹窗
@property (nonatomic, strong) MMSharePopView *sharePopView;//分享弹窗
@property (nonatomic, strong) MMCretPosterView *creatPopView;//生成海报弹窗

@property (nonatomic, strong) NSString *type;//0 展示类似商品列表 1 展示推荐商品列表
@property (nonatomic, assign) NSInteger page0; //类似商品的page
@property (nonatomic, assign) NSInteger page1; //推荐商品的page


@property (nonatomic, strong) UITabBarItem *cartabBarItem;

@property (nonatomic, strong) UIButton *backTopBt;

@property (nonatomic, strong) MMKeFuModel *kefuModel;


//英文版
@property (nonatomic, strong) MMGoodsNameEnView *nameView;
@property (nonatomic, strong) MMGoodsPriceEnView *priceEnView;
@property (nonatomic, strong) MMGoodsDiscountEnView *discountEnView;
@property (nonatomic, strong) MMParamInfoEnView *paramInfoView;
@property (nonatomic, strong) MMGoodsDetailParamEnPopView *paramEnPopView;
@property (nonatomic, strong) MMSpecSelectEnView *speceEnView;
@property (nonatomic, strong) MMPrecautionsTipEnView *tipsEnView;
@property (nonatomic, strong) MMAssureEnView *assureView;

@end

@implementation MMHomeGoodsDetailController

#pragma mark -- 懒加载创建

//英文版
-(MMGoodsNameEnView *)nameView{
    if(!_nameView){
        float hei = 12;
        CGSize size = [NSString sizeWithText:self.homeModel.proInfo.Name font:[UIFont fontWithName:@"PingFangSC-Semibold" size:23] maxSize:CGSizeMake(WIDTH - 30,MAXFLOAT)];
        hei += size.height + 18;
        CGSize size1 = [NSString sizeWithText:self.homeModel.proInfo.ShortName font:[UIFont fontWithName:@"PingFangSC-Semibold" size:23] maxSize:CGSizeMake(WIDTH - 30,MAXFLOAT)];
        if(size1.height > 10){
            hei += size1.height + 18;
        }
        _nameView = [[MMGoodsNameEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), WIDTH, hei) andData:self.homeModel];
        
    }
    return _nameView;
}

-(MMGoodsPriceEnView *)priceEnView{
    if(!_priceEnView){
        _priceEnView = [[MMGoodsPriceEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameView.frame), WIDTH, 60) andData:self.homeModel];
    }
    return _priceEnView;
}

-(MMGoodsDiscountEnView *)discountEnView{
    if(!_discountEnView){
        float mido = [self.homeModel.proInfo.Price floatValue]/100;
        NSInteger mido1 = [self.homeModel.proInfo.Price integerValue]/100;
        float sub = mido - mido1;
        NSString *discount;
        if(sub > 0){
            discount = [NSString stringWithFormat:@"+%ld %@",mido1 + 1,[UserDefaultLocationDic valueForKey:@"midou"]];
        }else{
            discount = [NSString stringWithFormat:@"%.f%@",mido,[UserDefaultLocationDic valueForKey:@"midou"]];
        }
        
        if(self.homeModel.proInfo.DiscountName == nil || self.homeModel.proInfo.DiscountName.length == 0){
            
        }else{
            discount = [NSString stringWithFormat:@"%@ | %@",discount,self.homeModel.proInfo.DiscountName];
        }
        
        if(self.homeModel.proInfo.PriceCutName == nil || [self.homeModel.proInfo.PriceCutName isEmpty] || [self.homeModel.proInfo.PriceCutName isEqualToString:@""]){
            
        }else{
            discount = [NSString stringWithFormat:@"%@ | %@",discount,self.homeModel.proInfo.PriceCutName];
        }
        
        if(self.proInfoModel.OptionalName == nil || self.proInfoModel.OptionalName.length == 0){
            
        }else{
            discount = [NSString stringWithFormat:@"%@ | %@",discount,self.proInfoModel.OptionalName];
        }
        
        CGSize size = [NSString sizeWithText:discount font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16] maxSize:CGSizeMake(WIDTH - 32,MAXFLOAT)];
        _discountEnView = [[MMGoodsDiscountEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceEnView.frame), WIDTH, size.height + 38) andBaseInfo:self.homeModel andMoreInfo:self.proInfoModel];
    }
    return _discountEnView;
}

-(MMParamInfoEnView *)paramInfoView{
    KweakSelf(self);
    if(!_paramInfoView){
        NSArray *arr = [self.proInfoModel.GuideParam componentsSeparatedByString:@"\r\n"];
        NSString *str = [arr[0] stringByReplacingOccurrencesOfString:@"|" withString:@":"];
        
        CGSize size = [NSString sizeWithText:str font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(WIDTH - 44,MAXFLOAT)];
        _paramInfoView = [[MMParamInfoEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.discountEnView.frame), WIDTH, size.height + 60) andMoreInfo:self.proInfoModel];
        _paramInfoView.returnParamBlock = ^(NSString * _Nonnull str) {
            [weakself showParamView];
        };
    }
    return _paramInfoView;
}

-(MMSpecSelectEnView *)speceEnView{
    if(!_speceEnView){
        KweakSelf(self);
        _speceEnView = [[MMSpecSelectEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.paramInfoView.frame), WIDTH, 235) andModel:self.homeModel andGoodsSpecArr:self.goodsSpecArr];
        if(self.proInfoModel.GuideParam.length == 0 || self.proInfoModel.GuideParam == nil){
            _speceEnView.y = CGRectGetMaxY(self.discountEnView.frame);
        }
        _speceEnView.returnSelectBlock = ^(NSString * _Nonnull str) {
            if([weakself.homeModel.proInfo.cid isEqualToString:@"794"]){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSDate *dateTime = [formatter dateFromString:weakself.homeModel.proInfo.DepositEndTime];
                
                NSTimeInterval a = [dateTime timeIntervalSince1970];
                
                NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
                NSTimeInterval a1 = [datenow timeIntervalSince1970];
                
                if(a1 > a){
                    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"depositEnd2"]];
                }else{
                    weakself.skuPopView.type = @"0";
                    [weakself showSkuView];
                }
            }else{
                weakself.skuPopView.type = @"0";
                [weakself showSkuView];
            }
        };
    }
    return _speceEnView;
}

-(MMPrecautionsTipEnView *)tipsEnView{
    if(!_tipsEnView){
        CGSize size = [NSString sizeWithText:self.homeModel.proInfo.Precautions font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 36,MAXFLOAT)];
        _tipsEnView = [[MMPrecautionsTipEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.speceEnView.frame), WIDTH, size.height + 40) andModel:self.homeModel];
    }
    return _tipsEnView;
}

-(MMAssureEnView *)assureView{
    if(!_assureView){
        NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"directMail"],[UserDefaultLocationDic valueForKey:@"guarante"],[UserDefaultLocationDic valueForKey:@"falsePays"],[UserDefaultLocationDic valueForKey:@"taxInclusive"],[UserDefaultLocationDic valueForKey:@"bzcwlythh"]];
        float hei = 22;
        for (int i = 0; i < arr.count; i++) {
            CGSize size = [NSString sizeWithText:arr[i] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(WIDTH - 52,MAXFLOAT)];
            hei += size.height + 12;
        }
        hei += 10;
        _assureView = [[MMAssureEnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipsEnView.frame), WIDTH, hei)];
        if([self.homeModel.proInfo.IsCanReturn isEqualToString:@"1"]){
            _assureView.y = CGRectGetMaxY(self.speceEnView.frame);
        }
    }
    return _assureView;
}


//其他版
-(UIButton *)backTopBt{
    if(!_backTopBt){
        _backTopBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 45, HEIGHT - 105 - TabbarHeight, 40, 40)];
        [_backTopBt setImage:[UIImage imageNamed:@"back_top_icon"] forState:(UIControlStateNormal)];
        _backTopBt.hidden = YES;
        [_backTopBt addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backTopBt;
}

-(UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout = layout;
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.numberOfColumns = 2;
//        layout.insets = UIEdgeInsetsMake(0, 10, 0, 10);
//        layout.rowGap = 10;
//        layout.columnGap = 10;
//        layout.sectionCount = 2;
//        layout.itemHeights = self.goodsHArr;
        // 头部视图悬停
//        MMFlowLayout *layout = [[MMFlowLayout alloc]init];
//        layout.sectionHeadersPinToVisibleBounds = NO;
        
    //设置垂直间的最小间距
    layout.minimumLineSpacing = 10;
    //设置水平间的最小间距
    layout.minimumInteritemSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(WIDTH,self.headerViewHeight + 44);
    layout.sectionInset = UIEdgeInsetsMake(10,10,0, 10);//item对象上下左右的距离
    layout.itemSize=CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);//每一个 item 对象大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 130 + StatusBarHeight) collectionViewLayout:layout];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.backgroundColor = UIColor.clearColor;
        _mainCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
//    _mainCollectionView.showsVerticalScrollIndicator = YES;
//    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_mainCollectionView registerClass:[MMHomeShopGoodsCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        }
    return _mainCollectionView;
}

//-(UIScrollView *)mainScrollView{
//    if(!_mainScrollView){
//        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 80 + StatusBarHeight - 25)];
//        _mainScrollView.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
//        _mainScrollView.delegate = self;
//        _mainScrollView.showsVerticalScrollIndicator = NO;
//        _mainScrollView.showsHorizontalScrollIndicator = NO;
//    }
//    return _mainScrollView;
//}

-(NSMutableArray *)similarArr{
    if(!_similarArr){
        _similarArr = [NSMutableArray array];
    }
    return _similarArr;
}

-(NSMutableArray *)recommendArr{
    if(!_recommendArr){
        _recommendArr = [NSMutableArray array];
    }
    return _recommendArr;
}

-(NSMutableArray *)goodsArr{
    if(!_goodsArr){
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(NSMutableArray *)evaluateArr{
    if(!_evaluateArr){
        _evaluateArr = [NSMutableArray array];
    }
    return _evaluateArr;
}

-(NSMutableArray *)evaluateTags{
    if(!_evaluateTags){
        _evaluateTags = [NSMutableArray array];
    }
    return _evaluateTags;
}

-(NSMutableArray *)goodsSpecArr{
    if(!_goodsSpecArr){
        _goodsSpecArr = [NSMutableArray array];
    }
    return _goodsSpecArr;
}

-(NSMutableArray *)goodsSpecShowArr{
    if(!_goodsSpecShowArr){
        _goodsSpecShowArr = [NSMutableArray array];
    }
    return _goodsSpecShowArr;
}

-(NSMutableArray *)addressArr{
    if(!_addressArr){
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}

-(NSMutableArray *)rotationArr{
    if(!_rotationArr){
        _rotationArr = [NSMutableArray array];
    }
    return _rotationArr;
}

-(NSMutableArray *)specHArr{
    if(!_specHArr){
        _specHArr = [NSMutableArray array];
    }
    return _specHArr;
}

-(NSMutableArray *)goodsImageHArr{
    if(!_goodsImageHArr){
        _goodsImageHArr = [NSMutableArray array];
    }
    return _goodsImageHArr;
}

-(MMGoodsDatailTopView *)topView{
    if(!_topView){
        _topView = [[MMGoodsDatailTopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight + 84)];
        _topView.scrollIndex = @"0";
    }
    return _topView;
}

-(MMTopBannerView *)bannerView{
    if(!_bannerView){
        _bannerView = [[MMTopBannerView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
        
    }
    return _bannerView;
}

-(MMLTGoodsInfoView *)ltGoodsInfoView{
    CGSize size1 = [NSString sizeWithText:self.homeModel.proInfo.ProductSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = size1.width + 16;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16]}];
    CGFloat hei1 = [self textViewHeightForAttributedString:attrText withWidth:WIDTH - 44];
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Precautions] attributes:@{NSParagraphStyleAttributeName: style1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
    CGFloat hei2 = [self textViewHeightForAttributedString:attrText1 withWidth:WIDTH - 44];
    
    if(hei2 > 0){
        hei2 += 12;
    }
    
    if([self.lang isEqualToString:@"1"]){
        hei1 += 29;
    }
    
    CGSize size000 = [NSString sizeWithText:self.homeModel.proInfo.ShortName font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 44,12)];
    
    if(!_ltGoodsInfoView){
        _ltGoodsInfoView = [[MMLTGoodsInfoView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bannerView.frame) + 12, WIDTH - 20, 136 + hei1 + hei2 + size000.height) andInfo:self.homeModel];
    }
    return _ltGoodsInfoView;
}

-(MMLTShipInfoView *)ltShipView{
    if(!_ltShipView){
        _ltShipView = [[MMLTShipInfoView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ltGoodsInfoView.frame) + 12, WIDTH - 20, 200)];
        if([self.lang isEqualToString:@"1"]){
            _ltShipView.height = 229;
        }
        _ltShipView.proInfo = self.homeModel;
        if(self.attModel.attr != nil){
            _ltShipView.showStr = [NSString stringWithFormat:@"%@ x1%@",self.attModel.attr,[UserDefaultLocationDic valueForKey:@"ipieces"]];
        }
       
    }
    return _ltShipView;
}

-(MMLTProgressView *)ltProgressView{
    if(!_ltProgressView){
        _ltProgressView = [[MMLTProgressView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ltShipView.frame) + 12, WIDTH - 20, 125)];
        _ltProgressView.imageUrl = self.bgImageUrl;
    }
    return _ltProgressView;
}

-(UIImageView *)limitImage{
    KweakSelf(self);
    if(!_limitImage){
        _limitImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bannerView.frame) + 12, WIDTH - 20, 82)];
//        _limitImage.image = [UIImage imageNamed:@"limit_bg"];
        if([self.lang isEqualToString:@"1"]){
            [_limitImage sd_setImageWithURL:[NSURL URLWithString:@"https://app.miau2020.com/upload/config/20220803144424964.png"] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
        }else{
            [_limitImage sd_setImageWithURL:[NSURL URLWithString:@"http://static.miau2020.com/upload/config/20220729152625418.png"] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
        }
       
        
        UILabel *priceLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:28 numberOfLines:0];
        priceLa.preferredMaxLayoutWidth = WIDTH - 130;
        [priceLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_limitImage addSubview:priceLa];
        [priceLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.top.mas_equalTo(44);
                    make.height.mas_equalTo(24);
        }];
        NSString *price;
        price = [self.homeModel.proInfo.ActivePrice floatValue] > 0?self.homeModel.proInfo.ActivePriceShowPrice:self.homeModel.proInfo.PriceShowPrice;
        [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(weakself.homeModel.proInfo.PriceShowSign).textColor(TCUIColorFromRGB(0xffffff)).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]);
            confer.text(price).textColor(TCUIColorFromRGB(0xffffff)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:28]);
        }];
        
        NSDate *datenow = [NSDate date];
        //时间转时间戳的方法:
        NSInteger timesp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];//现在时间

        NSInteger timesp2 = [self.homeModel.proInfo.PromotionEnd integerValue];
        CountDownLabel *lab = [[CountDownLabel alloc]initWithKeyInfo:@"limit1more"];
        lab.frame = CGRectMake(0, 0, 10, 11);
        lab.hidden = YES;
        [_limitImage addSubview:lab];
        
        UILabel *dayLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
        dayLa.frame = CGRectMake(WIDTH - 132, 30, 100, 12);
        [_limitImage addSubview:dayLa];
        
        UILabel *hourLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
        hourLa.backgroundColor = TCUIColorFromRGB(0xffffff);
        hourLa.layer.masksToBounds = YES;
        hourLa.layer.cornerRadius = 2.5;
        hourLa.frame = CGRectMake(WIDTH - 116, 52, 16, 16);
        [_limitImage addSubview:hourLa];
        
        UILabel *lab1 = [UILabel publicLab:@":" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
        lab1.frame = CGRectMake(CGRectGetMaxX(hourLa.frame) + 7, 52, 2, 7);
        [_limitImage addSubview:lab1];
        
        UILabel *minLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
        minLa.backgroundColor = TCUIColorFromRGB(0xffffff);
        minLa.layer.masksToBounds = YES;
        minLa.layer.cornerRadius = 2.5;
        minLa.frame = CGRectMake(CGRectGetMaxX(lab1.frame) + 7, 52, 16, 16);
        [_limitImage addSubview:minLa];
        
        UILabel *lab2 = [UILabel publicLab:@":" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
        lab2.frame = CGRectMake(CGRectGetMaxX(minLa.frame) + 7, 52, 2, 7);
        [_limitImage addSubview:lab2];
        
        UILabel *secLa = [UILabel publicLab:@"" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
        secLa.backgroundColor = TCUIColorFromRGB(0xffffff);
        secLa.layer.masksToBounds = YES;
        secLa.layer.cornerRadius = 2.5;
        secLa.frame = CGRectMake(CGRectGetMaxX(lab2.frame) + 7, 52, 16, 16);
        [_limitImage addSubview:secLa];
        
        [lab startCountDownWithTotalTime:timesp2 - timesp - 8 * 3600 countDowning:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            dayLa.text = [NSString stringWithFormat:@"%@%ld%@",[UserDefaultLocationDic valueForKey:@"iCountdown2"],(long)day,[UserDefaultLocationDic valueForKey:@"idays"]];
            NSString *hourStr;
            NSString *minuteStr;
            NSString *secondStr;
            if(hour < 10){
                hourStr = [NSString stringWithFormat:@"0%ld",hour];
            }else{
                hourStr = [NSString stringWithFormat:@"%ld",hour];
            }

            if(minute < 10){
                minuteStr = [NSString stringWithFormat:@"0%ld",minute];
            }else{
                minuteStr = [NSString stringWithFormat:@"%ld",minute];
            }
            
            if(second < 10){
                secondStr = [NSString stringWithFormat:@"0%ld",second];
            }else{
                secondStr = [NSString stringWithFormat:@"%ld",second];
            }
            hourLa.text = hourStr;
            minLa.text = minuteStr;
            secLa.text = secondStr;
        } countDownFinished:^(NSTimeInterval leftTime) {
            
        } waitingBlock:^{
            
        }];
    }
    return _limitImage;
}

-(MMGoodsPriceView *)priceView{
    if(!_priceView){
        _priceView = [[MMGoodsPriceView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bannerView.frame) + 12, WIDTH - 20, 70)];
    }
    return _priceView;
}

-(MMGoodsInfoView *)goodsInfoView{
    CGSize size1 = [NSString sizeWithText:self.homeModel.proInfo.ProductSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = size1.width + 8;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16]}];
    CGFloat hei1 = [self textViewHeightForAttributedString:attrText withWidth:WIDTH - 44];
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Precautions] attributes:@{NSParagraphStyleAttributeName: style1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
    CGFloat hei2 = [self textViewHeightForAttributedString:attrText1 withWidth:WIDTH - 44];
    
    if(!_goodsInfoView){
        _goodsInfoView = [[MMGoodsInfoView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.priceView.frame) - 20, WIDTH - 20, 340)];
        if([self.homeModel.proInfo.IsLimitTime isEqualToString:@"1"]){
            _goodsInfoView.y = CGRectGetMaxY(self.limitImage.frame);
            _goodsInfoView.height = 340;
        }
        if(!self.homeModel){
            _goodsInfoView.height = 340;
        }else{
            if([self.homeModel.proInfo.cid isEqualToString:@"828"]){
                if(self.homeModel.proInfo.ShortName.length > 6){
                   
                }else{
                    _goodsInfoView.height = 340 + hei1 + 12;
                    
                }
            }else{
               
                if([self.homeModel.proInfo.IsCanReturn isEqualToString:@"0"] && self.homeModel.proInfo.Precautions.length > 6){
                    if(self.homeModel.proInfo.ShortName.length > 6){
                        _goodsInfoView.height = 352 + hei2 + 12 + hei1 + 12;
                    }else{
                        _goodsInfoView.height = 340 + hei2 + 12 + hei1 + 12;
                    }
                    
                }else{
                    if(self.homeModel.proInfo.ShortName.length > 6){
                        _goodsInfoView.height = 352  + hei1 + 12;
                    }else{
                        _goodsInfoView.height = 340 + hei1 + 12;
                    }
                }
                if([self.homeModel.proInfo.cid isEqualToString:@"794"]){
                    _goodsInfoView.height += 66;
                }
                
            }
        }
        
    }
    return _goodsInfoView;
}

-(MMAssessView *)assessView{
    NSArray *arr = [MMGoodsDetailAssessModel mj_objectArrayWithKeyValuesArray:self.proInfoModel.assesslist];
    CGFloat hei = 0;
    if(!_assessView){
        _assessView = [[MMAssessView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.goodsInfoView.frame) + 12, WIDTH - 20, 78)];
        if([self.proInfoModel.cid isEqualToString:@"828"]){
            _assessView.y = CGRectGetMaxY(self.ltProgressView.frame) + 12;
        }
        if([self.lang isEqualToString:@"1"]){
            _assessView.y = CGRectGetMaxY(self.assureView.frame);
        }
        if(self.proInfoModel.assesslist.count == 0){
            _assessView.height = 78;
        }else if (self.proInfoModel.assesslist.count == 1){
            MMGoodsDetailAssessModel *model = arr[0];
            UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
            CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
            hei = size.height + 138;
            _assessView.height = hei;
        }else{
            for (int i = 0; i < 2; i++) {
                MMGoodsDetailAssessModel *model = arr[i];
                UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
                la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
                CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
                hei = (size.height + 52) + hei;
            }
            _assessView.height = hei + 86;
        }
    }
    return _assessView;
}

-(MMShopInfoView *)shopInfoView{
    NSInteger num = [self.proInfoModel.brandInfo.BrandNum integerValue];
    if(!_shopInfoView){
        _shopInfoView = [[MMShopInfoView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.assessView.frame) + 12, WIDTH - 20, 342)];
        if(!self.proInfoModel.brandInfo){
            _shopInfoView.height = 0;
        }else{
            if(num <= 3){
                _shopInfoView.height = 73;
            }
        }
        
    }
    return _shopInfoView;
}
-(MMPromiseView *)promiseView{
    if(!_promiseView){
        _promiseView = [[MMPromiseView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shopInfoView.frame) + 12, WIDTH, self.tkynHeight)];
        if(!self.proInfoModel.brandInfo){
            _promiseView.y = CGRectGetMaxY(self.assessView.frame) + 12;
        }
    }
    return _promiseView;
}

-(MMSpecificationView *)specificationView{
    if(!_specificationView){
        _specificationView = [[MMSpecificationView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.promiseView.frame) + 12, WIDTH - 20, self.specifiHei)];
    }
    return _specificationView;
}

-(WKWebView *)detailImgView{
    if(!_detailImgView){
        _detailImgView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.specificationView.frame) + 12, WIDTH,1)];
              
        if([self.proInfoModel.GuideParam isEmpty]){
            _detailImgView.y = CGRectGetMaxY(self.promiseView.frame) + 12;
        }
        _detailImgView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _detailImgView.navigationDelegate = self;
        _detailImgView.UIDelegate = self;
        _detailImgView.opaque = NO;
        _detailImgView.scrollView.scrollEnabled = NO;
        [_detailImgView loadHTMLString:self.proInfoModel.Conts baseURL:nil];
       
        //WKWebView
        [_detailImgView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _detailImgView;
}

-(WKWebView *)otherWebView{
    if(!_otherWebView){
        _otherWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.detailImgView.frame), WIDTH, 1)];
        _otherWebView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _otherWebView.navigationDelegate = self;
        _otherWebView.UIDelegate = self;
        _otherWebView.opaque = NO;
        _otherWebView.scrollView.scrollEnabled = NO;
        [_otherWebView loadHTMLString:self.proInfoModel.Other baseURL:nil];
       
    }
    return _otherWebView;
}

//-(MMDetailImgView *)detailImgView{
//    if(!_detailImgView){
//        _detailImgView = [[MMDetailImgView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.specificationView.frame) + 12, WIDTH - 20, self.detailH)];
//        if([self.proInfoModel.GuideParam isEmpty]){
//            _detailImgView.y = CGRectGetMaxY(self.promiseView.frame) + 12;
//        }
//    }
//    return _detailImgView;
//}

-(MMChangeListView *)recommendView{
    if(!_recommendView){
        _recommendView = [[MMChangeListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.otherWebView.frame) + 5, WIDTH, 44)];
//        if(self.detailImgView == nil){
//            _recommendView.y = CGRectGetMaxY(self.specificationView.frame) + 12;
//            if(!self.specificationView){
//                _recommendView.y = CGRectGetMaxY(self.promiseView.frame) + 12;
//            }
//        }
        
    }
    return _recommendView;
}

-(MMGoodsDetailBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[MMGoodsDetailBottomView alloc]initWithFrame:CGRectMake(0, HEIGHT - 80, WIDTH, 80)];
        _bottomView.num = self.homeModel.proInfo.cartnum;
        _bottomView.model = self.homeModel;
    }
    return _bottomView;
}

#pragma mark -- 进入页面
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"商品详情页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.numStr = @"1";
    self.page0 = 1;
    self.page1 = 1;
    self.type = @"0";
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    if(!self.memberToken && !self.tempcart){
        NSString *str1 = [self generateTradeNO:8];
        NSString *str2 = [self generateTradeNO:4];
        NSString *str3 = [self generateTradeNO:4];
        NSString *str4 = [self generateTradeNO:4];
        NSString *str5 = [self generateTradeNO:12];
        self.tempcart = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",str1,str2,str3,str4,str5];
        [self.userDefaults setValue:self.tempcart forKey:@"tempcart"];
        [self.userDefaults  synchronize];
    }
    self.view.backgroundColor = TCUIColorFromRGB(0xdddddd);
    
    UITabBarController * root = self.tabBarController; // self当前的viewController
    UITabBarItem * tabBarItem = [UITabBarItem new];
    if (root.tabBar.items.count > 3) {
        tabBarItem = root.tabBar.items[3];// 拿到需要设置角标的tabarItem
        self.cartabBarItem = tabBarItem;
    }
    
//    self.detailImgHei = HEIGHT - StatusBarHeight - 164;
    
    [self loadHttpData];
    
   
    // Do any additional setup after loading the view.
}

-(void)SetBrowseRecord{
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"SetBrowseRecord"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    if(self.ID){
        [param setValue:self.ID forKey:@"ItemID"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"ItemID"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",jsonDic);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)loadHttpData {
    KweakSelf(self);
    [ZTProgressHUD showLoadingWithMessage:@""];
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求乐天商品等流程图
        [weakself GetPicture];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求商品详情主要数据
        [weakself requestMainData];
    });
    
    if(self.memberToken){
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //将商品添加进足迹列表
            [weakself SetBrowseRecord];
        });
    }
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求次要数据
        [weakself requestDataSecond];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求规格
        [weakself requestGoodsspec];
    });
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //请求地址
//        [weakself requestAddressList];
//    });
 
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //请求晒单信息
     [weakself requestShareData];
 });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //请求评价信息
     [weakself requestEvaData];
 });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //请求评价信息
     [weakself requestSimilarGoodsList];
 });

 
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //请求评价信息
     [weakself requestRecommendGoodsList];
 });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        [weakself CalculationTopHeight];
    });
//    dispatch_group_t group = dispatch_group_create();
//       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//           //请求商品详情主要数据
//           [weakself requestMainData];
//       });
//       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//           //请求次要数据
//           [weakself requestDataSecond];
//       });
//       dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//           //请求规格
//           [weakself requestGoodsspec];
//       });
//
//       dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//           //界面刷新
//           [weakself CalculationTopHeight];
//       });
   
}

-(void)CalculationTopHeight{
    if([self.lang isEqualToString:@"1"]){
        [self setUI1];
    }else{
        self.headerViewHeight = 0;
        //banner高度
        self.headerViewHeight += WIDTH + 12;
        
        if([self.homeModel.proInfo.cid isEqualToString:@"828"]){
            CGSize size1 = [NSString sizeWithText:self.homeModel.proInfo.ProductSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] maxSize:CGSizeMake(MAXFLOAT,16)];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.firstLineHeadIndent = size1.width + 16;//首行缩进
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16]}];
            CGFloat hei1 = [self textViewHeightForAttributedString:attrText withWidth:WIDTH - 44];
            
            NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
            NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Precautions] attributes:@{NSParagraphStyleAttributeName: style1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
            CGFloat hei2 = [self textViewHeightForAttributedString:attrText1 withWidth:WIDTH - 44];
            
            CGSize size000 = [NSString sizeWithText:self.homeModel.proInfo.ShortName font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 44,12)];
            
            if(hei2 > 0){
                hei2 += 12;
            }
            
            self.headerViewHeight += size000.height;
            self.headerViewHeight += hei1 + 148 + 12 + hei2;
            self.headerViewHeight += 132 + 12;
            self.headerViewHeight += 125;
            self.headerViewHeight += 68;
            
            if([self.lang isEqualToString:@"1"]){
                self.headerViewHeight += 29;
            }
            
        }else{
            //价格高度
            self.headerViewHeight += 50;
            //商品信息高度
            //    UILabel *la = [UILabel publicLab:[NSString stringWithFormat:@"%@  %@",self.homeModel.proInfo.ProductSign,self.homeModel.proInfo.Name] textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:16 numberOfLines:0];
            //    la.frame = CGRectMake(0, 0, WIDTH - 44, 0);
            //    CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
            //    NSInteger realnum = [self.homeModel.proInfo.RealNumber integerValue];
            
            CGSize size1 = [NSString sizeWithText:self.homeModel.proInfo.ProductSign font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.firstLineHeadIndent = size1.width + 8;//首行缩进
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16]}];
            CGFloat hei1 = [self textViewHeightForAttributedString:attrText withWidth:WIDTH - 44];
            
            if([self.lang isEqualToString:@"1"]){
                hei1 += 29;//29是英语最下边的不支持无理由退货的高度
            }
            
            if([self.homeModel.proInfo.cid isEqualToString:@"794"]){
                hei1 += 66;
            }
            
            NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
            NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.homeModel.proInfo.Precautions] attributes:@{NSParagraphStyleAttributeName: style1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
            CGFloat hei2 = [self textViewHeightForAttributedString:attrText1 withWidth:WIDTH - 44];
            
            self.headerViewHeight += 340;
            if(!self.homeModel){
                
            }else{
                if(self.homeModel.proInfo.ShortName.length > 6){
                    self.headerViewHeight += 24;
                }
                
                if([self.homeModel.proInfo.cid isEqualToString:@"828"]){
                    
                }else{
                    if([self.homeModel.proInfo.IsCanReturn isEqualToString:@"0"] == YES && self.homeModel.proInfo.Precautions.length > 6){
                        self.headerViewHeight += hei2 + 12;
                    }else{
                        
                    }
                }
                
                self.headerViewHeight += hei1 + 12;
            }
        }
        
        
        
        
        
        //评价高度
        NSArray *arr = [MMGoodsDetailAssessModel mj_objectArrayWithKeyValuesArray:self.proInfoModel.assesslist];
        
        if(self.proInfoModel.assesslist.count == 0){
            self.headerViewHeight += 90;
        }else if (self.proInfoModel.assesslist.count == 1){
            MMGoodsDetailAssessModel *model = arr[0];
            UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
            CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
            self.headerViewHeight += size.height + 150;
        }else{
            float hei = 0;
            for (int i = 0; i < 2; i++) {
                MMGoodsDetailAssessModel *model = arr[i];
                UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
                la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
                CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
                hei = (size.height + 52) + hei;
            }
            self.headerViewHeight += hei + 98;
        }
        //品牌信息高度
        NSInteger num = [self.proInfoModel.brandInfo.BrandNum integerValue];
        if(num > 3){
            self.headerViewHeight += 354;
        }else{
            self.headerViewHeight += 85;
        }
        //蜜柚承诺高度
        
        self.headerViewHeight += self.tkynHeight + 12;
        //规格列表高度
        if([self.proInfoModel.GuideParam isEmpty]){
            
        }else{
            self.headerViewHeight += self.specifiHei + 12;
        }
        //商品详情图高度
        if(self.detailImgHei > 0){
            self.headerViewHeight += self.detailImgHei;
        }
        //other高度
        if(self.otherViewHei > 0){
            self.headerViewHeight += self.otherViewHei;
        }
        //切换list高度
        self.headerViewHeight += 56;
        [self setUI];
    }
    
    
    
}

//英文UI
-(void)setUI1{
    KweakSelf(self);
    [ZTProgressHUD hide];
    
    self.skuPopView = [[MMSelectSKUPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.goodsSpecInfo];
    self.skuPopView.SkuAndNumBlock = ^(MMGoodsAttdataModel * _Nonnull model, NSString * _Nonnull numStr) {
        
       
        NSInteger num = [model.number integerValue];
        NSString *stock;
        if(num > 0){
            if(num >= 10){
                stock = [NSString stringWithFormat:@"%@",[UserDefaultLocationDic valueForKey:@"inStock"]];
            }else{
               stock = [NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"istock"],model.number,[UserDefaultLocationDic valueForKey:@"ipiece"]];
            }
            
        }else{
           // stock = [NSString stringWithFormat:@"%@",self.homeModel.proInfo.ProductSignTimeStr];
        }
       
        if([weakself.homeModel.proInfo.cid isEqualToString:@"828"]){
            weakself.ltShipView.showStr = [NSString stringWithFormat:@"%@x%@",model.attr,numStr];
            weakself.ltShipView.stockStr = stock;
        }else{
            weakself.speceEnView.showStr = [NSString stringWithFormat:@"%@x%@",model.attr,numStr];
            weakself.speceEnView.stockStr = stock;
        }
        weakself.attid = model.ID;
        weakself.numStr = numStr;
    };
    self.skuPopView.addCarBlock = ^(NSString * _Nonnull str) {
        [weakself requestAddCar];
    };
    
    self.skuPopView.buyNowBlock = ^(NSString * _Nonnull str) {
        [weakself requestBuyNow];
    };
    
    self.skuPopView.payDepositBlock = ^(NSString * _Nonnull str) {
        [weakself DepositDown];
    };
    
    
    
    
    self.view.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:scrollView];
    self.mainScrollView = scrollView;
    
    self.bannerView.bannerArr = self.homeModel.proInfo.Albums;
    self.bannerView.model = self.homeModel;
    self.bannerView.tapImageBlock = ^(NSArray * _Nonnull arr, NSInteger index) {
        [weakself showBigImage:arr andIndex:index];
    };
    [scrollView addSubview:self.bannerView];
    
    [scrollView addSubview:self.nameView];
    
    [scrollView addSubview:self.priceEnView];
    
    [scrollView addSubview:self.discountEnView];
   
    
    if(self.proInfoModel.GuideParam.length == 0 || self.proInfoModel.GuideParam == nil){
        
    }else{
        [scrollView addSubview:self.paramInfoView];
        scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.paramInfoView.frame));
        
        NSArray *arr = [self.proInfoModel.GuideParam componentsSeparatedByString:@"\r\n"];
        
        float hei = 0;
        for (int i = 0; i < arr.count; i++) {
            NSString *str = arr[i];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange range = [str rangeOfString:@"|"];
            NSArray *array;
            if(range.location != NSNotFound){
                NSString *str1 = [str substringToIndex:range.location];
                NSString *str2 = [str substringFromIndex:range.location + 1];
                array = @[str1,str2];
            }
            
            CGSize size = [NSString sizeWithText:array[0] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(120,MAXFLOAT)];
            CGSize size1 = [NSString sizeWithText:array[1] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(WIDTH - 185,MAXFLOAT)];
            
            if(size.height < size1.height){
                hei += size1.height + 44;
            }else{
                hei += size.height + 44;
            }
            
            
        }
        self.paramEnPopView = [[MMGoodsDetailParamEnPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andMoreInfo:self.proInfoModel andHei:hei + 161];
     
    }
    
    [scrollView addSubview:self.speceEnView];
    
    if([self.homeModel.proInfo.IsCanReturn isEqualToString:@"0"]){
        [scrollView addSubview:self.tipsEnView];
    }
    
    [scrollView addSubview:self.assureView];
    
    self.assessView.proInfoModel = self.proInfoModel;
    self.assessView.tags = self.evaluateTags;
    self.assessView.assessTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goAssessList];
    };
    [scrollView addSubview:self.assessView];
    
    
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.assessView.frame));
    
    
}

-(void)setUI{
    KweakSelf(self);
    [ZTProgressHUD hide];
    
//    [self.view addSubview:self.mainCollectionView];
    
    self.discountPopView = [[MMDiscountView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.homeModel andMoreModel:self.proInfoModel];
    self.discountPopView.jumpTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself.discountPopView hideView];
        [weakself goIntegralRule];
    };
    
    self.sharePopView = [[MMSharePopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.sharePopView.tapNumBlock = ^(NSInteger index) {
        if(index == 1){
            [weakself showCreatView];
        }else{
            if(index == 0){
               
                dispatch_queue_t q = dispatch_queue_create("ll", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(q, ^{
                    WXMiniProgramObject *object = [WXMiniProgramObject object];
                    object.webpageUrl = @"http://uniapp.dcloud.io";
                    object.userName = @"gh_8c9eabe6d697";
                    object.path = [NSString stringWithFormat:@"pages/shop/info?id=%@",weakself.homeModel.proInfo.ID];
                    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakself.homeModel.proInfo.Picture]];
                    object.hdImageData = data;
                    
                    object.withShareTicket = NO;
                    object.miniProgramType = WXMiniProgramTypeRelease;
                    WXMediaMessage *message = [WXMediaMessage message];
                    message.title = weakself.homeModel.proInfo.Name;
                    message.description = @"MiauMall";
    //                message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
                                              //使用WXMiniProgramObject的hdImageData属性
                    message.mediaObject = object;
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = WXSceneSession;  //目前只支持会话
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [WXApi sendReq:req completion:nil];
                    });
                    
                });
               
            }
            
        }
        
    };
    
    self.creatPopView = [[MMCretPosterView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.homeModel andGoodsInfo:self.proInfoModel];
    self.creatPopView.tapNumBlock = ^(NSInteger index) {
        [ZTProgressHUD showMessage:[NSString stringWithFormat:@"%ld",index]];
    };
    
    self.skuPopView = [[MMSelectSKUPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:self.goodsSpecInfo];
    self.skuPopView.SkuAndNumBlock = ^(MMGoodsAttdataModel * _Nonnull model, NSString * _Nonnull numStr) {
        
       
        NSInteger num = [model.number integerValue];
        NSString *stock;
        if(num > 0){
            if(num >= 10){
                stock = [NSString stringWithFormat:@"%@,%@",[UserDefaultLocationDic valueForKey:@"inStock"],self.homeModel.proInfo.ProductSignTimeStr];
            }else{
               stock = [NSString stringWithFormat:@"%@%@%@,%@",[UserDefaultLocationDic valueForKey:@"istock"],model.number,[UserDefaultLocationDic valueForKey:@"ipiece"],self.homeModel.proInfo.ProductSignTimeStr];
            }
            
        }else{
            stock = [NSString stringWithFormat:@"%@",self.homeModel.proInfo.ProductSignTimeStr];
        }
       
        if([weakself.homeModel.proInfo.cid isEqualToString:@"828"]){
            weakself.ltShipView.showStr = [NSString stringWithFormat:@"%@x%@%@",model.attr,numStr,[UserDefaultLocationDic valueForKey:@"ipiece"]];
            weakself.ltShipView.stockStr = stock;
        }else{
            weakself.goodsInfoView.showStr = [NSString stringWithFormat:@"%@x%@%@",model.attr,numStr,[UserDefaultLocationDic valueForKey:@"ipiece"]];
            weakself.goodsInfoView.stockStr = stock;
        }
        weakself.attid = model.ID;
        weakself.numStr = numStr;
    };
    self.skuPopView.addCarBlock = ^(NSString * _Nonnull str) {
        [weakself requestAddCar];
    };
    
    self.skuPopView.buyNowBlock = ^(NSString * _Nonnull str) {
        [weakself requestBuyNow];
    };
    
    self.skuPopView.payDepositBlock = ^(NSString * _Nonnull str) {
        [weakself DepositDown];
    };
    
    self.servicePopView = [[MMServiceDesPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    [self.view addSubview:self.mainCollectionView];
    
    
    
    self.bottomView.homeTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goHome];
    };
    
    self.bottomView.kefuTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goKeFu];
    };
    
    self.bottomView.carTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself goShopCar];
    };
    
    self.bottomView.addCarTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself addCar];
    };
    
    self.bottomView.buyNowTapBlock = ^(NSString * _Nonnull indexStr) {
        [weakself buyNow];
    };
    
    [self.view addSubview:self.bottomView];
    self.topView.searchBlock = ^(NSString * _Nonnull indexStr) {
        MMSearchViewController *searchVC = [[MMSearchViewController alloc]init];
        [weakself.navigationController pushViewController:searchVC animated:YES];
    };
    self.topView.scrollOnBlock = ^(NSString * _Nonnull indexStr) {
        if([indexStr isEqualToString:@"0"]){
            [UIView animateWithDuration:0.25 animations:^{
                [weakself.mainCollectionView setContentOffset:CGPointMake(0, -59)];
            }];
        }else if ([indexStr isEqualToString:@"1"]){
            [UIView animateWithDuration:0.25 animations:^{
                [weakself.mainCollectionView setContentOffset:CGPointMake(0, CGRectGetMaxY(weakself.goodsInfoView.frame) - StatusBarHeight - 84)];
            }];
        }else if ([indexStr isEqualToString:@"2"]){
            [UIView animateWithDuration:0.25 animations:^{
                [weakself.mainCollectionView setContentOffset:CGPointMake(0, CGRectGetMaxY(weakself.shopInfoView.frame) - StatusBarHeight - 84)];
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                [weakself.mainCollectionView setContentOffset:CGPointMake(0, CGRectGetMaxY(weakself.otherWebView.frame) - StatusBarHeight - 84)];
            }];
        }
        
    };
    self.topView.alpha = 0;
    [self.view addSubview:self.topView];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight, 30, 30)];
    [returnBt setImage:[UIImage imageNamed:@"return_black"] forState:(UIControlStateNormal)];
    [returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBt];
    
    UIButton *moreBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, StatusBarHeight, 30, 30)];
    [moreBt setImage:[UIImage imageNamed:@"more_black"] forState:(UIControlStateNormal)];
    [moreBt addTarget:self action:@selector(clickMore) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:moreBt];
    
    UIButton *starBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 75, StatusBarHeight, 30, 30)];
    [starBt setImage:[UIImage imageNamed:@"star_black"] forState:(UIControlStateNormal)];
    [starBt setImage:[UIImage imageNamed:@"star_icon_select"] forState:(UIControlStateSelected)];
    [starBt addTarget:self action:@selector(clickCollection) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:starBt];
    if([self.proInfoModel.IsColl isEqualToString:@"1"]){
        starBt.selected = YES;
    }else{
        starBt.selected = NO;
    }
    self.collectionBt = starBt;
    
    
    [self.view addSubview:self.backTopBt];
    
    [self setupRefresh];
    
}

#pragma mark -- uicollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if([self.type isEqualToString:@"0"]){
        return self.similarArr.count;
    }else{
        return self.recommendArr.count;
    }
}

//设置头部高度
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    return CGSizeMake(WIDTH, self.headerViewHeight + 100);
//}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    UICollectionReusableView *reusableview = nil;
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        headV.backgroundColor = TCUIColorFromRGB(0xe8e8e8);
        reusableview = headV;
        
        self.bannerView.bannerArr = self.homeModel.proInfo.Albums;
        self.bannerView.model = self.homeModel;
        self.bannerView.tapImageBlock = ^(NSArray * _Nonnull arr, NSInteger index) {
            [weakself showBigImage:arr andIndex:index];
        };
        [headV addSubview:self.bannerView];
        
        if([self.homeModel.proInfo.cid isEqualToString:@"828"]){
            [headV addSubview:self.ltGoodsInfoView];
            [headV addSubview:self.ltShipView];
            self.ltShipView.selectTapBlock = ^(NSString * _Nonnull indexStr) {
                weakself.skuPopView.type = @"0";
                [weakself showSkuView];
            };
            self.ltShipView.equityTapBlock = ^(NSString * _Nonnull indexStr) {
                [weakself goPromise];
            };
            [headV addSubview:self.ltProgressView];
        }else{
            if([self.homeModel.proInfo.IsLimitTime isEqualToString:@"1"]){
                [headV addSubview:self.limitImage];
            }else{
                self.priceView.proInfo = self.homeModel;
                [headV addSubview:self.priceView];
            }
            
            self.goodsInfoView.proInfo = self.homeModel;
            self.goodsInfoView.moreModel = self.proInfoModel;
            self.goodsInfoView.rotationArr = self.rotationArr;
            if(self.attModel.attr != nil){
                self.goodsInfoView.showStr = [NSString stringWithFormat:@"%@ x1%@",self.attModel.attr,[UserDefaultLocationDic valueForKey:@"ipieces"]];
            }
            
            self.goodsInfoView.selectTapBlock = ^(NSString * _Nonnull indexStr) {
                if([weakself.homeModel.proInfo.cid isEqualToString:@"794"]){
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                    NSDate *dateTime = [formatter dateFromString:weakself.homeModel.proInfo.DepositEndTime];
                    
                    NSTimeInterval a = [dateTime timeIntervalSince1970];
                    
                    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
                    NSTimeInterval a1 = [datenow timeIntervalSince1970];
                    
                    if(a1 > a){
                        [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"depositEnd2"]];
                    }else{
                        weakself.skuPopView.type = @"0";
                        [weakself showSkuView];
                    }
                }else{
                    weakself.skuPopView.type = @"0";
                    [weakself showSkuView];
                }
                
                
                
            };
            self.goodsInfoView.equityTapBlock = ^(NSString * _Nonnull indexStr) {
                [weakself goPromise];
            };
            if([self.goodsSpecInfo.LimtOrderBuy isEqualToString:@"999999999"]){
                self.goodsInfoView.limitNum = @"0";
            }else{
                self.goodsInfoView.limitNum = self.goodsSpecInfo.LimtOrderBuy;
            }
            if([self.goodsSpecInfo.attbuying.attr isEmpty]){
            }else{
                self.goodsInfoView.showStr = [NSString stringWithFormat:@"%@x1%@",self.goodsSpecInfo.attbuying.attr,[UserDefaultLocationDic valueForKey:@"ipiece"]];
            }
            
            
            self.goodsInfoView.discountTapBlock = ^(NSString * _Nonnull indexStr) {
                [weakself showDiscountView];
            };
            
            self.goodsInfoView.shareTapBlock = ^(NSString * _Nonnull indexStr) {
                [weakself jumpRouters:indexStr];
            };
            [headV addSubview:self.goodsInfoView];
        }
        
        
        
        self.assessView.proInfoModel = self.proInfoModel;
        self.assessView.tags = self.evaluateTags;
        self.assessView.assessTapBlock = ^(NSString * _Nonnull indexStr) {
            [weakself goAssessList];
        };
        [headV addSubview:self.assessView];
        
        self.shopInfoView.brandInfoModel = self.proInfoModel.brandInfo;
        self.shopInfoView.brandTapBlock = ^(NSString * _Nonnull indexStr) {
            [weakself goBrandDetail:indexStr];
        };
        self.shopInfoView.goodsTapBlock = ^(NSString * _Nonnull indexStr) {
            [weakself jumpRouters:indexStr];
        };
        [headV addSubview:self.shopInfoView];
        
        self.promiseView.mainModel = self.homeModel;
        self.promiseView.promissTapBlock = ^(NSString * _Nonnull indexStr) {
            [weakself goPromise];
        };
        self.promiseView.questionTapBlock = ^(NSString * _Nonnull indexStr) {
            [weakself jumpRouters:indexStr];
        };
        [headV addSubview:self.promiseView];
        
        if([self.proInfoModel.GuideParam isEmpty]){
            
        }else{
            self.specificationView.specHArr = self.specHArr;
            self.specificationView.proModel = self.proInfoModel;
            [headV addSubview:self.specificationView];
        }
        [headV addSubview:self.detailImgView];
        [headV addSubview:self.otherWebView];
//        if(self.goodsImageHArr.count == self.proInfoModel.detailImages.count){
//            self.detailImgView.imageArr = self.proInfoModel.detailImages;
//            self.detailImgView.imaHarr = self.goodsImageHArr;
//            [headV addSubview:self.detailImgView];
//        }
        
        self.recommendView.changeListBlcok = ^(NSString * _Nonnull str) {
            weakself.type = str;
            [weakself.mainCollectionView reloadData];
        };
        [headV addSubview:self.recommendView];
        
    }
    return reusableview;
}



-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMHomeShopGoodsCell *cell =
    (MMHomeShopGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if([self.type isEqualToString:@"0"]){
        cell.model = self.similarArr[indexPath.item];
    }else{
        cell.model = self.recommendArr[indexPath.item];
    }
    cell.TapCarBlock = ^(NSString * _Nonnull indexStr) {
        weakself.goodsId = indexStr;
        [weakself GetProductBuyTest:indexStr];
    };
    
    return cell;
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  CGSizeMake((WIDTH - 30)/2, (WIDTH - 30)/2 + 153);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.type isEqualToString:@"0"]){
        MMHomeRecommendGoodsModel *model = self.similarArr[indexPath.item];
        [self jumpRouters:model.Url];
    }else{
        MMHomeRecommendGoodsModel *model = self.recommendArr[indexPath.item];
        [self jumpRouters:model.Url];
    }
}


#pragma mark -- 请求接口 异步请求多个
    
    -(void)GetPicture{
        KweakSelf(self);
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPicture"];
        NSDictionary *param = @{@"id":@"174",@"lang":self.lang,@"cry":self.cry};
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            dispatch_semaphore_signal(sema);
            weakself.bgImageUrl = jsonDic[@"Picture"];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
//获取主要信息接口
-(void)requestMainData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBaseInfo"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.tempcart forKey:@"tempcart"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        if(self.param[@"id"]){
            [param setValue:self.param[@"id"] forKey:@"id"];
        }else{
            [param setValue:self.param[@"code"] forKey:@"code"];
        }
        
    }
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",jsonDic);
        
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.homeModel = [MMGoodsDetailMainModel mj_objectWithKeyValues:jsonDic];
            dispatch_queue_t q = dispatch_queue_create("hei", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
//                CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:weakself.homeModel.tkyn]];
                weakself.tkynHeight = WIDTH/(375/158);
            });
            
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
       
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
//获取次要信息接口
-(void)requestDataSecond{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductMoreInfo"]; //@"https://miaumall2022.azurewebsites.net/unishop/Face.ashx?t=GetProductMoreInfo&membertoken=&tempcart=942d3f02-61d9-30d4-ef73-412ecf639c2e&id=41097&code=&lang=0&cry=5";
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    //GetVersion。GetProductMoreInfo
    [param setValue:@"GetProductMoreInfo" forKey:@"t"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        if(self.param[@"id"]){
            [param setValue:self.param[@"id"] forKey:@"id"];
        }else{
            [param setValue:self.param[@"code"] forKey:@"code"];
        }
        
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"" forKey:@"code"];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
                NSLog(@"%@",jsonDic);
                dispatch_semaphore_signal(sema);
                NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                if([code isEqualToString:@"1"]){
                    weakself.proInfoModel = [MMGoodsProInfoModel mj_objectWithKeyValues:jsonDic[@"proInfo"]];
                    weakself.evaluateArr = [MMGoodsDetailAssessModel mj_objectArrayWithKeyValuesArray:weakself.proInfoModel.assesslist];
                    [weakself requestBrandInfo:weakself.proInfoModel.brandInfo.ID];
                    if([weakself.proInfoModel.GuideParam isEmpty]){
                        
                    }else{
//                        NSString *strUrl = [weakself.proInfoModel.GuideParam stringByReplacingOccurrencesOfString:@"\n" withString:@","];
//
//                        NSString *str1 = [strUrl substringFromIndex: strUrl.length - 1];
//                        if([str1 isEqualToString:@","]){
//                            strUrl = [strUrl substringToIndex:[strUrl length] - 1];
//                        }
//                        strUrl = [weakself removeSpaceAndNewline:strUrl];
                        NSArray *arr = [weakself.proInfoModel.GuideParam componentsSeparatedByString:@"\r\n"];
                
                        weakself.specStrArr = [NSMutableArray arrayWithArray:arr];
                    }
                    
                    if([weakself.proInfoModel.GuideParam isEmpty]){
                    }else{
                        CGFloat h1 = 52;
                        for (int i = 0; i < weakself.specStrArr.count; i++) {
                            NSString *str = weakself.specStrArr[i];
                            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                            NSRange range = [str rangeOfString:@"|"];
                            NSArray *array;
                            if(range.location != NSNotFound){
                                NSString *str1 = [str substringToIndex:range.location];
                                NSString *str2 = [str substringFromIndex:range.location + 1];
                                array = @[str1,str2];
                            }
                            
//                            array = [str componentsSeparatedByString:@"|"];
                            NSString *valueStr = array[1];
                            
//                            valueStr = [valueStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//                            valueStr = [valueStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            UILabel *replyLa = [UILabel publicLab:valueStr textColor:TCUIColorFromRGB(0x989898) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
                            replyLa.frame = CGRectMake(0, 0, WIDTH - 154, 36);
                            CGSize size = [replyLa sizeThatFits:CGSizeMake(WIDTH - 154,MAXFLOAT)];
                            [self.specHArr addObject:[NSString stringWithFormat:@"%.f",size.height + 22]];
                            h1 = h1 + size.height + 22;
                        }
                        weakself.specifiHei = h1;
                    }
                    
//                    if(weakself.proInfoModel.detailImages.count > 0){
//
//                        dispatch_queue_t q = dispatch_queue_create("hei", DISPATCH_QUEUE_CONCURRENT);
//
//                        dispatch_async(q, ^{
//                            CGFloat hei = 0;
//                            for (int i = 0; i < weakself.proInfoModel.detailImages.count; i++) {
//                                NSString *url = weakself.proInfoModel.detailImages[i];
//                                CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:url]];
//                                CGFloat h1 = (WIDTH - 20)/(size.width/size.height);
//                                [weakself.goodsImageHArr addObject:[NSString stringWithFormat:@"%.f",h1]];
//                                hei += h1;
//
//                                weakself.detailH = hei;
//
//
//                                if(i == weakself.proInfoModel.detailImages.count - 1){
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                                        if(weakself.mainScrollView.contentSize.height == 0){
//
//                                        }else{
//                                            [weakself.mainCollectionView reloadData];
//                                        }
//
//                                    });
//                                }
//                            }
//
//
//                        });
//
//                    }
            
                }else{
                    [ZTProgressHUD showMessage:jsonDic[@"msg"]];
                }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
//获取商品规格接口
-(void)requestGoodsspec{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBuyTest"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetProductBuyTest" forKey:@"t"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        if(self.param[@"id"]){
            [param setValue:self.param[@"id"] forKey:@"id"];
        }else{
            [param setValue:self.param[@"code"] forKey:@"code"];
        }
        
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.goodsSpecInfo = [MMGoodsSpecModel mj_objectWithKeyValues:jsonDic];
            weakself.attid = weakself.goodsSpecInfo.attbuying.attid;
            NSArray *goodsSpecArr = [MMGoodsAttdataModel mj_objectArrayWithKeyValuesArray:jsonDic[@"attdatas"]];
            weakself.goodsSpecArr = [NSMutableArray arrayWithArray:goodsSpecArr];
            
            if(goodsSpecArr.count > 0){
                weakself.attModel = goodsSpecArr[0];
                NSArray *attlist = jsonDic[@"attlist"];
                weakself.attlistModel = [MMAttlistItemModel mj_objectWithKeyValues:attlist[0]];
                NSArray *showArr = [MMGoodsSpecItemModel mj_objectArrayWithKeyValuesArray:weakself.attlistModel.child];
                weakself.goodsSpecShowArr = [NSMutableArray arrayWithArray:showArr];
            }
            
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
//请求收货地址列表
-(void)requestAddressList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetAddressList"];
//    [param setValue:@"GetAddressList" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *addressList = [MMAddressModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.normalAddressModel = addressList[0];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//晒单
-(void)requestShareData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetRotationPictures"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetRotationPictures" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"11" forKey:@"id"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *rotationArr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.rotationArr = [NSMutableArray arrayWithArray:rotationArr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//获取商品评价标签
-(void)requestEvaData{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPingJiaType"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetPingJiaType" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        if(self.param[@"id"]){
            [param setValue:self.param[@"id"] forKey:@"id"];
        }else{
            [param setValue:self.param[@"code"] forKey:@"code"];
        }
        
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMAssessTagsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"tag"]];
            weakself.evaluateTags = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//请求品牌商品列表
-(void)requestBrandInfo:(NSString *)bids{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBrandList"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
//    [param setValue:@"GetProductBrandList" forKey:@"t"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        if(self.param[@"id"]){
            [param setValue:self.param[@"id"] forKey:@"id"];
        }else{
            [param setValue:self.param[@"code"] forKey:@"code"];
        }
        
    }
    [param setValue:bids forKey:@"bids"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"999" forKey:@"limit"];
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
//        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.brandListModel = [MMBrandListModel mj_objectWithKeyValues:jsonDic];
            weakself.shopInfoView.listModel = weakself.brandListModel;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        dispatch_semaphore_signal(sema);
    }];
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//请求类似的商品列表
-(void)requestSimilarGoodsList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCommoditySimilar"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.ID){
        [param setValue:self.ID forKey:@"ItemID"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"ItemID"];
        
    }
    
    [param setValue:@"0" forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.similarArr = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//请求推荐商品列表
-(void)requestRecommendGoodsList{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCommodityRecommend"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.ID){
        [param setValue:self.ID forKey:@"ItemID"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"ItemID"];
    }
    [param setValue:@"0" forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        dispatch_semaphore_signal(sema);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            weakself.recommendArr = [NSMutableArray arrayWithArray:arr];
        }
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

#pragma mark -- 监听webview高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.detailImgView.height =  self.detailImgView.scrollView.contentSize.height;
        self.detailImgHei = self.detailImgView.scrollView.contentSize.height;
        self.otherWebView.y = CGRectGetMaxY(self.detailImgView.frame);
        self.recommendView.y = CGRectGetMaxY(self.otherWebView.frame) + 5;
        self.headerViewHeight = CGRectGetMaxY(self.otherWebView.frame) + 44;
        self.layout.headerReferenceSize = CGSizeMake(WIDTH, self.headerViewHeight);
        [self.mainCollectionView reloadData];

    }
    
}

/**  < 法2 >  */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    KweakSelf(self);
    //document.body.offsetHeight
    //document.body.scrollHeight
    //document.body.clientHeight
    if(webView == self.otherWebView){
        [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGFloat documentHeight = [result doubleValue];
            CGRect webFrame = webView.frame;
            webFrame.size.height = documentHeight;
            webView.frame = webFrame;
            weakself.otherWebView.height = webView.frame.size.height/2 - 50;
            weakself.otherViewHei = webView.frame.size.height/2 - 50;
            weakself.recommendView.y = CGRectGetMaxY(weakself.otherWebView.frame) + 5;
            weakself.headerViewHeight = CGRectGetMaxY(weakself.otherWebView.frame) + 44;
            weakself.layout.headerReferenceSize = CGSizeMake(WIDTH, weakself.headerViewHeight);
            [weakself.mainCollectionView reloadData];
        }];
    }
    
    
}


#pragma mark -- 后面请求的接口
-(void)requestAddCar{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"CartPlus"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
   // [param setValue:@"CartPlus" forKey:@"t"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    if(self.ID){
        [param setValue:self.ID forKey:@"id"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"id"];
    }
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.numStr forKey:@"num"];
    [param setValue:self.attid forKey:@"attid"];
    [param setValue:@"1" forKey:@"back"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMShopCarModel *model = [MMShopCarModel mj_objectWithKeyValues:jsonDic[@"key"]];
            weakself.cartabBarItem.badgeValue = model.num;
            weakself.bottomView.num = model.num;
            if([model.num isEqualToString:@"0"]){
                weakself.cartabBarItem.badgeValue = nil;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)DepositDown{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"DepositDown"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.attid forKey:@"attid"];
    [param setValue:self.numStr forKey:@"num"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.homeModel.proInfo.ID forKey:@"id"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSString *key = [NSString stringWithFormat:@"%@",jsonDic[@"key"]];
            [weakself GetPayHandleMoreOrders:key];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)GetPayHandleMoreOrders:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPayHandleMoreOrders"];
    NSDictionary *param = @{@"id":ID,@"memberToken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMPayResultModel *payModel = [MMPayResultModel mj_objectWithKeyValues:jsonDic];
            MMPayViewController *payVC = [[MMPayViewController alloc]init];
//            payVC.countryID = weakself.model.CountryID;
            payVC.model = payModel;
            payVC.isEnter = @"1";
            [weakself.navigationController pushViewController:payVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestBuyNow{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"FastAdd"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
   // [param setValue:@"CartPlus" forKey:@"t"];
    [param setValue:self.tempcart forKey:@"tempcart"];
    [param setValue:self.homeModel.proInfo.ID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:self.numStr forKey:@"num"];
    [param setValue:self.attid forKey:@"attid"];
    [param setValue:@"1" forKey:@"back"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            MMConfirmOrderViewController *confirmVC = [[MMConfirmOrderViewController alloc]init];
            [weakself.navigationController pushViewController:confirmVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//请求收藏
-(void)requestCollection{
    KweakSelf(self);
    if(self.memberToken){
        NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"Collection"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        if(self.memberToken){
            [param setValue:self.memberToken forKey:@"membertoken"];
        }
     
        if(self.ID){
            [param setValue:self.ID forKey:@"id"];
        }else{
            [param setValue:self.param[@"id"] forKey:@"id"];
        }
        
        [param setValue:self.lang forKey:@"lang"];
        [param setValue:self.cry forKey:@"cry"];
        [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            weakself.collectionBt.selected = !weakself.collectionBt.selected;
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        MMLoginViewController *loginVC = [[MMLoginViewController alloc]init];
        loginVC.modalPresentationStyle = 0;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}



#pragma mark -- 上拉加载
-(void)setupRefresh{
    KweakSelf(self);
    __block NSInteger page = 1;
    //上拉 加载
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        if([weakself.type isEqualToString:@"0"]){
            weakself.page0++;
            [self requestLoadMoreGoodsDataPage:weakself.page0];
        }else{
            weakself.page1++;
            [self requestLoadMoreGoodsDataPage:weakself.page1];
        }
    }];
    footer.triggerAutomaticallyRefreshPercent = -200;
    self.mainCollectionView.mj_footer = footer;

}

-(void)requestLoadMoreGoodsDataPage:(NSInteger )page{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCommoditySimilar"];
    if([self.type isEqualToString:@"1"]){
        url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetCommodityRecommend"];
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    if(self.ID){
        [param setValue:self.ID forKey:@"ItemID"];
    }else{
        [param setValue:self.param[@"id"] forKey:@"ItemID"];
    }
    [param setValue:@"0" forKey:@"StoreID"];
    [param setValue:@"0" forKey:@"pid"];
    [param setValue:@"0" forKey:@"brand"];
    [param setValue:@"0" forKey:@"otype"];
    [param setValue:@"0" forKey:@"IsMinApp"];
    [param setValue:pageStr forKey:@"curr"];
    [param setValue:@"20" forKey:@"limit"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = [MMHomeRecommendGoodsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
            if(arr.count > 0){
                if([weakself.type isEqualToString:@"0"]){
                    [weakself.similarArr addObjectsFromArray:arr];
                }else{
                    [weakself.recommendArr addObjectsFromArray:arr];
                }
                [weakself.mainCollectionView reloadData];
                [weakself.mainCollectionView.mj_footer endRefreshing];
            }else{
                if([weakself.type isEqualToString:@"0"]){
                    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
                    weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }else{
                    [ZTProgressHUD showMessage:[UserDefaultLocationDic valueForKey:@"noMoreData"]];
                    weakself.mainCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark -- 弹窗
//参数信息
-(void)showParamView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.paramEnPopView];
    [self.paramEnPopView showView];
}
//优惠
-(void)showDiscountView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.discountPopView];
    [self.discountPopView showView];
}
//规格
-(void)showSkuView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.skuPopView];
    [self.skuPopView showView];
}
//服务说明
-(void)showServiceView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.servicePopView];
    [self.servicePopView showView];
}
//分享弹窗
-(void)showShareView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharePopView];
    [self.sharePopView showView];
}

//生成海报弹窗
-(void)showCreatView{
    [[UIApplication sharedApplication].keyWindow addSubview:self.creatPopView];
    [self.creatPopView showView];
}

#pragma mark -- 页面跳转
-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)goShopCar{
    self.navigationController.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)goIntegralRule{
    MMIntegralRuleVC *vc = [[MMIntegralRuleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goKeFu{
//    NSString *deviceToken = [self.userDefaults valueForKey:@"deviceToken"];
//    NSString *email = [self.userDefaults valueForKey:@"Email"];
//    NSString *name = [self.userDefaults valueForKey:@"name"];
//    NSString *phone = [self.userDefaults valueForKey:@"Phone"];
//    NSString *userId = [self.userDefaults valueForKey:@"userID"];
//    NSString *currency = [self.userDefaults valueForKey:@"Currency_bind"];
    
    
    MMCustomerServiceVC *serviceVC = [[MMCustomerServiceVC alloc]init];
    serviceVC.goodsName = self.homeModel.proInfo.Name;
    [self.navigationController pushViewController:serviceVC animated:YES];
    
}

-(void)goAssessList{
    MMAssessListViewController *assessVC = [[MMAssessListViewController alloc]init];
    assessVC.cid = self.homeModel.proInfo.cid;
    assessVC.ID = self.homeModel.proInfo.ID;
    assessVC.assesslevel5rate = self.proInfoModel.assesslevel5rate;
    [self.navigationController pushViewController:assessVC animated:YES];
}

-(void)goPromise{
    MMPromiseVC *promiseVC = [[MMPromiseVC alloc]init];
    [self.navigationController pushViewController:promiseVC animated:YES];
}

-(void)buyNow{
    self.skuPopView.type = @"2";
    [self showSkuView];
}

//请求加入购物车
-(void)addCar{
    self.skuPopView.type = @"1";
    [self showSkuView];
}

-(void)goBrandDetail:(NSString *)ID{
    MMBrandDetailVC *detailVC = [[MMBrandDetailVC alloc]init];
    detailVC.ID = ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)jumpRouters:(NSString *)routers{
    if([routers isEqualToString:@""] || [routers isEmpty]){
    }else{
        MMBaseViewController *vc = [MMRouterJump jumpToRouters:routers];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)clickCollection{
    [self requestCollection];
}

-(void)changeList:(UIButton *)sender{
    if(sender.tag == 100){
        self.type = @"0";
        self.linView.centerX = self.similarBt.centerX;
    }else{
        self.type = @"1";
        self.linView.centerX = self.recommendBt.centerX;
    }
    [self.mainCollectionView reloadData];
}

-(void)clickMore{
    [self showShareView];
}

#pragma mark -- scrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = scrollView.contentOffset.y;
    self.topView.alpha = y/200;
    if(y <= CGRectGetMaxY(self.goodsInfoView.frame) - StatusBarHeight - 84){
        self.topView.scrollIndex = @"0";
    }else if(y < CGRectGetMaxY(self.assessView.frame) - StatusBarHeight - 84){
        self.topView.scrollIndex = @"1";
    }else if (y < CGRectGetMaxY(self.otherWebView.frame) - StatusBarHeight - 84){
        self.topView.scrollIndex = @"2";
    }else if(y >= (CGRectGetMaxY(self.otherWebView.frame) - StatusBarHeight - 84)){
        self.topView.scrollIndex = @"3";
    }
    

    if(self.mainCollectionView.contentOffset.y >= 300){
        self.backTopBt.hidden = NO;
    }else{
        self.backTopBt.hidden = YES;
    }
}

-(void)backTop{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainCollectionView.contentOffset = CGPointMake(0, 0);
    }];
}
    
#pragma mark -- 请求规格数据
-(void)GetProductBuyTest:(NSString *)ID{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetProductBuyTest"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSDictionary *param1 = @{@"id":ID,@"lang":self.lang,@"cry":self.cry};
    [param setDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            weakself.goodsSpecInfo = [MMGoodsSpecModel mj_objectWithKeyValues:jsonDic];
            weakself.attid = weakself.goodsSpecInfo.attbuying.attid;
            weakself.skuPopView1 = [[MMSelectSKUPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andData:weakself.goodsSpecInfo];
        
            self.skuPopView1.SkuAndNumBlock = ^(MMGoodsAttdataModel * _Nonnull model, NSString * _Nonnull numStr) {
                weakself.attid1 = model.ID;
                weakself.numStr1 = numStr;
            };
            self.skuPopView1.addCarBlock = ^(NSString * _Nonnull str) {
                [weakself requestAddCar];
            };
            
            self.skuPopView1.buyNowBlock = ^(NSString * _Nonnull str) {
                [weakself requestBuyNow];
            };
            weakself.skuPopView1.type = @"0";
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.skuPopView1];
            [weakself.skuPopView1 showView];
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 去除字符串空格换行
- (NSString *)removeSpaceAndNewline:(NSString *)str
{
NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
return temp;

}

//点击看大图
-(void)showBigImage:(NSArray *)arr andIndex:(NSInteger)index{
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    mg.exitComplate = ^(NSInteger lastSelectIndex) {
        NSLog(@"%zd",lastSelectIndex);
    };
    [mg showPhotoViewerModels:arr controller:self selectViewIndex:index];
}

#pragma mark -- 生成随机数

- (NSString *)generateTradeNO:(NSInteger )num

{
    NSString *sourceStr = @"0123456789abcdef";

    NSMutableString *resultStr = [[NSMutableString alloc] init];

    srand((unsigned)time(0));

    for (int i = 0; i < num; i++)

    {

        unsigned index = rand() % [sourceStr length];

        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];

        [resultStr appendString:oneStr];

    }

    return resultStr;
}

//计算富文本高度
- (CGFloat)textViewHeightForAttributedString:(NSAttributedString *)string withWidth:(CGFloat)width
{
    return [self rectForAttributedString:string withSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGSize)rectForAttributedString:(NSAttributedString *)string withSize:(CGSize)theSize
{
    if (!string || CGSizeEqualToSize(theSize, CGSizeZero)) {
        return CGSizeZero;
    }

    // setup TextKit stack
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:theSize];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    // query for size
    CGRect rect = [layoutManager usedRectForTextContainer:textContainer];

    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"商品详情页面"];
}




@end
