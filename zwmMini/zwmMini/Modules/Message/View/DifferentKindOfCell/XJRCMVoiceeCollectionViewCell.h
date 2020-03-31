//
//  XJRCMVoiceeCollectionViewCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/15.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJRCMVoiceeCollectionViewCell : RCMessageBaseCell

@property(nonatomic,strong) UIImageView *labaIV;
- (void)stopPlayVoicee;
@end

NS_ASSUME_NONNULL_END
