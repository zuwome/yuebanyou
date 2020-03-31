//
//  XJEditNicknameVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditNicknameVC.h"

@interface XJEditNicknameVC ()

@property(nonatomic,strong) UIView *whiteV;
@property(nonatomic,strong) UITextField *nickNameTf;

@end

@implementation XJEditNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self showNavRightButton:@"" action:@selector(doneAction) image:GetImage(@"dagou") imageOn:GetImage(@"dagou")];
    self.nickNameTf.text = XJUserAboutManageer.uModel.nickname;
    
   
}

- (void)doneAction{
    
    
    //type: 1个人签名 2昵称 3公开么么答 4私信么么答 5技能介绍
    [AskManager POST:API_CHECK_TEXT_POST dict:@{@"content":self.nickNameTf.text,@"type":@(2)}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            if (self.nameBlcok) {
                self.nameBlcok(self.nickNameTf.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
}

- (UIView *)whiteV{
    if (!_whiteV) {
    _whiteV = [XJUIFactory creatUIViewWithFrame:CGRectMake(0, 10, kScreenWidth, 50) addToView:self.view backColor:defaultWhite];
    }
    return _whiteV;
}
- (UITextField *)nickNameTf{
    
    if (!_nickNameTf) {
        _nickNameTf = [XJUIFactory creatUITextFiledWithFrame:CGRectMake(15, 0, kScreenWidth-30, 50) addToView:self.whiteV textColor:defaultBlack textFont:defaultFont(15) placeholderText:@"" placeholderTectColor:defaultGray placeholderFont:defaultFont(15) delegate:self];
        _nickNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nickNameTf;
    
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
