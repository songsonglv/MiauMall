//
//  MMTwoImgChangeCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//  两图切换

#import "MMTwoImgChangeCell.h"

@interface MMTwoImgChangeCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) MMHomeImageModel *model1;
@end

@implementation MMTwoImgChangeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    UIImageView *bgImage = [[UIImageView alloc]init];
    [self.contentView addSubview:bgImage];
    self.bgImage = bgImage;
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(clickBt) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
    }];
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    NSArray *imgArr = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *memberToken = [userDefaults valueForKey:@"membertoken"];
    NSURL *url;
    if(memberToken){
        MMHomeImageModel *model1 = imgArr[1];
        self.model1 = imgArr[0];
        url = [NSURL URLWithString:model1.url];
       
    }else{
        MMHomeImageModel *model1 = imgArr[0];
        self.model1 = imgArr[1];
        url = [NSURL URLWithString:model1.url];
    }
    [self.bgImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zhanweic"]];
}

-(void)clickBt{
    self.TapTwoImgChangeBlock(self.model1.link2);
}

@end
