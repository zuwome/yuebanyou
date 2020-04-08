//
//  XJRegistDoneVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRegistDoneVC.h"
#import "XJRegistDoneView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "XJUploader.h"
#import "PECropViewController.h"
@interface XJRegistDoneVC ()<XJRegistDoneViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
@property(nonatomic,strong) XJRegistDoneView *doneView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong) UIImage *selectImage;
@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,copy) NSString *nikcName;
@property(nonatomic,copy) NSString *wechatNum;
@property(nonatomic,copy) NSString *url;//头像url
@property(nonatomic,assign) NSInteger face_detect_status;//3代表人脸有比对通过 2代表人脸有比对但不通过 1代表人脸未比对
@property(nonatomic,assign) NSInteger status;//0=>审核不通过 1=>待审核 2=>已审核 3=>待确认



@end

@implementation XJRegistDoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传头像";
    [self.view addSubview:self.doneView];
    [self.doneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.url = @"";
    self.face_detect_status = 1;
    self.status = 1;


}

- (void)clickHeadIV:(UIImageView *)IV{
    NSLog(@"点击头像");
    self.headIV = IV;
    [self showImagePickerController];
    
}
- (void)nameText:(NSString *)name{
    NSLog(@"name = %@",name);
    self.nikcName = name;

}
- (void)wechatText:(NSString *)wechat{
    NSLog(@"wechat = %@",wechat);
    self.wechatNum = wechat;

    
}
- (void)clickDone{
    NSLog(@"点击完成");
    if (!self.selectImage) {
        [MBManager showBriefAlert:@"头像不能为空"];
        return;
    }
    if (NULLString(self.nikcName)) {
        [MBManager showBriefAlert:@"昵称不能为空"];
        return;

    }
//    if (NULLString(self.wechatNum) && !_isBoy) {
//        [MBManager showBriefAlert:@"微信号不能为空"];
//        return;
//    }
    
   
    
    
    
    //女要校验照片     //有人脸校验头像没有就不校验(女的一定有人脸男的不一定)

    if (!_isBoy) {
        
        [self checkHeadImage];
        
        
    }else if(_isBoy && !_isSkip){
        
        [self checkHeadImage];
        
    }else{
        
        [self sinUpFinish];
    }
   
}


//校验
- (void)checkHeadImage{
    
    
    
    if (NULLString(self.faceUrl)) {
        self.faceUrl = @"";
    }
    [MBManager showWaitingWithTitle:@"校验头像中..."];
    //@"http://img.movtrip.com/5bf3c8533a10dd1863a1ff19/1542764955291233.jpg"
    [AskManager POST:API_USER_SIGN_CHECK_PHOTO dict:@{@"photoUrl":self.url,@"faces":@[self.faceUrl]}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            
            [MBManager hideAlert];
            
//            NSLog(@"data = %@",data);
            NSString *isSame = data[@"isSame"];
            if ([isSame isEqualToString:@"true"]) {
                self.face_detect_status = 3;
                [self sinUpFinish];

            }else{
                //男的不管验证通没通过都注册成功
                self.face_detect_status = 2;

                if (self.isBoy) {
                    [self sinUpFinish];
                    
                }else{
                    [MBManager showBriefAlert:@"请上传真实头像"];
                }
            }
            
            
        }else{
            
            //男的不管验证通没通过都注册成功
            
            self.face_detect_status = 2;
        
            if (self.isBoy) {
                [self sinUpFinish];
            }
          
            [MBManager hideAlert];

            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        [MBManager hideAlert];

    }];
    
    
    
}


- (void)sinUpFinish{
    
    [MBManager showWaitingWithTitle:@"注册中..."];
    //type: 1个人签名 2昵称 3公开么么答 4私信么么答 5技能介绍
   
    [AskManager POST:API_CHECK_TEXT_POST dict:@{@"content":self.nikcName,@"type":@(2)}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:self.para];
            if (!NULLString(self.wechatNum)) {
                param[@"wechat_no"]=self.wechatNum;
            }
            if (!NULLString(self.faceUrl)) {
                param[@"faces"] = @[self.faceUrl];
            }
            param[@"nickname"] = self.nikcName;
            param[@"gender"] = self.isBoy? @(1):@(2);
            param[@"photos"] = @[
                                 @{
                                     @"face_detect_status": @(self.face_detect_status),
                                     @"status": @(self.status),
                                     @"url": self.url }
                                 ];
            param[@"uuid"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            //    NSLog(@"ppp= %@",param);
            
            [AskManager POST:API_REGIST_POST dict:param succeed:^(id data, XJRequestError *rError) {
                if (!rError) {
                    //            NSLog(@"data = %@",data);
                    XJUserAboutManageer.access_token = data[@"access_token"];
                    XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
                    XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data[@"user"]];
                    XJUserAboutManageer.uModel = userModel;
                    XJUserAboutManageer.isLogin = YES;
                    [self getRongToken];
                    [MBManager showBriefAlert:@"注册成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RegistrationSuccessNotification object:nil];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    
                    
                }
                [MBManager hideAlert];
                
            } failure:^(NSError *error) {
                
                [MBManager hideAlert];
                
            }];
            
            [MBManager hideAlert];

        }
        
        [MBManager hideAlert];

        
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];

    }];
  
}

//获取融云token
- (void)getRongToken{
    
    [AskManager GET:API_GET_RONGIM_TOKEN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            XJUserAboutManageer.rongTonek = data[@"token"];
            [[XJRongIMManager sharedInstance] connectRongIM];
        }
        
    } failure:^(NSError *error) {
        
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
    self.selectImage = image;
    [self edit:image];
    

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
        [MBManager showBriefAlert:@"上传成功"];

        
    } failure:^{
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"上传失败"];
        
    }];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (XJRegistDoneView *)doneView{
    if (!_doneView) {
        _doneView = [[XJRegistDoneView alloc] initWithFrame:CGRectZero];
        _doneView.delegate = self;
        _doneView.isBoy = _isBoy;
    }
    return _doneView;
    
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
