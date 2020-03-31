//
//  XJUtils.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XJUtils : NSObject

//判断是否是手机号
+ (BOOL)isPhoneNumber:(NSString *)mobile;

//判断密码是否是字母数字
+ (BOOL)isThePasswordNotTooSimpleWithPasswordString:(NSString *)passwordString;

//获取手机型号
+ (NSString*)deviceVersion;


// 系统通知是否已开启  NO:未开启
+ (BOOL)isOpenSystemNotification;


// 是否有相册权限  NO:无权限
+ (BOOL)isPhotoPermissions;


// 是否有相机权限  NO:无权限
+ (BOOL)isCameraPermissions;



+ (BOOL)isAllowPhotoLibrary;
/**
 *  是否允许相机访问
 */
+ (BOOL)isAllowCamera;
/**
 *  是否允许麦克风访问
 */
+ (BOOL)isAllowAudio;
/**
 *  是否允许定位
 */
+ (BOOL)isAllowLocation;
/**
 *  是否允许通知
 */
+ (BOOL)isAllowNotification;
/**
 *  是否允许访问通讯录
 */
+ (void)checkContactAuthorization:(void(^)(bool isAuthorized))block;

//获取缓存大小
+ (CGFloat)getCachSize;
//清除缓存
+ (void)handleClearCach;

+ (NSData *)imageRepresentationDataWithImage:(UIImage *)image;

//个人页压缩图片
+ (NSData *)userImageRepresentationDataWithImage:(UIImage *)image;

+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

// 计算 text 对应的高度
+ (CGFloat)heightForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont labelWidth:(CGFloat)labelWidth;

//计算 text 对应的宽度
+ (CGFloat)widthForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont;

//dic to json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//jsonstring to dic
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//设置间距
+ (NSMutableAttributedString *)setLineSpace:(NSString *)string space:(CGFloat)space fontSize:(CGFloat)fontSize color:(UIColor *)color;
//计算tags行数
+ (NSInteger)countTagsViewHeight:(NSArray *)arr;

//bundleName
+ (NSString *)bundleName;

//bundleVersion
+ (NSString *)bundleVersion;

//phoneVersion
+ (NSString *)phoneVersion;

@end

