//
//  MMPackageView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/17.
//

#import "MMPackageView.h"
#import "MMPackageGoodsModel.h"
@interface MMPackageView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *addressLa;//地址 //没有显示选择地址
@property (nonatomic, strong) UILabel *phoneLa;
@property (nonatomic, strong) UILabel *feeLa;//配送展示内容
@property (nonatomic, strong) UITextField *remarksField;
@property (nonatomic, strong) UILabel *titleLa;
@property (nonatomic, strong) UILabel *weightLa;//重量

@property (nonatomic, strong) UIView *goodsView;

@end

@implementation MMPackageView

-(UIView *)goodsView{
    if(!_goodsView){
        _goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, 132, WIDTH - 10, 80)];
        _goodsView.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    return _goodsView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *lab = [UILabel publicLab:@"我的包裹" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    lab.frame = CGRectMake(12, 15, WIDTH - 34, 15);
    [self addSubview:lab];
    self.titleLa = lab;
    
    UIImageView *locationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 52, 14, 18)];
    locationIcon.image = [UIImage imageNamed:@"location_icon_red"];
    [self addSubview:locationIcon];
    
    UILabel *addressLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"selAddress"] textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    addressLa.preferredMaxLayoutWidth = WIDTH - 110;
    [addressLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:addressLa];
    self.addressLa = addressLa;
    
    [addressLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(36);
            make.top.mas_equalTo(47);
            make.right.mas_equalTo(-64);
    }];
    
    UILabel *phoneLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    [self addSubview:phoneLa];
    self.phoneLa = phoneLa;
    
    [phoneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(36);
            make.top.mas_equalTo(addressLa.mas_bottom).offset(8);
            make.right.mas_equalTo(-64);
    }];
    
    UIImageView *rightIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 22, 56, 4, 8)];
    rightIcon.image = [UIImage imageNamed:@"right_icon_gary"];
    [self addSubview:rightIcon];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 48, WIDTH - 10, 30)];
    btn.backgroundColor = UIColor.clearColor;
    [btn addTarget:self action:@selector(selectAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    
    UIImageView *lineIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 110, WIDTH - 20, 3)];
    lineIcon.image = [UIImage imageNamed:@"line_icon"];
    [self addSubview:lineIcon];
    
    [self addSubview:self.goodsView];
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"ishipping"] textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = 180;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(236);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *weightLa = [UILabel publicLab:@"1.45kg" textColor:TCUIColorFromRGB(0xa5844d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:11 numberOfLines:0];
    weightLa.preferredMaxLayoutWidth = 180;
    [weightLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:weightLa];
    self.weightLa = weightLa;
    
    [weightLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab1.mas_right).offset(10);
            make.top.mas_equalTo(238);
            make.height.mas_equalTo(11);
    }];
    
    UILabel *feeLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    feeLa.preferredMaxLayoutWidth = 180;
    [feeLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:feeLa];
    self.feeLa = feeLa;
    
    [feeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(237);
            make.height.mas_equalTo(14);
    }];
    
    UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"iremark"] textColor:TCUIColorFromRGB(0x1e1e1e) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = 180;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(lab1.mas_bottom).offset(16);
            make.height.mas_equalTo(14);
    }];
    
    UITextField *field1 = [[UITextField alloc]init];
    field1.delegate = self;
    field1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    field1.textColor = TCUIColorFromRGB(0x333333);
    field1.clearButtonMode = UITextFieldViewModeWhileEditing;
    field1.textAlignment = NSTextAlignmentLeft;
    [field1 addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [self addSubview:field1];
    self.remarksField = field1;
    
    [field1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab2.mas_right).offset(12);
            make.top.mas_equalTo(lab1.mas_bottom).offset(15);
            make.width.mas_equalTo(WIDTH - 100);
            make.height.mas_equalTo(15);
    }];
}

-(void)setTipsArr:(NSArray *)tipsArr{
    _tipsArr = tipsArr;
    NSDictionary *dic = _tipsArr[0];
    self.remarksField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:dic[@"Name"] attributes:@{NSForegroundColorAttributeName:TCUIColorFromRGB(0x999999)}];
}

-(void)setModel:(MMConfirmOrderModel *)model{
    _model = model;
    
    [self setGoodsView];
}

-(void)setWeightStr:(NSString *)weightStr{
    _weightStr = weightStr;
    float weight = [_weightStr floatValue];
    self.weightLa.text = [NSString stringWithFormat:@"%.2fkg",weight];
}

-(void)setGoodsView{
        NSArray *arr;
        NSString  *number;
        if(self.index == 0){
            arr = [MMPackageGoodsModel mj_objectArrayWithKeyValuesArray:self.model.list];
            number = [NSString stringWithFormat:@"%@",self.model.PackNums[0]];
        }else if (self.index == 1){
            arr = [MMPackageGoodsModel mj_objectArrayWithKeyValuesArray:self.model.list2];
            number = [NSString stringWithFormat:@"%@",self.model.PackNums[1]];
        }else if (self.index == 2){
            arr = [MMPackageGoodsModel mj_objectArrayWithKeyValuesArray:self.model.list3];
            number = [NSString stringWithFormat:@"%@",self.model.PackNums[2]];
        }
        
        
        
        NSInteger num;
        if(arr.count > 3){
            num = 3;
        }else{
            num = arr.count;
        }
        
        CGFloat wid = 0;
        for (int i = 0; i < num; i++) {
            MMPackageGoodsModel *model = arr[i];
            UIImageView *goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(13 + 85 * i, 0, 80, 80)];
            [goodImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
            goodImage.layer.masksToBounds = YES;
            goodImage.layer.cornerRadius = 4;
            [self.goodsView addSubview:goodImage];
            
            if(i == num - 1){
                wid = 13 + 85 * i+ 80;
            }
        }
        
        UILabel *lab = [UILabel publicLab:[NSString stringWithFormat:@"%@%@%@",[UserDefaultLocationDic valueForKey:@"ioverall"],number,[UserDefaultLocationDic valueForKey:@"ipiece"]] textColor:TCUIColorFromRGB(0x8f8f8f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        lab.preferredMaxLayoutWidth = 200;
        [lab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
        [self.goodsView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wid + 20);
            make.top.mas_equalTo(33);
            make.height.mas_equalTo(13);
        }];
        
        UIImageView *rightIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_icon_gary"]];
        [self.goodsView addSubview:rightIcon];
        
        [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-12);
                make.top.mas_equalTo(36);
                make.width.mas_equalTo(4);
                make.height.mas_equalTo(8);
        }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 10, 80)];
    [btn setBackgroundColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(clickGoods) forControlEvents:(UIControlEventTouchUpInside)];
    [self.goodsView addSubview:btn];
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    self.titleLa.text = [NSString stringWithFormat:@"%@%ld",[UserDefaultLocationDic valueForKey:@"myPackage"],_index + 1];
    
}

-(void)setAddressModel:(MMAddressModel *)addressModel{
    _addressModel = addressModel;
    self.addressLa.text = [NSString stringWithFormat:@"%@%@",_addressModel.AreaName,_addressModel.Address];
    self.phoneLa.text = [NSString stringWithFormat:@"%@%@",_addressModel.Consignee,_addressModel.MobilePhone];
}

#pragma mark -- uitextfielddelegate
- (void)textFieldEditChanged:(UITextField *)textField
{
    if(textField.text.length > 0){
        self.returnRemarkBlock(textField.text,self.index);
    }
}

-(void)clickGoods{
    self.tapListBlock(self.index);
}

-(void)selectAddress{
    self.seleAddressBlock(self.index);
}

@end
