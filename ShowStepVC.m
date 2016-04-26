//
//  ShowStepVC.m
//  0401SearchMenu
//
//  Created by bever on 16/4/1.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "ShowStepVC.h"
#import "UIImageView+UIWebImage.h"
#import "StepCell.h"

#define kcs_w self.view.frame.size.width

@interface ShowStepVC () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ShowStepVC {
    NSArray *_stepArr;
    UIScrollView *_scroll;
    
    __weak IBOutlet UITableView *_table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getdata:nil];
}

- (void)getdata:(NSNotification *)dic { //代码都在这里写，数据传入之后

//    _stepArr = dic.userInfo[@"steps"];
    _stepArr = _sourceDic[@"steps"];
    

    [self creatScro];
    _scroll.alpha = 0;
    [_table reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stepArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    NSDictionary *d = _stepArr[indexPath.row];
    
    StepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stepCell"];

    cell.introduce.text = d[@"step"];
    [cell.img setMyImageWithURL:d[@"img"]];

    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeToScro)];
//   [cell addGestureRecognizer:tap];
    

    return cell;

}
- (void)creatScro{

    _scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width * _stepArr.count, self.view.frame.size.height);
    _scroll.pagingEnabled = YES;
    _scroll.bounces = NO;
    _scroll.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scroll];
    
    for (int i = 0; i < _stepArr.count; i++) {
        NSDictionary *d = _stepArr[i];
        //建立标签和imageview
        UILabel *introduce = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 100, self.view.frame.size.width, 90)];
        introduce.numberOfLines = 0;
        introduce.text = d[@"step"];
        introduce.textColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(introduce.frame.origin.x, introduce.frame.origin.y +90 , introduce.frame.size.width, 300)];
        [imgView setMyImageWithURL:d[@"img"]];
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView)];
        [imgView addGestureRecognizer:tap];
        
        [_scroll addSubview:introduce];
        [_scroll addSubview:imgView];
    }

}


- (void)changeView {

    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;

    [UIView animateWithDuration:.3 animations:^{
        _table.alpha = 1;
        _scroll.alpha = 0;
    }];
}
- (void)changeToScro {

    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    [UIView animateWithDuration:.3 animations:^{
        _scroll.alpha = 1;
        _table.alpha = 0;
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    //    NSLog(@"%ld",indexPath.row);
    _scroll.contentOffset = CGPointMake(kcs_w * indexPath.row, 0);
    [self changeToScro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getdata:) name:@"stepArrIsComming" object:nil];
}


@end
