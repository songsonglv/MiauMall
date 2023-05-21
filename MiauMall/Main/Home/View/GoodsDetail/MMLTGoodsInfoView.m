//
//  MMLTGoodsInfoView.m
//  MiauMall
//
//  Created by 吕松松 on 2023/4/13.
//  乐天商品信息view

#import "MMLTGoodsInfoView.h"

@interface MMLTGoodsInfoView ()
@property (nonatomic, strong) MMGoodsDetailMainModel *model;
@property (nonatomic, strong) UILabel *tipsLa;
@end

@implementation MMLTGoodsInfoView

-(instancetype)initWithFrame:(CGRect)frame andInfo:(MMGoodsDetailMainModel *)proInfo{
    if([super initWithFrame:frame]){
        self.backgroundColor = TCUIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        self.model = proInfo;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    float price = [self.model.proInfo.ActivePrice floatValue];
    NSString *str = price > 0 ? self.model.proInfo.ActivePriceShow : self.model.proInfo.TotalPriceShow;
    NSArray *temp = [str componentsSeparatedByString:@" "];
    UILabel *priceLa = [UILabel publicLab:str textColor:selectColor textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-SemiBold" size:26 numberOfLines:0];
    priceLa.frame = CGRectMake(12, 30, WIDTH - 44, 26);
    [self addSubview:priceLa];
    
    [priceLa rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(temp[0]).textColor(selectColor).font([UIFont fontWithName:@"PingFangSC-Medium" size:12]);
            confer.text(temp[1]).textColor(selectColor).font([UIFont fontWithName:@"PingFangSC-SemiBold" size:26]);
    }];
    
    UILabel *aboutLa = [UILabel publicLab:[NSString stringWithFormat:@"%@JPY%@",[UserDefaultLocationDic valueForKey:@"iabout"],self.model.proInfo.Price] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    aboutLa.frame = CGRectMake(12, 68, WIDTH -100, 12);
    [self addSubview:aboutLa];
    
    UILabel *saleLa = [UILabel publicLab:[NSString stringWithFormat:@"%@%@",[UserDefaultLocationDic valueForKey:@"salesVolume"],self.model.proInfo.Sales] textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentRight) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    saleLa.preferredMaxLayoutWidth = 100;
    [saleLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self addSubview:saleLa];
    
    [saleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(68);
            make.height.mas_equalTo(12);
    }];
    
    CGSize size = [NSString sizeWithText:self.model.proInfo.ProductSign font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] maxSize:CGSizeMake(MAXFLOAT,15)];
    UILabel *tagLa = [UILabel publicLab:self.model.proInfo.ProductSign textColor:TCUIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    tagLa.backgroundColor = TCUIColorFromRGB(0x333333);
    tagLa.layer.masksToBounds = YES;
    tagLa.layer.cornerRadius = 5;
    tagLa.frame = CGRectMake(12, CGRectGetMaxY(aboutLa.frame) + 18, size.width + 12, 22);
    [self addSubview:tagLa];
    
    UILabel *nameLa = [UILabel publicLab:@"" textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:16 numberOfLines:0];
    nameLa.preferredMaxLayoutWidth = WIDTH - 44;
    [nameLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:nameLa];
    
    [nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(CGRectGetMaxY(aboutLa.frame) + 20);
            make.width.mas_equalTo(WIDTH - 44);
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = size.width + 16;//首行缩进
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.model.proInfo.Name] attributes:@{NSParagraphStyleAttributeName: style,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:16]}];
    nameLa.attributedText = attrText;
    
    UILabel *shortLa = [UILabel publicLab:self.model.proInfo.ShortName textColor:TCUIColorFromRGB(0x333333) textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    shortLa.preferredMaxLayoutWidth = WIDTH - 44;
    [shortLa setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisVertical)];
    [self addSubview:shortLa];
    
    [shortLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(nameLa.mas_bottom).offset(12);
            make.width.mas_equalTo(WIDTH - 44);
//            make.height.mas_equalTo(12);
    }];
    
    if([self.model.proInfo.IsCanReturn isEqualToString:@"0"]){
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",self.model.proInfo.Precautions] attributes:@{NSParagraphStyleAttributeName: style1,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]}];
        self.tipsLa.attributedText = attrText1;
        CGFloat hei1 = [self textViewHeightForAttributedString:attrText1 withWidth:WIDTH - 44];
        
        UILabel *tipsLa = [UILabel publicLab:self.model.proInfo.Precautions textColor:redColor2 textAlignment:(NSTextAlignmentLeft) fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        tipsLa.attributedText = attrText1;
        [self addSubview:tipsLa];
        
        [tipsLa mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.top.mas_equalTo(shortLa.mas_bottom).offset(12);
                    make.width.mas_equalTo(WIDTH - 44);
                    make.height.mas_equalTo(hei1);
        }];
    }
    
}


- (CGFloat)textViewHeightForAttributedString:(NSAttributedString *)string withWidth:(CGFloat)width
{
    return [self rectForAttributedString:string withSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGSize)rectForAttributedString:(NSAttributedString *)string withSize:(CGSize)theSize
{
    if (!string || CGSizeEqualToSize(theSize, CGSizeZero)) {
        return CGSizeZero;
    }

    // setup TextKit stack
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:theSize];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];

    // query for size
    CGRect rect = [layoutManager usedRectForTextContainer:textContainer];

    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

@end
