//
//  MMOrderSubCauseModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMOrderSubCauseModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *JPName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ParID;
@property (nonatomic, copy) NSString *UKName;
@end

NS_ASSUME_NONNULL_END
