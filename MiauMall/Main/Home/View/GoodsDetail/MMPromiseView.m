//
//  MMPromise.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/19.
//。郑重承诺

#import "MMPromiseView.h"

@interface MMPromiseView ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *questionBt;
@end

@implementation MMPromiseView

-(UIImageView *)bgImage{
    if(!_bgImage){
        _bgImage = [[UIImageView alloc]init];
       
    }
    return _bgImage;
}

-(UIButton *)questionBt{
    if(!_questionBt){
        _questionBt = [[UIButton alloc]init];
        [_questionBt setTitle:[UserDefaultLocationDic valueForKey:@"isupport"] forState:(UIControlStateNormal)];
        [_questionBt setTitleColor:TCUIColorFromRGB(0x090b09) forState:(UIControlStateNormal)];
        _questionBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _questionBt.layer.masksToBounds = YES;
        _questionBt.layer.cornerRadius = 15;
        _questionBt.layer.borderColor = TCUIColorFromRGB(0x090b09).CGColor;
        _questionBt.layer.borderWidth = 0.5;
    }
    return _questionBt;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.bgImage.frame = CGRectMake(0, 0, WIDTH, self.height);
    [self addSubview:self.bgImage];
    
    [self.questionBt addTarget:self action:@selector(clickQuestion) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.questionBt];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"isupport"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(MAXFLOAT,12)];
    
    [self.questionBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((self.width - size.width - 20)/2);
            make.bottom.mas_equalTo(-12);
            make.width.mas_equalTo(size.width + 20);
            make.height.mas_equalTo(30);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmptyView:)];
    [self addGestureRecognizer:tap];
}

-(void)setMainModel:(MMGoodsDetailMainModel *)mainModel{
    _mainModel = mainModel;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:_mainModel.tkyn] placeholderImage:[UIImage imageNamed:@"zhanweic"]];
//    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:_mainModel.tkyn]];
}

-(void)tapEmptyView:(UITapGestureRecognizer *)tap{
    self.promissTapBlock(@"进入承诺");
}

-(void)clickQuestion{
    self.questionTapBlock(@"/member/notice/question");
}

@end
