//
//  XJYoubiRecordModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJSubYoubiRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJYoubiRecordModel : NSObject

@property(nonatomic,strong) XJSubYoubiRecordModel  *mcoin_record;
@property(nonatomic,copy) NSString *sort_value;


@end

NS_ASSUME_NONNULL_END
