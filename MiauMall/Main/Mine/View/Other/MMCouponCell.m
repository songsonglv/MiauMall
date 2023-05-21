//
//  MMCouponCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import "MMCouponCell.h"
@interface MMCouponCell ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *contsLa;
@property (nonatomic, strong) UIButton *useBt;
@end

@implementation MMCouponCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIView *contView = [[UIView alloc]initWithFrame:CGRectMake(10, 18, WIDTH - 20, 100)];
    contView.backgroundColor = TCUIColorFromRGB(0xf3f4f8);
    contView.layer.masksToBounds = YES;
    contView.layer.cornerRadius = 8;
    [self.contentView addSubview:contView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 118, 100)];
    imageV.image = [UIImage imageNamed:@"zhanweif"];
    [contView addSubview:imageV];
    self.imageV = imageV;
    
    UILabel *titleLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(126, 13, WIDTH - 158, 16);
    [contView addSubview:titleLa];
    self.titleLa = titleLa;
    
    UILabel *contLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    contLa.preferredMaxLayoutWidth = WIDTH - 234;
    [contLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [contView addSubview:contLa];
    self.contsLa = contLa;
    
    [contLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(126);
            make.top.mas_equalTo(38);
            make.width.mas_equalTo(WIDTH - 234);
    }];
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    timeLa.frame = CGRectMake(126, 82, WIDTH - 158, 10);
    [contView addSubview:timeLa];
    self.timeLa = timeLa;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:TCUIColorFromRGB(0xffffff)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"useNow"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xff5d4c) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 12.5;
    btn.layer.borderColor = TCUIColorFromRGB(0xff5d4c).CGColor;
    btn.layer.borderWidth = 0.5;
    btn.userInteractionEnabled = NO;
    [contView addSubview:btn];
    self.useBt = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-6);
            make.centerY.mas_equalTo(contView);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(25);
    }];
}

-(void)setModel:(MMCouponInfoModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
    self.titleLa.text = _model.Name;
    self.contsLa.text = _model.Summary;
    if([_model.TimeType isEqualToString:@"0"]){
        self.timeLa.text = @"无使用期限";
    }else if ([_model.TimeType isEqualToString:@"1"]){
        NSString *start = [_model.StartTime substringToIndex:10];
        NSString *end = [_model.EndTime substringToIndex:10];
        self.timeLa.text = [NSString stringWithFormat:@"%@-%@",start,end];
    }else{
        NSString *end = [_model.EndTime substringToIndex:10];
        self.timeLa.text = [NSString stringWithFormat:@"有效期至%@",end];
    }
    
    if([_model.Status isEqualToString:@"0"]){
        self.useBt.userInteractionEnabled = YES;
        [self.useBt addTarget:self action:@selector(clickGoHome) forControlEvents:(UIControlEventTouchUpInside)];
    }else if ([_model.Status isEqualToString:@"1"]){
        [self.useBt setTitle:[UserDefaultLocationDic valueForKey:@"iused"] forState:(UIControlStateNormal)];
        [self.useBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        self.useBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
        self.useBt.layer.borderWidth = 0.5;
    }else if ([_model.Status isEqualToString:@"2"] || [_model.Status isEqualToString:@"3"]){
        [self.useBt setTitle:[UserDefaultLocationDic valueForKey:@"iInvalid"] forState:(UIControlStateNormal)];
        [self.useBt setTitleColor:TCUIColorFromRGB(0x383838) forState:(UIControlStateNormal)];
        self.useBt.layer.borderColor = TCUIColorFromRGB(0x383838).CGColor;
        self.useBt.layer.borderWidth = 0.5;
    }else{
        self.useBt.userInteractionEnabled = YES;
        [self.useBt addTarget:self action:@selector(clickGoHome) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

-(void)clickGoHome{
    self.goHomeBlock(@"1");
}

@end
