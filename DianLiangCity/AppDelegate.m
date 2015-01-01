//
//  AppDelegate.m
//  DianLiangCity
//
//  Created by Seven on 14-9-29.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckNetwork.h"
#import "WuYeNoticeXibView.h"
#import "BillsDetialViewController.h"
#import "SysInfoDetailView.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

#import "XGPush.h"
#import "XGSetting.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //将状态栏文字设为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    //检查网络是否存在 如果不存在 则弹出提示
    [UserModel Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    
    self.pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    UINavigationBar.appearance.barTintColor = UIColorRGB(226, 100, 0);
    self.isFirst = NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.isFirst = [prefs boolForKey:@"kAppLaunched"];
    
    if (self.isFirst)
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"StartView" bundle:nil];
        self.window.rootViewController = [storyBoard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
        [prefs setBool:NO forKey:@"kAppLaunched"];
    } else
    {
    }
    
    
    //集成信鸽start
    [XGPush startApp:2200074993 appKey:@"I9DJ38Q2RP9Y"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush setAccount:@"testAccount1"];
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    [XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
        [self pushNotificationHandle];
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    //信鸽END
    
    return YES;
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

//信鸽
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    
    if (userInfo.tel != nil && [userInfo.tel length] > 0) {
        [XGPush setAccount:userInfo.tel];
    }
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    //    [XGPush setTag:@"0"];
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

//点击通知出发事件
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    self.pushInfo = userInfo;
    
    //回调版本示例
    /**/
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
        if (_isForeground == YES) {
            [self pushNotificationHandle];
        }
        else
        {
            NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:alertStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
            notificationAlert.tag = 1;
            [notificationAlert show];
        }
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            [self pushNotificationHandle];
        }
    }
}

//推送通知处理
- (void)pushNotificationHandle
{
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSString *type = [self.pushInfo  objectForKey:@"type"];
    if ([type isEqualToString:@"01"] == YES) {
        WuYeNoticeXibView* noticeDetailView = [[WuYeNoticeXibView alloc] initWithNibName:@"WuYeNoticeXibView" bundle:nil];
        noticeDetailView.noticId = [self.pushInfo objectForKey:@"id"];
        UINavigationController *detailViewNav = [[UINavigationController alloc] initWithRootViewController:noticeDetailView];
        [self.window.rootViewController presentViewController:detailViewNav animated:YES completion:^{
                        _isForeground = NO;
                    }];
    }
    else if ([type isEqualToString:@"02"] == YES)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UtilityBills" bundle:nil];
        BillsDetialViewController* billDetailView = [storyBoard instantiateViewControllerWithIdentifier:@"BillsDetialViewController"];
        billDetailView.billId = [self.pushInfo objectForKey:@"id"];
        billDetailView.present = @"present";
        UINavigationController *detailViewNav = [[UINavigationController alloc] initWithRootViewController:billDetailView];
        [self.window.rootViewController presentViewController:detailViewNav animated:YES completion:^{
            _isForeground = NO;
        }];
    }
    else if ([type isEqualToString:@"03"] == YES)
    {
        SysInfoDetailView *sysinfoDetail = [[SysInfoDetailView alloc] initWithNibName:@"SysInfoDetailView" bundle:nil];
        sysinfoDetail.infoId = [self.pushInfo objectForKey:@"id"];
        UINavigationController *suitDetailNav = [[UINavigationController alloc] initWithRootViewController:sysinfoDetail];
        [self.window.rootViewController presentViewController:suitDetailNav animated:YES completion:^{
            _isForeground = NO;
        }];
    }
}

//信鸽


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _isForeground = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
