//
//  MMNotificationSetupView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/29.
//

#import "MMNotificationSetupView.h"

@interface MMNotificationSetupView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *emailBt;
@property (nonatomic, strong) UIButton *systemBt;
@property (nonatomic, strong) UIButton *expressBt;
@property (nonatomic, strong) UIButton *orderBt;
@property (nonatomic, strong) MMMineMainDataModel *model;
@end

@implementation MMNotificationSetupView

-(instancetype)initWithFrame:(CGRect)frame andData:(nonnull MMMineMainDataModel *)model{
    if(self = [super initWithFrame:frame]){
        self.model = model;
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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 2 * HEIGHT - 472, WIDTH,472)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 17.5;
    [self addSubview:self.bgView];
    
    NSArray *arr = @[@"邮件消息",@"系统消息",@"物流消息",@"订单消息"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 12 + 66 * i, WIDTH, 66)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.bgView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x231815) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 120;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(33);
                    make.centerY.mas_equalTo(view);
                    make.height.mas_equalTo(15);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"switch_on"] forState:(UIControlStateSelected)];
        [btn setImage:[UIImage imageNamed:@"switch_off"] forState:(UIControlStateNormal)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(view);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(20);
                }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 65.5, WIDTH - 32, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
        [view addSubview:line];
        
        if(i == 0){
            self.emailBt = btn;
            if([self.model.memberInfo.IsReceiveEmail isEqualToString:@"1"]){
                self.emailBt.selected = YES;
            }else{
                self.emailBt.selected = NO;
            }
        }else if (i == 1){
            self.systemBt = btn;
            if([self.model.memberInfo.TipsSys isEqualToString:@"1"]){
                self.systemBt.selected = YES;
            }else{
                self.systemBt.selected = NO;
            }
        }else if (i == 2){
            self.expressBt = btn;
            if([self.model.memberInfo.TipsWulu isEqualToString:@"1"]){
                self.expressBt.selected = YES;
            }else{
                self.expressBt.selected = NO;
            }
        }else{
            self.orderBt = btn;
            if([self.model.memberInfo.TipsOrder isEqualToString:@"1"]){
                self.orderBt.selected = YES;
            }else{
                self.orderBt.selected = NO;
            }
        }
    }
    
    UIButton *sureBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 366, WIDTH - 20, 54)];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 27;
    [sureBt setBackgroundColor:redColor2];
    [sureBt setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBt addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
}
-(void)clickBt:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(void)clickBt{
    NSString *isEmail,*isSystem,*isExpress,*isOrder;
    
    if(self.emailBt.selected){
        isEmail = @"1";
    }else{
        isEmail = @"0";
    }
    if(self.systemBt.selected){
        isSystem = @"1";
    }else{
        isSystem = @"0";
    }
    if(self.expressBt.selected){
        isExpress = @"1";
    }else{
        isExpress = @"0";
    }
    
    if(self.orderBt.selected){
        isOrder = @"1";
    }else{
        isOrder = @"0";
    }
    self.saveNotificationBlock(isEmail, isSystem, isExpress, isOrder);
    [self hideView];
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
