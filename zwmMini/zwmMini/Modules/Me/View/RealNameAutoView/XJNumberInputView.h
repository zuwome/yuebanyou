//
//  XJNumberInputView.h
//  zwmMini
//
//  Created by Batata on 2018/12/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NumberinputBlock)(NSString *inputStr);
@interface XJNumberInputView : UIView

@property(nonatomic,copy) NumberinputBlock block;
@property(nonatomic,copy) NSString *nameStr;
@property(nonatomic,copy) NSString *placeholderStr;

@property(nonatomic,copy) NSString *inputnumStr;
@property(nonatomic,assign) BOOL isCanEdit;


@end

NS_ASSUME_NONNULL_END
