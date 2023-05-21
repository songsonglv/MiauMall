//
//  MMGoodsDetailBottomView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//

#import "MMGoodsDetailBottomView.h"
#import "MYNumLabel.h"
@interface MMGoodsDetailBottomView ()
@property (nonatomic, strong) MYNumLabel *numLa;
@property (nonatomic, strong) UIView *ysView;
@end

@implementation MMGoodsDetailBottomView

-(UIView *)ysView{
    if(!_ysView){
        _ysView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 236, 8, 216, 40)];
        
        _ysView.layer.masksToBounds = YES;
        _ysView.layer.cornerRadius = 20;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDate *dateTime = [formatter dateFromString:self.model.proInfo.DepositEndTime];
        
        NSTimeInterval a = [dateTime timeIntervalSince1970] - 8 * 3600;
        
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSTimeInterval a1 = [datenow timeIntervalSince1970];
        
        if(a1 > a){
            _ysView.backgroundColor = TCUIColorFromRGB(0xcbcbcb);
            UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"depositEnd2"] textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
            lab.frame = CGRectMake(0, 0, 216, 40);
            [_ysView addSubview:lab];
        }else{
            [self setView:_ysView andCorlors:@[TCUIColorFromRGB(0xff7633),redColor2]];
            NSString *endtime = [self setString:self.model.proInfo.DepositEndTime];
            CGSize size1 = [NSString sizeWithText:endtime font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            UILabel *lab1 = [UILabel publicLab:endtime textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
            lab1.frame = CGRectMake(12, 7, size1.width, 12);
            [_ysView addSubview:lab1];
            
            CGSize size4 = [NSString sizeWithText:self.model.proInfo.DepositMoneyShow font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            
            
            
            CGSize size3 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"depositEnd"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            UILabel *lab3 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"depositEnd"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
            lab3.frame = CGRectMake(0, CGRectGetMaxY(lab1.frame) + 5, size3.width, 12);
            lab3.centerX = lab1.centerX;
            [_ysView addSubview:lab3];
            
            
            UILabel *lab4 = [UILabel publicLab:self.model.proInfo.DepositMoneyShow textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
            lab4.frame = CGRectMake(216 - size4.width - 12, CGRectGetMaxY(lab1.frame) + 5, size4.width, 12);
            [_ysView addSubview:lab4];
            
            CGSize size2 = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"payDeposit2"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"payDeposit2"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
            lab2.frame = CGRectMake(0, 7, size2.width, 12);
            lab2.centerX = lab4.centerX;
            [_ysView addSubview:lab2];
            
            
            
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 216, 40)];
            [btn addTarget:self action:@selector(clickBuyNow) forControlEvents:(UIControlEventTouchUpInside)];
            [_ysView addSubview:btn];
        }
        
        
       
        
    }
    return _ysView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    NSArray *arr = @[[UserDefaultLocationDic valueForKey:@"ihome"],[UserDefaultLocationDic valueForKey:@"customerService"],[UserDefaultLocationDic valueForKey:@"shopCart"]];
    NSArray *imgArr = @[@"home_icon",@"kefu_icon",@"car_icon"];
    
    CGFloat wid = 7;
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid, 10, 34, 34)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 24, 20)];
        image.image = [UIImage imageNamed:imgArr[i]];
        [view addSubview:image];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x636363) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:9 numberOfLines:0];
        lab.frame = CGRectMake(0, 28, 34, 9);
        [view addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(wid ,10, 34, 34);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        wid += 46;
        
        if(i == 2){
            MYNumLabel *numLa = [[MYNumLabel alloc]initWithFrame:CGRectMake(18, -5, 20, 14)];
            numLa.backgroundColor = redColor2;
            numLa.layer.masksToBounds = YES;
            numLa.layer.cornerRadius = 7;
            numLa.textColor = TCUIColorFromRGB(0xffffff);
            numLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
            numLa.textAlignment = NSTextAlignmentCenter;
            [view addSubview:numLa];
            self.numLa = numLa;
        }
    }
    
    UIButton *buyNowBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 120, 8, 100, 40)];
    buyNowBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    buyNowBt.backgroundColor = TCUIColorFromRGB(0xd64f3e);
    buyNowBt.layer.masksToBounds = YES;
    buyNowBt.layer.cornerRadius = 20;
    [buyNowBt setTitle:[UserDefaultLocationDic valueForKey:@"buyNow"] forState:(UIControlStateNormal)];
    [buyNowBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [buyNowBt addTarget:self action:@selector(clickBuyNow) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:buyNowBt];
    self.exchangeBt = buyNowBt;
    
    UIButton *addCarBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 230, 8, 100, 40)];
    addCarBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    addCarBt.backgroundColor = TCUIColorFromRGB(0x333333);
    addCarBt.layer.masksToBounds = YES;
    addCarBt.layer.cornerRadius = 20;
    [addCarBt setTitle:[UserDefaultLocationDic valueForKey:@"addCart"] forState:(UIControlStateNormal)];
    [addCarBt setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [addCarBt addTarget:self action:@selector(clickAddCar) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:addCarBt];
    self.addCarBt = addCarBt;
}

-(void)clickBuyNow{
    self.buyNowTapBlock(@"1");
}

-(void)clickAddCar{
    self.addCarTapBlock(@"1");
}

-(void)clickBtn:(UIButton *)sender{
    if(sender.tag == 100){
        self.homeTapBlock(@"1");
    }else if(sender.tag == 101){
        self.kefuTapBlock(@"1");
    }else{
        self.carTapBlock(@"1");
    }
}

-(void)setModel:(MMGoodsDetailMainModel *)model{
    _model = model;
    
    if([_model.proInfo.cid isEqualToString:@"794"]){
        self.exchangeBt.hidden = YES;
        self.addCarBt.hidden = YES;
        [self addSubview:self.ysView];
    }
}

-(void)setNum:(NSString *)num{
    _num = num;
    self.numLa.count = _num;
    NSInteger numer = [num integerValue];
    if (numer > 99) {
        self.numLa.width = 26;
        
    }else if (numer > 9){
        self.numLa.width = 20;
        
    }else if (numer > 0) {
        self.numLa.width = 14;
       
    }else{
        self.numLa.hidden = YES;
    }
}


//设置渐变色
-(void)setView:(UIView *)btn andCorlors:(NSArray *)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 = colors[0];
    UIColor *color2 = colors[1];
    gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint =  CGPointMake(1,1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    [btn.layer addSublayer:gradientLayer];
}

//时间格式转换
-(NSString *)setString:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *dateTime = [formatter dateFromString:timeStr];
    
//    NSCalendar *calandar = [NSCalendar currentCalendar];
//    NSUInteger unitflags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSCalendarUnitSecond;
//    NSDateComponents *components = [calandar  components:unitflags fromDate:dateTime];
    
    
    NSString *timeStr1 = [self dateAsString:dateTime];
    //[NSString stringWithFormat:@"%d-%d %d:%d",components.month,components.day,components.hour,components.minute];
    return timeStr1;
}

-(NSString*)dateAsString:(NSDate*)date {
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    [formatter setTimeZone:timeZone];
    NSString * timeString = [formatter stringFromDate:date];
    return timeString;
}

@end
