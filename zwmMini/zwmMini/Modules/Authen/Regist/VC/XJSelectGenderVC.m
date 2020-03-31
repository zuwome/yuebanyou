//
//  XJSelectGenderVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSelectGenderVC.h"
#import "XJSelectGenderView.h"
#import "XJLiveCheckFaceVC.h"
@interface XJSelectGenderVC ()
@property(nonatomic,copy) NSString *genderStr;
@end

@implementation XJSelectGenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.genderStr = @"";
    XJSelectGenderView *genderView = [[XJSelectGenderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:genderView];
    XJLiveCheckFaceVC *liveCheckVC = [XJLiveCheckFaceVC new];
    liveCheckVC.isRegister = YES;
    genderView.clickBoy = ^{
        NSLog(@"男");
        self.genderStr = @"boy";
        liveCheckVC.isBoy = YES;
    };
    genderView.clickgirl = ^{
        NSLog(@"女");
        self.genderStr = @"girl";
        liveCheckVC.isBoy = NO;


    };
    genderView.clicksure = ^{
        NSLog(@"确定");
        if (NULLString(self.genderStr)) {
            [MBManager showBriefAlert:@"请选择性别"];
            return ;
        }
        
        liveCheckVC.praDic = self.praDic;
        [self.navigationController pushViewController:liveCheckVC animated:YES];
        
        
        

    };
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.genderStr = @"";
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

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
