//
//  TTNotificationService.h
//  TTCommon
//
//  Created by Ma Jianglin on 3/20/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTNotificationService : NSObject

@property(nonatomic, strong) NSString *deviceToken;

+(TTNotificationService *)sharedService;

//注册消息推送，在application:didFinishLaunchingWithOptions:中调用
- (void)registerForRemoteNotification;

//注册成功，在application:didRegisterForRemoteNotificationsWithDeviceToken:中调用
- (void)successRegisterWithDeviceToken:(NSData*)deviceToken;

//注册失败，在application:didFailToRegisterForRemoteNotificationsWithError:中调用
- (void)failedRegisterWithError:(NSError*)error;

//发送设备令牌到服务器上
// 如果设备令牌需要与用户绑定，用户登录和注销时需要以下操作
// 1. 用户登录后，加上userId发送到服务器上
// 2. 用户注销后，清空deviceToken发送到服务器上，要将这个设备和这个用户绑定关系去掉
- (void)postDeviceToken;

@end
