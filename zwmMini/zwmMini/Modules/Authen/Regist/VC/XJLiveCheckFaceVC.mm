//
//  XJLiveCheckFaceVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLiveCheckFaceVC.h"
#import "XJLivewCheckFaceView.h"
#import "XJRegistDoneVC.h"
#import "XJCheckingFaceVC.h"
#import <IDLFaceSDK/IDLFaceSDK.h>

@interface XJLiveCheckFaceVC ()
@property(nonatomic,strong) XJLivewCheckFaceView *liveCheckView;
@end

@implementation XJLiveCheckFaceVC

- (instancetype)init {
    self = [super init];
    if (self) {
        _isRegister = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isRegister = NO;
    self.title = @"人脸识别";
    _liveCheckView = [[XJLivewCheckFaceView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_liveCheckView];

    [_liveCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (_isBoy) {
        _liveCheckView.isBoy = YES;
    }else{
        _liveCheckView.isBoy = NO;
    }
    @WeakObj(self);

    _liveCheckView.clickSkip = ^{
        NSLog(@"跳过");
        @StrongObj(self);
        
      
        
        
        
        XJRegistDoneVC *reVC = [XJRegistDoneVC new];
        reVC.isBoy = self.isBoy;
        reVC.para = self.praDic;
        reVC.isSkip = YES;
        [self.navigationController pushViewController:reVC animated:YES];
        
        
        
    };
    _liveCheckView.clickBegin = ^{
        @StrongObj(self);
        NSLog(@"开始验证");
        //验证成功就注册
        
        XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
        
        if (self.isRegister) {
            [lvc livenesswithList:@[@(0)] order:YES numberOfLiveness:1];
        }
        else {
            [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
        }
//        [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
        [self presentViewController:lvc animated:YES completion:nil];
        lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
            
            [self checkIshack:bestImg];
            
        };
        
        
       
    };

}

- (void)checkIshack:(UIImage *)bestimg{
    
    [MBManager showWaitingWithTitle:@"验证人脸中..."];
    [XJUploader uploadImage:bestimg progress:^(NSString *key, float percent) {
    } success:^(NSString * _Nonnull url) {
        
        [AskManager POST:API_PHOTOT_IS_HACK_POST dict:@{@"image_best":url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                NSString *isHack = data[@"isHack"];
                if ([isHack isEqualToString:@"true"]) {
                    [self showAlerVCtitle:@"检测失败" message:@"请重新刷脸" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                        
                    } cancelBlock:^{
                        
                    }];
                    
                }else{
                    
                    
                    XJRegistDoneVC *reVC = [XJRegistDoneVC new];
                    reVC.isBoy = self.isBoy;
                    reVC.para = self.praDic;
                    reVC.isSkip = NO;
                    reVC.faceUrl = url;
                    [self.navigationController pushViewController:reVC animated:YES];
                    
                }
                
                
                
            }else{
                
                [self showAlerVCtitle:@"检测失败" message:@"" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                    
                } cancelBlock:^{
                    
                }];
                
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
        [MBManager hideAlert];
    } failure:^{
        [MBManager hideAlert];
    }];
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    if (_liveCheckView) {
        
        if (_isBoy) {
            _liveCheckView.isBoy = YES;
        }else{
            _liveCheckView.isBoy = NO;
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*如果face++
 
 
 //
 //    NSMutableDictionary* liveInfoDict = [[NSMutableDictionary alloc] initWithCapacity:1];
 //    [liveInfoDict setObject:@"3" forKey:@"liveness_retry_count"];
 //    [liveInfoDict setObject:@"1" forKey:@"verbose"];
 //    [liveInfoDict setObject:@"2" forKey:@"security_level"];
 //    [liveInfoDict setObject:_isMeglive.selectedSegmentIndex == 0 ? @"meglive" : @"still" forKey:@"liveness_type"];
 //
 //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bizTokenImage" ofType:@"png"];
 //    UIImage *bizTokenImage = [UIImage imageWithContentsOfFile:filePath];
 //
 //
 //    [[MGFaceIDNetWork singleton] queryDemoMGFaceIDAntiSpoofingBizTokenWithUUID:[NSUUID UUID].UUIDString imageRef:bizTokenImage liveConfig:nil success:^(NSInteger statusCode, NSDictionary *responseObject) {
 //
 //        NSLog(@"%ld======%@",statusCode,responseObject);
 //
 //    } failure:^(NSInteger statusCode, NSError *error) {
 //
 //        NSLog(@"%ld======%@",statusCode,error);
 //        NSDictionary *erroInfo = error.userInfo;
 //        NSData *data = [erroInfo valueForKey:@"com.alamofire.serialization.response.error.data"]; NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 //        NSLog(@"%@", errorString);
 
 //    }];
 
 */

@end
