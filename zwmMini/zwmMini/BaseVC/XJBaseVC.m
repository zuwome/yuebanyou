//
//  XJBaseVC.m
//  RobooFitCoach
//
//  Created by Batata on 2018/9/12.
//  Copyright © 2018年 . All rights reserved.
//

#import "XJBaseVC.h"

#import <MJRefresh/MJRefresh.h>


@interface XJBaseVC ()<UIGestureRecognizerDelegate>


@property(nonatomic,strong) UIView *nodataV;

@end

@implementation XJBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.view.backgroundColor = RGBA(240, 240, 240,1);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.translucent = NO;

    if (self.navigationController.viewControllers.count > 1) {
        [self showBack:@selector(goBackActin:)];
    }
}

- (void)dealloc{

    
}
-(void)showBack:(SEL)sel{
    [self showNavLeftButton:nil action:sel image:[UIImage imageNamed:@"fanhui"] imageOn:nil];
}


-(void)showNavRightButton:(NSString*)title action:(SEL)sel image:(UIImage *)imageName imageOn:(UIImage*)imageOnName{
    self.navigationItem.rightBarButtonItems = nil;
    if (!imageName) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setFrame:CGRectMake(0, 5,80, 28)];
        bt.titleLabel.font = [UIFont systemFontOfSize:15];
        bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [bt setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [bt setTitle:title forState:UIControlStateNormal];
        [bt addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
        self.navigationItem.rightBarButtonItem = item;
        bt.selected = NO;
    }else{
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setFrame:CGRectMake(0, 0, 28, 28)];
        bt.titleLabel.font = [UIFont systemFontOfSize:11];
        [bt setTitleColor:RGBA(49, 195, 124,1) forState:UIControlStateNormal];
        [bt setImage:imageName forState:UIControlStateNormal];
        [bt addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        bt.selected = NO;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
   
    }
    
    
}

/**
 *  显示左按钮
 *
 *  @param title       按钮文字
 *  @param sel         sel
 *  @param imageName   默认图片
 *  @param imageOnName 按下图片
 */
-(void)showNavLeftButton:(NSString *)title action:(SEL)sel image:(UIImage *)imageName imageOn:(UIImage *)imageOnName{
    self.navigationItem.leftBarButtonItems = nil;
    if (!imageName) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:sel];
        self.navigationItem.leftBarButtonItem = item;
        
    } else if (imageName && title) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [backBtn setImage:imageName forState:UIControlStateNormal];
        
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        [backBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 40, 40)];
        backLab.font = [UIFont systemFontOfSize:15];
        backLab.textColor = [UIColor whiteColor];
        [backBtn addSubview:backLab];
        
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    } else{
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setFrame:CGRectMake(0, 0, 28, 28)];
        [bt setImage:imageName forState:UIControlStateNormal];
        [bt setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [bt addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        
        negativeSpacer.width = -5;
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
        
    }
}



/**
 *  设置标题颜色
 */
-(void)showTitleColor:(UIColor *)color{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

/**点击背景释放界面*/
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)goBackActin:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showChangeNameView:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder sureblock:(void(^)(NSString * text)) sure cancelblock:(void(^)(void)) cancel
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeholder;
        textField.textColor = [UIColor orangeColor];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *nameTextField = alertController.textFields.firstObject;
        
        sure(nameTextField.text);
        
    }];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancel();
    }];
    [alertController addAction:ok];
    [alertController addAction:cancelaction];
    [self presentViewController:alertController animated:YES completion:^{ }];
}


- (void)showAlerVCtitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)suretitle cancelTitle:(NSString *)cancelTitle sureBlcok:(void(^)(void))sure cancelBlock:(void(^)(void))cancel
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:suretitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        sure();
        
    }];
    if (!NULLString(cancelTitle)) {
        UIAlertAction *cance = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancel();
        }];
        [alertController addAction:cance];

    }
    
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:^{ }];
}

- (void)showDeleteAlerView:(NSString *)title doneAct:(void(^)(void))done;
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *deleteAct = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
        done();
        
    }];
    
    
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:deleteAct];
    [alert addAction:cancelAct];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _theTableView.backgroundColor = [UIColor whiteColor];
        _theTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _theTableView.separatorColor = defaultLineColor;
        _theTableView.estimatedSectionHeaderHeight = 0;
        _theTableView.estimatedSectionFooterHeight = 0;
        [_theTableView setTableFooterView:[UIView new]];

        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _theTableView.mj_header = header;
        
        //底部刷新
        MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:@"我是有底线的～" forState: MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:14.f];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _theTableView.mj_footer = footer;
        
        
        if (@available(iOS 11.0, *)) {
            _theTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _theTableView.scrollIndicatorInsets = _theTableView.contentInset;
        }else{
//            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _theTableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)theCollectionView
{
    if (_theCollectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _theCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height - SafeAreaBottomHeight-SafeAreaTopHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _theCollectionView.mj_header = header;
        
        //底部刷新
        MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:@"我是有底线的～" forState: MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:14.f];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _theCollectionView.mj_footer = footer;
        
        _theCollectionView.backgroundColor=[UIColor whiteColor];
        _theCollectionView.scrollsToTop = YES;
    }
    return _theCollectionView;
}
-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}





//tableview显示无数据
- (void)showNoDataView{
    
    @WeakObj(self);
    _nodataV=[[UIView alloc] init];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        @StrongObj(self);
        if ([obj isKindOfClass:[UITableView class]] || [obj isKindOfClass:[UICollectionView class]]) {
            [self.nodataV setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:self.nodataV];
        }
    }];
    
}

//隐藏无数据
- (void)hideNodataView{
    
    if (_nodataV) {
        [_nodataV removeFromSuperview];
        _nodataV = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
