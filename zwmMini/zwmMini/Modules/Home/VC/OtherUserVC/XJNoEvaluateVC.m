//
//  XJNoEvaluateVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/10.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNoEvaluateVC.h"
#import "XJBadEvualuateCoCell.h"
#import "TYAttributedLabel.h"

static NSString *collectionIdentifier = @"noevaluateCollectionidentifier";

@interface XJNoEvaluateVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TYAttributedLabelDelegate>
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UIButton *copyWxBtn;
@property(nonatomic,strong) UIButton *titleWxBtn;
@property(nonatomic,strong) UIButton *goodBtn;
@property(nonatomic,strong) UIButton *badBtn;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSIndexPath *lastIndexPath;
@property(nonatomic,copy) NSArray *badArray;
@property(nonatomic,copy) NSString *selectBadStr;
@property(nonatomic,assign) CGFloat coHeight;
@property(nonatomic,strong) UIView *rightnowBtnView;
@property(nonatomic,strong) UIButton *rightnowBtn;
@property (nonatomic,strong) TYAttributedLabel *payAgreementLab;//充值协议
@property(nonatomic,strong) NSMutableArray *selectBadArray;

@end

@implementation XJNoEvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.6);
    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.coHeight = 0.01;
    self.badArray = XJUserAboutManageer.sysCofigModel.wechat.comment_content;
    self.selectBadArray = [NSMutableArray new];
    if (self.badArray.count > 0) {
//        self.selectBadStr = self.badArray.firstObject;
        NSInteger line = self.badArray.count % 2;
        self.coHeight = (line + self.badArray.count/2)*52;
    }
   
    [self creatUI];
    
    //如果已评价过设置按钮不能点击等
    if (self.isEvaluate) {
        [self setUpHasevaluate];
    }
}
- (void)creatUI{
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(314);
    }];
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(67);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(60);
    }];
    [self.copyWxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView);
        make.height.mas_equalTo(67);
        make.width.mas_equalTo(kScreenWidth/2.0);
    }];
    [self.titleWxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.copyWxBtn.mas_right);
        make.height.mas_equalTo(67);
        make.width.mas_equalTo(150);
    }];
    
    [self.goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headIV.mas_bottom).offset(34);
        make.right.equalTo(self.bgView.mas_centerX).offset(-22);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(40);
    }];
    [self.badBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headIV.mas_bottom).offset(34);
        make.left.equalTo(self.bgView.mas_centerX).offset(22);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(40);
    }];
    
    [self.bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodBtn.mas_bottom).offset(26);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(0.01);
    }];
    
    [self.rightnowBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(-30);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(50);
    }];
    [self.rightnowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rightnowBtnView);
    }];
    
    [self.payAgreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.rightnowBtnView.mas_top).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(220);
    }];
    
}
- (void)closeAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//如果已评价过设置按钮不能点击等
- (void)setUpHasevaluate{
    //1 差评  5好评
    [self.rightnowBtn setTitle:@"已评价" forState:UIControlStateNormal];
    self.rightnowBtn.enabled = NO;
//    self.badBtn.enabled = NO;
//    self.goodBtn.enabled = NO;
    if (self.userModel.wechat_comment_score == 1) {
        
        self.goodBtn.enabled = NO;
        [self badAction:self.badBtn];
        self.badArray = self.userModel.wechat_comment_content;
        NSInteger line = self.badArray.count % 2;
        self.coHeight = (line + self.badArray.count/2)*52;
        [self.collectionView reloadData];
        
    }else{
        self.badBtn.enabled = NO;
        [self goodAction:self.goodBtn];
    }
    
}
- (void)copywxAction{
    
    NSLog(@"复制wx");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.userModel.wechat.no;
    [MBManager showBriefAlert:@"已复制至剪贴板"];
    
}
- (void)nothingAction{
}

//好评
- (void)goodAction:(UIButton *)btn{
    
    self.badBtn.selected = NO;
    btn.selected = YES;
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(314);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodBtn.mas_bottom).offset(26);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(0.01);
    }];
    
    
}
//差评
- (void)badAction:(UIButton *)btn{
    self.goodBtn.selected = NO;
    btn.selected = YES;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodBtn.mas_bottom).offset(26);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(self.coHeight);
        
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(314+self.coHeight);
    }];
    
}
//立即评价
- (void)rightAction:(UIButton *)btn{
    
    [MBManager showLoading];
    //1 差评 5 好评
    NSNumber *score = self.goodBtn.selected? @(5):@(1);
    NSMutableString *contentStr = [[NSMutableString alloc] initWithString:@""];
    for (NSString *str  in self.selectBadArray) {
        [contentStr appendString:[NSString stringWithFormat:@"|%@",str]];
    }
    NSMutableDictionary *dic = @{@"score":score}.mutableCopy;
    if (!NULLString(contentStr) && [score isEqual:@(1)]) {
        [contentStr deleteCharactersInRange:NSMakeRange(0, 1)];
        dic[@"content"] = contentStr;
        
    }
    
    [AskManager POST:API_EVALUATE_WX_WITH_(self.userModel.uid) dict:dic succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            
            [MBManager showBriefAlert:@"评价成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadLookOtherInfo object:self];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            
        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];

        
    }];
    
}
- (void)viewDidLayoutSubviews{
    
    [self.bgView cornerRadiusViewWithTopRadius:17];
    
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"立即举报"]) {
            if (NULLString(self.userModel.wechat.no)) {
                [MBManager showBriefAlert:@"微信号不存在"];
                return;
            }
            [AskManager POST:API_RIGHTNOW_REPORT_WX_WITH_(self.userModel.uid) dict:@{@"content":self.userModel.wechat.no,@"type":@"1"}.mutableCopy succeed:^(id data, XJRequestError *rError) {
                if (!rError) {
                    [MBManager showBriefAlert:@"谢谢您的举报，我们将在2个工作日内解决!"];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark collectionViewDelegate dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2.0, 39);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.f;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.badArray.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJBadEvualuateCoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XJBadEvualuateCoCell alloc] initWithFrame:CGRectZero];
    }
    BOOL isselect = NO;
//    if (indexPath.item == 0) {
//        isselect = YES;
//    }
    [cell setUpContent:self.badArray[indexPath.item] isSelect:isselect IndexPath:indexPath];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isEvaluate) {
        return;
    }
    self.selectBadStr = self.badArray[indexPath.item];
    if ([self.selectBadArray containsObject:self.selectBadStr]) {
        [self.selectBadArray removeObject:self.selectBadStr];
        XJBadEvualuateCoCell *cell = (XJBadEvualuateCoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setUpContent:self.selectBadStr isSelect:NO IndexPath:indexPath];
        
    }else{
        [self.selectBadArray addObject:self.selectBadStr];
        XJBadEvualuateCoCell *cell = (XJBadEvualuateCoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setUpContent:self.selectBadStr isSelect:YES IndexPath:indexPath];
    }
   
//    if (self.lastIndexPath) {
//        XJBadEvualuateCoCell *cell = (XJBadEvualuateCoCell *)[collectionView cellForItemAtIndexPath:self.lastIndexPath];
//        [cell setUpContent:self.badArray[self.lastIndexPath.item] isSelect:NO IndexPath:self.lastIndexPath];
//    }
    self.lastIndexPath = indexPath;
    
}

#pragma mark lazy
- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
    }
    return _bgView;
    
}

- (UIImageView *)headIV{
    if (!_headIV) {
        
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@"pingjiaheadimg"];
    }
    return _headIV;
    
}

- (UIButton *)closeBtn{
    
    if (!_closeBtn) {
        _closeBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultClearColor nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"" selectImageName:@"" target:self action:@selector(closeAction)];
    }
    return _closeBtn;
}
- (UIButton *)copyWxBtn{
    
    if (!_copyWxBtn) {
        _copyWxBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultClearColor nomalTitle:@"复制微信号" titleColor:defaultBlack titleFont:defaultFont(15) nomalImageName:@"copywximg" selectImageName:@"copywximg" target:self action:@selector(copywxAction)];
        [_copyWxBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
    return _copyWxBtn;
}
- (UIButton *)titleWxBtn{
    
    if (!_titleWxBtn) {
        _titleWxBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultClearColor nomalTitle:@"评价TA的微信号" titleColor:defaultBlack titleFont:defaultFont(15) nomalImageName:@"copywximg" selectImageName:@"pjimg" target:self action:@selector(nothingAction)];
        [_titleWxBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
    return _titleWxBtn;
}
- (UIButton *)goodBtn{
    
    if (!_goodBtn) {
        _goodBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultClearColor nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"goodbtnnoamlimg" selectImageName:@"goodbtnselectimg" target:self action:@selector(goodAction:)];
        _goodBtn.selected = YES;

    }
    return _goodBtn;
}
- (UIButton *)badBtn{
    
    if (!_badBtn) {
        _badBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultClearColor nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"badbtnnomalimg" selectImageName:@"badbtnselectimg" target:self action:@selector(badAction:)];
    }
    return _badBtn;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = defaultWhite;
        [_collectionView registerClass:[XJBadEvualuateCoCell class] forCellWithReuseIdentifier:collectionIdentifier];
        
    }
    return _collectionView;
}
- (UIView *)rightnowBtnView{
    
    if (!_rightnowBtnView) {
        
        _rightnowBtnView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.bgView backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 50)];
        [_rightnowBtnView.layer addSublayer:gradientLayer];
        _rightnowBtnView.layer.cornerRadius = 25;
        _rightnowBtnView.layer.masksToBounds = YES;
    }
    return _rightnowBtnView;
}
- (UIButton *)rightnowBtn{
    if (!_rightnowBtn) {
        
        _rightnowBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.rightnowBtnView backColor:defaultClearColor nomalTitle:@"立即评价" titleColor:defaultWhite titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(rightAction:)];
    }
    return _rightnowBtn;
    
}
- (TYAttributedLabel *)payAgreementLab {
    if (!_payAgreementLab) {
        _payAgreementLab =[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
        _payAgreementLab.textAlignment = kCTTextAlignmentLeft;
        _payAgreementLab.textColor= RGB(128, 128, 128);
        
        _payAgreementLab.font= [UIFont systemFontOfSize:12];
        _payAgreementLab.text = @"TA的微信号不存在？";
        _payAgreementLab.delegate = self;
        [ _payAgreementLab appendLinkWithText:@"立即举报" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGB(1, 123, 255) underLineStyle:kCTUnderlineStyleNone linkData:@"立即举报"];
        [self.bgView addSubview:_payAgreementLab];
    }
    return _payAgreementLab;
}

@end
