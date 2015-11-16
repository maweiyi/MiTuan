//
//  AppDelegate.m
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DPAppDelegate.h"
#import "HomeViewController.h"
#import "ShangjiaViewController.h"
#import "WoDeViewController.h"
#import "GengduoViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DGAaimaView.h"

#define APP_KEY @"6129732649"
#define APP_SECRATE @"a0253d199f4b497ea70d8bbbad83a240"
@interface DPAppDelegate ()
{
    //成员变量的分栏控制器
    UITabBarController *_tabCtl;
    //背景图
    UIImageView *_bgView;
    //记录点击的tag
    NSInteger _tempNum;
    
    DGAaimaView * animaView;
}
@end

@implementation DPAppDelegate

+ (DPAppDelegate *)instance {
    return (DPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)init {
    self = [super init];
    if (self) {
        _dpapi = [[DPAPI alloc] init];
       // _appKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"appkey"];
        //if (_appKey.length<1) {
            _appKey = APP_KEY;
       // }
       // _appSecret = [[NSUserDefaults standardUserDefaults] valueForKey:@"appsecret"];
       //if (_appSecret.length<1) {
            _appSecret = APP_SECRATE;
        //}
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
   
    
    //设置默认城市为郑州
    self.city = @"郑州";
    //主视图
    HomeViewController *hvc = [[HomeViewController alloc] init];
    UINavigationController *na1 = [[UINavigationController alloc] initWithRootViewController:hvc];
    na1.navigationBarHidden = YES;
    
    
    //商家界面
    ShangjiaViewController *shang = [[ShangjiaViewController alloc] init];
    UINavigationController *na2 = [[UINavigationController alloc] initWithRootViewController:shang];
    
    na2.navigationBarHidden = YES;
    
    //我得界面
    WoDeViewController *wd = [[WoDeViewController alloc] init];
    UINavigationController *na3 = [[UINavigationController alloc] initWithRootViewController:wd];
    
    na3.navigationBarHidden = YES;
    
    //更多界面
    GengduoViewController *geng = [[GengduoViewController alloc] init];
    UINavigationController *na4 = [[UINavigationController alloc] initWithRootViewController:geng];
   
    na4.navigationBarHidden = YES;
    
    //tabbar
    _tabCtl = [[UITabBarController alloc] init];
    _tabCtl.viewControllers = @[na1,na2,na3,na4];
  
    animaView = [[DGAaimaView alloc]initWithFrame:self.window.bounds];
    [self.window addSubview:animaView];
    [animaView DGAaimaView:animaView BigCloudSpeed:1.5 smallCloudSpeed:1 earthSepped:1.0 huojianSepped:2.0 littleSpeed:2];
    [self performSelector:@selector(creatUI) withObject:nil afterDelay:2.3];
    self.window.rootViewController = _tabCtl;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)creatUI{
    [animaView removeFromSuperview];
    //自定义tabbar应该放到设置根视图后边,否则出现tabbar无法点击的状况
    self.window.rootViewController = _tabCtl;
    [self creatCusTabbar];
}
-(void)creatCusTabbar{
    
    //隐藏系统自带的tabbar
    _tabCtl.tabBar.hidden = YES;
    
    //创建一个背景图
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.window.bounds.size.height-49, self.window.bounds.size.width, 49)];
    _bgView.image = [UIImage imageNamed:@"tabBar.png"];

    //人机交互开关
    _bgView.userInteractionEnabled = YES;
    [self.window addSubview:_bgView];
    NSArray *arr = @[@"团购",@"商家",@"我的",@"更多"];
    for (int i = 0; i<4; i++) {
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(40+83*i, 6, 24, 24);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(40+83*i, 33, 24, 10)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:10];
        lable.tag = 50+i+1;
        lable.text = arr[i];
        [_bgView addSubview:lable];
        
        //设置正常状态下的图片
        [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabb%d_n",i+1]] forState:UIControlStateNormal];
        //设置高亮状态下的图片
        //[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d_s",i+1]] forState:UIControlStateHighlighted];
        //设置选中状态下的图片
        [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabb%d_s",i+1]] forState:UIControlStateSelected];
        b.tag = i+1;
        [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:b];
        if (i==0) {
            
            b.selected = YES;
            
        }
        
    }
    
    //设置默认记录值是1
    _tempNum = 1;
    
   
    
}

-(void)btnAction:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    UILabel *lableTemp = (UILabel *)[_bgView viewWithTag:_tempNum+50];
    lableTemp.textColor = [UIColor blackColor];
    //根据tag值变换控制器
    //复原上一次的btn
    UIButton *b = (UIButton *)[_bgView viewWithTag:_tempNum];
    b.selected = NO;
    
    //改变当前btn的选中状态
    btn.selected = YES;
    
    //再次记录
    _tempNum = btn.tag;
    
    _tabCtl.selectedIndex = btn.tag-1;
    //改变label的值
    UILabel *label = (UILabel *)[_bgView viewWithTag:btn.tag+50];
    label.textColor = [UIColor colorWithRed:47/255.0 green:173/255.0 blue:160/255.0 alpha:1.0];
    
   
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

// 支付成功回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSString * temp = [[NSString stringWithFormat:@"%@",url] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"application is %@",temp);
    /*
     PayDemo://safepay/?{"memo":{"ResultStatus":"9000","memo":"","result":"partner=\"2088511933544308\"&seller_id=\"yingtehua8@sina.com\"&out_trade_no=\"123321\"&subject=\"商品标题\"&body=\"商品描述\"&total_fee=\"0.01\"&notify_url=\"http:\/\/www.baidu.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"cPvT5c10kIRqe97J8CIbzxl5cNZGNCNyPFIeNKOa79OdPUvdov78Sp3x45n0q\/Bi11rbMxEE4MphYNCAMD3ngS\/2ObmmGE1jVQirOdSdwcFUlFFwWo+XPM+5UIiewLKQq3zKqTMVm61KbcdTnw5PtrQ87iYvxzJnUgzU8F0uwts=\""},"requestType":"safepay"}
     */
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             __unused NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }
    
    return YES;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "wzl.MiTuan" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MiTuan" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MiTuan.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
