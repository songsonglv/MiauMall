//
//  MMShopListEnglistTopView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/18.
//

#import "MMShopListEnglistTopView.h"
#import "MMSortModel.h"

@interface MMShopListEnglistTopView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) float hei;
@property (nonatomic, strong) UIButton *selectBt;

@end

@implementation MMShopListEnglistTopView

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(nonnull NSArray *)dataArr andIndex:(NSInteger)seleIndex andHei:(float)hei{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.selectedIndex = seleIndex;
        self.dataArr = dataArr;
        self.hei = hei;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.hei)];
    scrollView.backgroundColor = TCUIColorFromRGB(0xffffff);
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(10 + 80 * self.dataArr.count, self.hei);
    
    
    
    
    float wid = 10;
    for (int i = 0; i < self.dataArr.count; i++) {
        MMSortModel *model = self.dataArr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wid, 0, 70, self.hei)];
        view.backgroundColor = TCUIColorFromRGB(0xf5f5f4);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        [scrollView addSubview:view];
        
        UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [logoImage sd_setImageWithURL:[NSURL URLWithString:model.SmallPicture] placeholderImage:[UIImage imageNamed:@"zhanweif"]];
        logoImage.layer.masksToBounds = YES;
        logoImage.layer.cornerRadius = 4;
        [view addSubview:logoImage];
        
        CGSize size = [NSString sizeWithText:model.Name font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] maxSize:CGSizeMake(70,MAXFLOAT)];
        UILabel *lab = [UILabel publicLab:model.Name textColor:TCUIColorFromRGB(0x000000) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:10 numberOfLines:0];
        lab.frame = CGRectMake(0, 76, 70, size.height);
        [view addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, self.hei)];
        btn.backgroundColor = UIColor.clearColor;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickBt:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColor.clearColor.CGColor;
        [view addSubview:btn];
        
        if(i == self.selectedIndex){
            btn.layer.borderColor = TCUIColorFromRGB(0x333333).CGColor;
            btn.selected = YES;
            self.selectBt = btn;
        }
        
        wid += 80;
    }
    
    if(self.selectedIndex >= 4 && self.dataArr.count > 5){
        
        [scrollView setContentOffset:CGPointMake(10 + 80 * (self.selectedIndex - 2), 0)];
    }
}

-(void)clickBt:(UIButton *)sender{
    if([self.selectBt isEqual:sender]){
        
    }else{
        self.selectBt.selected = NO;
        self.selectBt.layer.borderColor = UIColor.clearColor.CGColor;
        sender.layer.borderColor = TCUIColorFromRGB(0x333333).CGColor;
        self.selectBt = sender;
    }
    
    MMSortModel *model = self.dataArr[sender.tag - 100];
    self.tapSortBlock(model.ID);
}



@end
