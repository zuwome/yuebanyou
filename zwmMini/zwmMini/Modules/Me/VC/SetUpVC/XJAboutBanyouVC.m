//
//  XJAboutBanyouVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJAboutBanyouVC.h"

@interface XJAboutBanyouVC ()


@end

@implementation XJAboutBanyouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于租我吗";
    
    UIImageView *logoIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.view imageUrl:nil placehoderImage:@"ios 256_25"];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(68);
        make.width.height.mas_equalTo(102);
    }];
    UILabel *versionLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:YES];
    [versionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logoIV);
        make.top.equalTo(logoIV.mas_bottom).offset(15);
    }];
    versionLb.text = @"租我吗V4.0.0";
    
    UIView *whiteV = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
    [whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLb.mas_bottom).offset(58);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *kefuLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:whiteV textColor:defaultBlack text:@"客服热线" font:defaultFont(15) textInCenter:NO];
    [kefuLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteV).offset(15);
        make.centerY.equalTo(whiteV);
    }];
    
    UILabel *phoneL = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:whiteV textColor:[UIColor blueColor] text:@"4008-520-272" font:defaultFont(15) textInCenter:NO];
    [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteV);
        make.right.equalTo(whiteV).offset(-15);
    }];
    phoneL.userInteractionEnabled = YES;
    UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction)];
    [phoneL addGestureRecognizer:phonetap];
    
    
}
- (void)phoneAction{
    
    [self showAlerVCtitle:@"提示" message:@"确认拨打电话\n4008-520-272?" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4008-520-272"]];
        
    } cancelBlock:^{
        
    }];
    
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
