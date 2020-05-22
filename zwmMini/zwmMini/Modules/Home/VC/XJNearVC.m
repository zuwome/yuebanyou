//
//  XJNearVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNearVC.h"
#import "XJNearTableViewCell.h"
#import "XJHomeListModel.h"
static NSString *tableIdentifier = @"nearTableviewidentifier";
@interface XJNearVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *nearListArray;
@property(nonatomic,copy) NSString *cate;//推荐recommend  //附近near //新鲜new
@property(nonatomic,copy) NSString *sortValue;

@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lng;

@end

@implementation XJNearVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cate = @"near";
    self.sortValue = @"";
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddress) name:refreshNearTableViewName object:nil];

    

    [self creatUI];
}



- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)receiveAddress{
    
    if (self.tabBarController.selectedIndex == 0) {
        self.lat = NULLString(XJUserAboutManageer.localLatitude) ? @"":XJUserAboutManageer.localLatitude;
        self.lng = NULLString(XJUserAboutManageer.localLongitude) ? @"":XJUserAboutManageer.localLongitude;
        [self headerRereshing];
    }
  
    
}

- (void)refresh {
    [_tableView.mj_header beginRefreshing];
}

//下拉刷新
-(void)headerRereshing{
    
    [self endfresh];

    NSLog(@"下拉刷新");
    self.lat = NULLString(XJUserAboutManageer.localLatitude) ? @"":XJUserAboutManageer.localLatitude;
    self.lng = NULLString(XJUserAboutManageer.localLongitude) ? @"":XJUserAboutManageer.localLongitude;
    if (NULLString(self.lat) || NULLString(self.lng)) {
        return;
    }
    self.sortValue = @"";
    [self.nearListArray removeAllObjects];
    [self getHomeData];
    
}

//上拉加载
-(void)footerRereshing{
    
    [self endfresh];
    if (NULLString(self.lat) || NULLString(self.lng)) {
        return;
    }
    if (self.nearListArray.count > 0) {
        XJHomeListModel *lmodel = [self.nearListArray lastObject];
        self.sortValue = lmodel.sortValue;
        [self getHomeData];
        NSLog(@"上拉加载");
    }
  
    
}



- (void)getHomeData{
    
    
    
    NSString *homeurl = XJUserAboutManageer.isLogin ? API_ISLOIN_HOME_GET:API_HOME_GET;
  
    NSLog(@"%@",@{@"cate":self.cate,@"sortValue":self.sortValue,@"lat":self.lat,@"lng":self.lng});
    NSDictionary *pdic ;
//    if (NULLString(self.lat) || NULLString(self.lng)) {
//        pdic = @{@"cate":self.cate,@"sortValue":self.sortValue};
//        [MBManager showBriefAlert:@"未获取到当前位置"];
//    }else{
        pdic = @{@"cate":self.cate,@"sortValue":self.sortValue,@"lat":self.lat,@"lng":self.lng};
//    }
    [AskManager GET:homeurl dict:pdic.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
         [self endfresh];

        if (!rError) {

            
//            NSLog(@"===%@",data);


//
            for (NSDictionary *dic in data) {

                XJHomeListModel *lmodel = [XJHomeListModel yy_modelWithDictionary:dic];
                [self.nearListArray addObject:lmodel];
            }
//
//
            if ([data count] == 0) {

                [self.tableView.mj_footer endRefreshingWithNoMoreData];

            }
            
            [self.tableView reloadData];



        }else{


        }
        
    } failure:^(NSError *error) {
        [self endfresh];
    }];
    
}

- (void)endfresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 132.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.nearListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJNearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[XJNearTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    if (self.nearListArray.count > 0) {
        cell.model = self.nearListArray[indexPath.row];

    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.block) {
        self.block(self.nearListArray[indexPath.item]);
    }
    
}


#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,0 , 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        WEAK_SELF()
        self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headerRereshing];
        }];
        self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footerRereshing];
        }];
        
//        //头部刷新
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//        header.automaticallyChangeAlpha = YES;
//        header.lastUpdatedTimeLabel.hidden = NO;
//        _tableView.mj_header = header;
//
//        //底部刷新
//        MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//        [footer setTitle:@"我是有底线的～" forState: MJRefreshStateNoMoreData];
//        footer.stateLabel.font = [UIFont systemFontOfSize:14.f];
//        footer.stateLabel.textColor = [UIColor lightGrayColor];
//        _tableView.mj_footer = footer;
        
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}

- (NSMutableArray *)nearListArray{
    if (!_nearListArray) {
        _nearListArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _nearListArray;
    
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
