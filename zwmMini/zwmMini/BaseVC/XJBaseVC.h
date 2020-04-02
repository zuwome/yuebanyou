//
//  RBBaseViewController.h
//  RobooFitCoach
//
//  Created by Batata on 2018/9/12.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJBaseVC : UIViewController

@property (nonatomic, strong) UITableView * theTableView;
@property (nonatomic, strong) UICollectionView * theCollectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *navigationLeftBtn;
@property (nonatomic, strong) UIButton *navigationRightDoneBtn;


-(void)showBack:(SEL)sel;

/**
 *  显示右按钮
 *
 *  @param title       按钮文字
 *  @param sel         sel
 *  @param imageName   默认图片
 *  @param imageOnName 按下图片
 */
-(void)showNavRightButton:(NSString*)title action:(SEL)sel image:(UIImage *)imageName imageOn:(UIImage*)imageOnName;

- (void)createNavigationRightDoneBtn;

/**
 *  显示左按钮
 *
 *  @param title       按钮文字
 *  @param sel         sel
 *  @param imageName   默认图片
 *  @param imageOnName 按下图片
 */
-(void)showNavLeftButton:(NSString *)title action:(SEL)sel image:(UIImage *)imageName imageOn:(UIImage *)imageOnName;

/*修改昵称之类的**/
- (void)showChangeNameView:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder sureblock:(void(^)(NSString * text)) sure cancelblock:(void(^)(void)) cancel;
//aler
- (void)showAlerVCtitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)suretitle cancelTitle:(NSString *)cancelTitle sureBlcok:(void(^)(void))sure cancelBlock:(void(^)(void))cancel;

- (void)showDeleteAlerView:(NSString *)title doneAct:(void(^)(void))done;

//显示无数据
- (void)showNoDataView;

//隐藏无数据
- (void)hideNodataView;

- (void)gotoLoginView;

@end
