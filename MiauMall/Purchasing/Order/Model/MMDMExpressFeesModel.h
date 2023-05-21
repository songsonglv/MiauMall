//
//  MMDMExpressFeesModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMDMExpressFeesModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *UKName;
@property (nonatomic, copy) NSString *JPName;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *UKConts;
@property (nonatomic, copy) NSString *JPConts;
@property (nonatomic, copy) NSString *Price;
@end

NS_ASSUME_NONNULL_END
