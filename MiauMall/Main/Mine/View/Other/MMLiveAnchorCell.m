//
//  MMLiveAnchorCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/13.
//

#import "MMLiveAnchorCell.h"

@interface MMLiveAnchorCell ()
@property (nonatomic, strong) UIView *viewersView;//观看人数view
@property (nonatomic, strong) UIImageView *liveImage;//直播图片
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *roomNameLa;//房间名
@property (nonatomic, strong) UIImageView *anchorHead;//头像
@property (nonatomic, strong) UILabel *followNumLa;//关注人数
@property (nonatomic, strong) UILabel *numLa;//观看人数
@property (nonatomic, strong) UILabel *noLiveLa;//未直播
@end

@implementation MMLiveAnchorCell

-(instancetype)initWithFrame:(CGRect)frame{
self = [super initWithFrame:frame];
if (self) {
    [self setupUI];
}
    return self;
}

-(UIView *)viewersView{
    KweakSelf(self);
    if(!_viewersView){
        _viewersView = [[UIView alloc]initWithFrame:CGRectMake(7, 8, 80, 16)];
        _viewersView.backgroundColor = TCUIColorFromRGB(0x303030);
        _viewersView.alpha = 0.5;
        _viewersView.layer.masksToBounds = YES;
        _viewersView.layer.cornerRadius = 8;
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        iconImage.image = [UIImage imageNamed:@"live_icon"];
        [_viewersView addSubview:iconImage];
        
        UILabel *numLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        numLa.preferredMaxLayoutWidth = 150;
        [numLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_viewersView addSubview:numLa];
        self.numLa = numLa;
        
        [numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(weakself.viewersView);
            make.height.mas_equalTo(10);
        }];
        
    }
    return _viewersView;
}


-(void)setupUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6;
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (WIDTH - 15)/2, (WIDTH - 15)/2)];
    bgImage.image = [UIImage imageNamed:@"zhanweif"];
    bgImage.backgroundColor = TCUIColorFromRGB(0x000000);
    bgImage.alpha = 0.3;
    [self.contentView addSubview:bgImage];
    self.liveImage = bgImage;
    
    UILabel *lab = [UILabel publicLab:@"未直播" textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    lab.frame = CGRectMake(0, (bgImage.width - 16)/2, bgImage.width, 16);
    [bgImage addSubview:lab];
    self.noLiveLa = lab;
    
    [self.contentView addSubview:self.viewersView];
    
    UILabel *roomNameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x2e2e2e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:12 numberOfLines:0];
    roomNameLa.frame = CGRectMake(7, CGRectGetMaxY(bgImage.frame) + 12, bgImage.width - 14, 12);
    [self.contentView addSubview:roomNameLa];
    self.roomNameLa = roomNameLa;
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, CGRectGetMaxY(roomNameLa.frame) + 12, 20, 20)];
    headImage.image = [UIImage imageNamed:@"partner_head_nomal"];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 10;
    [self.contentView addSubview:headImage];
    self.anchorHead = headImage;
    
    UILabel *nameLa= [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x888888) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = 120;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:nameLa];
    self.nameLa = nameLa;
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(32);
            make.bottom.mas_equalTo(-18);
            make.height.mas_equalTo(12);
    }];
    
    UILabel *followLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x888888) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    followLa.preferredMaxLayoutWidth = 150;
    [followLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:followLa];
    self.followNumLa = followLa;
    
    [followLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(-18);
            make.height.mas_equalTo(12);
    }];
    
}

-(void)setModel:(MMLiveAnchorModel *)model{
    _model = model;
    [self.liveImage sd_setImageWithURL:[NSURL URLWithString:_model.LivePicture] placeholderImage:[UIImage imageNamed:@"pingfangz"]];
    CGSize size1 = [NSString sizeWithText:[NSString stringWithFormat:@"%@观看",_model.OnlineCount] font:[UIFont fontWithName:@"PingFangSC-Regular" size:11] maxSize:CGSizeMake(MAXFLOAT, 11)];
    self.viewersView.width = size1.width + 27;
    self.numLa.text = [NSString stringWithFormat:@"%@观看",_model.OnlineCount];
    if([_model.IsIiving isEqualToString:@"0"]){
        self.noLiveLa.hidden = NO;
        self.viewersView.hidden = YES;
        self.liveImage.alpha = 0.3;
    }else{
        self.noLiveLa.hidden = YES;
        self.viewersView.hidden = NO;
        self.liveImage.alpha = 1;
    }
    
    self.roomNameLa.text = _model.Profile;
    [self.anchorHead sd_setImageWithURL:[NSURL URLWithString:_model.Picture] placeholderImage:[UIImage imageNamed:@"partner_head_nomal"]];
    self.nameLa.text = _model.Name;
    self.followNumLa.text = [NSString stringWithFormat:@"%@关注",_model.FocusCount];
}
@end
