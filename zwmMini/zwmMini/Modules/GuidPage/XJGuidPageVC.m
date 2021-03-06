//
//  XJGuidPageVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/10.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJGuidPageVC.h"
#import "XJGuidPageView.h"

#define tempWidth(w) (kScreenWidth/375.f)*w
@interface XJGuidPageVC ()

@property(nonatomic,strong) UIScrollView *bgScroView;
@property(nonatomic,strong) UIButton *rightNowBtn;

@end

@implementation XJGuidPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
}
- (void)creatUI{
    
    NSArray *titleArr = @[@"品质社交",
                          @"海量达人",
                          @"真实高效"];
    NSArray *contentArr = @[@"约见更优秀的人",
                            @"任何领域都有达人能指导",
                            @"线下一对一交流指导"];
    NSArray *centerImgtArr = @[@"guide1",
                               @"guide2",
                               @"guide3"];
    NSArray *bottomImgtArr = @[@"guidebottomview1",
                               @"guidbottomimg2",
                               @""];
    
    for (int i = 0; i<titleArr.count; i++) {
        XJGuidPageView *gudeV = [[XJGuidPageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        [self.bgScroView addSubview:gudeV];
        [gudeV setUpTitle:titleArr[i] content:contentArr[i] ceterIV:centerImgtArr[i] bottomIV:bottomImgtArr[i]];
        if (i == 2) {
            [gudeV addSubview:self.rightNowBtn];
            [self.rightNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(gudeV);
                make.bottom.equalTo(gudeV).offset(-tempWidth(42));
                make.width.mas_equalTo(tempWidth(130));
                make.height.mas_equalTo(tempWidth(44));
            }];
        }
    }
}

- (void)rightNowBtnAction{
    
    NSLog(@"立即体验");
    [[NSNotificationCenter defaultCenter] postNotificationName:changeRootVCNotifi object:self];
}

- (UIScrollView *)bgScroView{
    
    if (!_bgScroView ) {
       
     _bgScroView = [XJUIFactory creatUIScrollViewWithFram:CGRectMake(0, 0,kScreenWidth , kScreenHeight) addToView:self.view backColor:defaultWhite contentSize:CGSizeMake(kScreenWidth*3,0) delegate:self isPage:YES];
    _bgScroView.pagingEnabled = YES;

    }
    return _bgScroView;
    
}

- (UIButton *)rightNowBtn{
    if (!_rightNowBtn) {
        _rightNowBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:nil backColor:defaultWhite nomalTitle:@"立即体验" titleColor:defaultRedColor titleFont:defaultFont(18) nomalImageName:nil selectImageName:nil target:self action:@selector(rightNowBtnAction)];
        _rightNowBtn.layer.borderColor = defaultRedColor.CGColor;
        _rightNowBtn.layer.borderWidth = 1;
        _rightNowBtn.layer.cornerRadius = tempWidth(22);
        _rightNowBtn.layer.masksToBounds = YES;
    }
    return _rightNowBtn;
    
    
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
