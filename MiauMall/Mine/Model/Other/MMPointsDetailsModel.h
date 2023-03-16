//
//  MMPointsDetailsModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//积分明细model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPointsDetailsModel : NSObject
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Amounts;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ParID;
@property (nonatomic, copy) NSString *ParID_Bind;
@property (nonatomic, copy) NSString *Plus;
@end

NS_ASSUME_NONNULL_END
