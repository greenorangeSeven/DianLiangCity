//
//  TTBaseTableViewController.h
//  DelightCity
//
//  Created by totem on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BackButton.h"
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")


@interface TTBaseTableViewController : UITableViewController<MBProgressHUDDelegate>

- (void)showLoadingView;        //显示加载视图
- (void)showLoadingViewWithMessage:(NSString *)message; //显示加载视图，带提示消息
- (void)hideLoadingView;        //隐藏加载视图

- (void)showConnectionTimeout;      //显示连接超时提示
- (void)showNetworkNotAvailable;    //显示网络不可用提示

- (void)showToast:(NSString*)message;   //显示提示消息，不影响用户继续操作
- (void)showToast:(NSString*)message duration:(float)seconds;   //显示提示消息，可以设定显示时间

- (IBAction)backAction:(id)sender;  //使用导航返回上一个视图
- (IBAction)dismissAction:(id)sender;  //dismissView
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;


@end
