//
//  MMOrderCollectionCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/13.
//

#import "MMOrderCollectionCell.h"
#import "MMOrderListModel.h"
#import "MMOrderListCell.h"

@interface MMOrderCollectionCell ()<UITableViewDelegate,UITableViewDataSource,HGCategoryViewDelegate>
@property (nonatomic, strong) NSMutableArray *heiArr;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) HGCategoryView *cateView;
@end

@implementation MMOrderCollectionCell

-(NSMutableArray *)heiArr{
    if(!_heiArr){
        _heiArr = [NSMutableArray array];
    }
    return _heiArr;
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, StatusBarHeight + 64, WIDTH - 20, HEIGHT - StatusBarHeight - TabbarSafeBottomMargin - 64) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(HGCategoryView *)cateView{
    if(!_cateView){
        _cateView = [[HGCategoryView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 25)];
        _cateView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        _cateView.delegate = self;
        _cateView.titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"售后"];
        _cateView.selectedIndex = self.index;
        _cateView.alignment = HGCategoryViewAlignmentLeft;
        _cateView.titleNomalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _cateView.titleNormalColor = TCUIColorFromRGB(0x282932);
        _cateView.titleSelectedColor = TCUIColorFromRGB(0x282932);
        _cateView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _cateView.vernier.backgroundColor = TCUIColorFromRGB(0x2e2e2e);
        _cateView.topBorder.hidden = YES;
        _cateView.bottomBorder.hidden = YES;
        _cateView.vernier.height = 2.0f;
        _cateView.vernierWidth = 15;
    }
    return _cateView;
}

-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    //[self setupUI];
}
    return self;
}

-(void)setUI{
    [self addSubview:self.mainTableView];
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    for (MMOrderListModel *model in _dataArr) {
        if(model.EstimatedShipment.length > 0){
         float hei = 265 + 124 * model.itemlist.count;
            NSString *heistr = [NSString stringWithFormat:@"%.2f",hei];
            [self.heiArr addObject:heistr];
        }else{
           float hei = 210 + 124 * model.itemlist.count;
            NSString *heistr = [NSString stringWithFormat:@"%.2f",hei];
            [self.heiArr addObject:heistr];
        }
    }
    [self setUI];
}



#pragma mark -- uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMOrderListModel *model = self.dataArr[indexPath.row];
    if(model.EstimatedShipment.length > 0){
        return 265 + 124 * model.itemlist.count;
    }else{
        return 210 + 124 * model.itemlist.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *identity = @"tableHead";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identity];
    if(!view){
        view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identity];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 60)];
        bgView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
        [view addSubview:bgView];
        [bgView addSubview:self.cateView];
    }
   
//    [view addSubview:self.cateView];

    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMOrderListCell*cell = [[MMOrderListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MMOrderListModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.tapGoodsBlock = ^(NSString * _Nonnull router) {
        weakself.tapGoodsBlock(router);
    };
    cell.tapCopyBlock = ^(NSString * _Nonnull OrderNo) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = OrderNo;
        [ZTProgressHUD showMessage:@"复制成功！"];
    };
    cell.tapRigthBlock = ^(NSString * _Nonnull btType) {
        weakself.tapRightBlock(btType, model.ID, model);
//        [weakself clickRight:btType andItemID:model.ID andModel:model];
    };
    cell.tapCenterBlock = ^(NSString * _Nonnull btType) {
        weakself.tapCenterBlock(btType, model.ID, model);
//        [weakself clickCenter:btType andItemID:model.ID andModel:model];
    };
    cell.tapLeftBlock = ^(NSString * _Nonnull btType) {
        weakself.tapCenterBlock(btType, model.ID, model);
//        weakself.seleModel = model;
//        [weakself clickLeft:btType andItemID:model.ID];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMOrderListModel *model = self.dataArr[indexPath.row];
    self.tapDidselectBlock(model.ID);
}
@end
