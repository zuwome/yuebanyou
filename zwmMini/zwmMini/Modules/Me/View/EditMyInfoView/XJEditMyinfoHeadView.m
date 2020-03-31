//
//  XJEditMyinfoHeadView.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditMyinfoHeadView.h"
#import "RACollectionViewReorderableTripletLayout.h"
#import "XJEditHeadViewPhotoCollCell.h"
#import "XJEditHeadViewAddPhotoCoCell.h"
#import "XJEditHeadViewEmptyCoCell.h"

static NSString *photoidentifier = @"phototidentifiercell";
static NSString *addphotoidentifier = @"addphototidentifiercell";
static NSString *emptyphotoidentifier = @"emptyphototidentifiercell";


@interface XJEditMyinfoHeadView()<UICollectionViewDelegate,UICollectionViewDataSource,RACollectionViewDelegateReorderableTripletLayout,RACollectionViewReorderableTripletLayoutDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RACollectionViewReorderableTripletLayout *layout;
@property(nonatomic,strong) NSMutableArray *oldimgsArray;


@end

@implementation XJEditMyinfoHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];

        
    }
    return self;
}


- (void)setUpRefreshCollection:(NSArray *)phtotosArray{
    
    [self.oldimgsArray removeAllObjects];
    [self.oldimgsArray addObjectsFromArray:phtotosArray];
    [self.collectionView reloadData];
    
}


#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.item < self.oldimgsArray.count) {
        XJEditHeadViewPhotoCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoidentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[XJEditHeadViewPhotoCollCell alloc] initWithFrame:CGRectZero];
            
        }
        
        cell.errorView.hidden = YES;
        cell.coverBgView.hidden = YES;
        cell.contentView.layer.borderWidth = 0;
        
        [cell setImgWithPhptpModel:self.oldimgsArray[indexPath.item]];
        __weak typeof(cell) weakcell = cell;
        cell.tapBlock = ^{
            if (indexPath.row == 0) {
                if ([XJUserAboutManageer.uModel isAvatarManualReviewing]) {
                    return ;
                }
            }
            [self tapPhotoCell:weakcell];
        };
        
        XJPhoto *photo1 = self.oldimgsArray[indexPath.item];
        //用户头像只有首张显示审核不通过原因，技能图片每张都要显示不通过原因
        if ((indexPath.row == 0) && [photo1 isKindOfClass:[XJPhoto class]]) {
            XJPhoto *model = (XJPhoto *)photo1;
            // 头像状态
            if (model.status == 0) {
                cell.contentView.layer.borderWidth = 1;
                cell.errorView.hidden = NO;
                cell.coverBgView.hidden = NO;
                
                // 因为人工审核失败
                if (XJUserAboutManageer.uModel.avatar_manual_status == 3) {
                    cell.errorLabel.text = @"抱歉！头像审核失败,请重新上传";
                }
                else {
                    cell.errorLabel.text = @"审核失败";
                }
            }
            else {
                if (XJUserAboutManageer.uModel.avatar_manual_status == 1) {
                    cell.contentView.layer.borderWidth = 1;
                    cell.errorView.hidden = NO;
                    cell.errorLabel.text = @"人工审核中头像暂不可操作";
                    cell.coverBgView.hidden = NO;
                }
            }
        }
        
        return cell;

    } else if (indexPath.item == self.oldimgsArray.count) {
        
        XJEditHeadViewAddPhotoCoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addphotoidentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[XJEditHeadViewAddPhotoCoCell alloc] initWithFrame:CGRectZero];
        }
        __weak typeof(cell) weakcell = cell;
        cell.tapBlock = ^{
            [self tapAddPhotoCell:weakcell];
        };
        return cell;
    }else{
        
        
        XJEditHeadViewEmptyCoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emptyphotoidentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[XJEditHeadViewEmptyCoCell alloc] initWithFrame:CGRectZero];
        }
     
        return cell;
    
        
    }

}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.oldimgsArray.count) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.row >= self.oldimgsArray.count) {
        return NO;
    } else {
        if (toIndexPath.row == 0 && [XJUserAboutManageer.uModel isAvatarManualReviewing]) {
            return NO;
        }
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chaneIndexFrom:to:)]) {
        
        [self.delegate chaneIndexFrom:fromIndexPath.item to:toIndexPath.item];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self finishRecognizer];

}
- (void)finishRecognizer
{
    if (!_layout.recognizerFinish) {
        [_layout finishRecognizer];
    }
}

//单击图片
- (void)tapPhotoCell:(UICollectionViewCell *)cell{
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPhoto:)]) {
        
        [self.delegate clickPhoto:indexPath.item];
    }
    
    

    
}
//点添加图片
- (void)tapAddPhotoCell:(UICollectionViewCell *)cell{
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAddPhoto:)]) {
        
        [self.delegate clickAddPhoto:indexPath.item];
    }
    
}



#pragma mark lazy

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _layout = [[RACollectionViewReorderableTripletLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XJEditHeadViewPhotoCollCell class] forCellWithReuseIdentifier:photoidentifier];
        [_collectionView registerClass:[XJEditHeadViewAddPhotoCoCell class] forCellWithReuseIdentifier:addphotoidentifier];
        [_collectionView registerClass:[XJEditHeadViewEmptyCoCell class] forCellWithReuseIdentifier:emptyphotoidentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)oldimgsArray
{
    if (!_oldimgsArray) {
        _oldimgsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _oldimgsArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
