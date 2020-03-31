//
//  XJRechargeProtocalVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRechargeProtocalVC.h"

@interface XJRechargeProtocalVC ()

@end

@implementation XJRechargeProtocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户充值协议";
    [self deleteWebCache];
    [self webViewloadRequestWithURLString:H5_RECHARGE_PROTOCAL];
    [self creatBack];
}

- (void)backaction{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)creatBack{
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 28, 28)];
    [bt setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [bt setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [bt addTarget:self action:@selector(backaction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -5;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
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
