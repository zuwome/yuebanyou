//
//  XJWithDrawProtocalVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJWithDrawProtocalVC.h"

@interface XJWithDrawProtocalVC ()

@end

@implementation XJWithDrawProtocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现规则";
    [self deleteWebCache];
    [self webViewloadRequestWithURLString:H5_WITHDRAW_PROTOCAL];
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
