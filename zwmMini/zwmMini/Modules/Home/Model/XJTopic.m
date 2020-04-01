//
//  XJTopics.m
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJTopic.h"
#import "XJSkill.h"

@implementation XJTopic

//// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"skills" : [XJSkill class],

    };
}

- (NSString *)title {
    NSMutableArray *s = [NSMutableArray array];
    [self.skills enumerateObjectsUsingBlock:^(XJSkill *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [s addObject:obj.name];
    }];
    return [s componentsJoinedByString:@"、"];
}

- (void)setPriceWithNSNumber:(NSNumber *)number {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    f.maximumFractionDigits = 2;
    self.price = [f stringFromNumber:number];
}


@end
