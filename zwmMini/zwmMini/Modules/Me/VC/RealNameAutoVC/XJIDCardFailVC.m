//
//  XJIDCardFailVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJIDCardFailVC.h"
#import "XJNumberInputView.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface XJIDCardFailVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UILabel *hintLb;
@property(nonatomic,copy) NSString *nameStr;
@property(nonatomic,copy) NSString *numStr;
@property(nonatomic,strong) UIButton *commintBtn;
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,strong) UIView *whiteBgView;
@property(nonatomic,strong) UIImageView *kuangIV;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong) UIImageView *carameIV;
@end

@implementation XJIDCardFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交证件";
    [self creatUI];
}



- (void)creatUI{
    
    [self.hintLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(32);
    }];
    
    XJNumberInputView *nameView = [[XJNumberInputView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 50)];
    nameView.nameStr = @"姓名";
    nameView.placeholderStr = @"请输入真是姓名";
    [self.view addSubview:nameView];
    
    
    XJNumberInputView *numberView = [[XJNumberInputView alloc] initWithFrame:CGRectMake(0, 106, kScreenWidth, 50)];
    numberView.nameStr = @"身份证";
    numberView.placeholderStr = @"请输入身份证号码";
    [self.view addSubview:numberView];
    
    nameView.block = ^(NSString * _Nonnull inputStr) {
        self.nameStr = inputStr;
    };
    
    numberView.block = ^(NSString * _Nonnull inputStr) {
        self.numStr = inputStr;
    };
    [self.commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-17);
        make.width.mas_equalTo(345);
        make.height.mas_equalTo(50);
    }];
    self.commintBtn.layer.cornerRadius = 25;
    self.commintBtn.layer.masksToBounds = YES;
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView.mas_bottom).offset(8);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(345);
    }];
    
    UILabel *imgtitle = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.whiteBgView textColor:defaultBlack text:@"请上传手持正面照片" font:defaultFont(15) textInCenter:NO];
    
    [imgtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBgView).offset(15);
        make.top.equalTo(self.whiteBgView).offset(15);
    }];
    [self.carameIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgtitle.mas_bottom).offset(78);
        make.centerX.equalTo(self.whiteBgView);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(28);
    }];
    [self.kuangIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgtitle.mas_bottom).offset(12);
        make.left.equalTo(self.whiteBgView).offset(15);
        make.right.equalTo(self.whiteBgView).offset(-15);
        make.height.mas_equalTo(180);
    }];
    
    UILabel *imgbotitle = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.whiteBgView textColor:defaultBlack text:@"照片要求如下" font:defaultFont(15) textInCenter:NO];
    [imgbotitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBgView).offset(15);
        make.top.equalTo(self.kuangIV.mas_bottom).offset(20);
    }];
    
    UILabel *exlb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.whiteBgView textColor:RGB(102, 102, 102) text:@"1.需本人手持证件（带有头像照片的一面）\n2.证件上的信息/号码/住址清晰可见" font:defaultFont(13) textInCenter:NO];
    exlb.numberOfLines = 2;
    [exlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBgView).offset(15);
        make.top.equalTo(imgbotitle.mas_bottom).offset(20);
    }];
    
    
}

//选择照片
- (void)selectImgAction{
    
    [self showImagePickerController];

}


//提交
- (void)comminAction{
    if (NULLString(self.nameStr)) {
        [MBManager showBriefAlert:@"请输入姓名"];
        return;
    }
    if (NULLString(self.numStr)) {
        [MBManager showBriefAlert:@"请输入身份证号"];
        return;
        
    }
    if (NULLString(self.imgUrl)) {
        [MBManager showBriefAlert:@"请选择图片"];
        return;
        
    }
    
    [MBManager showWaitingWithTitle:@"提交中..."];
    [AskManager POST:API_REALNAME_FAIL_RE_POST dict:@{@"name":self.nameStr,@"code":self.numStr,@"pic":self.imgUrl}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
                    NSLog(@"realnamdata = %@",data);
        if (!rError) {
            XJRealNameModel *realnameModel = [XJRealNameModel yy_modelWithDictionary:data];
            XJUserModel *umode = XJUserAboutManageer.uModel;
            umode.realname = realnameModel;
            XJUserAboutManageer.uModel = umode;
            [MBManager hideAlert];
            [MBManager showBriefAlert:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            [MBManager hideAlert];

        }
        
        
    } failure:^(NSError *error) {
       
        [MBManager hideAlert];

    }];
    
}
#pragma mark ShowImagePickerController
- (void)showImagePickerController
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @WeakObj(self);
    UIAlertAction *takePhotoAct = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        //选择相机时，设置UIImagePickerController对象相关属性
        self.imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //跳转到UIImagePickerController控制器弹出相机
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *photoAct = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        //选择相册时，设置UIImagePickerController对象相关属性
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //跳转到UIImagePickerController控制器弹出相册
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takePhotoAct];
    [alert addAction:photoAct];
    [alert addAction:cancelAct];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.kuangIV.image = image;
    
    //上传头像
    [MBManager showLoading];
    [XJUploader uploadImage:image progress:^(NSString *key, float percent) {
        
    } success:^(NSString * _Nonnull url) {
        
        self.imgUrl = url;
        [MBManager hideAlert];
        
        
    } failure:^{
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"上传失败"];
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (UILabel *)hintLb{
    if (!_hintLb) {
        _hintLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultRedColor text:@"实名认证后的身份证信息不可修改" font:defaultFont(14) textInCenter:YES];
        _hintLb.backgroundColor = RGB(255, 233, 237);
    }
    return _hintLb;
    
}

- (UIButton *)commintBtn{
    
    if (!_commintBtn) {
        _commintBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.view backColor:defaultRedColor nomalTitle:@"提交" titleColor:defaultWhite titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(comminAction)];
    }
    return _commintBtn;
}
- (UIView *)whiteBgView{
    if (!_whiteBgView) {
        
        _whiteBgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
    }
    return _whiteBgView;
    
}
- (UIImageView *)carameIV{
    if (!_carameIV) {
        _carameIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.whiteBgView imageUrl:nil placehoderImage:@"icPhotoPaperwork"];

    }
    
    return _carameIV;
    
}
- (UIImageView *)kuangIV{
    if (!_kuangIV) {
        _kuangIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.whiteBgView imageUrl:nil placehoderImage:@"xukuang"];
        _kuangIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImgAction)];
        [_kuangIV addGestureRecognizer:tap];
    }
    
    return _kuangIV;
    
}
- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        //创建UIImagePickerController对象，并设置代理和可编辑
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.editing = YES;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
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
