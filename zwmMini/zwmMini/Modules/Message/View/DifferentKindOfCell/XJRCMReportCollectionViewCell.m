//
//  XJRCMReportCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRCMReportCollectionViewCell.h"
#import "ZZChatReportModel.h"
#import "TYAttributedLabel.h"

@interface XJRCMReportCollectionViewCell()<TYAttributedLabelDelegate>

@property (nonatomic,strong) TYAttributedLabel *payAgreementLab;//充值协议
@property(nonatomic,strong) UILabel *reportLb;

@end

@implementation XJRCMReportCollectionViewCell


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
    
    
//    [self.baseContentView addSubview:self.payAgreementLab];
    [self.baseContentView addSubview:self.reportLb];
//    self.baseContentView.backgroundColor = defaultLineColor;
    
    
}

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    
    //0 举报 2微信敏感词
    ZZChatReportModel *text = (ZZChatReportModel *)model.content;

    if ([text.type integerValue] == 0) {
        return CGSizeMake(kScreenWidth, 80+extraHeight);

    }else{
        
        CGFloat heigt = [XJUtils heightForCellWithText:[NSString stringWithFormat:@"%@%@",text.content,text.title] fontSize:13 labelWidth:250];
        return CGSizeMake(kScreenWidth, heigt+extraHeight+20);

        
    }
    
    
    
}

- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel: model];
    
    ZZChatReportModel *text = (ZZChatReportModel *)model.content;
    //0 举报 2微信敏感词
    if ([text.type integerValue] == 0) {
        self.reportLb.frame = CGRectMake((kScreenWidth-250)/2.0, 0, 250, 80);
      NSMutableAttributedString *newstr =  [NSString changeStringColorAndFontWithOldStr:@"如遇骚扰，请点击" changeStr:@"立即举报" color:RGB(1, 123, 255) font:defaultFont(14)];
        self.reportLb.attributedText = newstr;
    }
    if ([text.type integerValue] == 3) {
        self.reportLb.frame = CGRectMake((kScreenWidth-250)/2.0, 0, 250, 80);
        NSString *oldstr = [NSString stringWithFormat:@"%@%@",text.content,text.title];
        NSMutableAttributedString *newstr =  [NSString changeStringColorAndFontWithOldStr:oldstr changeStr:@"匿名举报" color:RGB(1, 123, 255) font:defaultFont(14)];
        self.reportLb.attributedText = newstr;

    }

    
}
#pragma mark - TYAttributedLabelDelegate

//- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
//{
//    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
//        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
//        if ([linkStr isEqualToString:@"立即举报"]) {
//            //跳转到充值协议
//            if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
//                [self.delegate didTapMessageCell:self.model];
//            }
//        }
//
//    }
//}

- (void)tapLable{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
    
}
- (TYAttributedLabel *)payAgreementLab {
    if (!_payAgreementLab) {
        _payAgreementLab =[[TYAttributedLabel alloc]initWithFrame:CGRectMake((kScreenWidth-250)/2.0, 0, 250, 80)];
        _payAgreementLab.textAlignment = kCTTextAlignmentCenter;
        _payAgreementLab.textColor= RGB(128, 128, 128);
        _payAgreementLab.font= [UIFont systemFontOfSize:15];
        _payAgreementLab.text = @"如遇骚扰，请点击";
        _payAgreementLab.delegate = self;
        [ _payAgreementLab appendLinkWithText:@"立即举报" linkFont:[UIFont systemFontOfSize:16 ] linkColor: [UIColor blueColor] underLineStyle:kCTUnderlineStyleNone linkData:@"立即举报"];
    }
    return _payAgreementLab;
}
- (UILabel *)reportLb{
    
    if (!_reportLb) {
        _reportLb = [XJUIFactory creatUILabelWithFrame:CGRectMake((kScreenWidth-250)/2.0, 0, 250, 80) addToView:nil textColor:defaultGray text:@"" font:defaultFont(13) textInCenter:YES];
        _reportLb.numberOfLines = 0;
        _reportLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLable)];
        Tap.numberOfTapsRequired = 1;
        Tap.numberOfTouchesRequired = 1;
        [_reportLb addGestureRecognizer:Tap];
    }
    return _reportLb;
    
}
@end
