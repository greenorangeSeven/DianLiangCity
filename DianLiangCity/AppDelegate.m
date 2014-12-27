//
//  AppDelegate.m
//  DianLiangCity
//
//  Created by Seven on 14-9-29.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckNetwork.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //将状态栏文字设为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    //检查网络是否存在 如果不存在 则弹出提示
    [UserModel Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
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
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
