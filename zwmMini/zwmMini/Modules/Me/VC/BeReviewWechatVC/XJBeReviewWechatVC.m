//
//  XJBeReviewWechatVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBeReviewWechatVC.h"
#import "XJBeReviewTbCell.h"
#import "XJHasReviewListModel.h"
#import "XJLookoverOtherUserVC.h"
#import "XJNoEvaluateVC.h"

static NSString *myTableviewIdentifier = @"hasreviewwxIdentifier";

@interface XJBeReviewWechatVC ()<UITableViewDelegate,UITableViewDataSource,XJBeReviewTBCellDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,copy) NSString *sortValue;

@end

@implementation XJBeReviewWechatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信被查看记录";
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


//点击头像
- (void)clickHeadIndexPaht:(NSIndexPath *)indexPath{
    XJHasReviewListModel *model = self.listArray[indexPath.row];
    if (model.user.banStatus) {
        [MBManager showBriefAlert:@"该用户当前处于被封禁状态，无法进行此操作"];
        return;
    }
    XJLookoverOtherUserVC *otherVC = [XJLookoverOtherUserVC new];
    otherVC.topUserModel = model.user;
    [self.navigationController pushViewController:otherVC animated:YES];
}

//下拉刷新
-(void)headerRereshing{
    
    NSLog(@"下拉刷新");
    [self endfresh];
    self.sortValue = @"";
    [self.listArray removeAllObjects];
    [self getHasreviewList];
    
}

//上拉加载
-(void)footerRereshing{
    
    [self endfresh];
    
    if (self.listArray.count > 0) {
        XJHasReviewListModel *lmodel = [self.listArray lastObject];
        self.sortValue = lmodel.sort_value;
        [self getHasreviewList];
        NSLog(@"上拉加载");
    }
    
    
}



- (void)getHasreviewList{
    
    [AskManager GET:API_BE_LOOK_WX_LIST_GET dict:@{@"sort_value":self.sortValue}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        [self endfresh];
        
        if (!rError) {
            
            
            for (NSDictionary *dic in data) {
                
                XJHasReviewListModel *lmodel = [XJHasReviewListModel yy_modelWithDictionary:dic];
                [self.listArray addObject:lmodel];
            }
            
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



#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 87.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJBeReviewTbCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    if (cell == nil) {
        cell = [[XJBeReviewTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    if (self.listArray.count > 0) {
        cell.delegate = self;
        [cell setUpContent:self.listArray[indexPath.row] indexPaht:indexPath];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    XJHasReviewListModel *listmodel = self.listArray[indexPath.row];
//    [MBManager showLoading];
//    @WeakObj(self);
//    [AskManager GET:[NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,listmodel.user.uid] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
//        @StrongObj(self);
//
//        XJUserModel *lookuserModel = [XJUserModel yy_modelWithDictionary:data];
//
//        //已评价
//        if (lookuserModel.have_commented_wechat_no) {
//
//
//            XJNoEvaluateVC *noValuatVC = [XJNoEvaluateVC new];
//            noValuatVC.userModel = lookuserModel;
//            //            self.definesPresentationContext = YES;
//            noValuatVC.isEvaluate = YES;
//            noValuatVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            [self presentViewController:noValuatVC animated:YES completion:nil];
//
//            //未评价微信号去评价
//        }else{
//
//            XJNoEvaluateVC *noValuatVC = [XJNoEvaluateVC new];
//            noValuatVC.userModel = lookuserModel;
//            //            self.definesPresentationContext = YES;
//            noValuatVC.isEvaluate = NO;
//            noValuatVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            [self presentViewController:noValuatVC animated:YES completion:nil];
//
//        }
//
//
//
//        [MBManager hideAlert];
//    } failure:^(NSError *error) {
//        [MBManager hideAlert];
//
//    }];
    
    
}


#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
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



-(NSMutableArray *)listArray{
    
    if (!_listArray) {
        
        _listArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _listArray;
    
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
