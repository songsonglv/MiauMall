//
//  MMCommonProblemVC.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//  常见问题

#import "MMCommonProblemVC.h"
#import "MMQuestionFirstModel.h"
#import "MMQuestionSecondModel.h"
#import "MMQuestionCell.h"
#import "MMProblemDetailVC.h"
#import "MMHeaderView.h"

@interface MMCommonProblemVC ()<UITableViewDelegate,UITableViewDataSource,MMHeaderViewDelegate>
{
    int _currentRow;
    int _currentSection;
}
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *headerViewArr;


@end

@implementation MMCommonProblemVC

-(NSMutableArray *)headerViewArr{
    if(!_headerViewArr){
        _headerViewArr = [NSMutableArray array];
    }
    return _headerViewArr;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 64, WIDTH, HEIGHT - StatusBarHeight - 64 - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = TCUIColorFromRGB(0xffffff);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
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
    titleView.titleLa.text = @"常见问题";
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    [self.view addSubview:self.mainTableView];
    
    [self LoadQuestion];
}

-(void)LoadQuestion{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"LoadQuestion"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSDictionary *param1 = @{@"lang":self.lang,@"cry":self.cry};
    [param setDictionary:param1];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"memberToken"];
    }
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            NSArray *arr = jsonDic[@"list"];
            MMQuestionFirstModel *model = [MMQuestionFirstModel mj_objectWithKeyValues:arr[0]];
            NSArray *arr1 = [MMQuestionFirstModel mj_objectArrayWithKeyValuesArray:model.sub];
            weakself.dataArr = [NSMutableArray arrayWithArray:arr1];
            
            int i = 0;
            for (MMQuestionFirstModel *model in arr1) {
                MMHeaderView *headView = [[MMHeaderView alloc]init];
                headView.model = model;
                headView.delegate = self;
                headView.index = i;
                i++;
                [weakself.headerViewArr addObject:headView];
            }
            [weakself.mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headerViewArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerViewArr[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MMHeaderView *headView = self.headerViewArr[section];
    MMQuestionFirstModel *model = self.dataArr[section];
    return headView.open?model.sub.count:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMQuestionCell*cell = [[MMQuestionCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        MMQuestionFirstModel *model = self.dataArr[indexPath.section];
        NSArray *arr = [MMQuestionSecondModel mj_objectArrayWithKeyValuesArray:model.sub];
        cell.model = arr[indexPath.row];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMQuestionFirstModel *model = self.dataArr[indexPath.section];
    MMQuestionSecondModel *model1 = [MMQuestionSecondModel mj_objectWithKeyValues:model.sub[indexPath.row]];
    MMProblemDetailVC *problemVC = [[MMProblemDetailVC alloc]init];
    problemVC.ID = model1.ID;
    [self.navigationController pushViewController:problemVC animated:YES];
}

#pragma mark -- headviewdelegate
-(void)selectWidth:(MMHeaderView *)view{
    _currentRow = -1;
    if(view.open){
        for (int i = 0; i < self.headerViewArr.count; i++) {
            MMHeaderView *head = [self.headerViewArr objectAtIndex:i];
            head.open = NO;
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                head.backBt.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            } completion:nil];
        }
        [_mainTableView reloadData];
        return;
    }
    _currentSection = (int)view.index;
    [self reset];
}

-(void)reset{
    for (int i = 0; i < self.headerViewArr.count; i++) {
        MMHeaderView *head = [self.headerViewArr objectAtIndex:i];
        if(head.index == _currentSection){
            head.open = YES;
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                head.backBt.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } completion:nil];
        }else{
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                head.backBt.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            } completion:nil];
            head.open = NO;
        }
    }
    [_mainTableView reloadData];
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
