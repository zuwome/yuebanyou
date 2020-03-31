//
//  XJSystemMsgListModel.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSystemMsgListModel.h"

@implementation XJSystemMsgListModel

- (void)setTimeStamp {
    self.message.timeStamps = self.sort_value;
}

@end
