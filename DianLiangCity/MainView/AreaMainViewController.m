//
//  AreaMainViewController.m
//  DianLiangCity
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "AreaMainViewController.h"
#import "BackButton.h"
#import "Community.h"
#import "YellowPageViewController.h"
#import "WuYeNoticeViewController.h"
#import "UtilityBillsViewController.h"
#import "BBSTableView.h"
#import "RepairListViewController.h"
#import "ProfileCenterViewController.h"
#import "OwnerFieldViewController.h"

@interface AreaMainViewController () <UIAlertViewDelegate>

@end

@implementation AreaMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    if([[UserModel Instance] isLogin])
    {
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(gotoAction:) image:@"personInfo"];
    }
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.navigationItem.title = self.commData.title;
}

-(void)backAction:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

-(void)gotoAction:(UIButton *)sender
{
    ProfileCenterViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileCenterViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 我的账单
- (IBAction)billAction:(UIButton *)sender
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"成为业主，享受更多专属服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我是业主", nil];
        [alert show];
        return;
    }
    //如果是家庭成员则也不能进入
    else if (self.commData.customer_pro == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您无权使用此项服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        UtilityBillsViewController *manager = [[UIStoryboard storyboardWithName:@"UtilityBills" bundle:nil] instantiateViewControllerWithIdentifier:@"UtilityBillsViewController"];
        manager.commData = self.commData;
        [self.navigationController pushViewController:manager animated:YES];
    }
}

#pragma mark 物业报修
- (IBAction)repairAction:(UIButton *)sender
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"成为业主，享受更多专属服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我是业主", nil];
        [alert show];
        return;
    }
    RepairListViewController *manager = [[UIStoryboard storyboardWithName:@"Repair" bundle:nil] instantiateViewControllerWithIdentifier:@"RepairListViewController"];
    manager.commData = self.commData;
    [self.navigationController pushViewController:manager animated:YES];
}

#pragma mark 物业通告
- (IBAction)propertyNoticAction:(UIButton *)sender
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"成为业主，享受更多专属服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我是业主", nil];
        [alert show];
        return;
    }
    WuYeNoticeViewController *manager = [[UIStoryboard storyboardWithName:@"Notice" bundle:nil] instantiateViewControllerWithIdentifier:@"WuYeNoticeViewController"];
    manager.title = @"物业通告";
    manager.type_id = 1;
    manager.commData = self.commData;
    [self.navigationController pushViewController:manager animated:YES];
}

#pragma mark 业主园地
- (IBAction)scopeAction:(UIButton *)sender
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"成为业主，享受更多专属服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我是业主", nil];
        [alert show];
        return;
    }
    else
    {
        OwnerFieldViewController *manager = [[UIStoryboard storyboardWithName:@"OwnerField" bundle:nil] instantiateViewControllerWithIdentifier:@"OwnerFieldViewController"];
        manager.title = @"业主园地";
        manager.commData = self.commData;
        [self.navigationController pushViewController:manager animated:YES];
    }
}

#pragma mark 社区共建
- (IBAction)buildAction:(UIButton *)sender
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"成为业主，享受更多专属服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我是业主", nil];
        [alert show];
        return;
    }
    else
    {
        BBSTableView *bbsTableView = [[BBSTableView alloc] init];
        bbsTableView.commData = self.commData;
        bbsTableView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bbsTableView animated:YES];
    }
}

#pragma mark 政务通告
- (IBAction)governmentAction:(UIButton *)sender
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"成为业主，享受更多专属服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我是业主", nil];
        [alert show];
        return;
    }
    WuYeNoticeViewController *manager = [[UIStoryboard storyboardWithName:@"Notice" bundle:nil] instantiateViewControllerWithIdentifier:@"WuYeNoticeViewController"];
    manager.title = @"政务通告";
    manager.type_id = 2;
    manager.commData = self.commData;
    [self.navigationController pushViewController:manager animated:YES];
}

#pragma mark 社区黄页
- (IBAction)yellowAction:(UIButton *)sender
{
    YellowPageViewController *yellowPageViewController = [[UIStoryboard storyboardWithName:@"YelloPage" bundle:nil] instantiateViewControllerWithIdentifier:@"YellowPageViewController"];
    yellowPageViewController.commData = self.commData;
    [self.navigationController pushViewController:yellowPageViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


@end
