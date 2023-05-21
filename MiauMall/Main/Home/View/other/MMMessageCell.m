//
//  MMMessageCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/7.
//

#import "MMMessageCell.h"

@interface MMMessageCell ()
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UILabel *contLa;
@property (nonatomic, strong) UILabel *timeLa;
@end

@implementation MMMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xdfdfdf);
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, WIDTH - 20, 110)];
    bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    [self.contentView addSubview:bgView];
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(8, 20, 6, 6)];
    redView.backgroundColor = TCUIColorFromRGB(0xd74f3f);
    redView.layer.masksToBounds = YES;
    redView.layer.cornerRadius = 3;
    [bgView addSubview:redView];
    self.redView = redView;
    
    UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    titleLa.preferredMaxLayoutWidth = WIDTH - 170;
    [titleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgView addSubview:titleLa];
    self.titleLa = titleLa;
    
    [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(19);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(16);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon_gary"]];
    [bgView addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(18);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *detailLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"viewDetails"] textColor:TCUIColorFromRGB(0xa0a0a0) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    detailLa.preferredMaxLayoutWidth = 120;
    [detailLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [bgView addSubview:detailLa];
    
    [detailLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(17);
            make.height.mas_equalTo(14);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(7, 42, WIDTH - 34, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [bgView addSubview:line];
    
    UILabel *contLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa0a0a0) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    contLa.frame = CGRectMake(18, 60, WIDTH - 56, 14);
    [bgView addSubview:contLa];
    self.contLa = contLa;
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xa0a0a0) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    timeLa.frame = CGRectMake(18, 84, WIDTH - 56, 10);
    [bgView addSubview:timeLa];
    self.timeLa = timeLa;
    
}

-(void)setModel:(MMMessageModel *)model{
    _model = model;
    if([_model.HadRead isEqualToString:@"1"]){
        self.redView.hidden = YES;
    }
    self.titleLa.text = _model.Name;
    self.contLa.text = _model.Summary;
    self.timeLa.text = [self timeWithYearMonthDayCountDown:_model.TimeStamp];
    
    
}

-(NSString*)timeWithYearMonthDayCountDown:(NSString*)timestamp{
    // 时间戳转日期
    // 传入的时间戳timeStr如果是精确到毫秒的记得要/1000
    NSTimeInterval timeInterval=[timestamp doubleValue];
    NSDate*detailDate=[NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];// 实例化一个NSDateFormatter对象，设定时间格式，这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*dateStr=[dateFormatter stringFromDate:detailDate];
    return dateStr;
    
}


@end
