//
//  MMMyAssessModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMMyAssessModel : NSObject
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, strong) NSArray *Albums;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *DataID;
@property (nonatomic, copy) NSString *IsRec;
@property (nonatomic, copy) NSString *Level;
@property (nonatomic, strong) NSArray *Products;//商品详情
@property (nonatomic, copy) NSString *ReplyConts;
@property (nonatomic, copy) NSString *ReplyMark;
@property (nonatomic, strong) NSArray *Tags;
@end

NS_ASSUME_NONNULL_END
