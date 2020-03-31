//
//  XJSubYoubiRecordModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJSubYoubiRecordModel : NSObject

@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *amount;
@property(nonatomic,copy) NSString *type_text;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *created_at_text;
@property(nonatomic,copy) NSString *channel;

@end

NS_ASSUME_NONNULL_END
