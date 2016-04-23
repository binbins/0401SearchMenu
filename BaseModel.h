//
//  BaseModel.h
//  MTime
//
//  Created by 孙 峰 on 15/9/18.
//  Copyright (c) 2015年 SunFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject



//自定义初始化方法
- (id)initWithDic:(NSDictionary *)jsonDic;


- (NSDictionary *)attributesDic:(NSDictionary *)jsonDic;

@end
