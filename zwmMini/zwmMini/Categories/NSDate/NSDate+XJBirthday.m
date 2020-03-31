//
//  NSDate+XJBirthday.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "NSDate+XJBirthday.h"

@implementation NSDate (XJBirthday)

+ (NSInteger)ageWithBirthday:(NSDate *)birthday  {
    if (!birthday) {
        return 0;
    }
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:[NSDate date] options:0];
    
    return [components year];
    
}
@end
