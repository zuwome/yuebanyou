//
//  XJRentSkillItemView.m
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJRentSkillItemView.h"
#import "SKTagView.h"
#import "XJTopic.h"
#import "XJSkill.h"

@implementation XJRentSkillItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        _skillIcon = [[UIImageView alloc] init];
        _skillIcon.contentMode = UIViewContentModeScaleAspectFill;
        _skillIcon.clipsToBounds = YES;
        [self addSubview:_skillIcon];
        [_skillIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 62));
            make.top.leading.equalTo(@15);
        }];
        
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textAlignment = NSTextAlignmentLeft;
        _skillLabel.textColor = kBlackTextColor;
        _skillLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        [self addSubview:_skillLabel];
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_skillIcon.mas_trailing).offset(7);
            make.top.equalTo(_skillIcon);
            make.height.equalTo(@20);
        }];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = RGB(254, 83, 108);
        _priceLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _priceLabel.hidden = YES;
        [self addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(_skillLabel.mas_trailing).offset(8);
            make.top.equalTo(_skillLabel);
            make.width.greaterThanOrEqualTo(@90);
            make.height.equalTo(_skillLabel);
        }];
        
        _skillContent = [[UILabel alloc] init];
        _skillContent.font = [UIFont systemFontOfSize:14];
        _skillContent.textColor = kBlackTextColor;
        _skillContent.numberOfLines = 2;
        [self addSubview:_skillContent];
        [_skillContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_skillLabel.mas_bottom).offset(8);
            make.leading.equalTo(_skillLabel);
            make.trailing.equalTo(_priceLabel);
            make.bottom.equalTo(_skillIcon);
        }];
        
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 5;
        _tagView.interitemSpacing = 5;
        _tagView.preferredMaxLayoutWidth = kScreenWidth - 30;
        [self addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_skillIcon.mas_bottom).offset(10);
            make.trailing.equalTo(_skillContent);
            make.leading.equalTo(_skillIcon);
            make.height.greaterThanOrEqualTo(@0);
            make.bottom.equalTo(@-15);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(_skillIcon);
            make.trailing.equalTo(_priceLabel);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setData:(XJTopic *)topic isFirst:(BOOL)isFirst {
    if (isFirst) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
    _topic = topic;
    XJSkill *skill = topic.skills[0];
    _skillLabel.text = [topic title];
    _priceLabel.text = [NSString stringWithFormat:@"%@元/小时", topic.price];
    if (skill) {
        NSArray *passPhotos = [self getPassPhotos:skill.photo];
        if (passPhotos.count > 0) {
            XJPhoto *photo = passPhotos[0];
            [_skillIcon sd_setImageWithURL:[NSURL URLWithString:photo.url]];
        } else {
            [_skillIcon sd_setImageWithURL:[NSURL URLWithString:skill.defaultPhotoUrl]];
        }
        [_skillContent setText:(skill.detail.status == 0 || skill.detail.content.length <= 0) ? @"" : skill.detail.content];
    }
    
    [self.tagView removeAllTags];
    for (ZZSkillTag *tagModel in skill.tags) {
        SKTag *tag = [SKTag tagWithText:tagModel.name];
        tag.textColor = kBlackColor;
        tag.bgColor = UIColor.whiteColor;
        tag.cornerRadius = 2;
        tag.fontSize = 10;
        tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
        tag.borderColor = kGrayLineColor;
        tag.borderWidth = 1;
        [self.tagView addTag:tag];
    }
    
    [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_skillContent.mas_bottom).offset(skill.tags.count > 0 ? 10 : 0);
    }];
}

- (NSArray *)getPassPhotos:(NSArray *)photos {
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (XJPhoto *photo in photos) {
        if (photo.status != 0) {    // 0表示不通过 1 待审核 2审核通过
            [tmpArray addObject:photo];
        }
    }
    return [tmpArray copy];
}

@end
