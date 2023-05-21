//
//  MMCalendarViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/1.
//

#import "MMCalendarViewController.h"
#import "CalendarCell.h"
#import "MonthModel.h"
#import "CalendarHeaderView.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)

#define HeaderViewHeight 30
#define WeekViewHeight 40

@interface MMCalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (strong, nonatomic) NSDate *tempDate;
// 上一次选择index ，初始值为今天的index
@property (assign, nonatomic) NSInteger lastSelectIndex;

@end

@implementation MMCalendarViewController

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        NSInteger width = WIDTH/7;
        NSInteger height = WIDTH/7;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(WIDTH, HeaderViewHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 68, width * 7, 356) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    return _collectionView;
}

- (void)getDataDayModel:(NSDate *)date{
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter stringFromDate:mon.dateValue];
            if([self.timeStr isEqualToString:dateStr]){
                mon.isSelectedDay = @"2";
            }else if([self.timeArr containsObject:dateStr]){
                mon.isSelectedDay = @"1";
            }else{
                mon.isSelectedDay = @"0";
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KweakSelf(self);
    self.view.backgroundColor = [UIColor colorWithWzx:0 alpha:0.6];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 600, WIDTH, 600)];
    topV.backgroundColor = redColor2;
    topV.layer.masksToBounds = YES;
    topV.layer.cornerRadius = 17.5;
    [self.view addSubview:topV];
    
    UILabel *lab = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"shipCalendar"] textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-SemiBold" size:21 numberOfLines:0];
    lab.frame = CGRectMake(0, 27, WIDTH, 21);
    [topV addSubview:lab];
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"close_icon_white"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickHide) forControlEvents:(UIControlEventTouchUpInside)];
    [topV addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(10);
            make.width.height.mas_equalTo(18);
    }];
    
    UIView *monthView = [[UIView alloc]initWithFrame:CGRectMake(0, 76, WIDTH, 524)];
    monthView.backgroundColor = TCUIColorFromRGB(0xffffff);
    [topV addSubview:monthView];
    
    UILabel *monthLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x313131) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Medium" size:19 numberOfLines:0];
    monthLa.frame = CGRectMake(100, 23, WIDTH - 200, 21);
    [monthView addSubview:monthLa];
    self.dateLabel = monthLa;
    self.tempDate = [NSDate date];
    monthLa.text = self.tempDate.yyyyMMByLineWithDate;
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 27, 6, 12)];
    [btn1 setImage:[UIImage imageNamed:@"left_icon_black"] forState:(UIControlStateNormal)];
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:(UIControlEventTouchUpInside)];
    [btn1 setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [monthView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 32, 27, 6, 12)];
    [btn2 setImage:[UIImage imageNamed:@"right_icon_black"] forState:(UIControlStateNormal)];
    [btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:(UIControlEventTouchUpInside)];
    [btn2 setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [monthView addSubview:btn2];
    
    [monthView addSubview:self.collectionView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(18,CGRectGetMaxY(self.collectionView.frame) + 20, 14, 14)];
    view1.backgroundColor = selectColor;
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 2;
    [monthView addSubview:view1];
    self.view1 = view1;
    
    UILabel *lab1 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"yjSendTime"] textColor:TCUIColorFromRGB(0x3d3d3d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab1.preferredMaxLayoutWidth = WIDTH - 60;
    [lab1 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [monthView addSubview:lab1];
    self.label1 = lab1;
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(CGRectGetMaxY(weakself.collectionView.frame) + 20);
            make.height.mas_equalTo(14);
    }];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(18,CGRectGetMaxY(self.view1.frame) + 16, 14, 14)];
    view2.backgroundColor = redColor2;
    view2.layer.masksToBounds = YES;
    view2.layer.cornerRadius = 2;
    [monthView addSubview:view2];
    self.view2 = view2;
    
    UILabel *lab2 = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"jpHoliday"] textColor:TCUIColorFromRGB(0x3d3d3d) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    lab2.preferredMaxLayoutWidth = WIDTH - 60;
    [lab2 setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [monthView addSubview:lab2];
    self.label2 = lab2;
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(lab1.mas_bottom).offset(16);
            make.height.mas_equalTo(14);
    }];
    
    if(!self.timeStr){
        view1.hidden = YES;
        view2.y = view1.y;
        lab1.hidden = YES;
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetMaxY(weakself.collectionView.frame) + 20);
        }];
    }
    
    self.tempDate = [NSDate date];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    
    // Do any additional setup after loading the view.
}

-(void)clickBtn1{
    self.tempDate = [self getLastMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
}

-(void)clickBtn2{
    self.tempDate = [self getNextMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
        cell.dayLabel.backgroundColor = TCUIColorFromRGB(0xffffff);
    }
    
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.row == _lastSelectIndex) return;
//    id mon = self.dayModelArray[indexPath.row];
//    id lastMon = self.dayModelArray[self.lastSelectIndex];
//
//    if ([lastMon isKindOfClass:[MonthModel class]] && [mon isKindOfClass:[MonthModel class]]) {
//        MonthModel *lastMonthModel = (MonthModel *)lastMon;
//        lastMonthModel.isSelectedDay = NO;
//
//        MonthModel *monthModel = (MonthModel *)mon;
//        monthModel.isSelectedDay = YES;
//        self.dateLabel.text = [monthModel dateValue].yyyyMMddByLineWithDate;
//
//        NSIndexPath *lastSelectPath = [NSIndexPath indexPathForItem:self.lastSelectIndex inSection:0];
//        [self.collectionView reloadItemsAtIndexPaths:@[lastSelectPath, indexPath]];
//        self.lastSelectIndex = indexPath.row;
//    }
//
//
//}

#pragma mark -- 点击取消
-(void)clickHide{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -Private
- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;

}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}

@end




