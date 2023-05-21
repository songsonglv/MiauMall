//
//  MMTextField.h
//  MiauMall
//
//  Created by 吕松松 on 2023/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTextField : UITextField<UITextFieldDelegate>



/**
 是否可以粘贴
 */
@property (nonatomic, assign) BOOL canPaste;
 
/**
 是否可以选中
 */
@property (nonatomic, assign) BOOL canSelect;
 
/**
 是否可以全选
 */

@property (nonatomic, assign) BOOL canSelectAll;
@end

NS_ASSUME_NONNULL_END
