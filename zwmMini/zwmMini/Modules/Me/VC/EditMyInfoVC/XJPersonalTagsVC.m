//
//  XJPersonalTagsVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/29.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJPersonalTagsVC.h"
#import "XJSelectJbosCollectionViewCell.h"


static NSString *collectionIdentifier = @"edittagsCollectionidentifier";

@interface XJPersonalTagsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) NSMutableArray *tagsArray;

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray *selectTagsArray;

@property(nonatomic,copy) NSArray<NSString *> *selectedArray;

@end

@implementation XJPersonalTagsVC
//tags_new
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人标签";
    
    XJUserModel *model = XJUserAboutManageer.uModel;
    NSMutableArray *array = @[].mutableCopy;
    [model.tags_new enumerateObjectsUsingBlock:^(XJInterstsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.content];
    }];
    _selectedArray = array.copy;
    
    [self showNavRightButton:@"" action:@selector(doneAction) image:GetImage(@"dagou") imageOn:GetImage(@"dagou")];
    [self creatUI];
}

- (void)creatUI{

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self getTagsList];
}
- (void)doneAction{
    
    
    if (self.selectTagsArray.count > 0) {
        [AskManager POST:API_UPDATA_JOBS dict:@{@"tags_new":self.selectTagsArray}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                //            NSLog(@"===%@",data);
                XJUserAboutManageer.uModel = [XJUserModel yy_modelWithDictionary:data];
                [MBManager showBriefAlert:@"添加标签成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatetags" object:self ];

                [self.navigationController popViewControllerAnimated:YES];
                
            }
           
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            
        }];
    }else{
        
        [MBManager showBriefAlert:@"请选择标签"];
    
  
    }
    
   
    
}
- (void)getTagsList{
    __weak typeof(self) weakSelf = self;
    [MBManager showLoading];
    [AskManager GET:API_GET_TAGS_LIST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            
          
            [self.tagsArray addObjectsFromArray:data];
            [self.tagsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([weakSelf.selectedArray containsObject:obj[@"content"]]) {
                    [weakSelf.selectTagsArray addObject:obj];
                }
                
            }];
            
            [self.collectionView reloadData];
            
        }
        
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];
        
        
    }];
    
}

#pragma mark collectionViewDelegate dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-36-54)/3.f - 1, 34);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(14, 16, 14, 16);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.tagsArray.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJSelectJbosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XJSelectJbosCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    
    NSDictionary *currentDic = self.tagsArray[indexPath.item];
    BOOL isselect = NO;
    if ([self.selectTagsArray containsObject:currentDic]) {
        isselect = YES;
    }
    [cell setUpSubJobsDic:currentDic andIndexPath:indexPath isSelect:isselect];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XJSelectJbosCollectionViewCell *cell = (XJSelectJbosCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *currentDic = self.tagsArray[indexPath.item];
    
    
    if (self.selectTagsArray.count == 5 && ![self.selectTagsArray containsObject:currentDic]) {
        [MBManager showBriefAlert:@"最多选择5个标签"];
        return;
    }
   
    //是否包含当前选择的dic 是就取消选择
    if ([self.selectTagsArray containsObject:currentDic]) {
        [self.selectTagsArray removeObject:currentDic];
        cell.titileLb.layer.borderColor = RGB(122, 122, 122).CGColor;
        cell.titileLb.backgroundColor = defaultWhite;
        cell.titileLb.textColor = RGB(122, 122, 123);
    }else{
        [self.selectTagsArray addObject:currentDic];
        cell.titileLb.layer.borderColor = RGB(254, 83, 108).CGColor;
        cell.titileLb.backgroundColor = RGB(254, 83, 108);
        cell.titileLb.textColor = UIColor.whiteColor;
    }

    
}


- (NSMutableArray *)tagsArray{
    
    if (!_tagsArray) {
        
        _tagsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _tagsArray;
    
    
}
- (NSMutableArray *)selectTagsArray{
    
    if (!_selectTagsArray) {
        
        _selectTagsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _selectTagsArray;
    
    
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = defaultWhite;
        [_collectionView registerClass:[XJSelectJbosCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
        
    }
    return _collectionView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
