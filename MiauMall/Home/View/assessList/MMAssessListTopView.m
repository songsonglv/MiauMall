//
//  MMAssessListTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/21.
//

#import "MMAssessListTopView.h"
#import "MMAssessTagsModel.h"

@interface MMAssessListTopView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *goodLabel;//好评
@property (nonatomic, strong) NSMutableArray *newArr;
@property (nonatomic, strong) NSMutableArray *allArr;


@end

@implementation MMAssessListTopView

-(NSMutableArray *)newArr{
    if(!_newArr){
        _newArr = [NSMutableArray array];
    }
    return _newArr;
}

-(NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 12.5;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UILabel *goodLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x373737) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    goodLa.preferredMaxLayoutWidth = 150;
    [goodLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:goodLa];
    self.goodLabel = goodLa;
    
    [goodLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(17);
        make.height.mas_equalTo(11);
    }];
    
    
    
}

-(void)setAssesslevel5rate:(NSString *)assesslevel5rate{
    _assesslevel5rate = assesslevel5rate;
    self.goodLabel.text = [NSString stringWithFormat:@"好评率%@",_assesslevel5rate];
}

-(void)setTags:(NSArray *)tags{
    _tags = tags;
    NSDictionary *dic = @{@"Name":@"全部",@"Count":@"",@"ID":@"0"};
    NSDictionary *dic2 = @{@"Name":@"精选评论",@"Count":@"",@"ID":@"0"};
    MMAssessTagsModel *mode1 = [MMAssessTagsModel mj_objectWithKeyValues:dic];
    MMAssessTagsModel *mode2 = _tags[_tags.count - 1];
    MMAssessTagsModel *mode3 = [MMAssessTagsModel mj_objectWithKeyValues:dic2];
    NSArray *arr = @[mode1,mode2,mode3];
    [self.newArr addObject:arr];
    self.allArr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < _tags.count - 1; i++) {
        MMAssessTagsModel *model = _tags[i];
        [arr1 addObject:model];
        [self.allArr addObject:model];
    }
    [self.newArr addObject:arr1];
    int count = 0;
    float btnWidth = 0;
    float viewHeight = 0;

    NSArray *arr2 = self.newArr[0];
    NSArray *arr3 = self.newArr[1];
    for (int i = 0; i < arr2.count; i++) {
        MMAssessTagsModel *model = arr2[i];
        NSString *str = [NSString stringWithFormat:@"%@%@",model.Name,model.Count];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundColor:TCUIColorFromRGB(0xf5f5f5)];
        [btn setTitleColor:TCUIColorFromRGB(0x7d7d7d) forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0xe13925) forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 11;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.75;
        btn.layer.borderColor = TCUIColorFromRGB(0x7d7d7d).CGColor;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:12] forKey:NSFontAttributeName];
        CGSize btnSize = [str sizeWithAttributes:dict];
        
        btn.width = btnSize.width + 20;
        btn.height = btnSize.height + 10;
        
        btnWidth += CGRectGetMaxX(btn.frame)+12;
        
            
        if (btnWidth > WIDTH) {
        
            count++;
            btn.x = 12;
            btnWidth = CGRectGetMaxX(btn.frame);
        }else{
            btn.x += btnWidth - btn.width;
        }
          
        btn.y += count * (btn.height+12)+12;
            
        viewHeight = CGRectGetMaxY(btn.frame)+12;
        
        [self addSubview:btn];
        
        btn.tag = 10000+i;
        if(i == 0){
            self.selectBtn = btn;
            btn.selected = YES;
            [btn setBackgroundColor:TCUIColorFromRGB(0xfee6e3)];
            btn.layer.borderColor = TCUIColorFromRGB(0xe13925).CGColor;
        }
    }
    
    float btnWidth1 = 0;
    for (int i = 0; i < arr3.count; i++) {
        MMAssessTagsModel *model = arr3[i];
        NSString *str = [NSString stringWithFormat:@"%@%@",model.Name,model.Count];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundColor:TCUIColorFromRGB(0xf5f5f5)];
        [btn setTitleColor:TCUIColorFromRGB(0x7d7d7d) forState:UIControlStateNormal];
        [btn setTitleColor:TCUIColorFromRGB(0xe13925) forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 11;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.75;
        btn.layer.borderColor = TCUIColorFromRGB(0x7d7d7d).CGColor;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:12] forKey:NSFontAttributeName];
        CGSize btnSize = [str sizeWithAttributes:dict];
        
        btn.width = btnSize.width + 20;
        btn.height = btnSize.height + 10;
        
        btnWidth1 += CGRectGetMaxX(btn.frame)+12;
        
            
        if (btnWidth1 > WIDTH) {
        
            count++;
            btn.x = 12;
            btnWidth1 = CGRectGetMaxX(btn.frame);
        }else{
            btn.x += btnWidth1 - btn.width;
        }
          
        btn.y += count * (btn.height+12)+46;
            
        viewHeight = CGRectGetMaxY(btn.frame)+12;
        
        [self addSubview:btn];
        
        btn.tag = 10003+i;
        
    }
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (![self.selectBtn isEqual:btn]) {
        self.selectBtn.selected = NO;
        self.selectBtn.layer.borderColor = TCUIColorFromRGB(0x7d7d7d).CGColor;
        self.selectBtn.backgroundColor = TCUIColorFromRGB(0xffffff);
    }else{
        
    }
    
    btn.layer.borderColor = TCUIColorFromRGB(0xe13925).CGColor;
    btn.selected = YES;
    btn.backgroundColor = TCUIColorFromRGB(0xfee6e3);
    self.selectBtn = btn;
    
    
    
    NSInteger tag = btn.tag - 10000;
    MMAssessTagsModel *model = self.allArr[tag];
    self.btnTapBlock(model.ID,[NSString stringWithFormat:@"%ld",(long)tag]);
}


@end
