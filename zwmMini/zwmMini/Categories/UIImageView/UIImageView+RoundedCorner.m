//
//  UIImageView+RoundedCorner.m
//  ProApp
//

//

#import "UIImageView+RoundedCorner.h"

@implementation UIImageView (RoundedCorner)

- (void)roundedCorner {
    [self roundedCornerWithBorderColor:nil borderWidth:0 cornerRadius:self.frame.size.height/2];
}

- (void)roundedCornerByDefault {
    [self roundedCornerWithBorderColor:[UIColor whiteColor] borderWidth:1 cornerRadius:self.frame.size.height/2];
}

- (void)roundedCornerRadius:(CGFloat)radius {
    [self roundedCornerWithBorderColor:nil borderWidth:0 cornerRadius:radius];
}

- (void)roundedCornerWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth {
    [self roundedCornerWithBorderColor:borderColor borderWidth:broderWidth cornerRadius:self.frame.size.height/2];
}

- (void)roundedCornerWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth cornerRadius:(CGFloat)radius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = broderWidth;
}

@end
