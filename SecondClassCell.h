//
//  SecondClassCell.h
//  0401SearchMenu
//
//  Created by bever on 16/4/23.
//  Copyright © 2016年 bever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondModel.h"


@interface SecondClassCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, copy)NSString *iid, *parentId;

@property (nonatomic ,strong) SecondModel *model;
@end
