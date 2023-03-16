//
//  MMAssessView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/18.
//  评价view

#import "MMAssessView.h"
#import "MMAssessTagsModel.h"

#import "MMGoodsDetailAssessModel.h"

@interface MMAssessView ()
@property (nonatomic ,strong) UILabel *assessCountLa;//评价数量
@property (nonatomic, strong) UILabel *receiveLa;//好评
@property (nonatomic, strong) UILabel *noneLa;//无评价时展示
@property (nonatomic, strong) UIImageView *rightIcon;//点击小图标
@property (nonatomic, strong) MMStarRating *startingView;//星级评价
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) NSMutableArray *assessArr;
@property (nonatomic, strong) UIButton *selectBt;


@end

@implementation MMAssessView

-(NSMutableArray *)assessArr{
    if(!_assessArr){
        _assessArr = [NSMutableArray array];
    }
    return _assessArr;
}

#pragma mark -- 懒加载创建UI
-(UILabel *)assessCountLa{
    if(!_assessCountLa){
        _assessCountLa = [UILabel publicLab:@"宝贝评价(0)" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
        [_assessCountLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        
    }
    return _assessCountLa;
}

-(UIImageView *)rightIcon{
    if(!_rightIcon){
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.image = [UIImage imageNamed:@"right_icon_black"];
    }
    return _rightIcon;
}

-(UILabel *)receiveLa{
    if(!_receiveLa){
        _receiveLa = [UILabel publicLab:@"好评0%" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
        [_receiveLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    }
    return _receiveLa;
}
-(UILabel *)noneLa{
    if(!_noneLa){
        _noneLa = [UILabel publicLab:@"请留下你的足迹" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    }
    return _noneLa;
}

-(UIView *)tagView{
    if(!_tagView){
        _tagView = [[UIView alloc]init];
    }
    return _tagView;
}

-(UIButton *)selectBt{
    if(!_selectBt){
        _selectBt = [[UIButton alloc]init];
        
        [_selectBt addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectBt;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}


-(void)setUI{
    KweakSelf(self);
    [self addSubview:self.assessCountLa];
    
    [self.assessCountLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.rightIcon];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(18);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(8);
    }];
    
    [self addSubview:self.receiveLa];
    
    [self.receiveLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakself.rightIcon.mas_left).offset(-6);
            make.top.mas_equalTo(17);
            make.height.mas_equalTo(11);
    }];
    
    [self addSubview:self.noneLa];
    
    [self.noneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(weakself.assessCountLa.mas_bottom).offset(16);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(11);
    }];
    
    [self addSubview:self.tagView];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(weakself.assessCountLa.mas_bottom).offset(12);
            make.width.mas_equalTo(WIDTH);
            make.height.mas_equalTo(30);
    }];
    
    
//    self.assessListView.frame = CGRectMake(0, 86, WIDTH, 10);
//    [self addSubview:self.assessListView];
    
}

-(void)setTags:(NSArray *)tags{
    _tags = tags;
    CGFloat wid = 0;
    if(self.proInfoModel.assesslist.count > 0){
//        self.tagView.hidden = NO;
//        self.noneLa.hidden = YES;
        if(_tags.count > 3){
            for (int i =0; i < 3; i++) {
                MMAssessTagsModel *model = _tags[i];
                NSDictionary *attrs1 = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size:12]};
                CGSize size1 = [model.Name sizeWithAttributes:attrs1];
                UILabel *lab = [UILabel publicLab:model.Name textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
                lab.backgroundColor = TCUIColorFromRGB(0xfee6e3);
                lab.frame = CGRectMake(12 + 6 * i + wid, 4, size1.width + 28, 22);
                lab.layer.masksToBounds = YES;
                lab.layer.cornerRadius = 11.25;
                [self.tagView addSubview:lab];
                wid = size1.width + 28 + wid;
            }
        }else{
            for (int i =0; i < _tags.count; i++) {
                MMAssessTagsModel *model = _tags[i];
                NSDictionary *attrs1 = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size:12]};
                CGSize size1 = [model.Name sizeWithAttributes:attrs1];
                UILabel *lab = [UILabel publicLab:model.Name textColor:redColor1 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
                lab.layer.masksToBounds = YES;
                lab.layer.cornerRadius = 11.25;
                lab.backgroundColor = TCUIColorFromRGB(0xfee6e3);
                lab.frame = CGRectMake(12 + 6 * i + wid, 4, size1.width + 28, 22);
                [self.tagView addSubview:lab];
                wid = wid + size1.width + 28;
            }
        }
    }else{
//        self.tagView.hidden = YES;
//        self.noneLa.hidden = NO;
    }
}

-(void)setProInfoModel:(MMGoodsProInfoModel *)proInfoModel{
    KweakSelf(self);
    _proInfoModel = proInfoModel;
    self.assessCountLa.text = [NSString stringWithFormat:@"宝贝评价(%@)",_proInfoModel.assesscount];
    self.receiveLa.text = [NSString stringWithFormat:@"好评%@",_proInfoModel.assesslevel5rate];
    if(_proInfoModel.assesslist.count == 0){
        self.noneLa.hidden = NO;
        self.tagView.hidden = YES;
//        self.assessListView.hidden = YES;
    }else{
        self.noneLa.hidden = YES;
        self.tagView.hidden = NO;
//        self.assessListView.hidden = NO;
        NSArray *assArr = [MMGoodsDetailAssessModel mj_objectArrayWithKeyValuesArray:_proInfoModel.assesslist];
        self.assessArr = [NSMutableArray arrayWithArray:assArr];
        if(assArr.count == 1){
            MMGoodsDetailAssessModel *model = self.assessArr[0];
            
            UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
            CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
//            self.assessListView.height = size.height + 138;
            
            UIImageView *headImage = [[UIImageView alloc]init];
            [headImage sd_setImageWithURL:[NSURL URLWithString:model.HeadImg]];
            headImage.layer.masksToBounds = YES;
            headImage.layer.cornerRadius = 15;
            [self addSubview:headImage];
            
            [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(12);
                            make.top.mas_equalTo(86);
                            make.width.height.mas_equalTo(30);
            }];
            
            UILabel *nickLa = [UILabel publicLab:model.NickName textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
            [nickLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
            [self addSubview:nickLa];
            
            [nickLa mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(headImage.mas_right).offset(5);
                            make.top.mas_equalTo(89);
                            make.height.mas_equalTo(11);
            }];
            
            MMStarRating *ratingView = [[MMStarRating alloc] initWithFrame:CGRectMake(47, 103, 70, 10) Count:5];  //初始化并设置frame和个数
            ratingView.spacing = 5.0f; //间距
            ratingView.checkedImage = [UIImage imageNamed:@"icon_star_hight"]; //选中图片
            ratingView.uncheckedImage = [UIImage imageNamed:@"icon_star_normal"]; //未选中图片
            ratingView.type = RatingTypeWhole; //评分类型
            ratingView.currentScore = [model.Level floatValue];
            [self addSubview:ratingView];
            
            
            //评价内容
            UILabel *lab = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
            lab.preferredMaxLayoutWidth = WIDTH - 44;
            [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
            [self addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(12);
                            make.top.mas_equalTo(headImage.mas_bottom).offset(10);
                            make.width.mas_equalTo(WIDTH - 44);
            }];
        }else{
            CGFloat hei = 86;
            for (int i = 0;  i < 2; i++) {
                MMGoodsDetailAssessModel *model = self.assessArr[i];
                UILabel *la = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
                la.frame = CGRectMake(0, 0, WIDTH - 44, 36);
                CGSize size = [la sizeThatFits:CGSizeMake(la.frame.size.width,MAXFLOAT)];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, size.height + 52)];
                [self addSubview:view];
                
                hei = hei + size.height + 52;
                
                UIImageView *headImage = [[UIImageView alloc]init];
                [headImage sd_setImageWithURL:[NSURL URLWithString:model.HeadImg]];
                headImage.layer.masksToBounds = YES;
                headImage.layer.cornerRadius = 15;
                [view addSubview:headImage];
                
                [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(12);
                                make.top.mas_equalTo(0);
                                make.width.height.mas_equalTo(30);
                }];
                
                UILabel *nickLa = [UILabel publicLab:model.NickName textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
                [nickLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
                [view addSubview:nickLa];
                
                [nickLa mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(headImage.mas_right).offset(5);
                                make.top.mas_equalTo(3);
                                make.height.mas_equalTo(11);
                }];
                
                MMStarRating *ratingView = [[MMStarRating alloc] initWithFrame:CGRectMake(47, 19, 70, 10) Count:5]; //初始化并设置frame和个数
                ratingView.spacing = 5.0f; //间距
                ratingView.checkedImage = [UIImage imageNamed:@"icon_star_hight"]; //选中图片
                ratingView.uncheckedImage = [UIImage imageNamed:@"icon_star_normal"]; //未选中图片
                ratingView.type = RatingTypeWhole; //评分类型
                ratingView.currentScore = [model.Level floatValue];
                [view addSubview:ratingView];
                
                
                //评价内容
                UILabel *lab = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
                lab.preferredMaxLayoutWidth = WIDTH - 44;
                [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
                [view addSubview:lab];
                
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(12);
                                make.top.mas_equalTo(headImage.mas_bottom).offset(10);
                                make.width.mas_equalTo(WIDTH - 44);
                }];
                
                if(i == 0){
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, size.height + 48, WIDTH - 36, 1)];
                    line.backgroundColor = TCUIColorFromRGB(0xeef0f1);
                    [view addSubview:line];
                }
                
            }
        }
    }
    self.selectBt.frame = CGRectMake(0, 0, self.width, self.height);
    self.selectBt.timeInterval = 2.0;
    [self addSubview:self.selectBt];
}

-(void)clickBt{
    self.assessTapBlock(@"1");
}

@end
