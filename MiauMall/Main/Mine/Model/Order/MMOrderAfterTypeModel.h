//
//  MMOrderAfterTypeModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderAfterTypeModel : NSObject
@property (nonatomic, copy) NSString *SelectIndex;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *IsChoose;
@property (nonatomic, copy) NSString *IsUpload;
@property (nonatomic, copy) NSString *IsChooseNot;//是否可以选择不可退货商品
@property (nonatomic, strong) NSArray *RefundReason;

@end

NS_ASSUME_NONNULL_END
