//
//  MMEmailOpenWalletPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/4.
//

#import "MMEmailOpenWalletPopView.h"

@interface MMEmailOpenWalletPopView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UITextField *againField;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation MMEmailOpenWalletPopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(24, HEIGHT + (HEIGHT - 420)/2, WIDTH - 48, 290)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    UILabel *titleLa = [UILabel publicLab:@"开启我的钱包" textColor:TCUIColorFromRGB(0x2f2e2e) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:18 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 35, WIDTH - 48, 18);
    [self.bgView addSubview:titleLa];
    
    NSArray *arr = @[@"请输入支付密码",@"请确认支付密码"];
    NSArray *iconArr = @[@"lock_icon_black",@"lock_icon_black"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLa.frame) + 65 * i, WIDTH - 48, 65)];
        [self.bgView addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 22, 16, 20)];
        iconImage.image = [UIImage imageNamed:iconArr[i]];
        [view addSubview:iconImage];
        
        UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(58, 20, WIDTH - 148, 24)];
        field1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:arr[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xb1b0b0)}];
        field1.delegate = self;
        field1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        field1.textColor = textBlackColor2;
        field1.clearButtonMode = UITextFieldViewModeWhileEditing;
        field1.textAlignment = NSTextAlignmentLeft;
        [view addSubview:field1];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"eye_yes_black"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"eye_no_black"] forState:(UIControlStateSelected)];
        btn.selected = NO;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickEye:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(view);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(12);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 64.5, WIDTH - 78, 0.5)];
        line.backgroundColor = TCUIColorFromRGB(0xdedede);
        [view addSubview:line];
        
        if(i == 0){
            self.pwdField = field1;
            self.pwdField.secureTextEntry = btn.selected;
        }else{
            self.againField = field1;
            self.againField.secureTextEntry = btn.selected;
        }
    }
    
    UIButton *sureBt = [[UIButton alloc]init];
    [sureBt setBackgroundColor:TCUIColorFromRGB(0xe13916)];
    [sureBt setTitle:[UserDefaultLocationDic valueForKey:@"idetermine"] forState:(UIControlStateNormal)];
    [sureBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    sureBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    sureBt.layer.masksToBounds = YES;
    sureBt.layer.cornerRadius = 17;
    [sureBt addTarget:self action:@selector(clicksure) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:sureBt];
    
    [sureBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(28);
            make.bottom.mas_equalTo(-32);
            make.width.mas_equalTo(124);
            make.height.mas_equalTo(34);
    }];
    
    UIButton *homeBt = [[UIButton alloc]init];
    [homeBt setBackgroundColor:TCUIColorFromRGB(0xaeaeae)];
    [homeBt setTitle:@"回到首页" forState:(UIControlStateNormal)];
    [homeBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    homeBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    homeBt.layer.masksToBounds = YES;
    homeBt.layer.cornerRadius = 17;
    [homeBt addTarget:self action:@selector(goHome) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:homeBt];
    
    [homeBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-28);
            make.bottom.mas_equalTo(-32);
            make.width.mas_equalTo(124);
            make.height.mas_equalTo(34);
    }];
    
}

-(void)clickEye:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.tag == 100){
        if(sender.selected == YES){
            self.pwdField.secureTextEntry = YES;
        }else{
            self.pwdField.secureTextEntry = NO;
        }
    }else if (sender.tag == 101){
        if(sender.selected == YES){
            self.againField.secureTextEntry = YES;
        }else{
            self.againField.secureTextEntry = NO;
        }
    }
}

-(void)clicksure{
    if(self.pwdField.text.length > 0 && self.againField.text.length > 0){
        if([self.pwdField.text isEqualToString:self.againField.text]){
            self.clickSure(self.pwdField.text, self.againField.text);
        }else{
            [ZTProgressHUD showMessage:@"两次密码不一致"];
        }
    }else{
        [ZTProgressHUD showMessage:@"请将信息输入完整"];
    }
    
}

-(void)goHome{
    self.clickHome(@"1");
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
