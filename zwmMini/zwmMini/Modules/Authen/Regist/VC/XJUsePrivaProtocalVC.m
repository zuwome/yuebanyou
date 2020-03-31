//
//  XJUsePrivaProtocalVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/11.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUsePrivaProtocalVC.h"

@interface XJUsePrivaProtocalVC ()

@end

@implementation XJUsePrivaProtocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户使用和隐私协议";
    [self deleteWebCache];
    if (!_isPrivate) {
        [self webViewloadRequestWithURLString:H5_USER_USE_PRI_PROTOCAL];
    }
    else {
        [self webViewloadRequestWithURLString:H5_USER_USE_PROTOCAL];
    }
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
