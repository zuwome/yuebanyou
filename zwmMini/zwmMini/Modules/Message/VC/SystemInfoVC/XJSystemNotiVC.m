//
//  XJSystemNotiVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSystemNotiVC.h"
#import "XJSystemMsgListModel.h"
#import "XJSystemInfoTableViewCell.h"

static NSString *tableIdentifier = @"systemTableviewidentifier";

@interface XJSystemNotiVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *sysListArray;
@property(nonatomic,strong) NSMutableArray *sysHeghtArray;
@property(nonatomic,copy) NSString *sortValue;
@end

@implementation XJSystemNotiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    self.sortValue = @"";

    [self creatUI];
    
}
- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
//下拉刷新
-(void)headerRereshing{
    
    NSLog(@"下拉刷新");
   
    [self endfresh];
    self.sortValue = @"";
    [self.sysListArray removeAllObjects];
    [self.sysHeghtArray removeAllObjects];
    [self getlistData];
    
}



//上拉加载
-(void)footerRereshing{
    
    [self endfresh];
    
    if (self.sysListArray.count > 0) {
        XJSystemMsgListModel *lmodel = [self.sysListArray lastObject];
        self.sortValue = lmodel.sort_value;
        [self getlistData];
        NSLog(@"上拉加载");
    }
    
    
}



- (void)getlistData{
    
    
    
    [MBManager showLoading];
    [AskManager GET:API_SYTTEMLIST_INFO_GET dict:@{@"sort_value":self.sortValue}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        [self endfresh];
        
        if (!rError) {
            
//            NSLog(@"===%@",data);

            for (NSDictionary *dic in data) {

                XJSystemMsgListModel *lmodel = [XJSystemMsgListModel yy_modelWithDictionary:dic];
                [lmodel setTimeStamp];
                [self.sysListArray addObject:lmodel];
                
                XJSystemMsgModel *infoModel = lmodel.message;
                CGFloat tmpH = [XJUtils heightForCellWithText:infoModel.content fontSize:17 labelWidth:230]+110;
                [self.sysHeghtArray addObject:[NSString stringWithFormat:@"%f",tmpH]];
                
                
            }
            
            
            if ([data count] == 0) {

                [self.tableView.mj_footer endRefreshingWithNoMoreData];

            }
            
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 0.f;
    if (self.sysHeghtArray.count > 0) {
        h = [self.sysHeghtArray[indexPath.row] floatValue];
    }
    return h;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.sysListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJSystemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[XJSystemInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    if (self.sysListArray.count > 0) {

        XJSystemMsgListModel *lmodel = self.sysListArray[indexPath.row];
        XJSystemMsgModel *infoModel = lmodel.message;
        [cell setUpContent:infoModel];
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = defaultLineColor;
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

- (NSMutableArray *)sysListArray{
    if (!_sysListArray) {
        _sysListArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _sysListArray;
    
}
- (NSMutableArray *)sysHeghtArray{
    if (!_sysHeghtArray) {
        _sysHeghtArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _sysHeghtArray;
    
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
