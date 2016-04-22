//
//  CaheDic.h
//  0321刘飞儿
//
//  Created by bever on 16/3/22.
//  Copyright © 2016年 bever. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaheDic : NSObject


@property (nonatomic, strong)NSMutableDictionary *caheDic;

+(instancetype)shareThisDic;

@end
