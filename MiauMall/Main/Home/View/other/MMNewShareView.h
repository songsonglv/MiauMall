//
//  MMNewShareView.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMNewShareView : UIView
@property (nonatomic, copy) void(^tapMemberBlock)(NSInteger index);


-(instancetype)initWithFrame:(CGRect)frame andImageUrl:(NSString *)imageUrl andRegMembers:(NSArray *)members andOrderMembers:(NSArray *)orderMembers;
@end

NS_ASSUME_NONNULL_END
