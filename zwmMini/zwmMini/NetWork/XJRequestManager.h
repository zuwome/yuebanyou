//
//  XJRequestManager.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AskManager [XJRequestManager sharedInstance]
@class XJRequestError;
typedef void (^requestCallback)(XJRequestError *error, id data, NSURLSessionDataTask *task);

@interface XJRequestManager : NSObject

+ (XJRequestManager *)sharedInstance;

- (void)GET:(NSString *)URLString
       dict:(NSMutableDictionary *)params
    succeed:(void (^)(id data,XJRequestError *rError))succeed
    failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
        dict:(NSMutableDictionary *)params
     succeed:(void (^)(id data, XJRequestError *rError))succeed
     failure:(void (^)(NSError *error))failure;

- (void)Delete:(NSString *)URLString
        dict:(NSMutableDictionary *)params
     succeed:(void (^)(id data, XJRequestError *rError))succeed
     failure:(void (^)(NSError *error))failure;

- (void)specailPOST:(NSString *)URLString dict:(NSMutableDictionary *)params succeed:(void (^)(id data, XJRequestError *rError))succeed failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
   dict:(NSMutableDictionary *)params
 extraUrlPar:(NSString *)str
succeed:(void (^)(id data, XJRequestError *rError))succeed
     failure:(void (^)(NSError *error))failure;

@end

@interface XJRequestError : NSObject

@property(nonatomic,copy)  NSString *message;
@property(nonatomic,assign) NSInteger code;

@end


