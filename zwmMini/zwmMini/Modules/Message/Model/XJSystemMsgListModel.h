//
//  XJSystemMsgListModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJSystemMsgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJSystemMsgListModel : NSObject


@property(nonatomic,strong) XJSystemMsgModel *message;
@property(nonatomic,copy) NSString *sort_value;

- (void)setTimeStamp;

@end

NS_ASSUME_NONNULL_END
