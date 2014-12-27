//
//  TTBaseTableViewController.m
//  DelightCity
//
//  Created by totem on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "micro.h"

#define TIME 1.0

@interface TTBaseTableViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation TTBaseTableViewController


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dismissAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)showLoadingView
{
    [self showLoadingViewWithMessage:nil];
}

- (void)showLoadingViewWithMessage:(NSString *)message
{
    [self hideLoadingView];
    
    HUD = [[MBProgressHUD alloc] initWithView:SharedAppDelegate.window];
	[SharedAppDelegate.window addSubview:HUD];
	
    HUD.dimBackground = YES;
    HUD.labelText = message;
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)hideLoadingView
{
    if (HUD)
    {
        [HUD hide:YES];
        HUD = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"]
                                                 forBarPosition:UIBarPositionTopAttached
                                                     barMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)showConnectionTimeout
{
    
}


- (void)showNetworkNotAvailable
{
    [self showToast:NSLocalizedString(@"网络连接失败，请检查网络稍后重试", nil) duration:3.0];
}

- (void)showToast:(NSString*)message
{
    [self showToast:message duration:TIME];
}

- (void)showToast:(NSString*)message duration:(float)seconds
{
    [SharedAppDelegate.window makeToast:message duration:seconds position:@"center"];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
	for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
        {
            UITextField *textField = (UITextField*)view;
            [textField resignFirstResponder];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
