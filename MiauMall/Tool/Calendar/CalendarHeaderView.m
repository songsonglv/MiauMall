//
//  CalendarHeaderView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/1.
//

#import "CalendarHeaderView.h"
#define HeaderViewHeight 30
#define WeekViewHeight 40

@implementation CalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"Su",@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa", nil];
        
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*WIDTH/7, 0, WIDTH/7, HeaderViewHeight)];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor grayColor];
            weekLabel.font = [UIFont systemFontOfSize:18.f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
            
            if(i == 0 || i == 6){
                weekLabel.textColor = redColor2;
            }
        }
        
    }
    return self;
}
@end
