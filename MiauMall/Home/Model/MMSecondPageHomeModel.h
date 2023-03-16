//
//  MMSecondPageHomeModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMSecondPageHomeModel : NSObject
@property (nonatomic, copy) NSString *BackGroundColor;
@property (nonatomic, copy) NSString *BackGroundImage;
@property (nonatomic, copy) NSString *IsLoadMore;//他俩一个为1 最下边可加载
@property (nonatomic, copy) NSString *IsLoadRec;//他俩一个为1 最下边可加载
@property (nonatomic, copy) NSString *IsShare;
@property (nonatomic, copy) NSString *IsSpecial;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *SEOConts;
@property (nonatomic, copy) NSString *SEOKeyWord;
@property (nonatomic, copy) NSString *SEOTitle;
@property (nonatomic, copy) NSString *ShareInt;
@property (nonatomic, copy) NSString *classids;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
