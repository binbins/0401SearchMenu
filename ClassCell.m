//
//  ClassCell.m
//  0401SearchMenu
//
//  Created by bever on 16/4/22.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell


- (void)setModel:(ClassModel *)model {

    _model = model;
    _name.text = model.name;
    _parentId = model.parentId;
    _list = model.list;
}
@end
