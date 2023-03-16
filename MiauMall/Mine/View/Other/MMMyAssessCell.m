//
//  MMMyAssessCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//

#import "MMMyAssessCell.h"
@interface MMMyAssessCell ()
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *contLa;
@property (nonatomic, strong) UILabel *anonymousLa;//匿名
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation MMMyAssessCell

-(NSMutableArray *)models{
    if(!_models){
        _models = [NSMutableArray array];
    }
    return _models;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, 0, WIDTH - 28, 0.5)];
    line.backgroundColor = TCUIColorFromRGB(0xe6e6e6);
    [self.contentView addSubview:line];
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x848484) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = 300;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:timeLa];
    self.timeLa = timeLa;
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *nimingLa = [UILabel publicLab:@"匿名" textColor:TCUIColorFromRGB(0x848484) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    nimingLa.preferredMaxLayoutWidth = 100;
    [nimingLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:nimingLa];
    self.anonymousLa = nimingLa;
    
    [nimingLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *contLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x383838) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    contLa.preferredMaxLayoutWidth = WIDTH - 28;
    [contLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contentView addSubview:contLa];
    self.contLa = contLa;
    
    [contLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(46);
            make.width.mas_equalTo(WIDTH - 28);
    }];
}

-(void)setModel:(MMMyAssessModel *)model{
    KweakSelf(self);
    _model = model;
    NSString *timeStr = [_model.AddTime substringToIndex:10];
    self.timeLa.text = timeStr;
    self.contLa.text = _model.Conts;
    
    CGFloat sace = (WIDTH - 354)/2;//两边间距
    if(_model.Albums.count > 3){
        for (int i = 0; i < _model.Albums.count; i++) {
            NSInteger x = i%3;
            NSInteger y = i/3;
            
            UIImageView *image = [[UIImageView alloc]init];
            image.userInteractionEnabled = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:_model.Albums[i]] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius = 6;
            [self.contentView addSubview:image];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(sace + 122 * x);
                            make.top.mas_equalTo(weakself.contLa.mas_bottom).offset(18 + 118 * y);
                            make.width.height.mas_equalTo(110);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.tag = 100 + i;
            [image addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.left.width.height.mas_equalTo(image);
            }];
            
            JJDataModel *model = [JJDataModel alloc];
            model.containerView = image;
            model.img = _model.Albums[i];
            [self.models addObject:model];
        }
    }else if (_model.Albums.count > 0){
        for (int i = 0; i < _model.Albums.count; i++) {
            UIImageView *image = [[UIImageView alloc]init];
            image.userInteractionEnabled = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:_model.Albums[i]] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius = 6;
            [self.contentView addSubview:image];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(sace + 122 * i);
                            make.top.mas_equalTo(weakself.contLa.mas_bottom).offset(18);
                            make.width.height.mas_equalTo(110);
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.tag = 100 + i;
            [image addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.left.width.height.mas_equalTo(image);
            }];
            
            JJDataModel *model = [JJDataModel alloc];
            model.containerView = image;
            model.img = _model.Albums[i];
            [self.models addObject:model];
        }
    }
}

-(void)clickBt:(UIButton *)sender{
    self.tapPicArrBlock(self.models, sender.tag - 100);
}

@end
