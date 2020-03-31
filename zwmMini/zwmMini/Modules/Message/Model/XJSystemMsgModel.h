//
//  XJSystemMsgModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJSystemMsgModel : NSObject

@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *cover_url;
@property(nonatomic,copy) NSString *created_at;
@property(nonatomic,copy) NSString *created_at_text;
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *media_type;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSDictionary *params;

@property (nonatomic,   copy) NSString *timeStamps;
@end

NS_ASSUME_NONNULL_END
