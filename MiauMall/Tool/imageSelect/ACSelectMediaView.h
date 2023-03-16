//
//  ACSelectMediaView.h
//
//  Created by caoyq on 16/12/22.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMediaFrameConst.h"
#import "ACMediaModel.h"

typedef void(^ACMediaHeightBlock)(CGFloat mediaHeight);
typedef void(^ACSelectMediaBackBlock)(NSArray<ACMediaModel *> *list);

/** 选择媒体 并 排列展示 的页面 */
@interface ACSelectMediaView : UIView
@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL isfeed;

@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,strong)NSString *imagePath;
@property (nonatomic,strong)NSString *pingUploadUrlString;
@property (nonatomic,assign)NSInteger timeSecond;
@property (nonatomic, strong) NSString *isEnter;//comment为晒单页面  wish为心愿单页面 refund申请售后 assess商品评价

-(instancetype)initWithFrame:(CGRect)frame andIsEnter:(NSString *)isEnter;

/** 监控view的高度变化 */
- (void)observeViewHeight: (ACMediaHeightBlock)value;

/** 随时监控当前选择到的媒体文件 */
- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock;



/**
 视图一开始默认高度
 */
+ (CGFloat)defaultViewHeight;

@end


