//
//  MMVersionModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMVersionModel : NSObject
@property (nonatomic, copy) NSString *AbroadVersion;
@property (nonatomic, copy) NSString *AppUrl;
@property (nonatomic, copy) NSString *CartCount;
@property (nonatomic, copy) NSString *DomesticVersion;
@property (nonatomic, copy) NSString *IOSVersion;
@property (nonatomic, copy) NSString *IsOpenAbroad;
@property (nonatomic, copy) NSString *IsOpenDomestic;
@property (nonatomic, copy) NSString *IsOpenIOS; //是否展示弹窗
@property (nonatomic, copy) NSString *IsShowUpdate;
@property (nonatomic, copy) NSString *IsUpdateForce; //是否强更 1 强更 只显示更新按钮  0 非强更 两个按钮
@property (nonatomic, copy) NSString *NewNoticeCount;
@property (nonatomic, copy) NSString *NoReadCount;
@property (nonatomic, copy) NSString *Version;
@property (nonatomic, copy) NSString *VersionContent;
@end

NS_ASSUME_NONNULL_END
