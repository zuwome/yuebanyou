//
//  XJChatPayCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJChatPayCollectionViewCell.h"
#import "ZZMessageChatWechatPayModel.h"
@interface XJChatPayCollectionViewCell()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *contentLb;


@end

@implementation XJChatPayCollectionViewCell

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
    
    
    
    
}
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    ZZMessageChatWechatPayModel *text = (ZZMessageChatWechatPayModel *)model.content;
    
    CGFloat allheight = [XJUtils heightForCellWithText:text.content fontSize:13 labelWidth:kScreenWidth-50] + extraHeight+50;
    
    return CGSizeMake(kScreenWidth, allheight);

    
}
- (void)tapAction{
    
        if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
            [self.delegate didTapMessageCell:self.model];
        }
}


- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel:model];
    
    ZZMessageChatWechatPayModel *text = (ZZMessageChatWechatPayModel *)model.content;
    CGFloat heigt = [XJUtils heightForCellWithText:text.content fontSize:15 labelWidth:kScreenWidth-50];
    self.bgView.frame = CGRectMake(15, 10, kScreenWidth-30, heigt+50);
    self.titleLb.frame = CGRectMake(15, 5, 200, 30);
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).offset(0);
            make.left.equalTo(self.titleLb);
            make.right.equalTo(self.bgView).offset(-10);
            make.height.mas_equalTo(heigt);
    }];
   
    self.contentLb.numberOfLines = 0;
    self.titleLb.text = text.title;
    self.contentLb.text = text.content;
    if ([text.pay_type integerValue] == 2) {
        
        [AskManager GET:[NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,model.targetId] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
           
            if (!rError) {
                XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
                if (umodel.have_commented_wechat_no) {
                    self.titleLb.text = @"已评价";
                }
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}





#pragma mark lazy

- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.baseContentView backColor:defaultWhite];
      
    }
    return _bgView;
    
}

- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultRedColor text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _titleLb;
    
}
- (UILabel *)contentLb{
    
    if (!_contentLb) {
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:@"" font:defaultFont(13) textInCenter:NO];
        _contentLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        Tap.numberOfTapsRequired = 1;
        Tap.numberOfTouchesRequired = 1;
        [_contentLb addGestureRecognizer:Tap];
        
    }
    return _contentLb;
    
}
@end
