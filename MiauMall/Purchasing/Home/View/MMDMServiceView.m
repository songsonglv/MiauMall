//
//  MMDMServiceView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/26.
//

#import "MMDMServiceView.h"


@interface MMDMServiceView ()
@property (nonatomic, strong) MMDMSeriverModel *seleModel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIButton *selectBT;
@end

@implementation MMDMServiceView

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)arr{
    if(self = [super initWithFrame:frame]){
        NSArray *arr1 = [MMDMSeriverModel mj_objectArrayWithKeyValuesArray:arr];
        self.dataArr = [NSMutableArray arrayWithArray:arr1];
        self.seleModel = self.dataArr[0];
        [self setUI];
    }
    return self;
}

-(void)setUI{
    float hei = 15;
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"language"];
    for (int i = 0; i < self.dataArr.count; i++) {
        MMDMSeriverModel *model = self.dataArr[i];
        CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@：%@JPY",model.Name,model.Price] font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
        
        CGSize size1 = [NSString sizeWithText:model.Detail font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,12)];
        
        if([lang isEqualToString:@"1"]){
            size =  [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
            
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, size.height + size1.height)];
        if([lang isEqualToString:@"1"]){
            view.height += 26;
        }
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(15, 6, 15, 15)];
        seleBt.tag = 100 + i;
        [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [seleBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
        [seleBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [seleBt setEnlargeEdgeWithTop:10 right:200 bottom:30 left:15];
        seleBt.selected = NO;
        [view addSubview:seleBt];
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        lab.frame = CGRectMake(34, 1, WIDTH - 60, size.height);
        [view addSubview:lab];
        
        if([lang isEqualToString:@"1"]){
            lab.text = model.Name;
            
            UILabel *priceLa = [UILabel publicLab:[NSString stringWithFormat:@"%@JPY",model.Price] textColor:redColor3 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
            priceLa.frame = CGRectMake(34, CGRectGetMaxY(lab.frame) + 12, WIDTH - 60, 14);
            [view addSubview:priceLa];
        }else{
            lab.frame = CGRectMake(34, 1, WIDTH - 60, size.height);
            [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                        confer.text([NSString stringWithFormat:@"%@：",model.Name]).textColor(TCUIColorFromRGB(0x10131f)).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
                        confer.text([NSString stringWithFormat:@"%@JPY",model.Price]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:13]);
            }];
        }
        
        if(model.Detail){
            UILabel *detailLa = [UILabel publicLab:model.Detail textColor:TCUIColorFromRGB(0x4c4c4c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
            detailLa.frame = CGRectMake(34, CGRectGetMaxY(lab.frame) + 12, WIDTH - 60, size1.height);
            [view addSubview:detailLa];
            
            if([lang isEqualToString:@"1"]){
                detailLa.y = CGRectGetMaxY(lab.frame) + 38;
            }
        }
        
        
        hei += size.height + 36;
        
        if(size1.height > 0){
            hei += size1.height + 12;
        }
        
            
        if([lang isEqualToString:@"1"]){
            hei += 26;
        }
        
        
        
    }
}

-(void)clickBt:(UIButton *)sender{
    if([self.selectBT isEqual:sender]){
        sender.selected = !sender.selected;
        self.selectBT.selected = NO;
        self.selectBT = nil;
        self.returnModelBlock(nil);
    }else{
        sender.selected = !sender.selected;
        self.selectBT.selected = NO;
        self.selectBT = sender;
        MMDMSeriverModel *model = self.dataArr[sender.tag - 100];
        self.returnModelBlock(model);
    }
}

@end
