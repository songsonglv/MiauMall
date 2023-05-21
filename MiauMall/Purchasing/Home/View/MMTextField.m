//
//  MMTextField.m
//  MiauMall
//
//  Created by 吕松松 on 2023/5/5.
//

#import "MMTextField.h"

@implementation MMTextField


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self; // 设置 delegate 为 self，实现 UITextFieldDelegate 协议
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 在这里实现您想要的粘贴行为
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    

//    // 下面是一个示例：禁止用户在 TextField 中粘贴数字和符号
//    NSCharacterSet *blockedCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//    NSRange blockedRange = [newString rangeOfCharacterFromSet:blockedCharacterSet];
//    if (blockedRange.location != NSNotFound) {
//        return NO;
//    }

    return YES;
}


@end
