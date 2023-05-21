//
//  MMLimitEightCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/23.
//  限时抢购8

#import "MMLimitEightCell.h"
#import "MMLimit8GoodsView.h"

@interface MMLimitEightCell ()
@property (nonatomic, strong) UILabel *todayLa;//今天
@property (nonatomic, strong) UILabel *todayLa1;
@property (nonatomic, strong) UILabel *tomoLa;//明天
@property (nonatomic, strong) UILabel *tomoLa1;
@property (nonatomic, strong) UILabel *limitLa;
@property (nonatomic, strong) UILabel *hourLa;
@property (nonatomic, strong) UILabel *minLa;
@property (nonatomic, strong) UILabel *secLa;
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) MMLimit8GoodsView *limitV;


@end

@implementation MMLimitEightCell

-(MMLimit8GoodsView *)limitV{
    KweakSelf(self);
    if(!_limitV){
        if(self.model.cont.prolist.count > 0){
            NSArray *arr = self.model.cont.prolist[0];
            NSArray *arr1 = self.model.cont.prolist[1];
            _limitV = [[MMLimit8GoodsView alloc]initWithFrame:CGRectMake(10, 48, WIDTH - 20, 220) andTodayData:arr andTomorrowData:arr1 andModel:self.model];
            _limitV.type = @"0";
            _limitV.clickGoodsBlock = ^(NSString * _Nonnull str) {
                weakself.TapLimitEightMoreBlock(str);
            };
        }
        
    }
    return _limitV;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 14, 12, 20)];
    leftImage.image = [UIImage imageNamed:@"lightning_black"];
    [self.contentView addSubview:leftImage];
    
    UILabel *limitLa = [UILabel publicLab:@"限时秒杀" textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    limitLa.preferredMaxLayoutWidth = 200;
    [limitLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:limitLa];
    
    [limitLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(16);
    }];
    
    self.limitLa = limitLa;
    
    NSString *today = [UserDefaultLocationDic valueForKey:@"itoday"];
    
    UILabel *todayLa = [UILabel publicLab:today textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
    [self.contentView addSubview:todayLa];
    self.todayLa = todayLa;
    
    [todayLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *todayLa1 = [UILabel publicLab:@"09:00" textColor:redColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
    [self.contentView addSubview:todayLa1];
    self.todayLa1 = todayLa1;
    
    [todayLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(11);
    }];
    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.backgroundColor = UIColor.clearColor;
    [btn1 addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(125);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(24);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = TCUIColorFromRGB(0x000000);
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(todayLa.mas_right).offset(15);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(24);
    }];
    
    UILabel *tomoLa = [UILabel publicLab:@"明天" textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    [self.contentView addSubview:tomoLa];
    self.tomoLa = tomoLa;
    
    [tomoLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(15);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *tomoLa1 = [UILabel publicLab:@"09:00" textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:11 numberOfLines:0];
    [self.contentView addSubview:tomoLa1];
    self.tomoLa1 = tomoLa1;
    
    [tomoLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right).offset(15);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(11);
    }];
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.backgroundColor = UIColor.clearColor;
    [btn2 addTarget:self action:@selector(clickBt1) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right).offset(15);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(24);
    }];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    self.limitLa.text = _model.name;
    
    
    if(_model.cont.prolist.count > 0){
        NSArray *arr1 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist[1]];
        MMHomeLimitGoodsModel *model2 = arr1[0];
        NSString *str2 = [model2.PromotionStart substringWithRange:NSMakeRange(5,5)];
        self.tomoLa.text = str2;
        
        UILabel *hourLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        hourLa.frame = CGRectMake(WIDTH - 100, 15, 18, 18);
        hourLa.backgroundColor = TCUIColorFromRGB(0x2a2a2a);
        hourLa.layer.masksToBounds = YES;
        hourLa.layer.cornerRadius = 4;
        [self.contentView addSubview:hourLa];
        self.hourLa = hourLa;

        UILabel *lab1 = [UILabel publicLab:@":" textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab1.frame = CGRectMake(CGRectGetMaxX(hourLa.frame) + 4, 15, 2, 18);
        [self.contentView addSubview:lab1];
        self.lab1 = lab1;

        UILabel *minLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        minLa.frame = CGRectMake(CGRectGetMaxX(lab1.frame) + 4, 15, 18, 18);
        minLa.backgroundColor = TCUIColorFromRGB(0x2a2a2a);
        minLa.layer.masksToBounds = YES;
        minLa.layer.cornerRadius = 4;
        [self.contentView addSubview:minLa];
        self.minLa = minLa;

        UILabel *lab2 = [UILabel publicLab:@":" textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
        lab2.frame = CGRectMake(CGRectGetMaxX(minLa.frame) + 4, 15, 2, 18);
        [self.contentView addSubview:lab2];
        self.lab2 = lab2;

        UILabel *secLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
        secLa.frame = CGRectMake(CGRectGetMaxX(lab2.frame) + 4, 15, 18, 18);
        secLa.backgroundColor = TCUIColorFromRGB(0x2a2a2a);
        secLa.layer.masksToBounds = YES;
        secLa.layer.cornerRadius = 4;
        [self.contentView addSubview:secLa];
        self.secLa = secLa;

        
        NSDate *datenow = [NSDate date];
        //时间转时间戳的方法:
        NSInteger timesp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];//现在时间

        NSInteger timesp2 = [model2.StartStamp integerValue];
        CountDownLabel *lab = [[CountDownLabel alloc]initWithKeyInfo:@"limit1more"];
        lab.frame = CGRectMake(0, 0, 10, 11);
        lab.hidden = YES;
        [self.contentView addSubview:lab];

        [lab startCountDownWithTotalTime:timesp2 - timesp - 8 * 3600 countDowning:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            
            if(day > 0){
                hour = day * 24 + hour;
            }
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

            CGSize size1 = [NSString sizeWithText:hourStr font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
            hourLa.width = size1.width + 4;
            hourLa.text = hourStr;
            lab1.x = CGRectGetMaxX(hourLa.frame) + 4;
            minLa.x = CGRectGetMaxX(lab1.frame) + 4;
            lab2.x = CGRectGetMaxX(minLa.frame) + 4;
            secLa.x = CGRectGetMaxX(lab2.frame) + 4;

            minLa.text = minuteStr;
            secLa.text = secondStr;

        } countDownFinished:^(NSTimeInterval leftTime) {

        } waitingBlock:^{

        }];
        
        [self.contentView addSubview:self.limitV];
    }
}

-(void)clickBt{
    self.todayLa.textColor = redColor2;
    self.todayLa1.textColor = redColor2;
    self.todayLa.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    self.todayLa1.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    self.tomoLa.textColor = TCUIColorFromRGB(0x2a2a2a);
    self.tomoLa1.textColor = TCUIColorFromRGB(0x2a2a2a);
    self.tomoLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    self.tomoLa1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    self.limitV.type = @"0";
}

-(void)clickBt1{
    self.tomoLa.textColor = redColor2;
    self.tomoLa1.textColor = redColor2;
    self.tomoLa.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    self.tomoLa1.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:11];
    self.todayLa.textColor = TCUIColorFromRGB(0x2a2a2a);
    self.todayLa1.textColor = TCUIColorFromRGB(0x2a2a2a);
    self.todayLa.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    self.todayLa1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    self.limitV.type = @"1";
}

@end
