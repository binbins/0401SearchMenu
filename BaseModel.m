//
//  BaseModel.m
//  MTime
//
//  Created by 孙 峰 on 15/9/18.
//  Copyright (c) 2015年 SunFeng. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithDic:(NSDictionary *)jsonDic{
    
    self = [super init];
    
    if (self != nil) {
        [self setAttributes:jsonDic];
    }
    
    return self;
}

//映射关系
- (void)setAttributes:(NSDictionary *)jsonDic{
    
    //建立一个属性与key对应的字典
    NSDictionary *mapDic = [self attributesDic:jsonDic];
    
    for (NSString *jsonKey in mapDic) {
        
        // key -> key
        NSString *modelAttr = [mapDic objectForKey:jsonKey];

        //set方法
        SEL selector = [self stringToSel:modelAttr];
        //判断self有selector方法
        if ([self respondsToSelector:selector]) {
            
            //取出json字典中的value
            id value = [jsonDic objectForKey:jsonKey];
            
            //容错判断
            if ([value isKindOfClass:[NSNull class]]) {
                value = @"";
            }
            
            //调用属性的设置器方法，参数是json中的value
            [self performSelector:selector withObject:value];
            
        }
        
    }
    
}

//写set方法
- (SEL)stringToSel:(NSString *)attName{
    
    //截取首字母，变成大写
    NSString *first = [[attName substringToIndex:1] uppercaseString];
    
    //截取剩下字符串
    NSString *end = [attName substringFromIndex:1];
    
    NSString *methodName = [NSString stringWithFormat:@"set%@%@:",first,end];
    
    return NSSelectorFromString(methodName);
}

//建立映射 截止16年2月25日还不懂
- (NSDictionary *)attributesDic:(NSDictionary *)jsonDic{
    
    NSMutableDictionary *mapDic = [[NSMutableDictionary alloc] init];
    
    for (id key in jsonDic) {
        [mapDic setObject:key forKey:key];
    }
    
    return mapDic;
    
}

@end
