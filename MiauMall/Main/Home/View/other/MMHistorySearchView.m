//
//  MMHistorySearchView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/2/23.
//

#import "MMHistorySearchView.h"

@interface MMHistorySearchView ()

@end

@implementation MMHistorySearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    UILabel *titleLa = [UILabel publicLab:[UserDefaultLocationDic valueForKey:@"recentSearch"] textColor:TCUIColorFromRGB(0x959595) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    titleLa.frame = CGRectMake(10, 0, WIDTH - 43, 14);
    [self addSubview:titleLa];
    
    UIButton *deleteBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 23, 0.5, 13, 13)];
    [deleteBt setImage:[UIImage imageNamed:@"delete_account_icon"] forState:(UIControlStateNormal)];
    [deleteBt addTarget:self action:@selector(clickDelete) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:deleteBt];
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    for(UILabel *mylabel in [self subviews])
    {
        if ([mylabel isKindOfClass:[UILabel class]]) {
            if([mylabel.text isEqualToString:[UserDefaultLocationDic valueForKey:@"recentSearch"]]){
                
            }else{
                [mylabel removeFromSuperview];
            }
            
        }
    }
    
    CGFloat y = 14 + 14;
    CGFloat letfWidth = 12;
    for (int i = 0; i < _dataArr.count; i++) {
        NSString *text = _dataArr[i];
        CGFloat width = [self getWidthWithStr:text] + 28;
        
        if (letfWidth + width + 12 > WIDTH) {
            y += 35;
            letfWidth = 12;
        }
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 27)];
//        label.userInteractionEnabled = YES;
//        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        label.text = text;
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 13.5;
//        label.layer.borderColor = TCUIColorFromRGB(0xe7e7e7).CGColor;
//        label.layer.borderWidth = 0.5;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = TCUIColorFromRGB(0x959595);
//        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
//        [self addSubview:label];
//        letfWidth += width + 12;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(letfWidth, y, width, 27)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [btn setTitle:text forState:(UIControlStateNormal)];
        [btn setTitleColor:TCUIColorFromRGB(0x959595) forState:(UIControlStateNormal)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 13.5;
        btn.layer.borderColor = TCUIColorFromRGB(0xe7e7e7).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.timeInterval = 2.0;
        [btn addTarget:self action:@selector(tagDidCLick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        letfWidth += width + 12;
        
    }
    self.hei = y + 35;
}

-(void)clickDelete{
    self.tapDeleteBlock(@"1");
}

- (void)tagDidCLick:(UIButton *)tap
{
   
    self.tapSearchBlcok(tap.titleLabel.text);
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(WIDTH, 27) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.width;
    return width;
}
@end
