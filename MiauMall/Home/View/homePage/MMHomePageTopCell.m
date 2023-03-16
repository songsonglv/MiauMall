//
//  MMHomePageTopCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//  首页顶部装修区cell

#import "MMHomePageTopCell.h"
#import "MMCycleTableViewCell.h"
#import "MMLinkNaTableViewCell.h" //高度固定 192
#import "MMSinglePicTableViewCell.h" //单图 根据图片高度计算高度
#import "MMTwoImageOneCell.h" //双图 但可能里面会有三图

#import "MMThreeImgCell.h"    //三图组合二 一拖二
#import "MMThreeImgThreeCell.h" //三图组合三
#import "MMThreeImg4Cell.h"  //三图组合4
#import "MMLimitTypeCell.h"
#import "MMTwoImgTwoCell.h"//双图组合2cell
#import "MMNineImageCell.h" //九图轮播
#import "MMTwoImgChangeCell.h"//两图切换
#import "MMRecListEightCell.h" //推荐商品8列表
#import "MMProListTwoCell.h"  //商品列表2
#import "MMZYHDCell.h" //左右滑动
#import "MMRankList2Cell.h" //排行榜2 热销榜单
#import "MMProList4Cell.h"  //商品列表4
#import "MMProList7Cell.h"  //商品列表7
#import "MMProList1Cell.h"  //商品列表1cell
#import "MMProList8Cell.h" //商品列表8cell
#import "MMStackBannerCell.h" //堆叠轮播
//#import "MMTabClassifyCell.h"

@interface MMHomePageTopCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) NSMutableArray *items;//装修数组
@property (nonatomic, strong) NSMutableArray *bannerArr;//banner数组
@property (nonatomic, strong) NSMutableArray *bannerHArr;//banner数组
@property (nonatomic, strong) NSMutableArray *linkArr; //链接导航数组
@property (nonatomic, strong) NSMutableArray *singleArr;//单图数组
@property (nonatomic, strong) NSMutableArray *twoimg1Arr;//双图数组1
@property (nonatomic, strong) NSMutableArray *twoimg2Arr;//双图数组2
@property (nonatomic, strong) NSMutableArray *threeArr;//三图数组
@property (nonatomic, strong) NSMutableArray *threeImgThreeArr;//三图3数组
@property (nonatomic, strong) NSMutableArray *threeImg4Arr;//三图组合4数组
@property (nonatomic, strong) NSMutableArray *limitArr;//限时抢购数组
@property (nonatomic, strong) NSMutableArray *nineArr;//九图轮播
@property (nonatomic, strong) NSMutableArray *imageTwoTurnArr;//两图切换数组

@property (nonatomic, strong) NSMutableArray *stackBannerArr;//堆叠轮播数组
@property (nonatomic, strong) NSMutableArray *tabArr;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) float height0;//tableview高度



@end

@implementation MMHomePageTopCell

-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    //[self setupUI];
}
    return self;
}

-(UITableView *)topTableView{
    if (!_topTableView) {
        _topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.hei) style:(UITableViewStylePlain)];
        _topTableView.backgroundColor = UIColor.clearColor;
        _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topTableView.scrollEnabled = NO;
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.showsVerticalScrollIndicator = NO;
        _topTableView.showsHorizontalScrollIndicator = NO;
    }
    return _topTableView;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(NSMutableArray *)tabArr{
    if(!_tabArr){
        _tabArr = [NSMutableArray array];
    }
    return _tabArr;
}

-(NSMutableArray *)imageTwoTurnArr{
    if(!_imageTwoTurnArr){
        _imageTwoTurnArr = [NSMutableArray array];
    }
    return _imageTwoTurnArr;
}

-(NSMutableArray *)nineArr{
    if(!_nineArr){
        _nineArr = [NSMutableArray array];
    }
    return _nineArr;
}

-(NSArray *)limitArr{
    if(!_limitArr){
        _limitArr = [NSMutableArray array];
    }
    return _limitArr;
}

-(NSMutableArray *)threeArr{
    if(!_threeArr){
        _threeArr = [[NSMutableArray alloc]init];
    }
    return _threeArr;
}

-(NSMutableArray *)threeImgThreeArr{
    if(!_threeImgThreeArr){
        _threeImgThreeArr = [NSMutableArray array];
    }
    return _threeImgThreeArr;
}

-(NSMutableArray *)threeImg4Arr{
    if(!_threeImg4Arr){
        _threeImg4Arr = [NSMutableArray array];
    }
    return _threeImg4Arr;
}

-(NSMutableArray *)twoimg1Arr{
    if(!_twoimg1Arr){
        _twoimg1Arr = [[NSMutableArray alloc]init];
    }
    return _twoimg1Arr;
}

-(NSMutableArray *)twoimg2Arr{
    if(!_twoimg2Arr){
        _twoimg2Arr = [NSMutableArray array];
    }
    return _twoimg2Arr;
}

-(NSArray *)singleArr{
    if(!_singleArr){
        _singleArr = [[NSMutableArray alloc]init];
    }
    return _singleArr;
}

-(NSMutableArray *)items{
    if(!_items){
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

-(NSMutableArray *)bannerArr{
    if(!_bannerArr){
        _bannerArr = [[NSMutableArray alloc]init];
    }
    return _bannerArr;
}

-(NSMutableArray *)bannerHArr{
    if(!_bannerHArr){
        _bannerHArr = [[NSMutableArray alloc]init];
    }
    return _bannerHArr;
}

-(NSMutableArray *)linkArr{
    if(!_linkArr){
        _linkArr = [[NSMutableArray alloc]init];
    }
    return _linkArr;
}

-(NSMutableArray *)stackBannerArr{
    if(!_stackBannerArr){
        _stackBannerArr = [NSMutableArray array];
    }
    return _stackBannerArr;
}



-(void)setModel:(MMHomePageModel *)model{
    _model = model;
    KweakSelf(self);
    [self.threeImgThreeArr removeAllObjects];
    [self.threeImg4Arr removeAllObjects];
    NSArray *listModel = [MMHomePageItemModel mj_objectArrayWithKeyValuesArray:_model.list];
    for (MMHomePageItemModel*itemModel in listModel) {
        [self.items addObject:itemModel];
        if([itemModel.type isEqualToString:@"iadvimg"]){
            [weakself.singleArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"twoimg1"]){
            [weakself.twoimg1Arr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"twoimg2"]){
            [weakself.twoimg2Arr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"threeimg2"]){
            [weakself.threeArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"threeimg3"]){
            [weakself.threeImgThreeArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"threeimg4"]){
            [weakself.threeImg4Arr addObject:itemModel];
        }
        else if ([itemModel.type isEqualToString:@"limit1"]){
            [weakself.limitArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"jiutu"]){
            [weakself.nineArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"twoimgturn"]){
            [weakself.imageTwoTurnArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"stackbanners"]){
            [weakself.stackBannerArr addObject:itemModel];
        }
        else if ([itemModel.type isEqualToString:@"classtab"]){
            break;
        }
        
        if([itemModel.type isEqualToString:@"banner"] || [itemModel.type isEqualToString:@"nav"] || [itemModel.type isEqualToString:@"iadvimg"] ||[itemModel.type isEqualToString:@"twoimg1"] || [itemModel.type isEqualToString:@"threeimg2"] || [itemModel.type isEqualToString:@"limit1"] || [itemModel.type isEqualToString:@"twoimg2"]|| [itemModel.type isEqualToString:@"threeimg3"] || [itemModel.type isEqualToString:@"jiutu"] || [itemModel.type isEqualToString:@"twoimgturn"] || [itemModel.type isEqualToString:@"reclist8"] || [itemModel.type isEqualToString:@"prolist2"] || [itemModel.type isEqualToString:@"reclist2"] || [itemModel.type isEqualToString:@"zuoyouhd"] || [itemModel.type isEqualToString:@"ranklist2"] || [itemModel.type isEqualToString:@"prolist4"] || [itemModel.type isEqualToString:@"prolist7"] || [itemModel.type isEqualToString:@"threeimg4"] || [itemModel.type isEqualToString:@"prolist1"] || [itemModel.type isEqualToString:@"prolist8"] || [itemModel.type isEqualToString:@"stackbanners"]){
            [self.dataArr addObject:itemModel];
        }
    }
    
}

-(void)setModel1:(MMSecondPageHomeModel *)model1{
    _model1 = model1;
    KweakSelf(self);
    [self.threeImgThreeArr removeAllObjects];
    [self.threeImg4Arr removeAllObjects];
    NSArray *listModel = [MMHomePageItemModel mj_objectArrayWithKeyValuesArray:_model1.list];
    for (MMHomePageItemModel*itemModel in listModel) {
        [self.items addObject:itemModel];
        if([itemModel.type isEqualToString:@"iadvimg"]){
            [weakself.singleArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"twoimg1"]){
            [weakself.twoimg1Arr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"twoimg2"]){
            [weakself.twoimg2Arr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"threeimg2"]){
            [weakself.threeArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"threeimg3"]){
            [weakself.threeImgThreeArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"threeimg4"]){
            [weakself.threeImg4Arr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"limit1"]){
            [weakself.limitArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"jiutu"]){
            [weakself.nineArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"twoimgturn"]){
            [weakself.imageTwoTurnArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"stackbanners"]){
            [weakself.stackBannerArr addObject:itemModel];
        }else if ([itemModel.type isEqualToString:@"classtab"]){
            break;
        }
        
        if([itemModel.type isEqualToString:@"banner"] || [itemModel.type isEqualToString:@"nav"] || [itemModel.type isEqualToString:@"iadvimg"] ||[itemModel.type isEqualToString:@"twoimg1"] || [itemModel.type isEqualToString:@"threeimg2"] || [itemModel.type isEqualToString:@"limit1"] || [itemModel.type isEqualToString:@"twoimg2"] || [itemModel.type isEqualToString:@"threeimg3"] || [itemModel.type isEqualToString:@"jiutu"] || [itemModel.type isEqualToString:@"twoimgturn"] || [itemModel.type isEqualToString:@"reclist8"] || [itemModel.type isEqualToString:@"prolist2"] || [itemModel.type isEqualToString:@"reclist2"] || [itemModel.type isEqualToString:@"zuoyouhd"] || [itemModel.type isEqualToString:@"ranklist2"] || [itemModel.type isEqualToString:@"prolist4"] || [itemModel.type isEqualToString:@"prolist7"] || [itemModel.type isEqualToString:@"threeimg4"]|| [itemModel.type isEqualToString:@"prolist1"] || [itemModel.type isEqualToString:@"prolist8"] || [itemModel.type isEqualToString:@"stackbanners"]){
            [self.dataArr addObject:itemModel];
        }
    }
    
}

-(void)setHei:(CGFloat)hei{
    _hei = hei;
}

-(void)setBannerHei:(CGFloat)bannerHei{
    _bannerHei = bannerHei;
}

-(void)setSingleHArr:(NSArray *)singleHArr{
    _singleHArr = singleHArr;
}

-(void)setTwoimg2HArr:(NSArray *)twoimg2HArr{
    _twoimg2HArr = twoimg2HArr;
}

-(void)setTwoimg1HArr:(NSArray *)twoimg1HArr{
    _twoimg1HArr = twoimg1HArr;
    
}

-(void)setThreeimg3HArr:(NSArray *)threeimg3HArr{
    _threeimg3HArr = threeimg3HArr;
    
}

-(void)setNineImgHArr:(NSArray *)nineImgHArr{
    _nineImgHArr = nineImgHArr;
}

-(void)setImageTwoTurnHArr:(NSArray *)imageTwoTurnHArr{
    _imageTwoTurnHArr = imageTwoTurnHArr;
    
}

-(void)setThreeImg4HArr:(NSArray *)threeImg4HArr{
    _threeImg4HArr = threeImg4HArr;
    
}

-(void)setStackBannerHArr:(NSArray *)stackBannerHArr{
    _stackBannerHArr = stackBannerHArr;
    [self setupUI];
}



-(void)setupUI{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.topTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMHomePageItemModel *model = self.dataArr[indexPath.row];
    //三图高度
    double scale1 = 1.43; //左右图片的宽度比
    double scale2 = 0.9; //左边图片的长宽比
    float wid1 = (WIDTH - 30)/(1 + scale1);//左边图片宽度
    float hei1 = wid1 / scale2;//左边图片高度
    if([model.type isEqualToString:@"banner"]){
        return self.bannerHei;
    }else if([model.type isEqualToString:@"nav"]){
        if(model.cont.imglist.count > 5){
            return 192;
        }
        return 96;
    }else if ([model.type isEqualToString:@"iadvimg"]){
        for (int i = 0; i < self.singleArr.count; i++) {
            MMHomePageItemModel *model1 = self.singleArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.singleHArr[i];
                CGFloat hei = [heiStr floatValue];
                return hei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"twoimg1"]){
        for (int i = 0; i < self.twoimg1Arr.count; i++) {
            MMHomePageItemModel *model1 = self.twoimg1Arr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.twoimg1HArr[i];
                CGFloat hei = [heiStr floatValue];
                return hei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"twoimg2"]){
        for (int i = 0; i < self.twoimg2Arr.count; i++) {
            MMHomePageItemModel *model1 = self.twoimg2Arr[i];
            
            if([model.index isEqualToString:model1.index]){
                NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model1.cont.imglist];
                CGFloat top = [model1.margin1 floatValue];
                CGFloat bottom = [model1.margin3 floatValue];
                
                NSString *heiStr = self.twoimg2HArr[i];
                CGFloat hei = [heiStr floatValue];
                NSInteger row = imgArr.count/2;
                CGFloat allHei = row * (hei + 10) + top + bottom;
                
                return allHei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"threeimg2"]){
        return hei1;
    }else if ([model.type isEqualToString:@"threeimg3"]){
        for (int i = 0; i < self.threeImgThreeArr.count; i++) {
            MMHomePageItemModel *model1 = self.threeImgThreeArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.threeimg3HArr[i];
                CGFloat hei = [heiStr floatValue];
                return hei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"threeimg4"]){
        for (int i = 0; i < self.threeImg4Arr.count; i++) {
            MMHomePageItemModel *model1 = self.threeImg4Arr[i];
            if([model.index isEqualToString:model1.index]){
                NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:model1.cont.imglist];
                NSString *heiStr = self.threeImg4HArr[i];
                CGFloat hei = [heiStr floatValue];
                NSInteger row = imgArr.count/3;
                row = imgArr.count % 3 > 0 ? row + 1 : row;
                return row * hei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"jiutu"]){
        for (int i = 0; i < self.nineImgHArr.count; i++) {
            MMHomePageItemModel *model1 = self.nineArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.nineImgHArr[i];
                CGFloat hei = [heiStr floatValue];
                return hei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"twoimgturn"]){
        for (int i = 0; i < self.imageTwoTurnHArr.count; i++) {
            MMHomePageItemModel *model1 = self.imageTwoTurnArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.imageTwoTurnHArr[i];
                CGFloat hei = [heiStr floatValue];
                return hei;
            }
        }
        return 0;
    }else if ([model.type isEqualToString:@"limit1"]){
        float margin1 = [model.margin1 floatValue];
        float margin3 = [model.margin3 floatValue];
        return 264 + margin1 + margin3;
    }else if ([model.type isEqualToString:@"reclist8"]){
        return 216;
    }else if ([model.type isEqualToString:@"prolist2"]){
        return 186;
    }else if ([model.type isEqualToString:@"reclist2"]){
        return 186;
    }else if ([model.type isEqualToString:@"zuoyouhd"]){
        return 440;
    }else if ([model.type isEqualToString:@"ranklist2"]){
        return 254;
    }else if ([model.type isEqualToString:@"prolist4"]){
        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
        return 134 * arr.count;
    }else if ([model.type isEqualToString:@"prolist7"]){
        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
        return 134 * arr.count;
    }else if ([model.type isEqualToString:@"prolist1"]){
        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
        NSInteger row = arr.count/2;
        row = arr.count%2 > 0 ? row + 1 : row;
        
        return 10 + 325 * row;
    }else if ([model.type isEqualToString:@"prolist8"]){
        NSArray *arr = [MMHomeGoodsModel mj_objectArrayWithKeyValuesArray:model.cont.prolist];
        NSInteger row = arr.count/3;
        row = arr.count%3 > 0 ? row + 1 : row;
        return 216 * row;
    }else if ([model.type isEqualToString:@"stackbanners"]){
        for (int i = 0; i < self.stackBannerHArr.count; i++) {
            MMHomePageItemModel *model1 = self.stackBannerArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.stackBannerHArr[i];
                CGFloat hei = [heiStr floatValue];
                return hei;
            }
        }
        return 0;
    }
    else{
        return 0;
    }
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMHomePageItemModel *model = self.dataArr[indexPath.row];
    
    if([model.type isEqualToString:@"banner"]){
        MMCycleTableViewCell *cell = [[MMCycleTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"banner"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.BannerTapBlock = ^(NSString * _Nonnull indexStr) {
            weakself.BannerTapBlock(indexStr);
        };
        return cell;
    }else if ([model.type isEqualToString:@"nav"]){
        MMLinkNaTableViewCell *cell = [[MMLinkNaTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"navLink"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.LinkTapBlock = ^(NSString * _Nonnull indexStr) {
            weakself.LinkTapBlock(indexStr);
        };
        return cell;
    }else if ([model.type isEqualToString:@"iadvimg"]){
        MMSinglePicTableViewCell *cell = [[MMSinglePicTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"single"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapIadvBlock = ^(NSString * _Nonnull indexStr) {
            weakself.SingleTapBlock(indexStr);
        };
        return cell;
    }else if ([model.type isEqualToString:@"twoimg1"]){
        MMTwoImageOneCell *cell = [[MMTwoImageOneCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"twoimg1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapImgBlock = ^(NSString * _Nonnull indexStr) {
            weakself.TwoTapImgBlock(indexStr);
        };
        return cell;
    }else if ([model.type isEqualToString:@"twoimg2"]){
        MMTwoImgTwoCell *cell = [[MMTwoImgTwoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"twoimg2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        for (int i = 0; i < self.twoimg2Arr.count; i++) {
            MMHomePageItemModel *model1 = self.twoimg2Arr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.twoimg2HArr[i];
                cell.heiStr = heiStr;
            }
        }
        cell.TapImgTBlock = ^(NSString * _Nonnull indexStr) {
            weakself.TwoTapImgTBlock(indexStr);
        };
        return cell;
    }
    else if ([model.type isEqualToString:@"threeimg2"]){
        MMThreeImgCell *cell = [[MMThreeImgCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"threeimg2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapLeftImgBlock = ^(NSString * _Nonnull indexStr) {
            weakself.ThreeTapLeftImgBlock(indexStr);
        };
        cell.TapTopImgBlock = ^(NSString * _Nonnull indexStr) {
            weakself.ThreeTapTopImgBlock(indexStr);
        };
        cell.TapBottomImgBlock = ^(NSString * _Nonnull indexStr) {
            weakself.ThreeTapBottomImgBlock(indexStr);
        };
        return cell;
    }else if ([model.type isEqualToString:@"threeimg3"]){
        MMThreeImgThreeCell *cell = [[MMThreeImgThreeCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"threeimg3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        for (int i = 0; i < self.threeImgThreeArr.count; i++) {
            MMHomePageItemModel *model1 = self.threeImgThreeArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.threeimg3HArr[i];
                cell.heiStr = heiStr;
            }
        }
        cell.TapThreeImgThreeBlock = ^(NSString * _Nonnull router) {
            weakself.ThreeTapImgThreeBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"threeimg4"]){
        MMThreeImg4Cell *cell = [[MMThreeImg4Cell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"threeimg4"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        
        for (int i = 0; i < self.threeImg4Arr.count; i++) {
            MMHomePageItemModel *model1 = self.threeImg4Arr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.threeImg4HArr[i];
                cell.heiStr = heiStr;
            }
        }
        cell.TapThreeImg4Block = ^(NSString * _Nonnull router) {
            weakself.ThreeTapImgThreeBlock(router);
        };
        return cell;
    }
    else if ([model.type isEqualToString:@"jiutu"]){
        MMNineImageCell *cell = [[MMNineImageCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"jiutu"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapNineImageBlock = ^(NSString * _Nonnull router) {
            weakself.NineTapImageBlock(router);
        };
        cell.tapNineImageCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapRecEightGoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"twoimgturn"]){
        MMTwoImgChangeCell *cell = [[MMTwoImgChangeCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"twoimgturn"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapTwoImgChangeBlock = ^(NSString * _Nonnull router) {
            weakself.tapTwoImageChangeBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"limit1"]){
        MMLimitTypeCell *cell = [[MMLimitTypeCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"limit1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapLimitMoreBlock = ^(NSString * _Nonnull str) {
            weakself.limitTapMoreBlock(str);
        };
        return cell;
    }else if ([model.type isEqualToString:@"reclist8"]){
        MMRecListEightCell *cell = [[MMRecListEightCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reclist8"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapRecEightGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapRecEightGoodsBlock(router);
        };
        cell.tapRecEithGoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapRecEightGoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"prolist2"]){
        MMProListTwoCell *cell = [[MMProListTwoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"prolist2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapProListTwoGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsBlock(router);
        };
        cell.tapProListTwoGoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"reclist2"]){
        MMProListTwoCell *cell = [[MMProListTwoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reclist2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapProListTwoGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsBlock(router);
        };
        cell.tapProListTwoGoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"zuoyouhd"]){
        MMZYHDCell *cell = [[MMZYHDCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"zuoyouhd"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        
        cell.TapZYHDGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsBlock(router);
        };
        cell.tapZYHDGoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"ranklist2"]){
        MMRankList2Cell *cell = [[MMRankList2Cell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ranklist2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        
        cell.TapRankListTwoGoodsBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsBlock(router);
        };
        cell.tapRankListwoGoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapProList2GoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"prolist4"]){
        MMProList4Cell *cell = [[MMProList4Cell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"prolist4"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapPro4GoodsBlock = ^(NSString * _Nonnull str) {
            weakself.tapProList2GoodsBlock(str);
        };
        return cell;
    }else if ([model.type isEqualToString:@"prolist7"]){
        MMProList7Cell *cell = [[MMProList7Cell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"prolist7"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.TapPro7GoodsBlock = ^(NSString * _Nonnull str) {
            weakself.tapProList2GoodsBlock(str);
        };
        return cell;
    }else if ([model.type isEqualToString:@"prolist1"]){
        MMProList1Cell *cell = [[MMProList1Cell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"prolist1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.tapProlist1Block = ^(NSString * _Nonnull str) {
            weakself.tapProList2GoodsBlock(str);
        };
        return cell;
    }else if ([model.type isEqualToString:@"prolist8"]){
        MMProList8Cell *cell = [[MMProList8Cell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"prolist8"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.taPro8GoodsBlock = ^(NSString * _Nonnull str) {
            weakself.tapProList2GoodsBlock(str);
        };
        cell.tapPro8GoodsCarBlock = ^(NSString * _Nonnull router) {
            weakself.tapRecEightGoodsCarBlock(router);
        };
        return cell;
    }else if ([model.type isEqualToString:@"stackbanners"]){
        MMStackBannerCell *cell = [[MMStackBannerCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"stackbanners"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        
        for (int i = 0; i < self.stackBannerArr.count; i++) {
            MMHomePageItemModel *model1 = self.stackBannerArr[i];
            if([model.index isEqualToString:model1.index]){
                NSString *heiStr = self.stackBannerHArr[i];
                cell.heiStr = heiStr;
            }
        }
        cell.tapImageBlock = ^(NSString * _Nonnull router) {
            weakself.ThreeTapImgThreeBlock(router);
        };
        return cell;
    }
    
    return nil;
    
}

@end
