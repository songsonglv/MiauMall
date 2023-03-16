//
//  ZTBSUtils.h
//  zhuantou
//
//  Created by 吕松松 on 2019/4/18.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZTBSUtils : NSObject


#pragma mark 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma mark 正则匹配用户密码6-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma  mark 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma  mark 正则匹配用户姓名,20位的中文或英文 全部汉字
+ (BOOL)checkname : (NSString *) userName;

#pragma mark 银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber;

#pragma mark 数字 汉子 字母
+ (BOOL)checkDetailname : (NSString *) userDetail;

#pragma  mark 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma mark 大于6位的数字和字母
+ (BOOL)checkPayPwd : (NSString *) paypwd;

#pragma mark 正则匹配中文 英文 数字
+ (BOOL)checkNickName : (NSString *) nickname;

#pragma mark 邮箱验证
+ (BOOL)checkEmail : (NSString *)email;

#pragma mark 车牌号验证
+ (BOOL)checkCardNo : (NSString *)carNo;

#pragma mark 邮政编码
+ (BOOL)checkPostlcode : (NSString *)postlcode;

#pragma mark 纯汉字
+ (BOOL)checkChinese : (NSString *)chinese;

#pragma mark 身份证号
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;

#pragma mark 提现和充值 正则匹配小数点和数字
+ (BOOL) checkMoneyNum:(NSString *)moneyNum;

//获取时间
+(NSString*)getCurrentTimes;
//包含汉字
+(BOOL)isChinese:(NSString *)str;
@end


