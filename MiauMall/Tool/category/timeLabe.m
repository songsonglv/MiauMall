//
//  timeLabe.m
//  SpareTime
//
//  Created by 吕松松 on 2020/4/16.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import "timeLabe.h"

@interface timeLabe ()
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation timeLabe

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
            self.hour--;
        }
    }
    
    if (self.hour < 0  || self.minute < 0 || self.second < 0) {
        self.text = @"00:00:00";
        [self.timer invalidate];
        self.timer = nil;
    }else
    {
        
        
        if (self.hour < 10 && self.minute < 10 && self.second < 10) {
            self.text = [NSString stringWithFormat:@"0%ld:0%ld:0%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else if(self.hour < 10 && self.minute < 10){
            self.text = [NSString stringWithFormat:@"0%ld:0%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else if (self.minute < 10 && self.second < 10){
            self.text = [NSString stringWithFormat:@"%ld:0%ld:0%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else if (self.hour < 10 && self.second < 10){
            self.text = [NSString stringWithFormat:@"0%ld:%ld:0%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else if (self.hour < 10 && self.minute < 10){
            self.text = [NSString stringWithFormat:@"0%ld:0%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else if (self.minute < 10){
            self.text = [NSString stringWithFormat:@"%ld:0%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else if (self.second < 10){
            self.text = [NSString stringWithFormat:@"%ld:%ld:0%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }else{
            self.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
        }
        
    }
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}

@end
