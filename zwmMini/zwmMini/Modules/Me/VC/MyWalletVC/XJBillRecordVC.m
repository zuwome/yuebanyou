//
//  XJBillRecordVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBillRecordVC.h"
#import "XJHomeTitleSelectView.h"
#import "SubTitleView.h"
#import "XJBalanceRecordVC.h"
#import "XJCoinRecordVC.h"


@interface XJBillRecordVC ()<SubTitleViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SubTitleView *subTitleView;
@property(nonatomic,strong) UIScrollView *backScrollView;
@property(nonatomic,strong) XJBalanceRecordVC *balanceVC;
@property(nonatomic,strong) XJCoinRecordVC *coinVC;




@end

@implementation XJBillRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单记录";
    self.view.backgroundColor = defaultWhite;
    [self creatUI];
}

- (void)creatUI{
    
    [self.view addSubview:self.subTitleView];
    [self addChildViewController:self.balanceVC];
    UIView *balanceView = self.balanceVC.view;
    [self.backScrollView addSubview:balanceView];
    balanceView.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight - 64-SafeAreaBottomHeight-SafeAreaTopHeight);
    
    [self addChildViewController:self.coinVC];
    UIView *coinView = self.coinVC.view;
    [self.backScrollView addSubview:coinView];
    coinView.frame = CGRectMake(kScreenWidth, 0,kScreenWidth , kScreenHeight - 64-SafeAreaBottomHeight-SafeAreaTopHeight);

}

- (void)subTitleViewDidSelected:(SubTitleView *)titleView atIndex:(NSInteger)index title:(NSString *)title {
//    NSLog(@"%ld %@",index,title);
    if (index == 0) {
        [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }else{
        [self.backScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];

    }
 
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.backScrollView]) {
        
        CGPoint offset=scrollView.contentOffset;
        CGFloat page = offset.x/kScreenWidth;
        [self.subTitleView transToShowAtIndex:page];
        
    }
    
    
}




#pragma mark lazy
- (SubTitleView *)subTitleView
{
    if (!_subTitleView) {
        _subTitleView = [[SubTitleView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
        _subTitleView.delegate = self;
        _subTitleView.titleArray = @[@"余额记录",@"么币记录"];
        _subTitleView.selectTag = (NSInteger)self.recordStyle;
    }
    return _subTitleView;
}

- (UIScrollView *)backScrollView{
    
    if (!_backScrollView) {
        _backScrollView = [XJUIFactory creatUIScrollViewWithFram:CGRectMake(0, 64,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-64) addToView:self.view backColor:defaultWhite contentSize:CGSizeMake(kScreenWidth*2,0) delegate:self isPage:YES];
    }
    
    return _backScrollView;
    
    
}
- (XJBalanceRecordVC *)balanceVC{
    if (!_balanceVC) {
        
        _balanceVC = [[XJBalanceRecordVC alloc] init];
        
    }
    return _balanceVC;
    
}

- (XJCoinRecordVC *)coinVC{
    if (!_coinVC) {
        
        _coinVC = [[XJCoinRecordVC alloc] init];
        
    }
    return _coinVC;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
