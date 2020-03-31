//
//  UILabel+ShadowText.m
//  ProApp
//

//

#import "UILabel+ShadowText.h"

@implementation UILabel (ShadowText)

- (void)shadowWtihText:(NSString *)text {
    [self shadowWtihText:text shadowBlurRadius:3 shadowColor:[UIColor grayColor] shadowOffset:CGSizeMake(1, 1)];
}

- (void)shadowWtihText:(NSString *)text shadowBlurRadius:(CGFloat)shadowBlurRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = shadowBlurRadius;//阴影半径，默认值3
    shadow.shadowColor = shadowColor;//阴影颜色
    shadow.shadowOffset = shadowOffset;//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSShadowAttributeName: shadow}];
    self.attributedText = attributedText;;
}

@end
