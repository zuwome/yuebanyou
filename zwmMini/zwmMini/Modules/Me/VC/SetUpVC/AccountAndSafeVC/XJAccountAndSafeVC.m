//
//  XJAccountAndSafeVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJAccountAndSafeVC.h"
#import "XJChangePsVC.h"
#import "UIActionSheet+Blocks.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "XJUploadRealHeadImgVC.h"
#import "XJCheckingFaceVC.h"
#import "XJTabBarVC.h"
static NSString *myTableviewIdentifier = @"accountsafetableviewIdentifier";

@interface XJAccountAndSafeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *titlesArray;
@property(nonatomic,copy) NSString *reasonStr;

@end

@implementation XJAccountAndSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号和安全";
    self.titlesArray = @[@"修改密码"];//@"注销账号"
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.titlesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.textLabel.font = defaultFont(15);
    cell.textLabel.textColor = defaultBlack;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[XJChangePsVC new] animated:YES];
        }
            break;
        case 1:
        {
            [self accoutnCancel];
        }
            break;
        default:
            break;
    }
}

- (void)zhuxiao:(NSString *)reason {
    @WeakObj(self);
    [self showAlerVCtitle:@"请确认注销账号操作" message:@"您的账号将不会再被任何人看到，并且所有的聊天信息将会被删除。注销前需要先进行一次本人验证" sureTitle:@"确认注销" cancelTitle:@"取消" sureBlcok:^{
        
        XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
        [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
        //                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
        [weakself presentViewController:lvc animated:YES completion:nil];
        lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
            weakself.reasonStr = reason;
            [weakself checkIshack:bestImg];
            
        };
    }  cancelBlock:^{
        
    }];
}

- (void)accoutnCancel{
    
    [AskManager GET:API_ACCOUNT_CANCEL_FIRST_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            NSLog(@"data = %@",data);
            BOOL canCancelAccount = [data[@"can_close_account"] boolValue];
            NSArray *reasonArr = data[@"reason"];
            
            if (!canCancelAccount) {
                return ;
            }
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:reasonArr[0] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *r0Action = [UIAlertAction actionWithTitle:reasonArr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self zhuxiao:reasonArr[0]];
            }];
            UIAlertAction *r1Action = [UIAlertAction actionWithTitle:reasonArr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self zhuxiao:reasonArr[1]];
            }];
            UIAlertAction *r2Action = [UIAlertAction actionWithTitle:reasonArr[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self zhuxiao:reasonArr[2]];
            }];
            UIAlertAction *r3Action = [UIAlertAction actionWithTitle:reasonArr[3] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self zhuxiao:reasonArr[3]];
            }];
            UIAlertAction *r4Action = [UIAlertAction actionWithTitle:reasonArr[4] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self zhuxiao:reasonArr[4]];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [actionSheetController addAction:r0Action];
            [actionSheetController addAction:r1Action];
            [actionSheetController addAction:r2Action];
            [actionSheetController addAction:r3Action];
            [actionSheetController addAction:r4Action];
            [actionSheetController addAction:cancelAction];
//            [actionSheetController addAction:cancelAction];
//            [actionSheetController addAction:commentAction];
//            [actionSheetController addAction:showAllInfoAction];
            
            [self presentViewController:actionSheetController animated:YES completion:nil];
            
    
            
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)checkIshack:(UIImage *)bestimg{
    
    [MBManager showWaitingWithTitle:@"验证人脸中..."];
    [XJUploader uploadImage:bestimg progress:^(NSString *key, float percent) {
    } success:^(NSString * _Nonnull url) {
        
        [AskManager POST:API_PHOTOT_IS_HACK_POST dict:@{@"image_best":url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                NSString *isHack = data[@"isHack"];
                if ([isHack isEqualToString:@"true"]) {
                    [self showAlerVCtitle:@"检测失败" message:@"请重新刷脸" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                        
                    } cancelBlock:^{
                        
                    }];
                    
                }else{
                    
                    [self closeAccount];
                    
                }
                
                
                
            }else{
                
                [self showAlerVCtitle:@"检测失败" message:@"" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                    
                } cancelBlock:^{
                    
                }];
                
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
        [MBManager hideAlert];
    } failure:^{
        [MBManager hideAlert];
    }];
    
}
- (void)closeAccount{
    
    [AskManager POST:API_ACCOUNT_CLOSE_POST dict:@{@"reason":self.reasonStr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            [XJUserAboutManageer managerRemoveUserInfo];
            [[XJRongIMManager sharedInstance] logOutRongIM];
            ([UIApplication sharedApplication].delegate).window.rootViewController = [[XJTabBarVC alloc] init];
            [MBManager showBriefAlert:@"账号已注销"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark lzay
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.backgroundColor = defaultLineColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
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
