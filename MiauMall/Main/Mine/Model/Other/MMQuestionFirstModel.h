//
//  MMQuestionFirstModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMQuestionFirstModel : NSObject
@property (nonatomic, copy) NSString *Depth;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *JPName;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ParID;
@property (nonatomic, copy) NSString *UKName;
@property (nonatomic, strong) NSArray *sub;


@end

NS_ASSUME_NONNULL_END
