//
//  MMZhongCaoListVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/2.
//  种草列表页面

#import "MMZhongCaoListVC.h"
#import "MMZhongCaoListModel.h"
#import "MMZhongCaoListCell.h"
#import "MMZhongCaoInfoVC.h"

@interface MMZhongCaoListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger endpage;
@property (nonatomic, strong) MMTitleView *titleView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSMutableArray *itemHArr;
@end

@implementation MMZhongCaoListVC

-(NSMutableArray *)listArr{
    if(!_listArr){
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

-(NSMutableArray *)itemHArr{
    if(!_itemHArr){
        _itemHArr = [NSMutableArray array];
    }
    return _itemHArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54 - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    [TalkingDataSDK onPageBegin:@"种草列表页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarHeight)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}

-(void)GetZhongCao{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetZhongCao"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    [param setValue:@"0" forKey:@"cid"];
    [param setValue:@"1" forKey:@"curr"];
    [param setValue:@"10" forKey:@"limit"];
    [param setValue:self.param[@"pid"] forKey:@"pid"];
//    [ZTProgressHUD showLoadingWithMessage:@""];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([str isEqualToString:@"1"]){
            NSArray *arr = [MMZhongCaoListModel mj_objectArrayWithKeyValuesArray:jsonDic[@"list"]];
        
            weakself.titleView.titleLa.text = [NSString stringWithFormat:@"%@",jsonDic[@"Name"]];
            weakself.listArr = [NSMutableArray arrayWithArray:arr];
            CGFloat wid = WIDTH - 20;
            dispatch_queue_t q = dispatch_queue_create("hei", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(q, ^{
                for (MMZhongCaoListModel *model in arr) {
                    CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:model.Picture]];
                    CGFloat height = wid/(size.width/size.height) + 80;
                    NSString *heiStr = [NSString stringWithFormat:@"%f",height];
                    [weakself.itemHArr addObject:heiStr];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.mainTableView reloadData];
                });
                
            });
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUI{
    [self.view addSubview:self.mainTableView];
    
    [self GetZhongCao];
}

#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *heiStr = self.itemHArr[indexPath.row];
    return [heiStr floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMZhongCaoListCell*cell = [[MMZhongCaoListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listArr.count > 0) {
        cell.model = self.listArr[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMZhongCaoListModel *model = self.listArr[indexPath.row];
   
    MMZhongCaoInfoVC *infoVC = [[MMZhongCaoInfoVC alloc]init];
    infoVC.ID = model.ID;
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZTProgressHUD hide];
    [TalkingDataSDK onPageEnd:@"种草列表页面"];
}

@end
