//
//  MMLimitTypeCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/26.
//

#import "MMLimitTypeCell.h"
#import "MMHomeLimitView.h"
#import "MMHomePageItemModel.h"

@interface MMLimitTypeCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) CountDownLabel *countDownLabel1;
@property (nonatomic, strong) UILabel *todayLa;
@property (nonatomic, strong) UILabel *tomorrowLa;
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *moreLa;
@property (nonatomic, strong) MMHomeLimitView *limitV;
@end

@implementation MMLimitTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(MMHomeLimitView *)limitV{
    KweakSelf(self);
    if(!_limitV){
        CGFloat space = (WIDTH - 20 - 327)/4;
        NSArray *arr = self.model.cont.prolist[0];
        NSArray *arr1 = self.model.cont.prolist[1];
        _limitV = [[MMHomeLimitView alloc]initWithFrame:CGRectMake(10 + space, 45, WIDTH - 20 - 2 * space, 208) andTodayData:arr andTomorrowData:arr1 andModel:self.model];
        _limitV.type = @"0";
        _limitV.goodsRouterBlock = ^(NSString * _Nonnull str) {
            weakself.TapLimitMoreBlock(weakself.model.defin6);
        };
    }
    return _limitV;
}

-(void)creatUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 264)];
    [self.contentView addSubview:bgImage];
    self.bgImage = bgImage;
    
    UIImageView *textImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 11, 80, 20)];
//    textImage.image = [UIImage imageNamed:@"limit_text"];
    [bgImage addSubview:textImage];
    
    _countDownLabel1 = [[CountDownLabel alloc] initWithKeyInfo:@"label1"];
    _countDownLabel1.backgroundColor = [UIColor clearColor];
    _countDownLabel1.textColor = TCUIColorFromRGB(0xffffff);
    _countDownLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    _countDownLabel1.textAlignment = NSTextAlignmentCenter;
    _countDownLabel1.frame = CGRectMake(103, 15, 100, 11);
    [bgImage addSubview:_countDownLabel1];
    
    NSString *today = [UserDefaultLocationDic valueForKey:@"itoday"];
    NSArray *arr = @[today,@"明天",@"查看"];
    NSArray *arr1 = @[@"09:00",@"09:00",@"更多"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 20 - 150 + 50 * i, 10, 50, 25)];
        view.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:view];
        
        UILabel *lab = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:2];
        lab.frame = CGRectMake(0, 5, 50, 11);
        [view addSubview:lab];
        
        UILabel *lab1 = [UILabel publicLab:arr1[i] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:2];
        lab1.frame = CGRectMake(0, 18, 50, 11);
        [view addSubview:lab1];
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.timeInterval = 2.0;
        [view addSubview:btn];
        
        if(i == 0){
            self.todayLa = lab;
            self.lab1 = lab1;
        }else if (i == 1){
            self.tomorrowLa = lab;
            self.lab2 = lab1;
        }
    }
    
    
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    KweakSelf(self);
    float top = [_model.margin1 floatValue];
//    float bottom = [_model.margin3 floatValue];
    NSArray *arr = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist[0]];
    NSArray *arr1 = [MMHomeLimitGoodsModel mj_objectArrayWithKeyValuesArray:_model.cont.prolist[1]];
    MMHomeLimitGoodsModel *model2 = arr1[0];
    
    NSString *str2 = [model2.PromotionStart substringWithRange:NSMakeRange(5,5)];
    self.tomorrowLa.text = str2;
    self.tomorrowLa.textColor = [UIColor colorWithWzxString:_model.pagenum];
    self.lab2.textColor = [UIColor colorWithWzxString:_model.pagenum];
    self.bgImage.y = top;
//    self.bgImage.frame = CGRectMake(10, top, WIDTH - 20, 264);
//    self.tomorrowLa.textColor = [UIColor colorWithWzxString:_model.otherColor];
//    self.lab2.textColor = [UIColor colorWithWzxString:_model.otherColor];
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:_model.bgImage] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //时间转时间戳的方法:
    NSInteger timesp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];//现在时间
    
    MMHomeLimitGoodsModel *model1 = arr[0];
    NSInteger timesp2 = [model1.EndStamp integerValue];
    [self.countDownLabel1 startCountDownWithTotalTime:timesp2 - timesp - 8 * 3600 countDowning:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSString *dayStr;
        NSString *hourStr;
        NSString *minuteStr;
        NSString *secondStr;
        if(day < 10){
            dayStr = [NSString stringWithFormat:@"0%ld",day];
        }else{
            dayStr = [NSString stringWithFormat:@"%ld",day];
        }
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
        
        if(day){
            weakself.countDownLabel1.text = [NSString stringWithFormat:@"%@天 %@:%@:%@",dayStr,hourStr,minuteStr,secondStr];
        }else if (hour){
            weakself.countDownLabel1.text = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];
        }else if (minute){
            weakself.countDownLabel1.text = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
        }else{
            weakself.countDownLabel1.text = [NSString stringWithFormat:@"%@",secondStr];
        }
        
    } countDownFinished:^(NSTimeInterval leftTime) {
        self.countDownLabel1.text = [NSString stringWithFormat:@""];
    } waitingBlock:^{
        self.countDownLabel1.text = @"等待中...";
    }];
    [self.contentView addSubview:self.limitV];
    
}

-(void)clickBt:(UIButton *)sender{
    if(sender.tag == 100){
        self.limitV.type = @"0";
        self.todayLa.textColor = TCUIColorFromRGB(0xffffff);
        self.lab1.textColor = TCUIColorFromRGB(0xffffff);
        self.tomorrowLa.textColor = [UIColor colorWithWzxString:_model.pagenum];
        self.lab2.textColor = [UIColor colorWithWzxString:_model.pagenum];
    }else if (sender.tag == 101){
        self.limitV.type = @"1";
        self.todayLa.textColor = [UIColor colorWithWzxString:_model.pagenum];
        self.lab1.textColor = [UIColor colorWithWzxString:_model.pagenum];
        self.tomorrowLa.textColor = TCUIColorFromRGB(0xffffff);
        self.lab2.textColor = TCUIColorFromRGB(0xffffff);
    }else{
        self.TapLimitMoreBlock(self.model.defin6);
    }
}
@end
