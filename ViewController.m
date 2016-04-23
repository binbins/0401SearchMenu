//
//  ViewController.m
//  0401SearchMenu
//
//  Created by bever on 16/4/1.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "ResultListVC.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController {

    __weak IBOutlet UITextField *_searchKey;
    NSDictionary *_dataDic;
    ResultListVC *_vc;
    
}
//---------------89acf58f7297d91e14aa08bf3a6f9ba0------------我的授权码

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)searchKey:(UIButton *)sender {
    if (![_searchKey.text isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"search" sender:self];
    }
}


- (void)requestURL { //按下按钮开始搜索
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];   //返回数据json类型的

    NSString *keyWork = _searchKey.text;
    //做请求
    //接入菜谱大全的接口鸡蛋鸡蛋鸡蛋鸡蛋
    NSString *menuURL = @"http://apis.juhe.cn/cook/query.php";
    //参数必填类型，“menu” “key”（都是字符串类型）
    NSDictionary *menuPara = @{@"menu":keyWork,@"key":@"89acf58f7297d91e14aa08bf3a6f9ba0"};
    
    [manager POST:menuURL parameters:menuPara progress:^(NSProgress * _Nonnull uploadProgress) {
        //进程
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //之前已经设置过返回格式，返回的直接是一个字典，而且已经转码了
        _dataDic = responseObject;
        NSString *resultcode = _dataDic[@"resultcode"];

        
        if (![resultcode isEqualToString:@"202"]) {//不为空的时候才传
            
            [_vc setValue:_dataDic forKey:@"resultDic"];//给下一个控制器的属性传值
        }
      
        NSLog(@"请求成功");
        //现在才把字典传过了，但此时表示图已经加载好了，需要重新加载一下数据
        
    //建立通知:先不用通知传值,只是用通知触发重新加载的事件
        //安全判断：没有找到结果的情况
        NSNotification *notification = [NSNotification notificationWithName:@"dataIsCome" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
    }];
    

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    //只有一个sugue 不用判断了

    [self requestURL];  //含有的post方法是异步执行的，没法让他完全执行完再进行传值

    _vc = segue.destinationViewController;
    //    [_vc setValue:_dataDic forKey:@"resultDic"];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}//该页面的导航栏不再显示

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_searchKey resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
