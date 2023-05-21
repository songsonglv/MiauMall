//
//  MMSelectAreaViewController.m
//  MiauMall
//
//  Created by 吕松松 on 2023/3/16.
//  选择国家地区

#import "MMSelectAreaViewController.h"

@interface MMSelectAreaViewController ()

@end

@implementation MMSelectAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *param = [self readCityJSAndLanguage:self.language];
    // Do any additional setup after loading the view.
}

//读取本地js文件
-(NSDictionary *)readCityJSAndLanguage:(NSString *)language{
    NSString *path;
    if([language isEqualToString:@"0"]){
        path = [[NSBundle mainBundle] pathForResource:@"city_cn" ofType:@"json"];
    }else if ([language isEqualToString:@"1"]){
        path = [[NSBundle mainBundle] pathForResource:@"city_en" ofType:@"js"];
    }else if ([language isEqualToString:@"2"]){
        path = [[NSBundle mainBundle] pathForResource:@"city_ja" ofType:@"js"];
    }else if ([language isEqualToString:@"3"]){
        path = [[NSBundle mainBundle] pathForResource:@"city_tw" ofType:@"js"];
    }
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   
    return jsonDic;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
