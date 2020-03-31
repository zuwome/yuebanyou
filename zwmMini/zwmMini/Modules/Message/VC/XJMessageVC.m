//
//  XJMessageVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMessageVC.h"
#import "XJChatViewController.h"
#import "XJMessageListTbCell.h"
#import "XJSystemNotiTableViewCell.h"
#import "XJSystemNotiVC.h"
static NSString *myTableviewIdentifier = @"messagelisttableviewIdentifier";
static NSString *myInotidentifier = @"messagelistNotiIdentifier";

@interface XJMessageVC ()

@property(nonatomic,strong) NSMutableArray *listUserinfo;

@end

@implementation XJMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
  
    [self setUpRontKitAbout];
  
//   [self.tabBarController.tabBar showBadgeOnItemIndex:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.conversationListTableView.backgroundColor = RGB(245, 245, 245);
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)reloadMsgTableview{
    [self.conversationListTableView reloadData];
}

- (void)setUpRontKitAbout{
        
    // 设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_SYSTEM)]];
    
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    self.showConnectingStatusOnNavigatorBar = YES;
    self.conversationListTableView.tableFooterView = [UIView new];
    self.emptyConversationView = [UIView new];
}


- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{

    for (int i = 0 ; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        [dataSource replaceObjectAtIndex:i withObject:model];
    }
    
    RCConversationModel *model = [[RCConversationModel alloc]init];
    model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    model.conversationTitle = @"系统通知";
    model.isTop = YES;
    [dataSource insertObject:model atIndex:0];
    
    return dataSource;
    
}

//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 系统消息
    if (indexPath.row == 0) {
        XJSystemNotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myInotidentifier];
        if (cell == nil) {
            cell = [[XJSystemNotiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myInotidentifier];
        }
        [cell setUpSystemInfo:XJUserAboutManageer.unreadModel];
        return cell;
    }
    
    // 聊天框
    XJMessageListTbCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    if (cell == nil) {
        cell = [[XJMessageListTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    RCUserInfo *userinfo = [[RCIM sharedRCIM] getUserInfoCache:model.targetId];
    if (userinfo == nil) {
        
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
            
            [cell setUpContent:model rcUser:userinfo];

        }];
    }else{
        [cell setUpContent:model rcUser:userinfo];
    }
    return cell;
}


- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

/*!
 左滑删除cell
 */
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView setEditing:NO animated:YES];
        // 服务器删除
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                                 targetId:model.targetId];
        
        // UI本地删除
        [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.conversationListTableView reloadData];
        });
        [XJRongIMManager.sharedInstance setUpTabbarUnreadNum];
    }
}

#pragma mark - 设置cell的删除事件
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    RCConversationModel *model = [self.conversationListDataSource objectAtIndex:indexPath.row];
//    if(model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
//        return UITableViewCellEditingStyleNone;
//    }else{
//        return UITableViewCellEditingStyleDelete;
//    }
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;

    }else{
         return UITableViewCellEditingStyleDelete;
    }
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    //系统通知
    if (indexPath.row == 0) {
        NSLog(@"系统通知");
        [self.navigationController pushViewController:[XJSystemNotiVC new] animated:YES];
    }
    else{
        if ([XJUserAboutManageer isUserBanned]) {
//            [MBManager showBriefAlert:@"您已被封禁"];
            return;
        }
        XJChatViewController *conversationVC = [[XJChatViewController alloc]init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        RCUserInfo *userinfo = [[RCIM sharedRCIM] getUserInfoCache:model.targetId];
        if (userinfo == nil) {
            [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                conversationVC.title = userinfo.name;
            }];
        }else{
            conversationVC.title = userinfo.name;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getRechargeInfo:model.targetId pushController:conversationVC];
        });
    }
}

// 获取未读相关
- (void)getUnreadInfo {
    
    [AskManager GET:API_GET_UNREAD_INFO_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            
            XJUnreadModel *unreadM = [XJUnreadModel yy_modelWithDictionary:data];
            XJUserAboutManageer.unreadModel = unreadM;
//            if (self.conversationListTableView) {
//                [self.conversationListTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            }

        }
        
    } failure:^(NSError *error) {
        
    }];
}

// 私信是否收费
- (void)getRechargeInfo:(NSString *)targetid pushController:(XJChatViewController *)controller{
    [MBManager showLoading];
    @WeakObj(self);
    [AskManager GET:API_MESSAGE_ISCHARGE_(targetid) dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError){
        @StrongObj(self);
        if (!rError) {
            BOOL isNeedCharge = [data[@"open_charge"] boolValue];
            controller.isNeedCharge = isNeedCharge;
            [self.navigationController pushViewController:controller animated:YES];
        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];
    }];
}

// 收到消息
-(void)receiveMessageNofitication:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationListTableView reloadData];
    });
    NSLog(@"receivenotifi = %@",notification);
}

//- (void)didReceiveMessageNotification:(NSNotification *)notification{
//
//    [super didReceiveMessageNotification: notification];
//
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMsgTableview) name:reloadMessagelisttableviewNotifi object:nil];
    //收到消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNofitication:) name:chatVieewReceiveMessagtNoti object:nil];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [XJRongIMManager.sharedInstance setUpTabbarUnreadNum];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

@end
