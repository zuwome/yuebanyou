//
//  XJRCMVoiceeCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/15.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRCMVoiceeCollectionViewCell.h"
#import <AVKit/AVKit.h>

@interface XJRCMVoiceeCollectionViewCell ()<AVAudioPlayerDelegate>

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UIImageView *voiceIV;
@property(nonatomic,strong) UILabel *voiceTimeLb;
@property(nonatomic,strong) AVAudioPlayer * avPlayer;

@end

@implementation XJRCMVoiceeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
//        NSLog(@"语音");
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
    [self.baseContentView addSubview:self.voiceIV];
    [self.voiceIV addSubview:self.labaIV];
    [self.voiceIV addSubview:self.voiceTimeLb];
    
}


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    
    return CGSizeMake(kScreenWidth, 80+extraHeight);
    //      return CGSizeMake(kScreenWidth*0.63, 200);
    
    
}

- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel:model];
//    self.nicknameLabel.hidden = YES;
////
    RCVoiceMessage *voicemsg = (RCVoiceMessage *)model.content;
    NSDictionary *paydic = [XJUtils dictionaryWithJsonString:voicemsg.extra];

    NSString *userid = model.messageDirection == MessageDirection_SEND ? model.senderUserId:model.targetId;
    RCUserInfo *usinfo = [[RCIM sharedRCIM] getUserInfoCache:userid];
    if (usinfo == nil) {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userid completion:^(RCUserInfo *userInfo) {
            [self.headIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:GetImage(@"morentouxiang")];
        }];
    }else{
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:usinfo.portraitUri] placeholderImage:GetImage(@"morentouxiang")];
    }

    BOOL needCharge = NO;
    if (paydic != nil) {

        needCharge = NULLString(paydic[@"payChat"])? NO:YES;

    }




    self.voiceTimeLb.text = [NSString stringWithFormat:@"%ld''",voicemsg.duration];


    if (model.messageDirection == MessageDirection_SEND) {

        self.headIV.frame = CGRectMake(kScreenWidth-55, 10, 40, 40);


        if (needCharge) {

            [self.voiceIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headIV);
                make.right.equalTo(self.headIV.mas_left).offset(-10);
                make.width.mas_equalTo(110);
                make.height.mas_equalTo(64);

            }];
            self.voiceIV.image = GetImage(@"qipaoYuyinYou");


            self.labaIV.image = GetImage(@"yuyinPayRight");
            [self.labaIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.voiceIV);
                make.right.equalTo(self.voiceIV).offset(-17);
                make.width.height.mas_equalTo(18);
            }];
            self.labaIV.animationImages = @[GetImage(@"redright1"),GetImage(@"redright2"),GetImage(@"redright3")];
        }else{
            [self.voiceIV mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.centerY.equalTo(self.headIV);
                make.right.equalTo(self.headIV.mas_left).offset(-10);
                make.width.mas_equalTo(95);
                make.height.mas_equalTo(45);

            }];
            self.voiceIV.image = GetImage(@"qipaoYuyinUnpayRight");

            self.labaIV.image = GetImage(@"yuyinUnpayRight");
            [self.labaIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.voiceIV);
                make.right.equalTo(self.voiceIV).offset(-17);
                make.width.height.mas_equalTo(18);
            }];
            self.labaIV.animationImages = @[GetImage(@"whiteRight1"),GetImage(@"whiteRight2"),GetImage(@"whiteRight3")];

        }

        [self.voiceTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.labaIV);
            make.right.equalTo(self.labaIV.mas_left).offset(-15);
        }];

        

    }else{
        self.headIV.frame = CGRectMake(15, 0, 40, 40);


        if (needCharge) {
            [self.voiceIV mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.centerY.equalTo(self.headIV);
                make.left.equalTo(self.headIV.mas_right).offset(10);
                make.width.mas_equalTo(110);
                make.height.mas_equalTo(64);

            }];
            self.voiceIV.image = GetImage(@"qipaoYuyinZuo");

            self.labaIV.image = GetImage(@"yuyinPayLeft");
            [self.labaIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.voiceIV);
                make.left.equalTo(self.voiceIV).offset(17);
                make.width.height.mas_equalTo(18);
            }];
            
            self.labaIV.animationImages = @[GetImage(@"redleft1"),GetImage(@"redleft2"),GetImage(@"redleft3")];

        }else{
            [self.voiceIV mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.centerY.equalTo(self.headIV);
                make.left.equalTo(self.headIV.mas_right).offset(10);
                make.width.mas_equalTo(95);
                make.height.mas_equalTo(45);

            }];
            self.voiceIV.image = GetImage(@"qipaoYuyinUnpayLeft");

            self.labaIV.image = GetImage(@"yuyinPayLeft");
            [self.labaIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.voiceIV);
                make.left.equalTo(self.voiceIV).offset(17);
                make.width.height.mas_equalTo(18);
            }];

        }
        [self.voiceTimeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.labaIV);
            make.left.equalTo(self.labaIV.mas_right).offset(15);
        }];
        self.labaIV.animationImages = @[GetImage(@"redleft1"),GetImage(@"redleft2"),GetImage(@"redleft3")];


    }
    self.labaIV.animationDuration = 1.5f;
//    [self stopPlayVoicee];

//
//    NSLog(@"%ld",voicemsg.duration);
    
    
}

- (void)tapVoceimg:(UIGestureRecognizer *)gestureRecognizer {
    
//    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
//        [self.delegate didTapMessageCell:self.model];
//        
//        [self playVoice];
//    }

        [self playVoice];
    
    
}

- (void)playVoice{

 
    [self stopLastPlayer];
    
   RCVoiceMessage *voicemsg = (RCVoiceMessage *)self.model.content;

    if (self.avPlayer) {
//        self.avPlayer.isPlaying ? [self.avPlayer pause] :[self.avPlayer play];
        [self stopPlayVoicee];
        
    }
        NSError *error;
        self.avPlayer = [[AVAudioPlayer alloc] initWithData:voicemsg.wavAudioData error:&error];
        self.avPlayer.delegate = self;
        self.avPlayer.volume = 1.0;
        if (self.avPlayer == nil){
            NSLog(@"AudioPlayer did not load properly: %@", [error description]);
            
        }else{
            
            BOOL playsuccess = [self.avPlayer play];
//            NSLog(@"播放 %@",playsuccess ? @"yes":@"no");
            if (playsuccess) {
                
                [XJChatUtils sharedInstance].lastLabaIV = self.labaIV;
                [XJChatUtils sharedInstance].lastavPlayer = self.avPlayer;
                [self.labaIV startAnimating];
            }else{
                
                [self stopPlayVoicee];;
                
            }
            
        
    }
  

}
//播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlayVoicee];
    
}
//停止上一个的播放
- (void)stopLastPlayer{
    
    
    UIImageView *lastlaIV = [XJChatUtils sharedInstance].lastLabaIV;
    AVAudioPlayer *lastavPlayer = [XJChatUtils sharedInstance].lastavPlayer;
    if (lastlaIV) {
        [lastlaIV stopAnimating];
    }
    if (lastavPlayer) {
        [lastavPlayer pause];
        lastavPlayer.delegate = nil;
        lastavPlayer = nil;
    }
}

//停止播放
- (void)stopPlayVoicee{
    
    if (self.avPlayer) {
        [self.avPlayer pause];
        self.avPlayer.delegate = nil;
        self.avPlayer = nil;
    }
    [self.labaIV stopAnimating];
    
}



- (UIImageView *)headIV{
    
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
        _headIV.layer.cornerRadius = 20;
        _headIV.layer.masksToBounds = YES;
    }
    
    return _headIV;
    
}

- (UIImageView *)voiceIV{
    
    if (!_voiceIV) {
        
        _voiceIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
        _voiceIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVoceimg:)];
        Tap.numberOfTapsRequired = 1;
        Tap.numberOfTouchesRequired = 1;
        [_voiceIV addGestureRecognizer:Tap];
        
    }
    return _voiceIV;
    
}
- (UIImageView *)labaIV{
    
    if (!_labaIV) {
        
        _labaIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
//        _labaIV.userInteractionEnabled = YES;
    }
    return _labaIV;
    
}
- (UILabel *)voiceTimeLb{
  
    if (!_voiceTimeLb) {
        _voiceTimeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil textColor:defaultBlack text:@"" font:defaultFont(12) textInCenter:YES];
//        _voiceTimeLb.userInteractionEnabled = YES;

    }
    return _voiceTimeLb;
    
    
}
@end
