//
//  XJdisclaimerVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJdisclaimerVC.h"

@interface XJdisclaimerVC ()

@end

@implementation XJdisclaimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户使用和隐私协议";
    [self deleteWebCache];
    [self webViewloadRequestWithURLString:H5_USER_USE_PRI_PROTOCAL];
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
