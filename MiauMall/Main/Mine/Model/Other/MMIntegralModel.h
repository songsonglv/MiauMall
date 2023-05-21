//
//  MMIntegralModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMIntegralModel : NSObject
@property (nonatomic, strong) NSArray *Albums;
@property (nonatomic, copy) NSString *Collections;
@property (nonatomic, copy) NSString *Conts;
@property (nonatomic, copy) NSString *FirstVideo;
@property (nonatomic, copy) NSString *Hits;
@property (nonatomic, copy) NSString *IntegralFull;
@property (nonatomic, copy) NSString *IsColl;
@property (nonatomic, copy) NSString *IsOnline;
@property (nonatomic, copy) NSString *MemberInte;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *OldPrice;
@property (nonatomic, copy) NSString *Percent;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Sales;
@property (nonatomic, copy) NSString *ShortName;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, strong) NSArray *assesslist;//评价列表
@property (nonatomic, copy) NSString *cartnum;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray *ContsStr;//详情数组
@end

NS_ASSUME_NONNULL_END
