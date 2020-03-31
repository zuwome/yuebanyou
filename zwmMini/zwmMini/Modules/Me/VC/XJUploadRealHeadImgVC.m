//
//  XJUploadRealHeadImgVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/17.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUploadRealHeadImgVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "PECropViewController.h"


@interface XJUploadRealHeadImgVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UIView *gradienView;
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,copy) NSString *url;//头像url
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation XJUploadRealHeadImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传真实头像";
    
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.width.height.mas_equalTo(140);
    }];
    self.headIV.layer.cornerRadius = 70;
    self.headIV.layer.masksToBounds = YES;
    
    [self.gradienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.headIV.mas_bottom).offset(150);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(60);
    }];
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gradienView);
    }];
}

- (void)tapIV{
    [self showImagePickerController];
}

- (void)doneAction{
    
    if (NULLString(self.url)) {
        [MBManager showBriefAlert:@"请选择头像"];
        return;
    }
    [MBManager showWaitingWithTitle:@"正在保存用户信息..."];
    
    [AskManager POST:API_UPDATE_USER_AVATAR_POST dict:@{@"avatar_url":self.url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            XJUserAboutManageer.uModel = umodel;
            if (self.endBlock) {
                self.endBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBManager hideAlert];

    } failure:^(NSError *error) {
        [MBManager hideAlert];

    }];
}

- (void)checkImg{
    
    XJPhoto *photo = XJUserAboutManageer.uModel.photos.firstObject;
    [MBManager showWaitingWithTitle:@"检测头像中..."];
    NSDictionary *dic = @{@"photoUrl":self.url,@"faces":XJUserAboutManageer.uModel.faces,@"photoId":photo.id};
    [AskManager POST:API_USER_ISLOGIN_CHECK_PHOTO dict:dic.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            NSString *isSame = data[@"isSame"];
            if([isSame isEqual: @"false"]){
                
                [MBManager showBriefAlert:data[@"message"]];

                
            }else{
                
                [MBManager showBriefAlert:@"检测成功"];
                
            }
            
        }
        
        [MBManager hideAlert];
        
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
    [self edit:image];
  
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


//图片裁剪
- (void)edit:(UIImage *)originalImage{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = originalImage;
    controller.keepingCropAspectRatio = YES;
    UIImage *image = originalImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    [controller resetCropRect];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.headIV.image = croppedImage;
    [self uploadImg:croppedImage];
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)uploadImg:(UIImage *)image{
    
    //上传头像
    [MBManager showWaitingWithTitle:@"上传头像中..."];
    [XJUploader uploadImage:image progress:^(NSString *key, float percent) {
        
    } success:^(NSString * _Nonnull url) {
        
        [MBManager hideAlert];
        self.url = url;
        [self checkImg];
        
    } failure:^{
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"上传失败"];
        
    }];
    
}

#pragma mark lazy
- (UIImageView *)headIV{
    
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.view imageUrl:@"" placehoderImage:@"morentouxiang"];
        _headIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapIV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIV)];
        [_headIV addGestureRecognizer:tapIV];
    }
    return _headIV;
}


- (UIView *)gradienView{
    
    if (!_gradienView) {
        
        _gradienView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 60)];
        [_gradienView.layer addSublayer:gradientLayer];
        _gradienView.layer.cornerRadius = 30;
        _gradienView.layer.masksToBounds = YES;
    }
    return _gradienView;
}
- (UIButton *)doneBtn{
    
    if (!_doneBtn) {
        
        
        
        _doneBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.gradienView backColor:defaultClearColor nomalTitle:@"完成" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(doneAction)];
        
        
    }
    return _doneBtn;
    
    
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
