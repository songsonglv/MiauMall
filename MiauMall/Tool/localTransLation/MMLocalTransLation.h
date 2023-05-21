//
//  MMLocalTransLation.h
//  MiauMall
//
//  Created by 吕松松 on 2023/3/31.
//

#import <Foundation/Foundation.h>

@interface MMLocalTransLation : NSObject

+(MMLocalTransLation *)sharedManager;

-(NSString *)ttObjectForKey:(NSString *)string;

@end


