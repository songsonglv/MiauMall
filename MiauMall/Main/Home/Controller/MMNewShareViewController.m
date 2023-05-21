//
//  MMNewShareViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import "MMNewShareViewController.h"
#import "MMRegMemberModel.h"
#import "MMNewShareView.h"

@interface MMNewShareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *heis;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *tempcart;//未登录用户使用此字段
@property (nonatomic, strong) NSString *memberToken;//用户token
@property (nonatomic, strong) NSString *lang;//语言
@property (nonatomic, strong) NSString *cry;//国家
@property (nonatomic, strong) NSMutableArray *heiArr;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *RegMembers;
@property (nonatomic, strong) NSMutableArray *RegOrderMembers;
@property (nonatomic, strong) MMNewShareView *shareView;
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img2;
@property (nonatomic, strong) UIImageView *img4;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MMNewShareViewController

-(UIImageView *)img1{
    if(!_img1){
        NSString *heiStr = self.heis[0];
        float hei = [heiStr floatValue];
        _img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, hei)];
        [_img1 sd_setImageWithURL:[NSURL URLWithString:self.images[0]]];
    }
    return _img1;
}

-(UIImageView *)img2{
    if(!_img2){
        NSString *heiStr = self.heis[1];
        float hei = [heiStr floatValue];
        _img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.img1.frame), WIDTH, hei)];
        [_img2 sd_setImageWithURL:[NSURL URLWithString:self.images[1]]];
    }
    return _img2;
}

-(MMNewShareView *)shareView{
    KweakSelf(self);
    if(!_shareView){
        _shareView = [[MMNewShareView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.img2.frame), WIDTH, 0) andImageUrl:self.images[2] andRegMembers:self.RegMembers andOrderMembers:self.RegOrderMembers];
        if(self.RegMembers.count == 0 && self.RegOrderMembers.count == 0){
            _shareView.height = 0;
        }else{
            NSInteger j = self.RegMembers.count/5;
            NSInteger i = self.RegMembers.count%5;
            if(self.RegMembers.count == 0){
                _shareView.height = 44;
            }else{
                if(i > 0){
                    j += 1;
                }
                _shareView.height = 100 * j + 44;
            }
        }
          
        _shareView.tapMemberBlock = ^(NSInteger index) {
            if(index == 0){
                NSInteger j = weakself.RegMembers.count/5;
                NSInteger i = weakself.RegMembers.count%5;
                if(weakself.RegMembers.count == 0){
                    weakself.shareView.height = 44;
                }else{
                    if(i > 0){
                        j += 1;
                    }
                    weakself.shareView.height = 100 * j + 44;
                }
            }else{
                NSInteger j = weakself.RegOrderMembers.count/5;
                NSInteger i = weakself.RegOrderMembers.count%5;
                if(weakself.RegOrderMembers.count == 0){
                    weakself.shareView.height = 44;
                }else{
                    if(i > 0){
                        j += 1;
                    }
                    weakself.shareView.height = 100 * j + 44;
                }
            }
            weakself.img4.y = CGRectGetMaxY(weakself.shareView.frame);
            weakself.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(weakself.img4.frame));
        };
            
    }
    return _shareView;
}


-(UIImageView *)img4{
    if(!_img4){
        NSString *heiStr = self.heis[2];
        float hei = [heiStr floatValue];
        _img4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareView.frame), WIDTH, hei)];
        [_img4 sd_setImageWithURL:[NSURL URLWithString:self.images[3]]];
    }
    return _img4;
}

-(NSMutableArray *)heis{
    if(!_heis){
        _heis = [NSMutableArray array];
    }
    return _heis;
}

-(NSMutableArray *)RegMembers{
    if(!_RegMembers){
        _RegMembers = [NSMutableArray array];
    }
    return _RegMembers;
}

-(NSMutableArray *)RegOrderMembers{
    if(!_RegOrderMembers){
        _RegOrderMembers = [NSMutableArray array];
    }
    return _RegOrderMembers;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [TalkingDataSDK onPageBegin:@"分享蜜柚页面"];
}

-(NSMutableArray *)images{
    if(!_images){
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.memberToken = [self.userDefaults valueForKey:@"membertoken"];
    self.tempcart = [self.userDefaults valueForKey:@"tempcart"];
    self.lang = [self.userDefaults valueForKey:@"language"];
    self.cry = [self.userDefaults valueForKey:@"cry"];
    
    MMTitleView *titleView = [[MMTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, WIDTH, 54)];
    titleView.backgroundColor = TCUIColorFromRGB(0xffffff);
    titleView.titleLa.text = [UserDefaultLocationDic valueForKey:@"sharePomelo"];
    [titleView.returnBt addTarget:self action:@selector(clickReturn) forControlEvents:(UIControlEventTouchUpInside)];
    titleView.line.hidden = YES;
    [self.view addSubview:titleView];
    
    [self requestData];
    [self GetPicture];
    // Do any additional setup after loading the view.
}


-(void)setUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + 54, WIDTH, HEIGHT - StatusBarHeight - 54)];
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [scrollView addSubview:self.img1];
    [scrollView addSubview:self.img2];
    [scrollView addSubview:self.shareView];
    [scrollView addSubview:self.img4];
    scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(self.img4.frame));
}

-(void)requestData{
    KweakSelf(self);
   // [ZTProgressHUD showLoadingWithMessage:@""];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetSingle"];
    if(self.memberToken){
        [param setValue:self.memberToken forKey:@"membertoken"];
    }
    [param setValue:@"687" forKey:@"id"];
    [param setValue:self.lang forKey:@"lang"];
    [param setValue:self.cry forKey:@"cry"];
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
//        dispatch_semaphore_signal(sema);
        NSArray *arr1 = [MMRegMemberModel mj_objectArrayWithKeyValuesArray:jsonDic[@"RegMembers"]];
        NSArray *arr2 = [MMRegMemberModel mj_objectArrayWithKeyValuesArray:jsonDic[@"RegOrderMembers"]];
        weakself.RegMembers = [NSMutableArray arrayWithArray:arr1];
        weakself.RegOrderMembers = [NSMutableArray arrayWithArray:arr2];
    } failure:^(NSError *error) {
//        dispatch_semaphore_signal(sema);
        NSLog(@"%@",error);
    }];
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)GetPicture{
    KweakSelf(self);
    NSString *url = [NSString stringWithFormat:@"%s?t=%@",baseurl,@"GetPicture"];
    NSDictionary *param = @{@"id":@"167",@"lang":self.lang,@"cry":self.cry};
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [ZTNetworking FormPostRequestUrl:url RequestPatams:param ssuccess:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
//        dispatch_semaphore_signal(sema);
        NSString *pic1 = jsonDic[@"Picture"];
        NSString *pic2 = jsonDic[@"Picture2"];
        NSString *pic3 = jsonDic[@"Picture3"];
        NSString *pic4 = jsonDic[@"Picture4"];
        NSArray *arr = @[pic1,pic2,pic3,pic4];
        weakself.images = [NSMutableArray arrayWithArray:arr];
        
        dispatch_queue_t q1 = dispatch_queue_create("hei1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(q1, ^{
            CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:pic1]];
            float hei1  = WIDTH/(size.width/size.height);
            NSString *str1 = [NSString stringWithFormat:@"%.2f",hei1];
            
            CGSize size1 = [UIImage getImageSizeWithURL:[NSURL URLWithString:pic2]];
            float hei2  = WIDTH/(size1.width/size1.height);
            NSString *str2 = [NSString stringWithFormat:@"%.2f",hei2];
            
            CGSize size3 = [UIImage getImageSizeWithURL:[NSURL URLWithString:pic4]];
            float hei3  = WIDTH/(size3.width/size3.height);
            NSString *str3 = [NSString stringWithFormat:@"%.2f",hei3];
            
            [weakself.heis addObject:str1];
            [weakself.heis addObject:str2];
            [weakself.heis addObject:str3];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself setUI];
            });
        });
        
        
    
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        dispatch_semaphore_signal(sema);
    }];
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TalkingDataSDK onPageEnd:@"种草详情页面"];
}
@end
