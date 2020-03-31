//
//  XJRecommondVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRecommondVC.h"
#import "XJRecommondCollectionViewCell.h"

static NSString *collectionIdentifier = @"recollectionidentifier";
@interface XJRecommondVC ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong) UICollectionView *recollectionView;
@property(nonatomic,strong) NSMutableArray *homeHotArray;
@property(nonatomic,strong) NSMutableArray *homeListArray;
@property(nonatomic,copy) NSString *cate;//推荐recommend  //附近near //新鲜new
@property(nonatomic,copy) NSString *sortValue;
@property(nonatomic,copy) NSString *currentStar;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lng;




@end

@implementation XJRecommondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cate = @"recommend";
    self.sortValue = @"";
    self.currentStar = @"";
    self.type = @"";
   
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isloginsuccessAction) name:loginISSuccess object:nil];
}
- (void)isloginsuccessAction{
    [self.recollectionView.mj_header beginRefreshing];

    
}
- (void)creatUI{
    
    [self.view addSubview:self.recollectionView];
    [self.recollectionView.mj_header beginRefreshing];
   
}

- (void)refresh {
    [_recollectionView.mj_header beginRefreshing];
}

//下拉刷新
-(void)headerRereshing{
    
    NSLog(@"下拉刷新");
    
    [MBManager showLoading];
   
  
    [self endfresh];
    self.lat = NULLString(XJUserAboutManageer.localLatitude) ? @"":XJUserAboutManageer.localLatitude;
    self.lng = NULLString(XJUserAboutManageer.localLongitude) ? @"":XJUserAboutManageer.localLongitude;
    self.sortValue = @"";
    self.currentStar = @"";
    self.type = @"";
    [self.homeHotArray removeAllObjects];
    [self.homeListArray removeAllObjects];
    [self getHomeData];
    
}

//上拉加载
-(void)footerRereshing{
    [self endfresh];
    if (self.homeListArray.count > 0) {
        XJHomeListModel *lmodel = [self.homeListArray lastObject];
        self.sortValue = lmodel.sortValue;
        self.currentStar = lmodel.current_star;
        self.type = lmodel.type;
        [self getHomeData];
        NSLog(@"上拉加载");
    }
}

- (void)getHomeData{
    NSString *homeurl = XJUserAboutManageer.isLogin ? API_ISLOIN_HOME_GET:API_HOME_GET;
    
    NSString *cityname = NULLString(XJUserAboutManageer.cityName)?@"":XJUserAboutManageer.cityName;
    NSMutableDictionary *pdic = @{
        @"cate": self.cate,
        @"sortValue": self.sortValue,
        @"current_star": self.currentStar,
        @"cityName": cityname,
    }.mutableCopy;

    if (!NULLString(XJUserAboutManageer.cityName)) {
        pdic[@"city_choose_by"] = @"";
    }
    
    [AskManager GET:homeurl dict:pdic succeed:^(id data, XJRequestError *rError) {
        [self endfresh];
        if (!rError) {
                if (self.homeHotArray.count == 0) {
                    
                    for (NSDictionary *dic in data[@"hot"]) {
                        
                        XJHomeListModel *lmodel = [XJHomeListModel yy_modelWithDictionary:dic];
                        [self.homeHotArray addObject:lmodel];
                        [self.homeListArray addObject:lmodel];
                    }
                }
                
                for (NSDictionary *dic in data[@"recommend"]) {
                    
                    XJHomeListModel *lmodel = [XJHomeListModel yy_modelWithDictionary:dic];
                    [self.homeListArray addObject:lmodel];
                }
            
           
            if ([data[@"recommend"] count] == 0) {
                
                [self.recollectionView.mj_footer endRefreshingWithNoMoreData];
                
            }
            [self.recollectionView reloadData];

       
            
        }else{
            
            
        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [self endfresh];
        [MBManager hideAlert];

    }];
    
}

- (void)endfresh{
    if ([self.recollectionView.mj_header isRefreshing]) {
        [self.recollectionView.mj_header endRefreshing];
    }
    
    if ([self.recollectionView.mj_footer isRefreshing]) {
        [self.recollectionView.mj_footer endRefreshing];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    return self.homeListArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJRecommondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XJRecommondCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    if (self.homeListArray.count > 0) {
        [cell setUpContent:self.homeListArray[indexPath.item] withIndexpath:indexPath];
    }
    return cell;
    
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kScreenWidth/2.f) -3.5,(kScreenWidth/2.f)-3.5);
    return  size;
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7, 0, 0, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 7;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (self.block) {
        self.block(self.homeListArray[indexPath.item]);
    }
}





#pragma mark lazy
- (NSMutableArray *)homeHotArray{
    if (!_homeHotArray) {
        _homeHotArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _homeHotArray;
    
    
}
- (NSMutableArray *)homeListArray{
    if (!_homeListArray) {
        _homeListArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _homeListArray;
    
}

- (UICollectionView *)recollectionView{
    if (!_recollectionView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _recollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight) collectionViewLayout:flow];
        
         [_recollectionView registerClass:[XJRecommondCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _recollectionView.mj_header = header;
        
        //底部刷新
        MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:@"我是有底线的～" forState: MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:14.f];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _recollectionView.mj_footer = footer;
        
        _recollectionView.backgroundColor= defaultWhite;
//        _recollectionView.scrollsToTop = YES;
        _recollectionView.delegate = self;
        _recollectionView.dataSource = self;

    }
    
    return _recollectionView;
    
    
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
