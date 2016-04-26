//
//  ClassViewController.m
//  0401SearchMenu
//
//  Created by bever on 16/4/22.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "ClassViewController.h"
#import "AFNetworking.h"
#import "ClassCell.h"
#import "SecondClassViewController.h"

@interface ClassViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//这里可以填属性
@end

@implementation ClassViewController  {


    __weak IBOutlet UICollectionView *_collection;
    NSArray *_dataArr;
    NSMutableArray *_listArr;
    ClassCell *_currentCell;
    UIImageView *_headImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self postRequest];
    [self lodaData];
 
//从故事板上来的collectionView不用再去注册

    //稍后注册头视图
//    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"]; 
}


//获取分类数据
- (void)postRequest {
    
  
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //发出请求
    NSString *urlStr = @"http://apis.juhe.cn/cook/category";
    NSDictionary *paraDic = @{@"key":@"89acf58f7297d91e14aa08bf3a6f9ba0"};//只有一个必填的参数
    
    [manager POST:urlStr parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        //这里可以记录进度，如果想加上一个风火轮就写在这里
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"分类菜谱请求成功");
        _dataArr = responseObject[@"result"];
        
        
        [self lodaData];
        [self saveJson];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
        //错误的话弹出一个模态视图，要不然脱离Xcode之后怎么死的都不知道
        //连接error的结构
        
    }];
}

- (void)lodaData {
    
    //从本地取东西之前进行一下安全判断
    

    NSString *path = [[NSBundle mainBundle]pathForResource:@"class.archiver" ofType:nil];
    if (path) {

        //接档
        NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _dataArr = [NSArray arrayWithObject:array][0];
    }
    
    _listArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *d in _dataArr) {
        ClassModel *model = [[ClassModel alloc]initWithDic:d];

        [_listArr addObject:model];
    }
    [_collection reloadData];
}

- (void)saveJson {

//    NSData *data = [NSJSONSerialization dataWithJSONObject:_dataArr options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableString *dataPath = [[NSMutableString alloc]initWithString:NSHomeDirectory()];
    [dataPath appendFormat:@"/Documents/JSON/class.archiver"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataArr];
    [[NSFileManager defaultManager] createFileAtPath:dataPath contents:data attributes:nil];
    
    
    
}
#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    //从story里拿到的，不用代码创建
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];

    headView.clipsToBounds = NO;
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KCS_W, 150)];
    _headImg.image = [UIImage imageNamed:@"home_center"];
    
    [headView addSubview:_headImg];
    
    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    if (cell) {
        //不需要这个
    }
    ClassModel *model = _listArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    _currentCell = (ClassCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    [self performSegueWithIdentifier:@"secondClass" sender:self];
    //    NSLog(@"第%lu个item",indexPath.row);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//滑动视图的代理方法：前提是签订协议，这里呢已经在故事板里签过了
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //因为起初偏移了64
    float offsetY = scrollView.contentOffset.y +64;//因为导航栏等原因，加个64计算方便看
    if (offsetY < 0) {
    //        NSLog(@"%.2f",offsetY);
        _headImg.frame = CGRectMake(0, offsetY, KCS_W, 150 - offsetY);
    }
}



//弹出之前的准备
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //要是有多个推出视图就得判断一下identifer
    SecondClassViewController *vc = (SecondClassViewController *)segue.destinationViewController;
    [vc setValue:_currentCell.model forKey:@"passmodel"];//看着高大上，其实相当于VC.passmodel = ~~
    
    _currentCell = nil;//用完后置空
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
