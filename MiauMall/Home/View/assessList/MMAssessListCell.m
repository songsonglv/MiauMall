//
//  MMAssessListCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/22.
//

#import "MMAssessListCell.h"
@interface MMAssessListCell ()
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nickLa;
@property (nonatomic, strong) MMStarRating *startingView;//星级评价
@property (nonatomic, strong) UILabel *timeLa;
@property (nonatomic, strong) UILabel *contLa;
@property (nonatomic, strong) UILabel *replaceContLa;
@property (nonatomic, strong) UIView *contView;//内容view
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation MMAssessListCell

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
    self.contentView.backgroundColor = TCUIColorFromRGB(0xdddddd);
    self.contView = [[UIView alloc]init];
                     //WithFrame:CGRectMake(10, 10, WIDTH - 20, self.contentView.height - 10)];
    self.contView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.contView.layer.masksToBounds = YES;
    self.contView.layer.cornerRadius = 12.5;
    [self.contentView addSubview:self.contView];
    
    [self.contView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.width.mas_equalTo(WIDTH - 20);
            make.bottom.mas_equalTo(0);
    }];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 15;
    [self.contView addSubview:headImage];
    self.headImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.width.height.mas_equalTo(30);
    }];
    
    UILabel *nickLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
    nickLa.preferredMaxLayoutWidth = 200;
    [nickLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contView addSubview:nickLa];
    self.nickLa = nickLa;
    
    [nickLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headImage.mas_right).offset(5);
            make.top.mas_equalTo(14.5);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *timeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x6f6f6f) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    timeLa.preferredMaxLayoutWidth = 180;
    [timeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contView addSubview:timeLa];
    self.timeLa = timeLa;
    
    [timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(10);
    }];
    
    MMStarRating *ratingView = [[MMStarRating alloc] initWithFrame:CGRectMake(47, 30, 70, 10) Count:5];  //初始化并设置frame和个数
    ratingView.spacing = 5.0f; //间距
    ratingView.checkedImage = [UIImage imageNamed:@"icon_star_hight"]; //选中图片
    ratingView.uncheckedImage = [UIImage imageNamed:@"icon_star_normal"]; //未选中图片
    ratingView.type = RatingTypeWhole; //评分类型
    [self.contView addSubview:ratingView];
    self.startingView = ratingView;
    
    UILabel *assessLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    assessLa.preferredMaxLayoutWidth = WIDTH - 44;
    [assessLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self.contView addSubview:assessLa];
    self.contLa = assessLa;
    
    [assessLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(headImage.mas_bottom).offset(12);
            make.width.mas_equalTo(WIDTH - 44);
    }];
}

-(void)setModel:(MMGoodsDetailAssessModel *)model{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.HeadImg]];
    self.nickLa.text = _model.NickName;
    self.startingView.currentScore = [_model.Level floatValue];
    self.timeLa.text = [_model.AddTime substringToIndex:10];
    self.contLa.text = _model.Conts;
    
    UILabel *la0 = [UILabel publicLab:_model.Conts textColor:TCUIColorFromRGB(0x424242) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    la0.frame = CGRectMake(0, 0, WIDTH - 56, 36);
    CGSize size0 = [la0 sizeThatFits:CGSizeMake(la0.frame.size.width,MAXFLOAT)];
    
    NSArray *imgArr = _model.Albums;//图片数组
    CGFloat hei = 0;
    if(imgArr.count > 0){
        CGFloat wid = (WIDTH - 68)/3;
        
        if(imgArr.count >= 6){
            hei = 246;
            for (int i = 0; i < 6; i++) {
                NSInteger h = i/3;
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12 + (wid + 12) * (i%3), 68 + size0.height + 116 * h, wid, wid)];
                image.layer.masksToBounds = YES;
                image.layer.cornerRadius = 7.5;
                [image sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
                image.userInteractionEnabled = YES;
                [self.contView addSubview:image];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (wid + 12) * (i%3), 68 + size0.height + 116 * h, wid, wid)];
                [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                btn.tag = 100 + i;
                [self.contView addSubview:btn];
                
                JJDataModel *model = [JJDataModel alloc];
                model.containerView = image;
                model.img = imgArr[i];
                [self.models addObject:model];
            }
        }else if (imgArr.count >3){
            hei = 246;
            for (int i = 0; i < imgArr.count; i++) {
                NSInteger h = i/3;
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12 + (wid + 12) * (i%3), 68 + size0.height + 116 * h, wid, wid)];
                image.userInteractionEnabled = YES;
                image.layer.masksToBounds = YES;
                image.layer.cornerRadius = 7.5;
                [image sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
                [self.contView addSubview:image];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (wid + 12) * (i%3), 68 + size0.height + 116 * h, wid, wid)];
                [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                btn.tag = 100 + i;
                [self.contView addSubview:btn];
                
                JJDataModel *model = [JJDataModel alloc];
                model.containerView = image;
                model.img = imgArr[i];
                [self.models addObject:model];
            }
        }else if(imgArr > 0){
            hei = 130;
            for (int i = 0; i < imgArr.count; i++) {
                NSInteger h = i/3;
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12 + (wid + 12) * (i%3), 68 + size0.height + 116 * h, wid, wid)];
                image.userInteractionEnabled = YES;
                image.layer.masksToBounds = YES;
                image.layer.cornerRadius = 7.5;
                [image sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
                [self.contView addSubview:image];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (wid + 12) * (i%3), 68 + size0.height + 116 * h, wid, wid)];
                [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
                btn.tag = 100 + i;
                [self.contView addSubview:btn];
                
                JJDataModel *model = [JJDataModel alloc];
                model.containerView = image;
                model.img = imgArr[i];
                [self.models addObject:model];
            }
        }else{
            hei = 0;
        }
        
        if([_model.ReplyConts isEmpty]){
            
        }else{
            UILabel *la = [UILabel publicLab:_model.ReplyConts textColor:TCUIColorFromRGB(0x424242) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            la.frame = CGRectMake(0, 0, WIDTH - 56, 36);
            CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
            UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(12, 68 + size0.height + hei, WIDTH - 44, size.height + 24)];
            replyView.backgroundColor = TCUIColorFromRGB(0xf7f6f5);
            replyView.layer.masksToBounds = YES;
            replyView.layer.cornerRadius = 6;
            [self.contView addSubview:replyView];
            la.preferredMaxLayoutWidth = WIDTH - 56;
            [la setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
            [replyView addSubview:la];
            
            [la mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(6);
                            make.top.mas_equalTo(12);
                            make.width.mas_equalTo(WIDTH - 56);
            }];
        }
    }else{
        if([_model.ReplyConts isEmpty]){
            
        }else{
            UILabel *la = [UILabel publicLab:_model.ReplyConts textColor:TCUIColorFromRGB(0x424242) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            la.frame = CGRectMake(0, 0, WIDTH - 56, 36);
            CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
            UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(12, 68 + size0.height, WIDTH - 44, size.height + 24)];
            replyView.backgroundColor = TCUIColorFromRGB(0xf7f6f5);
            replyView.layer.masksToBounds = YES;
            replyView.layer.cornerRadius = 6;
            [self.contView addSubview:replyView];
            la.preferredMaxLayoutWidth = WIDTH - 56;
            [la setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
            [replyView addSubview:la];
            
            [la mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(6);
                            make.top.mas_equalTo(12);
                            make.width.mas_equalTo(WIDTH - 56);
            }];
        }
    }
    
    
}

-(void)clickBt:(UIButton *)sender{
    self.tapPicBlock(self.models, sender.tag - 100);
}
@end
