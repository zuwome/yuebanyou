//
//  XJRecommondVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRecommondVC.h"
#import "XJRecommondCollectionViewCell.h"
#import "XRWaterfallLayout.h"
#import "XJTopic.h"
#import "XJSkill.h"
#import "XJRecommondCell.h"

static NSString *collectionIdentifier = @"recollectionidentifier";
@interface XJRecommondVC ()<UICollectionViewDelegate,UICollectionViewDataSource,XRWaterfallLayoutDelegate, UITableViewDelegate, UITableViewDataSource>


@property(nonatomic,strong) UICollectionView *recollectionView;
@property(nonatomic,strong) NSMutableArray *homeHotArray;
@property(nonatomic,strong) NSMutableArray *homeListArray;
@property(nonatomic,copy) NSString *cate;//推荐recommend  //附近near //新鲜new
@property(nonatomic,copy) NSString *sortValue;
@property(nonatomic,copy) NSString *currentStar;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lng;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XRWaterfallLayout *waterfall;

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
//    [self.recollectionView.mj_header beginRefreshing];
    [_tableView.mj_header beginRefreshing];
    
}
- (void)creatUI{
    self.view.backgroundColor = RGB(245, 245, 245);
//    [self.view addSubview:self.recollectionView];
//    [self.recollectionView.mj_header beginRefreshing];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_tableView.mj_header beginRefreshing];
   
}

- (void)refresh {
//    [_recollectionView.mj_header beginRefreshing];
    [_tableView.mj_header beginRefreshing];
}

//下拉刷新
-(void)headerRereshing{
    
    NSLog(@"下拉刷新");
    
    [MBManager showLoading];
   
  
//    [self endfresh];
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
                
//                [self.recollectionView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
//            [self.recollectionView reloadData];
            [self.tableView reloadData];
       
            
        }else{
            
            
        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [self endfresh];
        [MBManager hideAlert];

    }];
    
}

- (void)endfresh{
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
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

    if (self.homeListArray.count > 0) {
        [cell setUpContent:self.homeListArray[indexPath.item] withIndexpath:indexPath];
    }
    return cell;
    
}

#pragma mark - XRWaterfallLayoutDelegate methods
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    if (self.homeListArray.count == 0) {
        return 0;
    }
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    CGFloat height = (kScreenWidth/2.f) - 3.5;
    
    XJHomeListModel *model = self.homeListArray[indexPath.item];
    
    XJSkill *mostCheapSkill = nil;
    for (XJTopic *topic in model.user.rent.topics) {
        if (topic.skills.count == 0) {  //主题无技能，跳过
            continue;
        }
        for (XJSkill *skill in topic.skills) {
            if (!mostCheapSkill) {
                mostCheapSkill = skill;
            }
            else if ([skill.price doubleValue] < [mostCheapSkill.price doubleValue]) {
                mostCheapSkill = skill;
            }
        }
    }
    
    // 技能名称、价格、介绍
    if (mostCheapSkill != nil) {
        if (!NULLString(mostCheapSkill.detail.content)) {
            height += 10.0;
            CGFloat textHeight = [XJUtils heightForCellWithText:mostCheapSkill.detail.content font:ADaptedFontBoldSize(16) labelWidth:(kScreenWidth/2.f) -3.5 maximunLine:3];
            height += textHeight;
        }
        height += 10.0;
        CGFloat textHeight = [XJUtils heightForCellWithText:mostCheapSkill.name font:ADaptedFontBoldSize(16) labelWidth:(kScreenWidth/2.f) -3.5];
        height += textHeight;
        height += 5;
        return height;
    }
    else {
        return (kScreenWidth/2.f) -3.5;
    }

}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (self.block) {
        self.block(self.homeListArray[indexPath.item]);
    }
}

#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.homeListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJRecommondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJRecommondCell"];
    if (cell == nil) {
        cell = [[XJRecommondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XJRecommondCell"];
    }
    if (self.homeListArray.count > 0) {
        cell.model = self.homeListArray[indexPath.row];

    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        
//        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        self.waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        //或者一次性设置
        [self.waterfall setColumnSpacing:7 rowSpacing:7 sectionInset:UIEdgeInsetsMake(7, 0, 0, 0)];
        self.waterfall.delegate = self;
        
        _recollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight) collectionViewLayout:self.waterfall];
        
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
        
        _recollectionView.backgroundColor= RGB(245, 245, 245);
//        _recollectionView.scrollsToTop = YES;
        _recollectionView.delegate = self;
        _recollectionView.dataSource = self;

    }
    
    return _recollectionView;
    
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(245, 245, 245);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _tableView.mj_header = header;
        
        //底部刷新
        MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:@"我是有底线的～" forState: MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:14.f];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _tableView.mj_footer = footer;
        
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}


@end
