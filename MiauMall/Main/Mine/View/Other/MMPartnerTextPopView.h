//
//  MMPartnerTextPopView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPartnerTextPopView : UIView

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)textArr andHeightArr:(NSArray *)heightArr;

-(void)hideView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
