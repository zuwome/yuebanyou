//
//  XJUtils.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUtils.h"
#import "sys/utsname.h"
#import "UIAlertView+Blocks.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@implementation XJUtils

+ (BOOL)isPhoneNumber:(NSString *)mobile{
    NSString *phoneRegex = @"^((148|198|146|166|174|199|(13[0-9])|(15([0-3]|[5-9]))|(17[678])|(18[0-9]))\\d{8})|(0\\d{2}-\\d{8})|(0\\d{3}-\\d{7})$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isThePasswordNotTooSimpleWithPasswordString:(NSString *)passwordString {
    //字母和数字
    NSString * passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    //字母数字特殊字符
    NSString * specialCharactersRegex = @"^(?![0-9]+$)(?![^0-9]+$)(?![a-zA-Z]+$)(?![^a-zA-Z]+$)(?![a-zA-Z0-9]+$)[a-zA-Z0-9\\S]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    NSPredicate *specialCharactersPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", specialCharactersRegex];
    
    BOOL isMatch = [pred evaluateWithObject:passwordString];
    
    BOOL isSpecialMatch = [specialCharactersPred evaluateWithObject:passwordString];
    
    return (isMatch||isSpecialMatch)? YES:NO;
}

+ (BOOL)isAllowPhotoLibrary
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        //8一下的不支持 就不做未授权时候的判断了
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
            [UIAlertView showWithTitle:NSLocalizedString(@"无法打开照相机", nil)
                               message:NSLocalizedString(@"请在“设置-隐私-相册”选项中允许《伴友》访问你的相册",nil)
                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
                     otherButtonTitles:nil
                              tapBlock:nil];
            return NO;
        }
        return YES;
    } else {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
            [UIAlertView showWithTitle:nil
                               message:NSLocalizedString(@"是否开启相册权限",nil)
                     cancelButtonTitle:NSLocalizedString(@"取消", nil)
                     otherButtonTitles:@[NSLocalizedString(@"确定", nil)]
                              tapBlock:
             ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                 if (buttonIndex) {
                     if (UIApplicationOpenSettingsURLString != NULL) {
                         NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                         [[UIApplication sharedApplication] openURL:appSettings];
                     }
                 }
             }];
            return NO;
        }
        return YES;
    }
}

+ (BOOL)isAllowCamera
{
    //判断是否有相机的权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[[UIDevice currentDevice] systemVersion] integerValue]< 8) {
                [UIAlertView showWithTitle:NSLocalizedString(@"无法打开照相机", nil)
                                   message:NSLocalizedString(@"请在“设置-隐私-相机”选项中允许《伴友》访问你的相机",nil)
                         cancelButtonTitle:NSLocalizedString(@"确定", nil)
                         otherButtonTitles:nil
                                  tapBlock:nil];
            }else
            {
                [UIAlertView showWithTitle:@"开启相机权限"
                                   message:NSLocalizedString(@"在“设置-伴友”中开启相机就可以开始使用本功能哦~",nil)
                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                         otherButtonTitles:@[NSLocalizedString(@"设置", nil)]
                                  tapBlock:
                 ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                     if (buttonIndex) {
                         if (UIApplicationOpenSettingsURLString != NULL) {
                             NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                             [[UIApplication sharedApplication] openURL:appSettings];
                         }
                     }
                 }];
            }
            
        });
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isOpenSystemNotification {
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
        return NO;
    }
    return YES;
}

+ (BOOL)isPhotoPermissions {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (NSMutableAttributedString *)setLineSpace:(NSString *)string space:(CGFloat)space fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    [paragraphStyle setLineSpacing:space];
    
    return attributedString;
}


+ (NSInteger)countTagsViewHeight:(NSArray *)arr{
    
    ///button 文字两边空隙
    CGFloat  btnEnhanceW = 16;
    ///button 左右之间间距
    CGFloat  btnMargin = 18;
    ///button 上下间距
    //    CGFloat  btnMarginTB = 20;
    //    ///button 高度
    //    CGFloat  btnH = 44;
    NSInteger countLines = 0;
    
    
    CGFloat tempSum = 0;
    NSInteger btnMargincount = 0;
    
    for (int i = 0; i<arr.count; i++) {
        
        XJInterstsModel *mm = arr[i];
        
        CGFloat btnW =  btnEnhanceW*2 + btnMargin*btnMargincount+[XJUtils widthForCellWithText:mm.content fontSize:12];
        tempSum   += btnW;
        if (tempSum < (kScreenWidth- 70) ) {
            
            btnMargincount +=1 ;
            continue;
            
        }else{
            
            countLines += 1 ;
            tempSum = btnW;
            btnMargincount = 0;
            
        }
        
    }
    
    return countLines +1;
    
}

+ (BOOL)isCameraPermissions {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        return NO;
    }
    return YES;
}


+ (BOOL)isAllowAudio
{
    //判断是否有相机的权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[[UIDevice currentDevice] systemVersion] integerValue]< 8) {
                [UIAlertView showWithTitle:NSLocalizedString(@"无法访问麦克风", nil)
                                   message:NSLocalizedString(@"请在“设置-隐私-麦克风”选项中允许《伴友》访问你的麦克风",nil)
                         cancelButtonTitle:NSLocalizedString(@"确定", nil)
                         otherButtonTitles:nil
                                  tapBlock:nil];
            }else
            {
                [UIAlertView showWithTitle:@"开启麦克风权限"
                                   message:@"在“设置-伴友”中开启麦克风就可以开始使用本功能哦~"
                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                         otherButtonTitles:@[NSLocalizedString(@"设置", nil)]
                                  tapBlock:
                 ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                     if (buttonIndex) {
                         if (UIApplicationOpenSettingsURLString != NULL) {
                             NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                             [[UIApplication sharedApplication] openURL:appSettings];
                         }
                     }
                 }];
            }
            
        });
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAllowLocation
{
    //判断定位
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        //无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[[UIDevice currentDevice] systemVersion] integerValue]< 8) {
                [UIAlertView showWithTitle:NSLocalizedString(@"定位服务未开启", nil)
                                   message:NSLocalizedString(@"您尚未开启定位功能，无法准确获取定位消息。请在“设置-隐私-定位服务中”，找到“伴友”并打开来获取最完整的服务",nil)
                         cancelButtonTitle:NSLocalizedString(@"确定", nil)
                         otherButtonTitles:nil
                                  tapBlock:nil];
            }else
            {
                [UIAlertView showWithTitle:nil
                                   message:NSLocalizedString(@"您尚未开启定位功能，无法准确获取定位消息。",nil)
                         cancelButtonTitle:NSLocalizedString(@"忽略", nil)
                         otherButtonTitles:@[NSLocalizedString(@"去开启", nil)]
                                  tapBlock:
                 ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                     if (buttonIndex) {
                         if (UIApplicationOpenSettingsURLString != NULL) {
                             NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                             [[UIApplication sharedApplication] openURL:appSettings];
                         }
                     }
                 }];
            }
        });
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAllowNotification
{
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 8) {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type) {
            return YES;
        } else {
            [UIAlertView showWithTitle:NSLocalizedString(@"消息通知功能未开启", nil)
                               message:NSLocalizedString(@"您尚未开启新消息通知功能，无法及时获得邀约等重要消息。请在设置-通知中心中，找到“伴友”并打开通知来获取最完整的服务。",nil)
                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
                     otherButtonTitles:nil
                              tapBlock:nil];
            
            return NO;
        }
    } else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        } else {
            [UIAlertView showWithTitle:nil
                               message:NSLocalizedString(@"您尚未开启新消息通知功能，无法及时获得订单等重要消息。",nil)
                     cancelButtonTitle:NSLocalizedString(@"忽略", nil)
                     otherButtonTitles:@[NSLocalizedString(@"去开启", nil)]
                              tapBlock:
             ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                 if (buttonIndex) {
                     if (UIApplicationOpenSettingsURLString != NULL) {
                         NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                         [[UIApplication sharedApplication] openURL:appSettings];
                     }
                 }
             }];
            
            return NO;
        }
    }
    
    return YES;
}
+ (void)checkContactAuthorization:(void(^)(bool isAuthorized))block
{
    if (IOS9_OR_LATER) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined || status == CNAuthorizationStatusAuthorized) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (error)
                     {
                         block(NO);
                     }
                     else if (!granted)
                     {
                         block(NO);
                     }
                     else
                     {
                         block(YES);
                     }
                 });
             }];
        } else {
            block(NO);
        }
    } else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusNotDetermined || status == kABAuthorizationStatusAuthorized) {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                     {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             if (error)
                                                             {
                                                                 NSLog(@"Error: %@", (__bridge NSError *)error);
                                                                 block(NO);
                                                             }
                                                             else if (!granted)
                                                             {
                                                                 block(NO);
                                                             }
                                                             else
                                                             {
                                                                 block(YES);
                                                             }
                                                         });
                                                     });
        } else {
            block(NO);
        }
    }
}

//图片压缩
+ (NSData *)imageRepresentationDataWithImage:(UIImage *)image
{
    NSData *imageDate = UIImagePNGRepresentation(image);
    NSInteger perMBBytes = 1024;
    NSLog(@"originimagesize === %ld",imageDate.length/perMBBytes);
    NSInteger imageSize  =  imageDate.length / perMBBytes;
    NSData *appendImageData = [[NSData alloc]init];
    if (imageSize > 0 && imageSize <  500)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.8);
    }
    else if (imageSize >= 500 && imageSize < 2000)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.5);
    }
    else if (imageSize >= 2000 )
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.2);
    }
    
    NSLog(@"imagesize === %ld",appendImageData.length/perMBBytes);
    return appendImageData;
}

+ (NSData *)userImageRepresentationDataWithImage:(UIImage *)image
{
    NSData *imageDate = UIImagePNGRepresentation(image);
    NSInteger perMBBytes = 1024;
    NSLog(@"originimagesize === %ld",imageDate.length/perMBBytes);
    NSInteger imageSize  =  imageDate.length / perMBBytes;
    NSData *appendImageData = [[NSData alloc]init];
    if (imageSize > 0 && imageSize <  500)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.8);
    }
    else if (imageSize >= 500 && imageSize < 2000)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.6);
    }
    else if (imageSize >= 2000)
    {
        appendImageData = UIImageJPEGRepresentation(image, 0.4);
    }
    
    NSLog(@"imagesize === %ld",appendImageData.length/perMBBytes);
    return appendImageData;
}

+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageDate = UIImagePNGRepresentation(newImage);
    NSInteger perMBBytes = 1024;
    NSInteger imageSize  =  imageDate.length / perMBBytes;
    
    NSData *appendImageData;
    if (imageSize > 26)
    {
        appendImageData = UIImageJPEGRepresentation([UIImage imageWithData:imageDate], 0.1);
    }else
    {
        appendImageData = imageDate;
    }
    return appendImageData;
}

+ (CGFloat)heightForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont labelWidth:(CGFloat)labelWidth
{
    CGFloat titleHeight = 0.0;
    if ([contentText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:contentText attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:labelFont]}];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        titleHeight = ceilf(rect.size.height);
    }
    
    return titleHeight;
}

+ (CGFloat)widthForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont
{
    CGFloat titleWidth;
    if ([contentText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:contentText
                                                                             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:labelFont]}];
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        titleWidth = ceilf(rect.size.width);
    }
    
    return titleWidth;
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }

    return dic;
}
+ (CGFloat)getCachSize {
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    //获取自定义缓存大小//用枚举器遍历 一个文件夹的内容
    //1.获取 文件夹枚举器
    NSString*myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];NSDirectoryEnumerator*enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    __block NSUInteger count =0;
    //2.遍历
    for(NSString*fileName in enumerator) {
        NSString*path = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary*fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
     count += fileDict.fileSize;
    }
        //自定义所有缓存大小
        // 得到是字节  转化为
        CGFloat totalSize = ((CGFloat)imageCacheSize + count)/1024/1024;
        return totalSize;
}
+ (void)handleClearCach {
    //删除两部分//1.删除 sd 图片缓存
    //先清除内存中的图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘的缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    //2.删除自己缓存
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
    
}

//获取手机型号
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    // 增加新设备型号
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3" ])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,11"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad6,12"])      return @"iPad 4";
    //新ipad
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5";
    if ([deviceString isEqualToString:@"iPad7,5"])      return @"iPad 6";
    if ([deviceString isEqualToString:@"iPad7,6"])      return @"iPad 6";

    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}
+ (NSString *)bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)bundleVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
+ (NSString *)phoneVersion{
    
    return [[UIDevice currentDevice] systemVersion];
   
}

@end
