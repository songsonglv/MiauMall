//
//  MMTestVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/8.
//

#import "MMTestVC.h"
#import "TYCyclePagerView.h"
#import "TYCyclePagerViewCell.h"
#import "TYCyclePagerTransformLayout.h"

@interface MMTestVC () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, assign) float hei;



@end

@implementation MMTestVC

-(NSMutableArray *)datas{
    if(!_datas){
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(TYCyclePagerView *)pagerView{
    if(!_pagerView){
        TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, 134)];
        pagerView.backgroundColor = UIColor.whiteColor;
        //pagerView.layer.borderWidth = 1;
        pagerView.isInfiniteLoop = YES;
        pagerView.autoScrollInterval = 3.0;
        pagerView.dataSource = self;
        pagerView.delegate = self;
        // registerClass or registerNib
        [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [self.view addSubview:pagerView];
        _pagerView = pagerView;
    }
    return _pagerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    titleView.titleLa.text = @"测试";
    [self.view addSubview:titleView];
    [self GetZhongCaoInfo];
    // Do any additional setup after loading the view.
}

-(void)GetZhongCaoInfo{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetZhongCaoInfo"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"4220" forKey:@"id"];
    [ZTProgressHUD showLoadingWithMessage:@""];
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
       
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *befoArr = [MMRotationPicModel mj_objectArrayWithKeyValuesArray:jsonDic[@"before"]];
            weakself.datas = [NSMutableArray arrayWithArray:befoArr];
            [weakself setUI];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)setUI{
    [ZTProgressHUD hide];
    
    [self.view addSubview:self.pagerView];
    [self.pagerView reloadData];
   
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _datas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.model = _datas[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame) * 0.9, CGRectGetHeight(pageView.frame) * 0.9);
    layout.itemSpacing = 5;
    layout.layoutType = 1;
    return layout;
}

-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    [ZTProgressHUD showMessage:[NSString stringWithFormat:@"%ld",index]];
}



-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
