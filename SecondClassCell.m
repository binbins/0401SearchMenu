//
//  SecondClassCell.m
//  0401SearchMenu
//
//  Created by bever on 16/4/23.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "SecondClassCell.h"

@implementation SecondClassCell


- (void)setModel:(SecondModel *)model {

    _model = model;
    _iid = model.iid;
    _parentId = model.parentId;
    _name.text = model.name;
}

@end
