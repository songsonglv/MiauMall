//
//  MMDMSeriverModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMSeriverModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *UKName;
@property (nonatomic, copy) NSString *JPName;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Detail;
@property (nonatomic, copy) NSString *UKDetail;
@property (nonatomic, copy) NSString *JPDetail;
@end

NS_ASSUME_NONNULL_END
