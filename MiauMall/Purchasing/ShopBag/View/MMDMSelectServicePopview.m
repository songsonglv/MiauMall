//
//  MMDMSelectServicePopview.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/7.
//

#import "MMDMSelectServicePopview.h"


@interface MMDMSelectServicePopview ()
@property (nonatomic, strong) NSMutableArray *serviceArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *selectBT;
@end

@implementation MMDMSelectServicePopview

-(NSMutableArray *)serviceArr{
    if(!_serviceArr){
        _serviceArr = [NSMutableArray array];
    }
    return _serviceArr;
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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0,  2 * HEIGHT - 472, WIDTH, 472)];
    [self setCircular:self.bgView andCir1:(UIRectCornerTopLeft) andCir2:(UIRectCornerTopRight)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 34, 12, 16, 16)];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    UILabel *tiLa = [UILabel publicLab:@"可选服务" textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
    tiLa.frame = CGRectMake(0, 36, WIDTH, 18);
    [self.bgView addSubview:tiLa];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tiLa.frame) + 20, WIDTH, 400)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    scrollView.contentSize = CGSizeMake(WIDTH, 400);
    [self.bgView addSubview:scrollView];
    self.scrollView = scrollView;
    
}

-(void)setTipsArr:(NSArray *)tipsArr{
    _tipsArr = tipsArr;
    NSArray *arr = [MMDMSeriverModel mj_objectArrayWithKeyValuesArray:_tipsArr];
    self.serviceArr = [NSMutableArray arrayWithArray:arr];
    
    float hei = 15;
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
    for (int i = 0; i < self.serviceArr.count; i++) {
        MMDMSeriverModel *model = self.serviceArr[i];
        CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@：%@JPY",model.Name,model.Price] font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
        
        CGSize size1 = [NSString sizeWithText:model.Detail font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,12)];
        
        if([lang isEqualToString:@"1"]){
            size =  [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
            
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, size.height + size1.height)];
        if([lang isEqualToString:@"1"]){
            view.height += 26;
        }
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.scrollView addSubview:view];
        
        UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(15, 6, 15, 15)];
        seleBt.tag = 100 + i;
        [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [seleBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
        [seleBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [seleBt setEnlargeEdgeWithTop:10 right:200 bottom:30 left:15];
        seleBt.selected = NO;
        [view addSubview:seleBt];
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        lab.frame = CGRectMake(34, 1, WIDTH - 60, size.height);
        [view addSubview:lab];
        
        if([lang isEqualToString:@"1"]){
            lab.text = model.Name;
            
            UILabel *priceLa = [UILabel publicLab:[NSString stringWithFormat:@"%@JPY",model.Price] textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
            priceLa.frame = CGRectMake(34, CGRectGetMaxY(lab.frame) + 12, WIDTH - 60, 14);
            [view addSubview:priceLa];
        }else{
            lab.frame = CGRectMake(34, 1, WIDTH - 60, size.height);
            [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                        confer.text([NSString stringWithFormat:@"%@：",model.Name]).textColor(TCUIColorFromRGB(0x10131f)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
                        confer.text([NSString stringWithFormat:@"%@JPY",model.Price]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
            }];
        }
        
        if(model.Detail){
            UILabel *detailLa = [UILabel publicLab:model.Detail textColor:TCUIColorFromRGB(0x4c4c4c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
            detailLa.frame = CGRectMake(34, CGRectGetMaxY(lab.frame) + 12, WIDTH - 60, size1.height);
            [view addSubview:detailLa];
            
            if([lang isEqualToString:@"1"]){
                detailLa.y = CGRectGetMaxY(lab.frame) + 38;
            }
        }
        
        
        hei += size.height + 36;
        
        if(size1.height > 0){
            hei += size1.height + 12;
        }
        
            
        if([lang isEqualToString:@"1"]){
            hei += 26;
        }
    }
    self.scrollView.contentSize = CGSizeMake(WIDTH, hei + 20);
    
}

-(void)clickBt:(UIButton *)sender{
    if([self.selectBT isEqual:sender]){
        sender.selected = !sender.selected;
        self.selectBT.selected = NO;
        self.selectBT = nil;
        self.selectServiceBlock(nil);
        [self hideView];
    }else{
        sender.selected = !sender.selected;
        self.selectBT.selected = NO;
        self.selectBT = sender;
        MMDMSeriverModel *model = self.serviceArr[sender.tag - 100];
        self.selectServiceBlock(model);
        [self hideView];
    }
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
@end
