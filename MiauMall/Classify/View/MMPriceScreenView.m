//
//  MMPriceScreenView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/8.
//  价格筛选弹窗

#import "MMPriceScreenView.h"
@interface MMPriceScreenView ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *priceArr;
@property (nonatomic, strong) UITextField *minField;
@property (nonatomic, strong) UITextField *maxField;
@property (nonatomic, strong) NSString *minPrice;
@property (nonatomic, strong) NSString *maxPrice;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, assign) CGFloat hei;
@end

@implementation MMPriceScreenView

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)priceArr andHei:(CGFloat)hei{
    if(self = [super initWithFrame:frame]){
        self.hei = hei;
        self.priceArr = priceArr;
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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
//    [self.view addGestureRecognizer:tap];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, 30)];
    self.topView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:self.topView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0,-HEIGHT, WIDTH, 218)];
    if(self.priceArr.count > 4){
        self.contentView.height = 272;
        
    }
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 7.5;
    [self.view addSubview:self.contentView];
    
    UILabel *lab = [UILabel publicLab:@"价格区间" textColor:TCUIColorFromRGB(0x4c4c4c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
    lab.frame = CGRectMake(13, 16, WIDTH - 26, 13);
    [self.contentView addSubview:lab];
    
    CGFloat wid = (WIDTH - 54)/4;
    for (int i = 0; i < self.priceArr.count; i++) {
        NSString *str = self.priceArr[i];
        NSInteger v = i/4;
        NSInteger h = i%4;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (wid + 10) * h, 46 + 54 * v, wid, 36)];
        [btn setTitle:str forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 6;
        btn.layer.borderColor = TCUIColorFromRGB(0x585c5f).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:btn];
    }
    
    CGFloat wid1 = (WIDTH - 49)/2;
    NSArray *arr1 = @[@"最低价",@"最高价"];
    for (int i = 0; i < arr1.count; i++) {
        UITextField *field1 = [[UITextField alloc]initWithFrame:CGRectMake(12 + (wid1 + 25) * i, 100, wid1, 36)];
        if(self.priceArr.count > 4){
            field1.y = 154;
        }
//        field1.layer.masksToBounds = YES;
        field1.borderStyle = UITextBorderStyleRoundedRect;
        field1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:arr1[i] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0xc0c0c0)}];
        field1.delegate = self;
        field1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        field1.textColor = TCUIColorFromRGB(0x333333);
        field1.clearButtonMode = UITextFieldViewModeWhileEditing;
        field1.textAlignment = NSTextAlignmentCenter;
        [field1 addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:(UIControlEventEditingChanged)];
        [self.contentView addSubview:field1];
        
        if(i == 0){
            self.minField = field1;
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(field1.frame) + 6, 118, 10, 1)];
            line.backgroundColor = TCUIColorFromRGB(0x4c4c4c);
            [self.contentView addSubview:line];
        }else{
            self.maxField = field1;
        }
    }
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 170, WIDTH/2, 48)];
    [btn1 setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [btn1 setTitle:@"重置" forState:(UIControlStateNormal)];
    [btn1 setTitleColor:TCUIColorFromRGB(0x7e7e7e) forState:(UIControlStateNormal)];
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn1 addTarget:self action:@selector(clickReset) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 170, WIDTH/2, 48)];
    [btn2 setBackgroundColor:TCUIColorFromRGB(0xda391d)];
    [btn2 setTitle:@"确定" forState:(UIControlStateNormal)];
    [btn2 setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btn2 addTarget:self action:@selector(clickSele) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn2];
    
    if(self.priceArr.count > 4){
        btn1.y = 230;
        btn2.y = 230;
    }
    
}

-(void)clickBt:(UIButton *)sender{
    NSInteger tag = sender.tag - 100;
    NSString *str = self.priceArr[tag];
//    sender.selected = !sender.selected;
    
    if([self.selectBt isEqual:sender]){
        [self.selectBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.selectBt.layer.borderColor = TCUIColorFromRGB(0x585c5f).CGColor;
        [self.selectBt setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
        self.selectBt.layer.borderWidth = 0.5;
        self.minField.text = @"";
        self.maxField.text = @"";
        self.maxPrice = @"";
        self.minPrice = @"";
        self.selectBt = nil;
    }else{
        [self.selectBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
        self.selectBt.layer.borderColor = TCUIColorFromRGB(0x585c5f).CGColor;
        [self.selectBt setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
        self.selectBt.layer.borderWidth = 0.5;
        self.minField.text = @"";
        self.maxField.text = @"";
        self.maxPrice = @"";
        self.minPrice = @"";
        self.selectBt = nil;
        [sender setBackgroundColor:TCUIColorFromRGB(0xfee6e4)];
        sender.layer.borderColor = redColor2.CGColor;
        [sender setTitleColor:redColor2 forState:(UIControlStateNormal)];
        sender.layer.borderWidth = 0.5;
        self.selectBt = sender;
        //componentsSeparatedByString 字符串转数组
        if([str containsString:@"-"]){
            NSArray *arr = [str componentsSeparatedByString:@"-"];
            self.minPrice = arr[0];
            self.minField.text = arr[0];
            self.maxPrice = arr[1];
            self.maxField.text = arr[1];
        }else{
            NSScanner *scanner = [NSScanner scannerWithString:str];
                [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
                int num;
                [scanner scanInt:&num];
            self.minPrice = [NSString stringWithFormat:@"%d",num];
            self.minField.text = [NSString stringWithFormat:@"%d",num];
        }
    }
        
        
    
}

-(void)clickReset{
    [self.selectBt setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    self.selectBt.layer.borderColor = TCUIColorFromRGB(0x585c5f).CGColor;
    [self.selectBt setTitleColor:TCUIColorFromRGB(0x4c4c4c) forState:(UIControlStateNormal)];
    self.selectBt.layer.borderWidth = 0.5;
    self.selectBt = nil;
    self.minField.text = @"";
    self.maxField.text = @"";
    self.maxPrice = @"";
    self.minPrice = @"";
    
}

-(void)clickSele{
    self.surePriceBlock(self.minPrice, self.maxPrice);
    [self hideView];
}

-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topView.centerY =self.topView.centerY-HEIGHT;
        self.contentView.centerY =self.contentView.centerY-HEIGHT;
        
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
        self.topView.centerY =self.topView.centerY + HEIGHT;
        self.contentView.centerY =self.contentView.centerY + HEIGHT;
       
     } completion:^(BOOL fin){}];
}

-(void)dealloc{
    NSLog(@"dealloc");
}

#pragma mark -- uitextfielddelegate
- (void)textFieldEditChanged:(UITextField *)textField
{
    if(textField == self.minField){
        self.minPrice = textField.text;
    }else{
        self.maxPrice = textField.text;
    }
}
@end
