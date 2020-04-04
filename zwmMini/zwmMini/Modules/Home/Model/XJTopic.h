//
//  XJTopics.h
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJSkill;
@interface XJTopic : JSONModel

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSMutableArray <XJSkill *> *skills;

- (NSString *)title;

@end

