//
//  MMMemberShowView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import "MMMemberShowView.h"
#import "MMRegMemberModel.h"

@implementation MMMemberShowView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.clearColor;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
}

-(void)setMembers:(NSArray *)members{
    _members = members;
    //[self removeFromSuperview];
    for (UIView* b in self.subviews)
       {
          [b removeFromSuperview];
       }
    float spac = (WIDTH - 60 - 240)/4;
    for (int i = 0; i < members.count; i++) {
        NSInteger j = i/5;
        NSInteger z = i%5;
        MMRegMemberModel *model = _members[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(spac + (spac + 48) * z, 10 + (100 * j), 48, 100)];
        view.backgroundColor = UIColor.clearColor;
        [self addSubview:view];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 48, 48)];
        [img sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 24;
        [view addSubview:img];
        
        UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0xf43029) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:11 numberOfLines:0];
        lab.frame = CGRectMake(0, 70, 48, 11);
        [view addSubview:lab];
    }
}

@end
