//
//  XJRCMTextsCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/15.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRCMTextsCollectionViewCell.h"
#import "XJChatLbel.h"
#import <RongIMKit/RongIMKit.h>
@interface XJRCMTextsCollectionViewCell()


@property(nonatomic,strong) UIImageView *coentBackgroundView;
@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UIImageView *contentBgIV;
@property(nonatomic,strong) XJChatLbel *contentLb;

@end
@implementation XJRCMTextsCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatViews];
        
        
        
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self creatViews];
    }
    return self;
}
- (void)creatViews{
    
    [self.baseContentView addSubview:self.headIV];
    [self.baseContentView addSubview:self.coentBackgroundView];
    [self.coentBackgroundView addSubview:self.contentLb];

    
    
}

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    RCTextMessage *text = (RCTextMessage *)model.content;
    
    CGFloat allheight = [XJUtils heightForCellWithText:text.content fontSize:15 labelWidth:kScreenWidth*0.6] + extraHeight+40;
    
    
    return CGSizeMake(kScreenWidth, allheight);
    
    
}

- (void)showUserInfo {
    if (self.model.messageDirection == MessageDirection_RECEIVE) {
        NSString *userid = self.model.targetId;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCellPortrait:)]) {
            [self.delegate didTapCellPortrait:userid];
        }
    }
}


- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel: model];

    //文本类
    RCTextMessage *text = (RCTextMessage *)model.content;
    CGFloat contentheight = [XJUtils heightForCellWithText:text.content fontSize:15 labelWidth:kScreenWidth*0.6];
    CGFloat contentwidth = [XJUtils widthForCellWithText:text.content fontSize:15];
//    self.baseContentView.frame = CGRectMake(0, 0, kScreenWidth, contentheight+60);
    //    self.baseContentView.backgroundColor = [UIColor lightGrayColor];
    [self setUpViewsLayout:model contentHeight:contentheight conteentWidht:contentwidth];
    NSString *userid = model.messageDirection == MessageDirection_SEND ? model.senderUserId:model.targetId;
    RCUserInfo *usinfo = [[RCIM sharedRCIM] getUserInfoCache:userid];
    if (usinfo == nil) {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userid completion:^(RCUserInfo *userInfo) {
            [self.headIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:GetImage(@"morentouxiang")];
        }];
    }else{
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:usinfo.portraitUri] placeholderImage:GetImage(@"morentouxiang")];
    }

    self.contentLb.text = text.content;

}


- (void)setUpViewsLayout:(RCMessageModel *)model contentHeight:(CGFloat)heigt conteentWidht:(CGFloat)width{
    
    RCTextMessage *textmsg = (RCTextMessage *)model.content;
    NSDictionary *paydic = [XJUtils dictionaryWithJsonString:textmsg.extra];
    BOOL needCharge = NO;
    if (paydic != nil) {
        needCharge = NULLString(paydic[@"payChat"])? NO : YES;
    }
    
    CGFloat contentBGDefaultHeight = needCharge ? 40.0 : 30.0;
    if (!needCharge && model.messageDirection == MessageDirection_SEND) {
        _contentLb.textColor = UIColor.whiteColor;
    }
    else {
        _contentLb.textColor = defaultBlack;
    }
    
    if (model.messageDirection == MessageDirection_SEND) {
        // 发送气泡
        
        // 头像
        self.headIV.frame = CGRectMake(kScreenWidth - 55, 14, 40, 40);
        if (width >= kScreenWidth * 0.6) {
            width = kScreenWidth * 0.6;
        }
        
        if (width < 15) {
            width = 15;
        }
        
        // 消息区内容框
        self.coentBackgroundView.frame = CGRectMake(kScreenWidth - width - 100, 10, width + 40, heigt + contentBGDefaultHeight);
        
        if (needCharge) {
            // 付费的
            [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.coentBackgroundView).offset(-3);
                make.centerX.equalTo(self.coentBackgroundView).offset(4);
                make.width.mas_equalTo(width+1);
                make.height.mas_equalTo(heigt);
            }];
            self.contentLb.backgroundColor = defaultClearColor;
            self.coentBackgroundView.image = [GetImage(@"qipaofufeiRight") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30,30, 30)];
        }else{
            // 非付费的
            [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.coentBackgroundView);
                make.centerX.equalTo(self.coentBackgroundView).offset(-1);
                make.width.mas_equalTo(width+1);
                make.height.mas_equalTo(heigt);
            }];

            CGFloat top = 23.5;
            CGFloat left = 27;
            CGFloat bottom = 22.5;
            CGFloat right = 27;
            
            self.contentLb.backgroundColor = defaultClearColor;
            
            self.coentBackgroundView.image = [GetImage(@"qipaoYuyinUnpayRight")
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(top, left,bottom, right)];
        }
        self.contentLb.textAlignment = NSTextAlignmentLeft;
        
    }else{
        // 接收消息
        
        // 头像
        self.headIV.frame = CGRectMake(15, 14, 40, 40);
        if (width >= kScreenWidth*0.6) {
            width = kScreenWidth*0.6;
        }
        
        if (width < 20) {
            width = 20;
        }

        // 消息内容框
        self.coentBackgroundView.frame =  CGRectMake(60, 10, width + 40, heigt+contentBGDefaultHeight);
        
       
        //        self.contentLb.textAlignment = NSTextAlignmentLeft;
        if (needCharge) {
            // 付费
            
            [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.coentBackgroundView).offset(-3);
                make.centerX.equalTo(self.coentBackgroundView).offset(-3);
                make.width.mas_equalTo(width+1);
                make.height.mas_equalTo(heigt);
                
            }];
            self.contentLb.backgroundColor = defaultClearColor;
            
            self.coentBackgroundView.image = [GetImage(@"qipaofufeiLeft") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30,30, 30)];
        }else{
            // 非付费
            
            [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.coentBackgroundView);
                make.centerX.equalTo(self.coentBackgroundView).offset(-1);
                make.width.mas_equalTo(width+1);
                make.height.mas_equalTo(heigt);
                
            }];
//            self.contentLb.backgroundColor = defaultClearColor;
//            self.coentBackgroundView.image = [GetImage(@"qipaoYuyinUnpayLeft") resizableImageWithCapInsets:UIEdgeInsetsMake(11, 27, 13, 20) resizingMode:UIImageResizingModeStretch];
            CGFloat top = 23.5;
            CGFloat left = 27;
            CGFloat bottom = 22.5;
            CGFloat right = 27;
            
            self.contentLb.backgroundColor = defaultClearColor;
            
            self.coentBackgroundView.image = [GetImage(@"qipaoYuyinUnpayLeft")
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(top, left,bottom, right)];
        }
        self.contentLb.textAlignment = NSTextAlignmentLeft;
    }
}


- (UIImageView *)coentBackgroundView{
    
    if (!_coentBackgroundView) {
        //        _bubbleBackgroundView = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.baseContentView imageUrl:nil placehoderImage:@"chatrechargebgimg"];
        _coentBackgroundView = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
    }
    return _coentBackgroundView;
}

- (UIImageView *)headIV{
    
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
        _headIV.layer.cornerRadius = 20;
        _headIV.layer.masksToBounds = YES;
        _headIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_headIV addGestureRecognizer:tap];
    }
    
    return _headIV;
    
}
- (UIImageView *)contentBgIV{
    
    if (!_contentBgIV) {
        _contentBgIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
        
    }
    
    return _contentBgIV;
    
}
- (XJChatLbel *)contentLb{
    if (!_contentLb) {
        //
        //        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bubbleBackgroundView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
        _contentLb = [[XJChatLbel alloc] initWithFrame:CGRectZero];
        _contentLb.textColor = defaultBlack;
        _contentLb.font = defaultFont(15);
        _contentLb.text = @"";
        _contentLb.textAlignment = NSTextAlignmentCenter;
        _contentLb.numberOfLines = 0;
        
        
    }
    
    return _contentLb;
    
    
}

@end
