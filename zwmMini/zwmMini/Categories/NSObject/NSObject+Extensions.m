//
//  NSObject+Extensions.m
//  AirMonitor
//
//  Created by 余天龙 on 2017/1/9.
//  Copyright © 2017年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "NSObject+Extensions.h"

#define BLOCK_SAFE_CALLS(block, ...) block ? block(__VA_ARGS__) : nil

#define BLOCK_SAFE_CALLS_In_Main_Queue(block, ...) block ? dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); }) : nil
@implementation NSObject (Extensions)

+ (void)asyncWaitingWithTime:(CGFloat)duration_time
               completeBlock:(void (^)(void))completed {

    dispatch_time_t afterTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration_time * NSEC_PER_SEC));
    dispatch_after(afterTime, dispatch_get_main_queue(), ^{
        BLOCK_SAFE_CALLS(completed);
    });
}

@end
