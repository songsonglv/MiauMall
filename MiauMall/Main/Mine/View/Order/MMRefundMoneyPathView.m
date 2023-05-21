//
//  MMRefundMoneyPathView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/12.
//

#import "MMRefundMoneyPathView.h"

@interface MMRefundMoneyPathView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, assign) NSInteger seleIndex;
@end

@implementation MMRefundMoneyPathView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDataArr:(NSArray *)dataArr{
    if(self = [super initWithFrame:frame]){
        self.dataArr = dataArr;
        self.titleStr = title;
        self.seleIndex = 0;
        
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    KweakSelf(self);
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 * HEIGHT - 340, WIDTH, 340)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1)];
    [self.bgView addGestureRecognizer:tap1];
    
    UILabel *titleLa = [UILabel publicLab:self.titleStr textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 25, WIDTH, 15);
    [self.bgView addSubview:titleLa];
    
    UIButton *closeBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 32, 16, 14, 14)];
    [closeBt setImage:[UIImage imageNamed:@"select_close"] forState:(UIControlStateNormal)];
    [closeBt addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:closeBt];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *str = self.dataArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 66 + 46 * i, WIDTH, 46)];
        [self.bgView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:str textColor:TCUIColorFromRGB(0x0c0307) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        lab.preferredMaxLayoutWidth = WIDTH - 62;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(14);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 100 + i;
        [btn setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"select_yes"] forState:(UIControlStateSelected)];
        btn.selected = NO;
        [btn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:200];
        [btn addTarget:self action:@selector(clickSele:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(view);
                    make.width.height.mas_equalTo(15);
        }];
        
        if(i == 0){
            btn.selected = YES;
            self.selectBt = btn;
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(17, 45.5, WIDTH - 34, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xebebeb);
        [view addSubview:line];
    }
    
    UIButton *doneBt = [[UIButton alloc]init];
    [doneBt setBackgroundColor:redColor2];
    [doneBt setTitle:@"完成" forState:(UIControlStateNormal)];
    [doneBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    doneBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    doneBt.layer.masksToBounds = YES;
    doneBt.layer.cornerRadius = 21;
    [doneBt addTarget:self action:@selector(clickDone) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:doneBt];
    
    [doneBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.bottom.mas_equalTo(-16);
            make.right.mas_equalTo(-18);
            make.height.mas_equalTo(42);
    }];
}

-(void)clickSele:(UIButton *)sender{
    self.seleIndex = sender.tag - 100;
    if([sender isEqual:self.selectBt]){
        
    }else{
        sender.selected = YES;
        self.selectBt.selected = NO;
        self.selectBt = sender;
    }
}

-(void)clickDone{
    NSString *str = self.dataArr[self.seleIndex];
    self.returnPathStr(str);
    [self hideView];
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
