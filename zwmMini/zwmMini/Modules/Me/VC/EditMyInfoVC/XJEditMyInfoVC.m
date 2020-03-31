//
//  XJEditMyInfoVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditMyInfoVC.h"
#import "XJEditMyinfoHeadView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "XJUploader.h"
#import "XJEditInfoTableViewCell.h"
#import "XJEditinfoTagsTbCell.h"
#import "XJEditNicknameVC.h"
#import "XJEditMyIntroduceVC.h"
#import "XJEditAgeVC.h"
#import "ZHPickView.h"
#import "XJSelectJobsVC.h"
#import "XJPersonalTagsVC.h"
#import "XJSelectInterestVC.h"
#import "XJCheckingFaceVC.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "PECropViewController.h"
#import "XJUploadRealHeadImgVC.h"


static NSString *tableIdentifier = @"editTableviewidentifier";
static NSString *tagsTableIdentifier = @"editTagsTableviewidentifier";

@interface XJEditMyInfoVC ()<XJEditMyinfoHeadViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,PECropViewControllerDelegate>

@property(nonatomic,strong) XJEditMyinfoHeadView *headView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *titleArray;
@property(nonatomic,strong) NSMutableArray *detailArray;
@property (nonatomic, strong) ZHPickView *pickview;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic,assign) NSInteger clickIndex;
@property(nonatomic,strong) NSMutableArray *imagesArray;//图片显示url数组（完整的url）
@property(nonatomic,strong) NSMutableArray *pushUrlsArray;
@property(nonatomic,copy) NSString *nickNewname;
@property(nonatomic,copy) NSString *mybioNewStr;
@property(nonatomic,copy) NSString *ageNewStr;
@property(nonatomic,copy) NSString *heightNewStr;
@property(nonatomic,copy) NSString *weightNewStr;
@property(nonatomic,copy) NSString *conNewStr;
@property(nonatomic,copy) NSString *birthdayNew;
@property(nonatomic,assign) BOOL haveEdit;
@property (nonatomic, assign) BOOL didModifyNickName;
@property (nonatomic, assign) BOOL didModifySignture;
@property (nonatomic, assign) NSInteger signErrorCode;
@end

@implementation XJEditMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.clickIndex = 0;
    [self showBack:@selector(backAction)];
    [self showNavRightButton:@"保存" action:@selector(rightAction) image:nil imageOn:nil];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.imagesArray addObjectsFromArray:XJUserAboutManageer.uModel.photos];
    [self.headView setUpRefreshCollection:(NSArray *)self.imagesArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatejobsSuccessAction) name:@"updatejobs" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatetagssSuccessAction) name:@"updatetags" object:nil];
}

//更新工作
- (void)updatejobsSuccessAction{
    
    XJUserModel *umodel = XJUserAboutManageer.uModel;
    NSMutableString *muworstr = [[NSMutableString alloc] initWithString:@""];
    if (umodel.works_new.count > 0) {
        
        for (XJInterstsModel *wmodel in umodel.works_new) {
            [muworstr appendString:[NSString stringWithFormat:@"、%@",wmodel.content]];
        }
    }
    if (!NULLString(muworstr)) {
        [muworstr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    NSString *workStr = muworstr;
    [self.detailArray replaceObjectAtIndex:5 withObject:workStr];
    [self.tableView reloadData];
    
}
- (void)updatetagssSuccessAction {
    [self.tableView reloadData];
}

- (void)backAction{
    if (_pickview) {
        [_pickview remove];
    }
    if (self.haveEdit) {
            [self showAlerVCtitle:@"是否未保存资料返回？" message:@"" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
        [self.navigationController popViewControllerAnimated:YES];
            }  cancelBlock:^{
        
            }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightAction{
    NSLog(@"保存");
    [self chectAvatar];
}

- (void)chectAvatar{//检查头像
    
    if (XJUserAboutManageer.uModel.gender == 2) {
        // 女的
        [self girlCheckIsRealPhtoo];
    }else{
        // 男的
        XJPhoto *realphpto = XJUserAboutManageer.uModel.photos.firstObject;
        if (XJUserAboutManageer.uModel.faces.count == 0 || realphpto == nil || realphpto.face_detect_status != 3) {
            
            [self showAlerVCtitle:@"温馨提示" message:@"为确保用户资料真实,使用非真实头像将导致以下功能限制:\n* 无法设置微信号码" sureTitle:@"前往识别" cancelTitle:@"继续保存" sureBlcok:^{
                
                if (XJUserAboutManageer.uModel.faces.count == 0 ) {
                    
                    [self pushCheckFace];
                    
                }else{
                    //上传真实头像
                    
                    XJUploadRealHeadImgVC *upVC = [XJUploadRealHeadImgVC new];
                    [self.navigationController pushViewController:upVC animated:YES];
                    upVC.endBlock = ^{
//                        [self chectAvatar];
                        [MBManager showBriefAlert:@"上传真实头像成功"];
                    };
                }
            } cancelBlock:^{
                [self continueSaveUserInfo];
            }];
            return;
        }
        [self continueSaveUserInfo];
    }
}

// 女的校验头像
- (void)girlCheckIsRealPhtoo{
    
    XJPhoto *photo = self.imagesArray[0];
    
    [MBManager showWaitingWithTitle:@"检测头像中..."];
    NSDictionary *dic = @{@"photoUrl":photo.url,@"faces":XJUserAboutManageer.uModel.faces,@"photoId":photo.id};
    [AskManager POST:API_USER_ISLOGIN_CHECK_PHOTO dict:dic.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            NSString *isSame = data[@"isSame"];
            if([isSame isEqual: @"false"]){
                [MBManager showBriefAlert:data[@"message"]];
                
            }else{
                [self continueSaveUserInfo];
            }
        }
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        [MBManager hideAlert];
    }];
}

//继续保存
- (void)continueSaveUserInfo{
    
//    NSMutableDictionary *userInfoMutableDic = [user toDictionary].mutableCopy;
    @WeakObj(self);
    
    [MBManager showWaitingWithTitle:@"保存资料中..."];
    [self.pushUrlsArray removeAllObjects];
    for (XJPhoto *photo in self.imagesArray) {
        //转dic
        NSString *str = [photo yy_modelToJSONString];
        NSDictionary *dic = [XJUtils dictionaryWithJsonString:str];
        [self.pushUrlsArray addObject:dic];
    }
    
    NSString *text = self.heightNewStr;
    if ([text containsString:@"cm"]) {
        text = [text substringWithRange:NSMakeRange(0, [text length] - 2)];
    }
    
    NSMutableDictionary *allPushDic = @{@"photos":self.pushUrlsArray,
                                        @"nickname":self.nickNewname,
                                        @"bio":self.mybioNewStr,
                                        @"age":self.ageNewStr,
                                        @"height":text,
                                        @"weight":self.weightNewStr,
                                        @"constellation":self.conNewStr,
                                        @"birthday":self.birthdayNew}.mutableCopy;
    
    if (_didModifySignture) {
        allPushDic[@"bio_violation_type"] = @(_signErrorCode);
        _didModifySignture = NO;
    }
    else {
         [allPushDic removeObjectForKey:@"bio"];
        allPushDic[@"bio_violation_type"] = @(0);
    }
    
    if (_didModifyNickName) {
        allPushDic[@"nickname_status"] = @(1);
        _didModifyNickName = NO;
    }
    else {
        [allPushDic removeObjectForKey:@"nickname"];
        allPushDic[@"nickname_status"] = @(0);
    }
    
    if ([XJUserAboutManageer.uModel isAvatarManualReviewing]) {
        [allPushDic removeObjectForKey:@"avatar_manual_status"];
    }
    
    [AskManager POST:API_UPDATA_JOBS dict:allPushDic succeed:^(id data, XJRequestError *rError) {
        @StrongObj(self);
        if (!rError) {
            
            NSLog(@"%@",data);
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:umodel.uid name:umodel.nickname portrait:umodel.avatar];
//            XJUserModel *uamodel = XJUserAboutManageer.uModel;
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:umodel.uid];
            XJUserAboutManageer.uModel = umodel;
            [MBManager showBriefAlert:@"保存成功"];
            
            if ([self.delegate respondsToSelector:@selector(editCompleet:)]) {
                [self.delegate editCompleet:YES];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        [MBManager hideAlert];
    }];
}

//前往人脸识别
- (void)pushCheckFace{
    
    NSLog(@"前往人脸识别");
    XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
    [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
    //                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    [self presentViewController:lvc animated:YES completion:nil];
    lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
        
        [self checkIshack:bestImg];
        
    };
    
}
- (void)checkIshack:(UIImage *)bestimg{
    
    [MBManager showWaitingWithTitle:@"验证人脸中..."];
    [XJUploader uploadImage:bestimg progress:^(NSString *key, float percent) {
    } success:^(NSString * _Nonnull url) {
        
        [AskManager POST:API_PHOTOT_IS_HACK_POST dict:@{@"image_best":url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                NSString *isHack = data[@"isHack"];
                if ([isHack isEqualToString:@"true"]) {
                    [self showAlerVCtitle:@"检测失败" message:@"请重新刷脸" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                        
                    } cancelBlock:^{
                        
                    }];
                    
                }else{
                    [self pushFaces:url];
//                    [self chectAvatar];
//                    [self continueSaveUserInfo];
                }
            }else{
                
                [self showAlerVCtitle:@"检测失败" message:@"" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                    
                } cancelBlock:^{
                    
                }];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
        [MBManager hideAlert];
    } failure:^{
        [MBManager hideAlert];
    }];
    
}

//更新face到服务器
- (void)pushFaces:(NSString *)url{
    
    NSArray *urlArr = @[url];
    [AskManager POST:API_UPDATA_JOBS dict:@{@"faces":urlArr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            XJUserAboutManageer.uModel = umodel;
//            [MBManager showBriefAlert:@"上传活体成功"];
            XJUploadRealHeadImgVC *upVC = [XJUploadRealHeadImgVC new];
            [self.navigationController pushViewController:upVC animated:YES];
            upVC.endBlock = ^{
                //                        [self chectAvatar];
                [MBManager showBriefAlert:@"上传真实头像成功"];
            };
 
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)chaneIndexFrom:(NSInteger)fromIndex to:(NSInteger)toIndex{
    NSLog(@" form = %ld  to %ld = ",fromIndex,toIndex);
    [self.imagesArray exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
    self.haveEdit = YES;
}

- (void)clickPhoto:(NSInteger)index{
    
    NSLog(@"click图片 = %ld",index);
    self.clickIndex = index;
    //头像选项：拍照，从手机相册选择
    if (index == 0) {
        [self showImagePickerController];
   //其他删除
    }else{

        [self showDeleteAlerView:@"删除" doneAct:^{
            [self.imagesArray removeObjectAtIndex:index];
            [self.headView setUpRefreshCollection:self.imagesArray];
            self.haveEdit = YES;

        }];
    }
}

- (void)clickAddPhoto:(NSInteger)index{
    self.clickIndex = index;
    [self showImagePickerController];
}

#pragma mark ShowImagePickerController
- (void)showImagePickerController {
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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
    [self uploadImg:croppedImage];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

//上传头像
- (void)uploadImg:(UIImage *)image {
    
    //上传头像
    [MBManager showWaitingWithTitle:@"上传头像中..."];
    [XJUploader uploadImage:image progress:^(NSString *key, float percent) {
        
    } success:^(NSString * _Nonnull url) {
        
        //        NSString *fullUrl = [NSString stringWithFormat:@"%@%@",PICTURE,url];
        
        [AskManager POST:API_GET_PHOTOINFO dict:@{@"status":@(0),@"face_detect_status":@(0),@"url":url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                if (self.clickIndex == 0) {
                    
                    XJPhoto *photoModel = [XJPhoto yy_modelWithDictionary:data];
                    [self.imagesArray replaceObjectAtIndex:0 withObject:photoModel];
                    
                }else{
                    
                    XJPhoto *photoModel = [XJPhoto yy_modelWithDictionary:data];
                    [self.imagesArray addObject:photoModel];
                    
                }
                [self.headView setUpRefreshCollection:(NSArray *)self.imagesArray];
                self.haveEdit = YES;
                
                
            }
            [MBManager hideAlert];
            
        } failure:^(NSError *error) {
            
            [MBManager hideAlert];
            
            [MBManager showBriefAlert:@"上传失败"];
            
        }];
        
        
    } failure:^{
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"上传失败"];
        
    }];
}

#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        CGFloat height =  [XJUtils countTagsViewHeight:XJUserAboutManageer.uModel.tags_new]*54+50;
        return height;
    }
    if (indexPath.row == 8) {
        CGFloat height =  [XJUtils countTagsViewHeight:XJUserAboutManageer.uModel.interests_new]*54+50;
        return height;
    }
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row <7) {
        XJEditInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
        if (cell == nil) {
            cell = [[XJEditInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        }
        [cell setTitles:self.titleArray[indexPath.row] andDetail:self.detailArray[indexPath.row]];
        return cell;
    }
    
    XJEditinfoTagsTbCell *cell = [tableView dequeueReusableCellWithIdentifier:tagsTableIdentifier];
    if (cell == nil) {
        cell = [[XJEditinfoTagsTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagsTableIdentifier];
    }
    [cell setTagsWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJUserModel *uModel = XJUserAboutManageer.uModel;
    switch (indexPath.row) {
        case 0: {
            // 修改昵称
            XJEditNicknameVC *nameVC = [XJEditNicknameVC new];
            [self.navigationController pushViewController:nameVC animated:YES];
            nameVC.nameBlcok = ^(NSString * _Nonnull newNickname) {
                if ([self.nickNewname isEqualToString:newNickname]) {
                    self.didModifyNickName = YES;
                }
                self.nickNewname = newNickname;
                [self.detailArray replaceObjectAtIndex:0 withObject:newNickname];
                [self.tableView reloadData];
                self.haveEdit = YES;

            };
            break;
        }
        case 1: {
            // 修改自我介绍
            XJEditMyIntroduceVC *intreVC = [XJEditMyIntroduceVC new];
            
            NSString *desc = nil;
            if (!NULLString(self.mybioNewStr)) {
                desc = self.mybioNewStr;
            }
            else if (!NULLString(XJUserAboutManageer.uModel.bio)) {
                desc = XJUserAboutManageer.uModel.bio;
            }
            intreVC.desc = desc;
            
            [self.navigationController pushViewController:intreVC animated:YES];
            intreVC.myIntroBlock = ^(NSString * _Nonnull intorStr, NSInteger errorCode) {
                if ([self.mybioNewStr isEqualToString:intorStr]) {
                    self.didModifySignture = YES;
                    self.signErrorCode = errorCode;
                }
                self.mybioNewStr = intorStr;
                [self.detailArray replaceObjectAtIndex:1 withObject:intorStr];
                [self.tableView reloadData];
                self.haveEdit = YES;
                
            };
            break;
        }
        case 2: {
             //修改年龄
            XJUserModel *umodel = XJUserAboutManageer.uModel;
            
            NSInteger age = 0;
            NSString *con = nil;
            NSString *birthday = nil;
            if (!NULLString(self.ageNewStr)) {
                age = [self.ageNewStr integerValue];
            }
            else {
                age = umodel.age?:0;
            }
            if (!NULLString(self.conNewStr)) {
                con = self.conNewStr;
            }
            else {
                con = umodel.constellation ? :@"";
            }
            
            if (!NULLString(self.birthdayNew)) {
                birthday = self.birthdayNew;
            }
            else {
                birthday = NULLString([NSString dateToString:umodel.birthday])? nil:[NSString dateToString:umodel.birthday];
            }
            
            if (uModel.realname.status == 2  && uModel.birthday) {
                break;
            }
            XJEditAgeVC *ageVC = [[XJEditAgeVC alloc] initWithAge:age con:con birthday:birthday];
            [self.navigationController pushViewController:ageVC animated:YES];

            ageVC.ageBlock = ^(NSDate * _Nonnull ageDate, NSString * _Nonnull conStr) {
                self.ageNewStr = [NSString stringWithFormat:@"%ld",[NSDate ageWithBirthday:ageDate]];
                self.conNewStr = conStr;
                self.birthdayNew = NULLString([NSString dateToString:ageDate])? @"":[NSString dateToString:ageDate];
                [self.detailArray replaceObjectAtIndex:2 withObject:self.ageNewStr];
                [self.detailArray replaceObjectAtIndex:6 withObject:conStr];
                [self.tableView reloadData];
                self.haveEdit = YES;

            };
            break;
        }
        case 3: {
            // 修改身高
            [self editHeight];
            break;
        }
        case 4: {
            // 修改体重
            [self editWeight];
            break;
        }
        case 5: {
            // 修改职业
            XJSelectJobsVC *jobsVC = [XJSelectJobsVC new];
            [self.navigationController pushViewController:jobsVC animated:YES];
            break;
        }
        case 6: {
            // 修改星座
            XJUserModel *umodel = XJUserAboutManageer.uModel;
            
            NSInteger age = 0;
            NSString *con = nil;
            NSString *birthday = nil;
            if (!NULLString(self.ageNewStr)) {
                age = [self.ageNewStr integerValue];
            }
            else {
                age = umodel.age?:0;
            }
            if (!NULLString(self.conNewStr)) {
                con = self.conNewStr;
            }
            else {
                con = umodel.constellation ? :@"";
            }
            
            if (!NULLString(self.birthdayNew)) {
                birthday = self.birthdayNew;
            }
            else {
                birthday = NULLString([NSString dateToString:umodel.birthday])? nil:[NSString dateToString:umodel.birthday];
            }
            
            if (uModel.realname.status == 2  && uModel.birthday) {
                break;
            }
            XJEditAgeVC *ageVC = [[XJEditAgeVC alloc] initWithAge:age con:con birthday:birthday];
            [self.navigationController pushViewController:ageVC animated:YES];
            
            ageVC.ageBlock = ^(NSDate * _Nonnull ageDate, NSString * _Nonnull conStr) {
                self.ageNewStr = [NSString stringWithFormat:@"%ld",[NSDate ageWithBirthday:ageDate]];
                self.conNewStr = conStr;
                self.birthdayNew = NULLString([NSString dateToString:ageDate])? @"":[NSString dateToString:ageDate];
                [self.detailArray replaceObjectAtIndex:2 withObject:self.ageNewStr];
                [self.detailArray replaceObjectAtIndex:6 withObject:conStr];
                [self.tableView reloadData];
                self.haveEdit = YES;
                
            };
            break;
        }
        case 7: {
            // 个人标签
            XJPersonalTagsVC *tagsVC = [XJPersonalTagsVC new];
            [self.navigationController pushViewController:tagsVC animated:YES];
        }
            break;
        case 8: {
            // 兴趣爱好
            XJSelectInterestVC *tagsVC = [XJSelectInterestVC new];
            [self.navigationController pushViewController:tagsVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)editHeight {
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 140; i<= 200; i++) {
        [data addObject:[NSString stringWithFormat:@"%dcm", i]];
    }
    @WeakObj(self);
    NSString *height = data.firstObject;
    if (!NULLString(self.heightNewStr)) {
        height = self.heightNewStr;
    }
    else {
        height = [NSString stringWithFormat:@"%ldcm",(long)XJUserAboutManageer.uModel.height];
    }
    
    _pickview = [[ZHPickView alloc] initPickviewWithArray:data defaultValue:height];

    _pickview.selectDoneBlock = ^(NSArray *items) {
        @StrongObj(self);
        NSMutableString *temstr = [[NSMutableString alloc] initWithString:items.firstObject];
        [temstr deleteCharactersInRange:NSMakeRange(3, 2)];
        self.heightNewStr = [NSString stringWithFormat:@"%@cm",temstr];
        [self.detailArray replaceObjectAtIndex:3 withObject:self.heightNewStr];
        [self.tableView reloadData];
        self.haveEdit = YES;

    };
    [_pickview showInView:self.view];
}

- (void)editWeight {
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:@[@"保密"]];
    for (int i = 40; i < 100; i++) {
        [data addObject:[NSString stringWithFormat:@"%dkg", i]];
    }
    @WeakObj(self);
    NSString *width = data.firstObject;
    if (!NULLString(self.weightNewStr)) {
        if ([self.weightNewStr isEqualToString:@"保密"]) {
            width = @"保密";
        }
        else {
            width = [NSString stringWithFormat:@"%@kg",self.weightNewStr];
        }
    }
    else {
        if (XJUserAboutManageer.uModel.weight == -1) {
            width = @"保密";
        }
        else {
            width = [NSString stringWithFormat:@"%ldkg",(long)XJUserAboutManageer.uModel.weight];
        }
    }
    
    _pickview = [[ZHPickView alloc] initPickviewWithArray:data defaultValue:width];
    
//    _pickview=[[ZHPickView alloc] initPickviewWithArray:data isHaveNavControler:NO];
    _pickview.selectDoneBlock = ^(NSArray *items) {
        @StrongObj(self);
        if ([[items firstObject] isEqualToString:@"保密"]) {
            self.weightNewStr = @"-1";
        }else{
            
            NSMutableString *temstr = [[NSMutableString alloc] initWithString:items.firstObject];
            [temstr deleteCharactersInRange:NSMakeRange(2, 2)];
            self.weightNewStr = [NSString stringWithFormat:@"%@",temstr];
        }
        NSString *displaystr = [self.weightNewStr isEqualToString:@"-1"] ? @"保密":self.weightNewStr;
        [self.detailArray replaceObjectAtIndex:4 withObject:displaystr];
        [self.tableView reloadData];
        self.haveEdit = YES;

       
    };
    [_pickview showInView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated {
   [ super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_pickview) {
        [_pickview remove];
    }
}

#pragma mark lazy
- (XJEditMyinfoHeadView *)headView {
    if (!_headView) {
        _headView = [[XJEditMyinfoHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _headView.delegate = self;
    }
    return _headView;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        //创建UIImagePickerController对象，并设置代理和可编辑
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.editing = YES;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _imagesArray;
    
}

- (NSMutableArray *)pushUrlsArray {
    if (!_pushUrlsArray) {
        _pushUrlsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _pushUrlsArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        UIView *footerv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        footerv.backgroundColor = RGB(240, 240, 240);
        [_tableView setTableFooterView:footerv];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableHeaderView:self.headView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"昵称",@"自我介绍",@"年龄",@"身高",@"体重",@"职业",@"星座"];
    }
    return _titleArray;
}

- (NSMutableArray *)detailArray {
    if (!_detailArray) {
        XJUserModel *umodel = XJUserAboutManageer.uModel;
        
        NSString *nameStr = NULLString(umodel.nickname) ? @"":umodel.nickname ;
        NSString *bioStr = NULLString(umodel.bio)? @"":umodel.bio;
        NSString *ageStr =  umodel.age == 0 ? @"":[NSString stringWithFormat:@"%ld",(long)umodel.age];
        NSString *hieghtinStr = NULLString(umodel.heightIn) ? @"":umodel.heightIn;
        NSString *weightinStr = NULLString(umodel.weightIn)? @"":umodel.weightIn;
        NSMutableString *muworstr = [[NSMutableString alloc] initWithString:@""];
        if (umodel.works_new.count > 0) {
           
            for (XJInterstsModel *wmodel in umodel.works_new) {
                [muworstr appendString:[NSString stringWithFormat:@"、%@",wmodel.content]];
            }
        }
        if (!NULLString(muworstr)) {
            [muworstr deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        NSString *workStr = muworstr;
        NSString *constellationStr = NULLString(umodel.constellation)? @"":umodel.constellation;
        //赋值
        self.nickNewname = nameStr;
        self.mybioNewStr = bioStr;
        self.ageNewStr = ageStr;
        self.heightNewStr = umodel.height ? [NSString stringWithFormat:@"%ld",(long)umodel.height]:@"";
        self.weightNewStr = umodel.weight ? [NSString stringWithFormat:@"%ld",(long)umodel.weight]:@"";
        self.conNewStr = constellationStr;
        self.birthdayNew = NULLString([NSString dateToString:umodel.birthday])? @"":[NSString dateToString:umodel.birthday];
        
        _detailArray = @[nameStr,bioStr,ageStr,hieghtinStr,weightinStr,workStr,constellationStr].mutableCopy;
    }
    return _detailArray;
}

@end
