//
//  MMLinkNaTableViewCell.m
//  MiauMall
//
//  Created by 吕松松 on 2022/12/7.
//  链接导航 类似于金刚区 nav

#import "MMLinkNaTableViewCell.h"

@interface MMLinkNaTableViewCell ()
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *linkArr;
@property (nonatomic, strong) NSMutableArray *iconArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@end

@implementation MMLinkNaTableViewCell

-(NSMutableArray *)linkArr{
    if(!_linkArr){
        _linkArr = [[NSMutableArray alloc]init];
    }
    return _linkArr;
}

-(NSMutableArray *)iconArr{
    if(!_iconArr){
        _iconArr = [[NSMutableArray alloc]init];
    }
    return _iconArr;
}

-(NSMutableArray *)titleArr{
    if(!_titleArr){
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}

-(UIScrollView *)mainScrollView{
    if(!_mainScrollView){
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 192)];
        _mainScrollView.backgroundColor = UIColor.clearColor;
        _mainScrollView.bounces = YES;
        _mainScrollView.alwaysBounceHorizontal = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}



-(void)creatUI{
    self.contentView.backgroundColor = TCUIColorFromRGB(0xffffff);
    
    [self.contentView addSubview:self.mainScrollView];
    
}

-(void)setModel:(MMHomePageItemModel *)model{
    _model = model;
    
    NSArray *items = [MMHomeImageModel mj_objectArrayWithKeyValuesArray:_model.cont.imglist];
    for (int i = 0; i < items.count; i++) {
        
        MMHomeImageModel *itemModel = items[i];
        [self.iconArr addObject:itemModel.url];
        [self.linkArr addObject:itemModel.link2];
        [self.titleArr addObject:itemModel.name];
    }
    
    NSUInteger num;
    NSUInteger line;
    if(items.count <= 5){
        line = 1;
        num = items.count;
    }else{
        line = 2;
       num = (items.count + 1)/2;//列数 取整
    }
    float wid;
    if(num >= 5){
        wid = WIDTH/5;
    }else{
        wid = WIDTH/num;
    }
    self.mainScrollView.contentSize = CGSizeMake(wid*num, 96 * line);
    for (int i = 0; i < self.iconArr.count; i++) {
        UIView *view = [[UIView alloc]init];
        if(line == 1){
            view.frame = CGRectMake(i * wid, 0, wid, 96);
        }else{
            view.frame = CGRectMake(i/line * wid, i % line * 96, wid, 96);
        }
        view.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self.mainScrollView addSubview:view];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((wid - 50)/2, 15, 50, 50)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.iconArr[i]]];
        [view addSubview:iconImage];
        
        UILabel *nameLa = [UILabel publicLab:self.titleArr[i] textColor:TCUIColorFromRGB(0x2a2a2a) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        [view addSubview:nameLa];
        
        [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(CGRectGetMaxY(iconImage.frame) + 5);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(16);
        }];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 96)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.timeInterval = 2.0;
        [view addSubview:btn];
    }
    
}

-(void)clickBtn:(UIButton *)sender{
    NSInteger index = sender.tag - 100;
    self.LinkTapBlock(self.linkArr[index]);
}

@end
