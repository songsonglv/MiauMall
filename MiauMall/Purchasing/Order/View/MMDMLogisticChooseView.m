//
//  MMDMLogisticChooseView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import "MMDMLogisticChooseView.h"
#import "MMDMExpressFeesModel.h"

@interface MMDMLogisticChooseView ()
@property (nonatomic, strong)NSArray *expressArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIButton *selectBT;
@end

@implementation MMDMLogisticChooseView

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(instancetype)initWithFrame:(CGRect)frame andArr:(nonnull NSArray *)expressArr{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.expressArr = expressArr;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:@"国际物流选择" textColor:TCUIColorFromRGB(0x030303) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:15 numberOfLines:0];
    titleLa.frame = CGRectMake(17, 24, WIDTH - 34, 15);
    [self addSubview:titleLa];
    
    float hei = 60;
    
    NSArray *arr = [MMDMExpressFeesModel mj_objectArrayWithKeyValuesArray:self.expressArr];
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    for (int i = 0; i < arr.count; i++) {
        MMDMExpressFeesModel *model = arr[i];
        
        CGSize size1 = [NSString sizeWithText:model.Conts font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] maxSize:CGSizeMake(WIDTH - 60,MAXFLOAT)];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, hei, WIDTH, size1.height + 47)];
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self addSubview:view];
        
        hei += size1.height + 47;
        
        UIButton *seleBt = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
        seleBt.tag = 100 + i;
        [seleBt setImage:[UIImage imageNamed:@"select_no"] forState:(UIControlStateNormal)];
        [seleBt setImage:[UIImage imageNamed:@"select_pink"] forState:(UIControlStateSelected)];
        [seleBt addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        [seleBt setEnlargeEdgeWithTop:0 right:200 bottom:size1.height left:15];
        seleBt.selected = NO;
        [view addSubview:seleBt];
        
        UILabel *lab = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x10131f) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:14 numberOfLines:0];
        lab.frame = CGRectMake(40, 1, WIDTH - 60, 14);
        [view addSubview:lab];
        
        [lab rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"%@  %@:",model.Name,@"费用"]).textColor(TCUIColorFromRGB(0x3c3c3c)).font([UIFont fontWithName:@"PingFangSC-Semibold" size:14]);
            confer.text([NSString stringWithFormat:@"JPY%@",model.Price]).textColor(redColor3).font([UIFont fontWithName:@"PingFangSC-Semibold" size:14]);
        }];
        
        UILabel *lab1 = [UILabel publicLab:model.Conts textColor:TCUIColorFromRGB(0x3c3c3c) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        lab1.frame = CGRectMake(38, 27, WIDTH - 60, size1.height);
        [view addSubview:lab1];
        
        if(i == 0){
            seleBt.selected = YES;
            self.selectBT = seleBt;
        }
    }
}

-(void)clickBt:(UIButton *)sender{
    if([self.selectBT isEqual:sender]){
        
    }else{
        sender.selected = !sender.selected;
        self.selectBT.selected = NO;
        self.selectBT = sender;
    }
    
    MMDMExpressFeesModel *model = self.dataArr[sender.tag - 100];
    self.returnModelBlock(model.ID);
    
}

@end
