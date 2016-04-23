//
//  ClassCell.h
//  0401SearchMenu
//
//  Created by bever on 16/4/22.
//  Copyright © 2016年 bever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@interface ClassCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, retain) NSArray *list;

@property (nonatomic, strong) ClassModel *model;

@end
