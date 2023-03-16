//
//  MMWishListModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMWishListModel : NSObject
@property (nonatomic, copy) NSString *Conts;//描述简介
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *InCount;//
@property (nonatomic, copy) NSString *IsIn;
@property (nonatomic, copy) NSString *ItemID;//
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Status;//是否已经有了
@property (nonatomic, copy) NSString *Url;
@end

NS_ASSUME_NONNULL_END
