//
//  SecondClassViewController.m
//  0401SearchMenu
//
//  Created by bever on 16/4/23.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "SecondClassViewController.h"
#import "SecondClassCell.h"

@interface SecondClassViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation SecondClassViewController {

    NSMutableArray *_models;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _passmodel.name;
    [self loadData];
}
- (void)loadData {
    _models = [[NSMutableArray alloc]init];
    
    for (NSDictionary *d in _passmodel.list) {//相当于引来了一个数据源
        SecondModel *model = [[SecondModel alloc]init];
        model.iid = d[@"id"];
        model.parentId = d[@"parentId"];
        model.name = d[@"name"];
        [_models addObject:model];
        
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPassmodel:(ClassModel *)passmodel {
    _passmodel = passmodel;
    
}

#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _passmodel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

     SecondClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"secondClass" forIndexPath:indexPath];
//    NSDictionary *d = _passmodel.list[indexPath.row];
    SecondModel *model = _models[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
