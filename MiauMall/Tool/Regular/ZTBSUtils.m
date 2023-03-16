//
//  ZTBSUtils.m
//  zhuantou
//
//  Created by 吕松松 on 2019/4/18.
//  Copyright © 2019 吕松松. All rights reserved.
//

#import "ZTBSUtils.h"

@implementation ZTBSUtils
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern =@"^1[3|4|5|7|8][0-9]\\d{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z\u4e00-\u9fa5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
#pragma 正则匹配支付密码,6-20位的数字或英文
+(BOOL)checkPayPwd:(NSString *)paypwd{
    NSString *pattern = @"^[a-zA-Z[0-9]]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:paypwd];
    return isMatch;
}

#pragma 身份证号
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}
#pragma mark 全部汉字的
+(BOOL)checkname:(NSString *)userName{
    NSString *pattern = @"^[\u4e00-\u9fa5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
#pragma mark  暂时
+(BOOL)checkDetailname:(NSString *)userDetail{
    NSString *pattern = @"^[a-zA-Z0-9 _() （）＿\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userDetail];
    return isMatch;
}

#pragma mark 银行卡
+ (BOOL) IsBankCard:(NSString *)cardNumber

{
    
    if(cardNumber.length==0)
        
    {
        
        return NO;
        
    }
    
    NSString *digitsOnly = @"";
    
    char c;
    
    for (int i = 0; i < cardNumber.length; i++)
        
    {
        
        c = [cardNumber characterAtIndex:i];
        
        if (isdigit(c))
            
        {
            
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
            
        }
        
    }
    
    int sum = 0;
    
    int digit = 0;
    
    int addend = 0;
    
    BOOL timesTwo = false;
    
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
        
    {
        
        digit = [digitsOnly characterAtIndex:i] - '0';
        
        if (timesTwo)
            
        {
            
            addend = digit * 2;
            
            if (addend > 9) {
                
                addend -= 9;
                
            }
            
        }
        
        else {
            
            addend = digit;
            
        }
        
        sum += addend;
        
        timesTwo = !timesTwo;
        
    }
    
    int modulus = sum % 10;
    
    return modulus == 0;
    
}
#pragma 正则匹配包含汉字
+(BOOL)isChinese:(NSString *) str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}




#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}

#pragma 正则匹配中文 英文 数字
+ (BOOL)checkNickName:(NSString *)nickname
{
    NSString *pattern = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:nickname];
    return isMatch;
}

#pragma mark 邮箱验证
+ (BOOL)checkEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 车牌号验证
+ (BOOL)checkCardNo:(NSString *)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

#pragma mark 邮政编码验证
+ (BOOL)checkPostlcode:(NSString *)postlcode
{
    NSString *phoneRegex = @"^[0-8]\\d{5}(?!\\d)$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:postlcode];
}

#pragma mark 纯汉字
+ (BOOL)checkChinese:(NSString *)chinese
{
    NSString *phoneRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:chinese];
}

#pragma mark -- 正则表达式小数点和数字
+ (BOOL)checkMoneyNum:(NSString *)moneyNum
{
    NSString *moneyNumRegex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *moneyNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyNumRegex];
    return [moneyNumTest evaluateWithObject:moneyNum];
}



//获取时间
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue] * 1000;
    NSString *timestr = [NSString stringWithFormat:@"%ld",(long)timeSp];
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return timestr;
    
}
@end
