//
//  XJMessageListTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMessageListTbCell.h"

@interface XJMessageListTbCell ()

@property(nonatomic,strong) UIImageView *headIv;

@property(nonatomic,strong) UILabel     *nickNameeLb;

@property(nonatomic,strong) UILabel     *contentLb;

@property(nonatomic,strong) UILabel     *timeLb;

@property(nonatomic,strong) UILabel     *numLb;

@property(nonatomic,strong) UILabel     *payLabel;

@end

@implementation XJMessageListTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.headIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(70);
        }];
        
        [self.nickNameeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIv.mas_right).offset(12);
            make.bottom.equalTo(self.headIv.mas_centerY).offset(-5);
//            make.right.equalTo(self.timeLb.mas_left).offset(-10);
        }];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickNameeLb);
            make.top.equalTo(self.headIv.mas_centerY).offset(5);
            make.width.mas_equalTo(220);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.nickNameeLb);
        }];
        
        [self.numLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentLb);
            make.width.height.mas_equalTo(18);
        }];
    }
    
    return self;
    
    
}
- (void)setUpContent:(RCConversationModel *)model rcUser:(RCUserInfo *)userInfo{
    
    [self.headIv sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:GetImage(@"morentouxiang")];
    self.nickNameeLb.text = userInfo.name;
    //消息类型
    self.contentLb.text = [[XJChatUtils sharedInstance] getMessageListLastContent:model rcUser:userInfo];
    NSString *temptime = [NSString stringWithFormat:@"%lld",model.receivedTime];
    self.timeLb.text = [NSString timeStampConversionNSString:temptime];
    self.numLb.text = [NSString stringWithFormat:@"%ld",(long)model.unreadMessageCount];
    self.numLb.hidden = model.unreadMessageCount == 0 ? YES:NO;
}


#pragma mark lazy

- (UIImageView *)headIv{
    
    if (!_headIv) {
        _headIv = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:nil placehoderImage:@""];
        _headIv.layer.cornerRadius = 35;
        _headIv.layer.masksToBounds = YES;
    }
    return _headIv;
    
}
- (UILabel *)nickNameeLb{
    
    if (!_nickNameeLb) {
        _nickNameeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nickNameeLb;
}
- (UILabel *)contentLb{
    
    if (!_contentLb) {
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(14) textInCenter:NO];
    }
    return _contentLb;
}

- (UILabel *)timeLb{
    
    if (!_timeLb) {
        _timeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(13) textInCenter:NO];
    }
    return _timeLb;
}

- (UILabel *)numLb{
    
    if (!_numLb) {
        _numLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultWhite text:@"" font:defaultFont(13) textInCenter:YES];
        _numLb.backgroundColor = [UIColor redColor];
        _numLb.layer.cornerRadius = 9;
        _numLb.layer.masksToBounds = YES;
    }
    return _numLb;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
