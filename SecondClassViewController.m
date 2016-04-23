//
//  SecondClassViewController.m
//  0401SearchMenu
//
//  Created by bever on 16/4/23.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "SecondClassViewController.h"
#import "SecondClassCell.h"
#import "AFNetworking.h"

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
    SecondModel *model = _models[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {

    //现在这里试试请求一下json，看能够得到什么
    SecondModel *model = _models[indexPath.row];
//    NSString *selfid = [NSString stringWithFormat:@"%@%@",model.parentId,model.iid];
    NSInteger cid = [model.iid integerValue];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //发出请求
    NSString *urlStr = @"http://apis.juhe.cn/cook/index";
    NSDictionary *paraDic = @{@"key":@"89acf58f7297d91e14aa08bf3a6f9ba0",@"cid":@"20", @"rd":@(20)};//只有一个必填的参数
    
    [manager POST:urlStr parameters:paraDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"按标签分类请求成功");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
