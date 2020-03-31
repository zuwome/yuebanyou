//
//  UILabel+ShadowText.h
//  ProApp
//

//

#import <UIKit/UIKit.h>

@interface UILabel (ShadowText)

- (void)shadowWtihText:(NSString *)text;
- (void)shadowWtihText:(NSString *)text shadowBlurRadius:(CGFloat)shadowBlurRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset;

    
@end
