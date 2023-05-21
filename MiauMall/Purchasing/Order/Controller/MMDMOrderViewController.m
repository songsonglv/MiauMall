//
//  MMDMOrderViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/23.
//

#import "MMDMOrderViewController.h"
#import "MMDMOrderListModel.h"
#import "MMDMOrderTopView.h"
#import "CustomPopOverView.h"
#import "MMDMArrowView.h"
#import "MMDMOrderTypeModel.h"
#import "MMDMOrderCell.h"
#import "MMCustomerServiceVC.h"
#import "MMPayResultModel.h"
#import "MMPayViewController.h"
#import "MMDMPhotoTipsModel.h"
#import "MMDMPhotoPopView.h"
#import "MMDMOrderDetailVC.h"
#import "MMDMChooseLogisticsVC.h"
#import "MMLogisticsInfomoationVC.h"

@interface MMDMOrderViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *subArr;
@property (nonatomic, strong) MMTitleView *titleView;
@property (nonatomic, strong) MMDMOrderTopView *topView;
@property (nonatomic, strong) MMDMArrowView *arrowView;//选择的弹窗
@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic, strong) MMDMOrderTypeModel *seleModel;
@property (nonatomic, strong) MMDMOrderTypeModel *allModel;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) MMDMPhotoTipsModel *photoTipsModel;
@property (nonatomic, strong) MMDMPhotoPopView *photoPopview;
@property (nonatomic, strong) NSString *orderID;

@end

@implementation MMDMOrderViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 88, WIDTH, HEIGHT - StatusBarHeight - 88 - NavigationBarHeight) style:(UITableViewStylePlain)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColor.clearColor;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(NSMutableArray *)subArr{
    if(!_subArr){
        _subArr = [NSMutableArray array];
    }
    return _subArr;
}

-(MMDMOrderTopView *)topView{
    KweakSelf(self);
    if(!_topView){
        _topView = [[MMDMOrderTopView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 34, WIDTH, 54)];
        if(self.type){
            _topView.selectIndex = [self.type integerValue];
        }else{
            _topView.selectIndex = 0;
        }
        _topView.selectIndexBlock = ^(NSInteger index, UIButton * _Nonnull btn) {
            if(index != 0){
//                float wid = WIDTH/weakself.titleArr.count;
                NSArray *arr = weakself.subArr[index - 1];
                weakself.arrowView.height = arr.count * 33 + 21;
                weakself.arrowView.x = btn.x - 40;
                if([weakself.selectBt isEqual:btn]){
                    if([weakself.arrowView.isShow isEqualToString:@"1"]){
                        weakself.arrowView.isShow = @"0";
                    }else{
                        weakself.arrowView.isShow = @"1";
                    }

                }else{
                    weakself.arrowView.isShow = @"1";
                    weakself.arrowView.dataArr = arr;
                }
                weakself.selectBt = btn;
                
                
                
//                CustomPopOverView *view = [CustomPopOverView popOverView];
//                view.layer.shadowOffset = CGSizeMake(0,5);
//                view.layer.shadowOpacity = 1;
//                view.layer.shadowRadius = 5;
//                view.layer.borderWidth = 0.5;
////                self.table.layer.borderColor = TCUIColorFromRGB(0xf5f5f4).CGColor;
//                view.layer.masksToBounds = YES;
//                view.layer.cornerRadius = 2.5;
//                view.content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 98, 208)];
//                view.content.backgroundColor = TCUIColorFromRGB(0xffffff);
//                view.style.shadowColor = [UIColor colorWithWzx:0xb4b4b4 alpha:0.15];
//                view.style.containerBorderColor = TCUIColorFromRGB(0xf5f5f4);
//                view.style.containerBorderWidth = 0.5;
//                view.backgroundColor = [UIColor clearColor];
//                [view showFrom:btn alignStyle:CPAlignStyleCenter];

            }else{
                weakself.arrowView.isShow = @"0";
                weakself.seleModel = weakself.allModel;
                weakself.titleView.titleLa.text = weakself.allModel.name;
                [weakself requestData];
            }
        };
        
    }
    return _topView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingDataSDK onPageBegin:@"代买订单列表"];
    
    if(self.mainTableView){
        [self requestData];
    }
}

- (void)viewDidLoad {
    KweakSelf(self);
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xf5f7f7);
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,StatusBarHeight + 88)];
    topV.backgroundColor = TCUIColorFromRGB(0xffffff);
    [self.view addSubview:topV];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 34)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"dOrderState0"];
//    titleView.returnBt.hidden = YES;
    titleView.line.hidden = YES;
    [topV addSubview:titleView];
    self.titleView = titleView;
    
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    
   
   
    
    self.titleArr = @[[UserDefaultLocationDic valueForKey:@"dOrderState0"],[UserDefaultLocationDic valueForKey:@"dOrderState1"],[UserDefaultLocationDic valueForKey:@"dOrderState2"],[UserDefaultLocationDic valueForKey:@"dOrderState3"],[UserDefaultLocationDic valueForKey:@"dOrderState4"]];
    
    NSArray *arr = @[@[@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState1"],@"ID":@"1"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState5"],@"ID":@"5"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState6"],@"ID":@"6"}],@[@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState2"],@"ID":@"2"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState7"],@"ID":@"7"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState8"],@"ID":@"8"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState9"],@"ID":@"9"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState10"],@"ID":@"10"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState11"],@"ID":@"11"}],@[@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState3"],@"ID":@"3"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState12"],@"ID":@"12"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState13"],@"ID":@"13"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState14"],@"ID":@"14"}],@[@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState4"],@"ID":@"4"},@{@"name":[UserDefaultLocationDic valueForKey:@"dOrderState16"],@"ID":@"16"}]];
    for (NSArray *arr1 in arr) {
        NSArray *arr2 = [MMDMOrderTypeModel mj_objectArrayWithKeyValuesArray:arr1];
        [self.subArr addObject:arr2];
    }
    
    NSString *str = [UserDefaultLocationDic valueForKey:@"dOrderState0"];
    self.allModel = [MMDMOrderTypeModel mj_objectWithKeyValues:@{@"name":str,@"ID":@"0"}];
    
    if([self.type isEqualToString:@"0"]  || !self.type){
        self.type = @"0";
        self.seleModel = self.allModel;
    }else{
        for (int i = 0; i < self.subArr.count; i++) {
            NSArray *arr = self.subArr[i];
            for (int j = 0; j < arr.count; j++) {
                MMDMOrderTypeModel *model = arr[j];
                if([self.type isEqualToString:model.ID]){
                    self.seleModel = model;
                }
            }
        }
    }
    
    self.titleView.titleLa.text = self.seleModel.name;
    
    [topV addSubview:self.topView];
    
    
    
   
    
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    KweakSelf(self);
    
    [self.view addSubview:self.mainTableView];
    
    self.arrowView = [[MMDMArrowView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 80, 108, 150)];
    self.arrowView.backgroundColor = TCUIColorFromRGB(0xffffff);
    self.arrowView.isShow = @"0";
    self.arrowView.returnTypeBlock = ^(MMDMOrderTypeModel * _Nonnull model) {
        weakself.titleView.titleLa.text = model.name;
        weakself.seleModel = model;
        weakself.arrowView.isShow = @"0";
        [weakself requestData];
    };
    [self.view addSubview:self.arrowView];
    
    [self GetRequestPhotoTips];
    
    [self setNoneData];
}

-(void)setNoneData{
    KweakSelf(self);
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"dm_order_none"
                                                                 titleStr:@""
                                                                detailStr:@"您还没有订单哦，快去逛逛吧~"
                                                              btnTitleStr:@""
                                                            btnClickBlock:^(){
        
        }];
    emptyView.backgroundColor = TCUIColorFromRGB(0xf7f7f8);
    emptyView.contentViewY = 108;
    
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabFont = [UIFont systemFontOfSize:13];
    emptyView.detailLabTextColor = TCUIColorFromRGB(0x6f6f6f);
    self.mainTableView.ly_emptyView = emptyView;
}

-(void)GetRequestPhotoTips{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetRequestPhotoTips"];
    NSDictionary *param = @{@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        webView.navigationDelegate = self;
        [weakself.view addSubview:webView];

        

        
        if([code isEqualToString:@"1"]){
            weakself.photoTipsModel = [MMDMPhotoTipsModel mj_objectWithKeyValues:jsonDic];
            
            weakself.photoPopview = [[MMDMPhotoPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andModel:weakself.photoTipsModel andHeight:760];
            weakself.photoPopview.returnSureBlock = ^(NSInteger num) {
                [weakself RequestPhoto:num];
            };
            
            
            
        }else{
            [ZTProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"orderList"];
    NSDictionary *param = @{@"curr":@"1",@"limit":@"20",@"typeid":self.seleModel.ID,@"membertoken":self.memberToken,@"lang":self.lang,@"cry":self.cry};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        [weakself.dataArr removeAllObjects];
        if([code isEqualToString:@"1"]){
            NSArray *arr1 = jsonDic[@"OrderInfoList"];
            if(arr1.count > 0){
                NSArray *arr = [MMDMOrderListModel mj_objectArrayWithKeyValuesArray:arr1];
                [weakself.dataArr addObjectsFromArray:arr];
            }
            [weakself.mainTableView reloadData];
           
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDMOrderListModel *model = self.dataArr[indexPath.row];
    return model.OrderProducts.count * 116 + 200;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KweakSelf(self);
    MMDMOrderListModel *model = self.dataArr[indexPath.row];
    MMDMOrderCell *cell = [[MMDMOrderCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    cell.clickLastBlock = ^(MMDMOrderListModel * _Nonnull model) {
        MMDMChooseLogisticsVC *chooseVC = [[MMDMChooseLogisticsVC alloc]init];
        chooseVC.orderId = model.ID;
        [weakself.navigationController pushViewController:chooseVC animated:YES];
    };
    cell.clickPayBlock = ^(MMDMOrderListModel * _Nonnull model) {
        [weakself GetPayHandleMoreOrders:model];
    };
    
    cell.clickKeFuBlock = ^(MMDMOrderListModel * _Nonnull model) {
        MMCustomerServiceVC *serviceVC = [[MMCustomerServiceVC alloc]init];
        serviceVC.isDM = @"1";
        serviceVC.orderID = model.ID;
        [weakself.navigationController pushViewController:serviceVC animated:YES];
    };
    
    cell.clickPhotoBlock = ^(MMDMOrderListModel * _Nonnull model) {
        weakself.orderID = model.ID;
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.photoPopview];
        [weakself.photoPopview showView];
    };
    
    cell.clickCancleBlock = ^(MMDMOrderListModel * _Nonnull model) {
        [weakself CancleOrder:model];
        
    };
    
    cell.clickResultBlock = ^(MMDMOrderListModel * _Nonnull model) {
        [ZTProgressHUD showMessage:@"结果"];
    };
    
    cell.clickRefundBlock = ^(MMDMOrderListModel * _Nonnull model) {
        [weakself DeleteCancelOrder:model];
    };
    
    cell.clickExpresstBlock = ^(MMDMOrderListModel * _Nonnull model) {
        MMLogisticsInfomoationVC *logictisVC = [[MMLogisticsInfomoationVC alloc]init];
        logictisVC.isEnter = @"1";
        logictisVC.orderID = model.ID;
        [weakself.navigationController pushViewController:logictisVC animated:YES];
    };
    
    cell.clickReceiptBlock = ^(MMDMOrderListModel * _Nonnull model) {
        KweakSelf(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UserDefaultLocationDic valueForKey:@"itips"]
                                                                       message:[UserDefaultLocationDic valueForKey:@"ifYouReceipt"]
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [action setValue:redColor2 forKey:@"titleTextColor"];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:[UserDefaultLocationDic valueForKey:@"idetermine"]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [action setValue:selectColor forKey:@"titleTextColor"];
            [weakself OrderReceipt:model.ID];
        }]];
        [weakself presentViewController:alert animated:true completion:nil];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMDMOrderListModel *model = self.dataArr[indexPath.row];
    MMDMOrderDetailVC *detailVC = [[MMDMOrderDetailVC alloc]init];
    detailVC.orderID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)DeleteCancelOrder:(MMDMOrderListModel *)model{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"DeleteCancelOrder"];
    NSDictionary *param = @{@"id":model.ID,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requestData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)CancleOrder:(MMDMOrderListModel *)model{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"CancelOrder"];
    NSDictionary *param = @{@"id":model.ID,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requestData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//确认收货请求
-(void)OrderReceipt:(NSString *)orderID{
    KweakSelf(self);
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"OrderReceipt"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:orderID forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
    
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requestData];
        }
        [ZTProgressHUD showMessage:jsonDic[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)RequestPhoto:(NSInteger )num{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"RequestPhoto"];
    NSString *numStr = [NSString stringWithFormat:@"%ld",num];
    NSDictionary *param = @{@"id":self.orderID,@"num":numStr,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if([code isEqualToString:@"1"]){
            [weakself requestData];
        }
    } RequestFaile:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//付款页面
-(void)GetPayHandleMoreOrders:(MMDMOrderListModel *)model{
    KweakSelf(self);
    NSString *str = [NSString stringWithFormat:@"%s%@",baseurl1,@"GetPayHandleFirst"];
    NSDictionary *param = @{@"orderid":model.ID,@"membertoken":self.memberToken,@"lang":self.lang};
    NSString *url = [MMGetRequestParameters getURLForInterfaceStringDefine:str params:param];
    [ZTNetworking getHttpRequestURL:url RequestSuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@",jsonDic);
            NSString *code = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
            if([code isEqualToString:@"1"]){
                MMPayResultModel *payModel = [MMPayResultModel mj_objectWithKeyValues:jsonDic];
                MMPayViewController *payVC = [[MMPayViewController alloc]init];
                payVC.model = payModel;
                payVC.isEnter = @"0";
                [weakself.navigationController pushViewController:payVC animated:YES];
            }else{
                [ZTProgressHUD showMessage:jsonDic[@"msg"]];
            }
        } RequestFaile:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"代卖订单列表"];
}
@end
