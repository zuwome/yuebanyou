//
//  XJEditMyIntroduceVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditMyIntroduceVC.h"

@interface XJEditMyIntroduceVC ()<UITextViewDelegate>
@property(nonatomic,strong) UITextView *myIntriduceTf;
@property(nonatomic,strong) UILabel *explainLb;
@property(nonatomic,strong) UILabel *numberLb;
@end

@implementation XJEditMyIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自我介绍";
    [self showNavRightButton:@"保存" action:@selector(doneAction) image:nil imageOn:nil];
    [self.explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myIntriduceTf.mas_bottom).offset(10);
        make.left.equalTo(self.myIntriduceTf);
    }];
    [self.numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainLb);
        make.right.equalTo(self.myIntriduceTf);
    }];
}

- (void)doneAction{
    
    //type: 1个人签名 2昵称 3公开么么答 4私信么么答 5技能介绍
    [AskManager POST:API_CHECK_TEXT_POST dict:@{@"content":self.myIntriduceTf.text,@"type":@(1)}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            if (self.myIntroBlock) {
                self.myIntroBlock(self.myIntriduceTf.text, rError.code);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
   
    
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    NSLog(@"===%@",textView.text);
//
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.numberLb.text = [NSString stringWithFormat:@"%ld/80",range.location+1];
    if (range.location >79) {
        return NO;
    }
    return YES;
    
}

- (UITextView *)myIntriduceTf{
    
    if (!_myIntriduceTf) {

        _myIntriduceTf = [[UITextView alloc] init];
        _myIntriduceTf.frame = CGRectMake(15, 10, kScreenWidth-30, 200);
        _myIntriduceTf.textAlignment = NSTextAlignmentLeft;
        _myIntriduceTf.textColor = defaultBlack;
        _myIntriduceTf.font = [UIFont systemFontOfSize:15];
        _myIntriduceTf.delegate = self;
        _myIntriduceTf.layer.cornerRadius = 5;
        _myIntriduceTf.layer.masksToBounds = YES;
        _myIntriduceTf.text = _desc;
    
        [self.view addSubview:_myIntriduceTf];
    }
    return _myIntriduceTf;
    
}
- (UILabel *)explainLb{
    
    if (!_explainLb) {
        _explainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultGray text:@"优秀的自我介绍可以获得更多粉丝和推荐机会噢" font:defaultFont(13) textInCenter:NO];
    }
    return _explainLb;
    
    
}
- (UILabel *)numberLb{
    
    if (!_numberLb) {
        _numberLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultGray text:@"0/80" font:defaultFont(13) textInCenter:NO];
        _numberLb.textAlignment = NSTextAlignmentRight;
    }
    return _numberLb;
    
    
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
