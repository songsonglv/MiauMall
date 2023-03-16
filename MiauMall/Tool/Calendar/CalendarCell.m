//
//  CalendarCell.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/1.
//

#import "CalendarCell.h"

@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height * 0.5;
        dayLabel.backgroundColor = [UIColor whiteColor];
        dayLabel.textColor = [UIColor blackColor];
        dayLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel{
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    if ([monthModel.isSelectedDay isEqualToString:@"1"]) {
        self.dayLabel.backgroundColor = redColor2;
        self.dayLabel.textColor = [UIColor whiteColor];
    }else if ([monthModel.isSelectedDay isEqualToString:@"2"]){
        self.dayLabel.backgroundColor = selectColor;
        self.dayLabel.textColor = [UIColor whiteColor];
    } else {
        self.dayLabel.backgroundColor = [UIColor whiteColor];
        self.dayLabel.textColor = [UIColor blackColor];
    }
}
@end
