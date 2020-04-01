//
//  UIButton+Utils.h
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LXMImagePosition) {
    LXMImagePositionLeft = 0,              //图片在左，文字在右，默认
    LXMImagePositionRight = 1,             //图片在右，文字在左
    LXMImagePositionTop = 2,               //图片在上，文字在下
    LXMImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (Utils)

- (void)setImagePosition:(LXMImagePosition)postion spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
