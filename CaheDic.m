//
//  CaheDic.m
//  0321刘飞儿
//
//  Created by bever on 16/3/22.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "CaheDic.h"

@implementation CaheDic

//先创建一个指针
static CaheDic *dic = nil;

- (NSMutableDictionary *)caheDic { //点语法就可以调用了

    if (!_caheDic) {   //nil
        _caheDic = [[NSMutableDictionary alloc]init];
    }
    
    return _caheDic;

}

//这个类创建的对象只能有一块内存（指针名字可能不一样），那么他的字典属性也就是唯一了
+(instancetype)shareThisDic {

    
    if (!dic) {
        return  dic = [[CaheDic alloc]init];
    }else
        return dic;
}


@end
