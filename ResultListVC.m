//
//  ResultListVC.m
//  0401SearchMenu
//
//  Created by bever on 16/4/2.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "ResultListVC.h"
#import "UIImageView+UIWebImage.h"

@interface ResultListVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ResultListVC {

    NSArray *_menuArr;
    NSDictionary *_currentDic;
    
    __weak IBOutlet UITableView *_table;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTable) name:@"dataIsCome" object:nil];
}

- (void)reloadTable{

    [_table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dic = [_resultDic objectForKey:@"result"];
    _menuArr = dic[@"data"];
    return _menuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//*****************我好像没有复用单元格*************
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    NSDictionary *dic = _menuArr[indexPath.row];
    NSArray *stepArr = dic[@"steps"];
    NSArray *albumArr = dic[@"albums"];
    UIImageView *imgView = [cell viewWithTag:110];
    UILabel *title = [cell viewWithTag:111];
    UILabel *imtro = [cell viewWithTag:112];
    UILabel *steps = [cell viewWithTag:113];

    [imgView setMyImageWithURL:albumArr[0]];
    title.text = dic[@"title"];
    imtro.text = dic[@"imtro"];

    steps.text = [NSString stringWithFormat:@"%ld步",stepArr.count];
    
    return cell;
}

//选中单元格后推出视图
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString: @"pushstep" ]) {
        
        NSIndexPath *indexpath = [_table indexPathForSelectedRow];
        _currentDic = _menuArr[indexpath.row];
        
    //        //通知
    //        NSNotification *noti = [NSNotification notificationWithName:@"stepArrIsComming" object:nil userInfo:_currentDic];
    //        [[NSNotificationCenter defaultCenter]postNotification:noti];
       
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {

    //通知
    NSNotification *noti = [NSNotification notificationWithName:@"stepArrIsComming" object:nil userInfo:_currentDic];
    [[NSNotificationCenter defaultCenter]postNotification:noti];
}
@end
