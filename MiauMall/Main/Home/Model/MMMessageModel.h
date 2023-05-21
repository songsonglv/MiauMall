//
//  MMMessageModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMMessageModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ColumnID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Summary;
@property (nonatomic, copy) NSString *MemberID;
@property (nonatomic, copy) NSString *HadRead;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *TimeStamp;
@end

NS_ASSUME_NONNULL_END
