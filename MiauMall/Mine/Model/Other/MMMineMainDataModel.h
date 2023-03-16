//
//  MMMineMainDataModel.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/10.
//

#import <Foundation/Foundation.h>
#import "MMSiteInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface MMMineMainDataModel : NSObject
@property (nonatomic, copy) NSString *IsShowLevel;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *KefuWeiXin;
@property (nonatomic, strong) NSArray *notice;
@property (nonatomic, copy) NSString *NotClickTips;
@property (nonatomic, copy) NSString *newcount;//新消息
@property (nonatomic, strong) NSArray *OrderNum; //每种订单的数量 用于展示数字
@property (nonatomic, copy) NSString *ClickActiveTips;
@property (nonatomic, copy) NSString *IsClickActive;
@property (nonatomic, copy) NSString *CollectionDownCount;
@property (nonatomic, copy) NSString *menus;
@property (nonatomic, strong) NSArray *banner;
@property (nonatomic, copy) NSString *IsShowLiveBroad;
@property (nonatomic, copy) NSString *CollectionCount;
@property (nonatomic, strong) MMSiteInfo *siteInfo;
@property (nonatomic, strong) MMMemberInfoModel *memberInfo;
@property (nonatomic, copy) NSString *ShowBtn;
@property (nonatomic, copy) NSString *BrowseCount;
@property (nonatomic, copy) NSString *IsOpen;
@end

NS_ASSUME_NONNULL_END
