//
//  MMDMAddressSelectPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import "MMDMAddressSelectPopView.h"
#import "MMDMAddressCell.h"

@interface MMDMAddressSelectPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@end

//addAddress

@implementation MMDMAddressSelectPopView

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 400) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.view];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    //    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0,  2 * HEIGHT - 540, WIDTH, 540)];
    [self setCircular:self.bgView andCir1:(UIRectCornerTopLeft) andCir2:(UIRectCornerTopRight)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 34, 12, 16, 16)];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UILabel *tiLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"chooseAddress"] textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    tiLa.frame = CGRectMake(0, 36, WIDTH, 15);
    [self.bgView addSubview:tiLa];
    
    [self.bgView addSubview:self.mainTableView];
    
    UIButton *addBT = [[UIButton alloc]initWithFrame:CGRectMake(10, 454, WIDTH - 20, 54)];
    [addBT setBackgroundColor:redColor3];
    [addBT setTitle:[NSString stringWithFormat:@"+ %@",[UserDefaultLocationDic valueForKey:@"addAddress"]] forState:(UIControlStateNormal)];
    [addBT setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    addBT.layer.masksToBounds = YES;
    addBT.layer.cornerRadius = 27;
    [addBT addTarget:self action:@selector(clickAdd) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:addBT];
}

-(void)clickAdd{
    self.addAddressBlock(@"1");
    [self hideView];
}

-(void)setAddressArr:(NSArray *)addressArr{
    _addressArr = addressArr;
    [self.mainTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMDMAddressCell*cell = [[MMDMAddressCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.addressArr[indexPath.row];
    cell.editAddressBlock = ^(MMAddressModel * _Nonnull model) {
        weakself.editAddressBlock(model);
        [weakself hideView];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMAddressModel *model = self.addressArr[indexPath.row];
    self.returnAddressBlock(model);
    [self hideView];
}

///设置圆角[左上、右上角]
- (void)setCircular:(UIView *)view andCir1:(UIRectCorner)cir1 andCir2:(UIRectCorner)cir2{

UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:cir1 | cir2 cornerRadii:CGSizeMake(17.5,17.5)];

//创建 layer
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = view.bounds;
//赋值
maskLayer.path = maskPath.CGPath;
view.layer.mask = maskLayer;
}

-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY =self.bgView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}
@end
