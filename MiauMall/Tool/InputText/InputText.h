//
//  InputText.h
//  MYShoppingAllowance
//
//  Created by weven on 2022/7/13.
//  Copyright © 2022 吕松松. All rights reserved.
//

#ifndef InputText_h
#define InputText_h
#import <UIKit/UIKit.h>
#import "UIMircro.h"

@interface InputTextView : UIView

//------ 发送文本 -----//
@property (nonatomic,copy) void (^EndTextViewBlock)(NSString *text);
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;

- (void)show;

#endif /* InputText_h */
