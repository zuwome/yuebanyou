//
//  XJHelpAndBackVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJHelpAndBackVC.h"

@interface XJHelpAndBackVC ()

@end

@implementation XJHelpAndBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助和反馈";
    [self deleteWebCache];
    [self webViewloadRequestWithURLString:H5_HELP_AND_BACK];
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
