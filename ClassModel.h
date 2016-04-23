//
//  ClassModel.h
//  0401SearchMenu
//
//  Created by bever on 16/4/22.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "BaseModel.h"

@interface ClassModel : BaseModel


@property (nonatomic, copy) NSString *name, *parentId;
@property (nonatomic, retain) NSArray *list;

@end
