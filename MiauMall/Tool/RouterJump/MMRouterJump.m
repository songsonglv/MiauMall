//
//  MMRouterJump.m
//  MiauMall
//
//  Created by 吕松松 on 2023/1/11.
//

#import "MMRouterJump.h"

@implementation MMRouterJump
+(MMBaseViewController *)jumpToRouters:(NSString *)routers{
    routers  = [routers stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([routers localizedStandardContainsString:@"?"]){
        NSURL *url = [NSURL URLWithString:routers];
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
        NSDictionary *param = [NSString getUrlParameterWithUrl:url];
        NSDictionary *dic = [NSString getJsonDataJsonname];
        NSString *str = dic[urlComponents.path];
        MMBaseViewController *vc = [[MMRouterManage sharedInstance]
                                 performAction:str
                                    params:@{@"param":param}
                                 shouldCacheTarget:NO];
        return vc;
    }else{
        NSDictionary *param = [NSString getJsonDataJsonname];
        NSString *str = param[routers];
        MMBaseViewController *vc = [[MMRouterManage sharedInstance]
                                 performAction:str
                                 params:nil
                                 shouldCacheTarget:NO];
        return vc;
    }
}


@end
