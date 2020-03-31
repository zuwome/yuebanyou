//
//  XJChangePsView.h
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XJChangePsViewDelegate <NSObject>

- (void)oldPassText:(NSString *)text;
- (void)newPassText:(NSString *)text;


@end
@interface XJChangePsView : UIView

@property(nonatomic,weak) id<XJChangePsViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
