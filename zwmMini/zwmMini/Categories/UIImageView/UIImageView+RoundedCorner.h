//
//  UIImageView+RoundedCorner.h
//  ProApp
//

//

#import <UIKit/UIKit.h>

@interface UIImageView (RoundedCorner)

- (void)roundedCorner;
- (void)roundedCornerByDefault;
- (void)roundedCornerRadius:(CGFloat)radius;
- (void)roundedCornerWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth;
- (void)roundedCornerWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth cornerRadius:(CGFloat)radius;

@end
