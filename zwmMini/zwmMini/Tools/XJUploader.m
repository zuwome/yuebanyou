//
//  XJUploader.m
//  zwmMini
//
//  Created by Batata on 2018/11/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUploader.h"

@implementation XJUploader




+ (void)putData:(NSData *)data next:(QNUpCompletionHandler)next {
    NSString *token = XJUserAboutManageer.qiniuUploadToken;
    XJUserModel *umodel = XJUserAboutManageer.uModel;
    NSString *uid ;
    if (umodel) {
    uid = umodel.uid;

    }
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *key;
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    if (uid) {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",uid,timeInterval+[strRandom integerValue]];
    } else {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",strRandom,timeInterval+[strRandom integerValue]];
    }
//    NSLog(@"timeinterval ====== %f\n ===== %ld KEY ====== %@",[[NSDate date] timeIntervalSince1970],(long)timeInterval,key);
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      next(info, key, resp);
                  });
                  if (!resp) {
                      
                      
                  }
                  
                  
              } option:nil];
}

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString * url))success failure:(void (^)(void))failure
{
    NSData *data = [XJUtils imageRepresentationDataWithImage:image];
    NSString *token = XJUserAboutManageer.qiniuUploadToken;
    XJUserModel *umodel = XJUserAboutManageer.uModel;
    NSString *uid ;
    if (umodel) {
        uid = umodel.uid;
    }
    
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *key;
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    if (uid) {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",uid,timeInterval+[strRandom integerValue]];
    } else {
        key = [NSString stringWithFormat:@"%@/%ld.jpg",strRandom,timeInterval+[strRandom integerValue]];
    }
//    NSLog(@"KEY ====== %@",key);
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (info.statusCode == 200 && resp) {
                          NSString *url = resp[@"key"];
                          if (success) {
                              success(url);
                          }
                      } else {
                          if (failure) {
                              failure();
                          }
//                          [self uploadLogs:info key:key isImage:YES];
                      }
                  });
              } option:nil];
    
}

@end
