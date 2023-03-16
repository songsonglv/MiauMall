//
//  MYNetManage.h
//  SpareTime
//
//  Created by 吕松松 on 2020/5/14.
//  Copyright © 2020 吕松松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYNetManage : NSObject
singleton_Interface(MYNetManage)
@property (nonatomic,assign) int netState;

@end

NS_ASSUME_NONNULL_END
