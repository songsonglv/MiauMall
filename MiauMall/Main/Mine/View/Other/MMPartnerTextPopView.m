//
//  MMPartnerTextPopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import "MMPartnerTextPopView.h"
#import "MMPartnerTextCell.h"
#import "MMTextModel.h"

@interface MMPartnerTextPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *textArr;
@property (nonatomic, strong) NSArray *heightArr;
@end

@implementation MMPartnerTextPopView

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDTH - 40, 400) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}


-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)textArr andHeightArr:(nonnull NSArray *)heightArr{
    if (self = [super initWithFrame:frame]) {
        self.textArr = textArr;
        self.heightArr = heightArr;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明view
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.view];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
//    [self.view addGestureRecognizer:tap];
    
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(20, HEIGHT + (HEIGHT - 508)/2, WIDTH - 40, 508)];
    self.bgView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 15;
    [self addSubview:self.bgView];
    
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"useGuide"] textColor:textBlackColor2 textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    titleLa.frame = CGRectMake(0, 20, WIDTH - 40, 16);
    [self.bgView addSubview:titleLa];
    
    [self.bgView addSubview:self.mainTableView];
    
    CGSize size = [NSString sizeWithText:[UserDefaultLocationDic valueForKey:@"readAgree"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT,13)];
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"withdraw_bg"] forState:(UIControlStateNormal)];
    [btn setTitle:[UserDefaultLocationDic valueForKey:@"readAgree"] forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 14;
    [btn addTarget:self action:@selector(hideView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.bottom.mas_equalTo(-20);
            make.width.mas_equalTo(size.width + 20);
            make.height.mas_equalTo(28);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.heightArr[indexPath.row];
    float hei = [str floatValue];
    return hei + 12;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMPartnerTextCell *cell = [[MMPartnerTextCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contextStr = self.textArr[indexPath.row];
    return  cell;
}


-(void)hideView1{
    
}


-(void)hideView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.centerY =self.bgView.centerY+HEIGHT;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)showView{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^
     {
         self.bgView.centerY = self.bgView.centerY-HEIGHT;
         
     } completion:^(BOOL fin){}];
}
@end
