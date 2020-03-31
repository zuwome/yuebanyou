//
//  XJUploader.h
//  zwmMini
//
//  Created by Batata on 2018/11/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJUploader : NSObject

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString * url))success failure:(void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
