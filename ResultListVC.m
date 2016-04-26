//
//  ResultListVC.m
//  0401SearchMenu
//
//  Created by bever on 16/4/2.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "ResultListVC.h"
#import "UIImageView+UIWebImage.h"
#import "ShowStepVC.h"
#import "Mytap.h"

@interface ResultListVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

//static BOOL isHidden = YES;

@implementation ResultListVC {

    NSArray *_menuArr;
    NSDictionary *_currentDic;
    
    __weak IBOutlet UITableView *_table;
    UIView *_postView, *_btnView;
    UIButton *_BtnA, *_BtnB;

    UIScrollView *_scroll;
    
    UILabel *_titleLabel, *_tagsLabel, *_burdenLabel;

    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTable) name:@"dataIsCome" object:nil];
    
    [self creatBarButtonItemList];//创建导航项
    
    
    
}

#pragma mark - 滑动视图和导航项按钮


- (void)creatBarButtonItemList { //这部分的代码，后期用for循环去改善

    //实现方法有一点复杂呢:创建两个frame相同的button（图片不一样），放在同一个view上，同一时刻只显示一个，根据点击的按钮来进行切换，
    NSArray *imgNames = @[@"list_home",@"poster_home"];
    NSMutableArray *btnArr = [[NSMutableArray alloc]init];
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 30);
        [button setTintColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_recharge_press"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
        [btnArr addObject:button];
        [_btnView addSubview:button];
    }
    _BtnA = btnArr[0];
    _BtnB = btnArr[1];

    _BtnB.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_btnView];


}

- (void)changeView:(UIButton *)btn {      //两种排列方式的转化写在一个方法里
    _BtnA.hidden = !_BtnA.hidden;
    _BtnB.hidden = !_BtnB.hidden;
    _table.hidden = !_table.hidden;
    _postView.hidden = !_postView.hidden;
//加上动画效果
    
    
    
    [UIView animateWithDuration:.4 animations:^{    //使用了三目运算符
        
        [UIView setAnimationTransition:[btn isEqual:_BtnA]? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:_btnView cache:YES];
        
        [UIView setAnimationTransition:[btn isEqual:_BtnA]? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    } completion:^(BOOL finished) {
       //动画结束后回调
    }];
    
    
}

- (void)reloadTable{


    [_table reloadData];
   
    //此时已经传递过来数据了，所以在这里创建poster视图
    [self creatPostView];
    
}
#pragma mark -
- (void)creatPostView { //创建三个标签

    _postView = [[UIView alloc]initWithFrame:self.view.frame];
    _postView.backgroundColor = [UIColor whiteColor];
    
    [self creatScroll];
//标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, KCS_W - 60, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [_postView addSubview:_titleLabel];
//tags
    _tagsLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 110, KCS_W - 60, 80)];
    [_postView addSubview:_tagsLabel];
    _tagsLabel.numberOfLines = 0;
//材料
    _burdenLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_scroll.frame)+5, KCS_W - 60, 70)];
    _burdenLabel.numberOfLines = 0;
    [_postView addSubview:_burdenLabel];
//初始化一下
    NSDictionary *firstMenu = [_menuArr firstObject];
    _titleLabel.text = firstMenu[@"title"];
    _tagsLabel.text = [NSString stringWithFormat:@"关键词:%@",firstMenu[@"tags"]];
    _burdenLabel.text = [NSString stringWithFormat:@"准备材料:%@",firstMenu[@"burden"]];
    
    
    [self.view addSubview:_postView];
    _postView.hidden = YES;
    
}


// 私有方法，分出来写
- (void)creatScroll {//同时贴上三个标签
  
    CGFloat itemWidth = KCS_W - 40*2;
    CGFloat bigSpace = 40;
    CGFloat space = 20;
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, KCS_W, 400)];
    _scroll.contentSize = CGSizeMake((_menuArr.count-1) *(itemWidth + space) +KCS_W, 400);
    _scroll.delegate = self;

    
    for (int i = 0; i < _menuArr.count; i++) {
        NSDictionary *thisMenu = _menuArr[i];
        UIImageView *album = [[UIImageView alloc]initWithFrame:CGRectMake(bigSpace +i*(itemWidth +space), 0, itemWidth, _scroll.frame.size.height)];
        
        [album setMyImageWithURL:thisMenu[@"albums"][0]];
        album.userInteractionEnabled = YES;
        Mytap *tap = [[Mytap alloc]initWithTarget:self action:@selector(tapToPushWithSelf:)];
        tap.dic = thisMenu;
        [album addGestureRecognizer:tap];
        [_scroll addSubview:album];

    }
    
    [_postView addSubview:_scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理方法
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ShowStepVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultStep"];
    
    //通过属性传递数据
    vc.sourceDic = _menuArr[indexPath.row];

    [self.navigationController pushViewController:vc animated:YES];

}
//跟单元格点击事件执行的是同样的方法，代码有冗余
- (void)tapToPushWithSelf:(Mytap *)tap {

    ShowStepVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"resultStep"];
    
    //通过属性传递数据
    vc.sourceDic = tap.dic;
    
    [self.navigationController pushViewController:vc animated:YES];
}
//该页面有表示图还有滑动视图，代理方法要进行判断， 对偏移量进行量化


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if ([scrollView isEqual:_scroll]) {
        
      
    //        NSLog(@"松手时%.2f",scrollView.contentOffset.x);
        
        CGFloat xOffset = targetContentOffset->x;   //强制访问属性

        //根据offset判断当前要显示的是第几张图片，再把根据图片的序数 和 section.row相联系
        NSInteger currentItem = ((KCS_W - 100)/2 + xOffset )/ (KCS_W - 100 );   //怎么算的，有点意思
        if (currentItem >= _menuArr.count) {
            currentItem = _menuArr.count - 1;    //防止越界
        }
        
        // 对偏移量进行量化:每次移动item宽与间隙之和的整数倍
        targetContentOffset->x = currentItem * (KCS_W - 80 +20);

        NSDictionary *firstMenu = _menuArr[currentItem];
        _titleLabel.text = firstMenu[@"title"];
        _tagsLabel.text = [NSString stringWithFormat:@"关键词:%@",firstMenu[@"tags"]];
        _burdenLabel.text = [NSString stringWithFormat:@"准备材料:%@",firstMenu[@"burden"]];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {


}
@end
