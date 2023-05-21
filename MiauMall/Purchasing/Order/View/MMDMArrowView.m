//
//  MMDMArrowView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/9.
//  带箭头的view

#import "MMDMArrowView.h"
#import "BubbleLayer.h"
#import "MMDMOrderTypeCell.h"
//#import "MMDMOrderTypeModel.h"


#define Length 5
#define Length2 15
@interface MMDMArrowView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *contV;
@end

@implementation MMDMArrowView

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, 92, self.height - 16) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.whiteColor;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
    
}

-(void)creatUI{
    
    self.backgroundColor = UIColor.whiteColor;
    
    
    
    UIView *contV = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 108, self.height - 5)];
    contV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self addSubview:contV];
    self.contV = contV;
    
    
    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(69, 0, 10, 6)];
    arrowImg.image = [UIImage imageNamed:@"arrow_up"];
    [self addSubview:arrowImg];
    
    
    
//    BubbleLayer *bbLayer = [[BubbleLayer alloc]initWithSize:self.bounds.size];
//
//    // 矩形框的圆角半径
//    bbLayer.cornerRadius = 2.5;
//
//    // 凸起那部分暂且称之为“箭头”，下面的参数设置它的形状
//    bbLayer.arrowDirection = ArrowDirectionTop;
//    bbLayer.arrowHeight = 7;   // 箭头的高度（长度）
//    bbLayer.arrowWidth = 10;    // 箭头的宽度
//    bbLayer.arrowPosition = 0.7;// 箭头的相对位置
//    bbLayer.arrowRadius = 0.1;    // 箭头处的圆角半径
//
//    [self.layer setMask:[bbLayer layer]];
    

    [contV addSubview:self.mainTableView];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDMOrderTypeModel *model = self.dataArr[indexPath.row];
    MMDMOrderTypeCell *cell = [[MMDMOrderTypeCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"dm"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    if(self.index == indexPath.row){
        cell.titleLa.textColor = redColor3;
    }
    return cell;
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    self.index = 100;
    [self.mainTableView reloadData];
}

-(void)layoutSubviews{
    self.contV.height = self.height - 5;
    self.contV.layer.shadowColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.15].CGColor;
    self.contV.layer.shadowOffset = CGSizeMake(0,5);
    self.contV.layer.shadowOpacity = 1;
    self.contV.layer.shadowRadius = 5;
    self.contV.layer.borderWidth = 0.5;
    self.contV.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1.0].CGColor;
    self.contV.layer.cornerRadius = 2.5;
    
    self.mainTableView.height = self.height - 21;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.index = indexPath.row;
    [self.mainTableView reloadData];
    MMDMOrderTypeModel *model = self.dataArr[indexPath.row];
    self.returnTypeBlock(model);
}





-(void)setIsShow:(NSString *)isShow{
    _isShow = isShow;
    if([_isShow isEqualToString:@"1"]){
        self.hidden = NO;
    }else{
        self.hidden = YES;
    }
}
@end
