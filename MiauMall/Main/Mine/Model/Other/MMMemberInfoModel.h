//
//  MMMemberInfoModel.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMMemberInfoModel : NSObject
@property (nonatomic, copy) NSString *AccountName;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *AlipayAccount;
@property (nonatomic, copy) NSString *AnchorID;
@property (nonatomic, copy) NSString *AnchorName;
@property (nonatomic, copy) NSString *AnchorPicture;
@property (nonatomic, copy) NSString *AnchorProfile;
@property (nonatomic, copy) NSString *AnchorPullUrl;
@property (nonatomic, copy) NSString *AnchorPushUrl;
@property (nonatomic, copy) NSString *AccountPassword;
@property (nonatomic, strong) NSArray *AreaIds;
@property (nonatomic, copy) NSString *AreaName;
@property (nonatomic, copy) NSString *BankAccount;
@property (nonatomic, copy) NSString *Birth;
@property (nonatomic, copy) NSString *CanBind;
@property (nonatomic, copy) NSString *CanRegCode;
@property (nonatomic, copy) NSString *CanWxBind;
@property (nonatomic, copy) NSString *CardBack;
@property (nonatomic, copy) NSString *CardPositive;
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *CurrencyImg;
@property (nonatomic, copy) NSString *Currency_Bind;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *Experience;
@property (nonatomic, copy) NSString *ExperienceUp;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *IDCard;
@property (nonatomic, copy) NSString *IntegralTotal;
@property (nonatomic, copy) NSString *IntegralUse;
@property (nonatomic, copy) NSString *Integration;
@property (nonatomic, copy) NSString *IsAnchor;
@property (nonatomic, copy) NSString *IsClickToday;
@property (nonatomic, copy) NSString *IsReceiveEmail;
@property (nonatomic, copy) NSString *IsSales;
@property (nonatomic, copy) NSString *IsShowSales;
@property (nonatomic, copy) NSString *IsTest;
@property (nonatomic, copy) NSString *IsUseBalance;
@property (nonatomic, copy) NSString *MobilePhone;
@property (nonatomic, copy) NSString *Moneys;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ParID;
@property (nonatomic, copy) NSString *ParID_Bind;
@property (nonatomic, copy) NSString *PaymentPassword;
@property (nonatomic, copy) NSString *Picture;
@property (nonatomic, copy) NSString *PostalCode;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, copy) NSString *RegCode;
@property (nonatomic, copy) NSString *Sex; //1 男 2 女
@property (nonatomic, copy) NSString *Sex_Bind;
@property (nonatomic, copy) NSString *SubYongRate;
@property (nonatomic, copy) NSString *YongBalanceJPY; //可用
@property (nonatomic, copy) NSString *YongCashOut;
@property (nonatomic, copy) NSString *YongTotal;//累计
@property (nonatomic, copy) NSString *YongBalance;
@property (nonatomic, copy) NSString *YongReady;//待入账
@property (nonatomic, copy) NSString *YongTotalReady;//可提现
@property (nonatomic, copy) NSString *YongTotalReadyShow;
@property (nonatomic, copy) NSString *TipsOrder;
@property (nonatomic, copy) NSString *TipsSys;
@property (nonatomic, copy) NSString *TipsWulu;
@property (nonatomic, copy) NSString *WeixinAccount;
@property (nonatomic, copy) NSString *YongRate;
@property (nonatomic, copy) NSString *lvdisc;
@property (nonatomic, copy) NSString *MoneySign;

@end

NS_ASSUME_NONNULL_END
