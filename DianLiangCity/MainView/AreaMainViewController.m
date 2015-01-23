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
#import "JSBadgeView.h"
@interface AreaMainViewController () <UIAlertViewDelegate>
{
    //未读账单和通知个数
    int billNoneSize;
    int noticNoneSize;
    MBProgressHUD *hud;
    JSBadgeView *billBadgeView;
    JSBadgeView *noticBadgeView;
}
@end

@implementation AreaMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    if([[UserModel Instance] isLogin])
    {
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(gotoAction:) image:@"personInfo"];
    }
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.navigationItem.title = self.commData.title;
    [self updateNoneSize];
}

- (void) updateNoneSize
{
    [self updateMyBills];
}

- (void)updateMyBills
{
    if(self.commData.customer_pro == 1)
    {
        UserModel *userMode = [UserModel Instance];
        UserInfo *userInfo = [userMode getUserInfo];
        if(userMode.isNetworkRunning)
        {
            NSString *url;
            
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&mobile=%@",api_base_url,api_get_my_bills,api_key,userInfo.tel];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            request.delegate = self;
            [request setDidFailSelector:@selector(requestFailed:)];
            [request setDidFinishSelector:@selector(requestMyBillOK:)];
            [request startAsynchronous];
            [Tool showHUD:@"请稍后" andView:self.view andHUD:hud];
        }
    }
    else
    {
        [self updateNoticNone];
    }
}

- (void)requestBillFailed:(ASIHTTPRequest *)request
{
    [self updateNoticNone];
}

- (void)requestMyBillOK:(ASIHTTPRequest *)request
{
    
    [request setUseCookiePersistence:YES];
    MyBill *myBill = [Tool readJsonStrToMyBill:request.responseString];
    EGOCache *cache = [EGOCache globalCache];
    //获取上次记录的最新一条记录的id
    NSString *bill_old_id = [cache stringForKey:@"billOldId"];
    if(myBill && myBill.nopay.count > 0)
    {
        if(bill_old_id)
        {
            for(Bill *bill in myBill.nopay)
            {
                if(![bill_old_id isEqualToString:bill.id])
                {
                    ++billNoneSize;
                }
                else
                {
                    Bill *bills = myBill.nopay[0];
                    [cache setString:bills.id forKey:@"billOldId"];
                    break;
                }
            }
        }
        else
        {
            Bill *bill = myBill.nopay[0];
            [cache setString:bill.id forKey:@"billOldId"];
            billNoneSize = myBill.nopay.count;
        }
    }
    
    if(billNoneSize > 0)
    {
        billBadgeView = [[JSBadgeView alloc] initWithParentView:self.billView alignment:JSBadgeViewAlignmentTopRight];
        billBadgeView.badgeText = [NSString stringWithFormat:@"%d", billNoneSize];
    }
    
    [self updateNoticNone];
}

- (void)updateNoticNone
{
    //如果是游客则不能进入
    if(self.commData.customer_pro == 3)
        return;
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        
        NSString *url;
        //如果为1则是物业通告
        url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&p=1",api_base_url,api_get_notice_list,api_key,self.commData.id];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestUpdateNoticOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
    }
}

- (void)requestNoticFailed:(ASIHTTPRequest *)request
{
    if(hud)
    {
        [hud hide:YES];
    }
}

- (void)requestUpdateNoticOK:(ASIHTTPRequest *)request
{
    if (hud)
    {
        [hud hide:YES];
    }
    NSMutableArray *newNews = [Tool readJsonStrToCommNotics:request.responseString];
    
    EGOCache *cache = [EGOCache globalCache];
    //获取上次记录的最新一条记录的id
    NSString *notic_old_id = [cache stringForKey:@"notic_old_id"];
    if(newNews && newNews.count > 0)
    {
        if(notic_old_id)
        {
            for(CommNotic *notic in newNews)
            {
                if(![notic_old_id isEqualToString:notic.id])
                {
                    ++noticNoneSize;
                }
                else
                {
                    CommNotic *notics = newNews[0];
                    [cache setString:notics.id forKey:@"notic_old_id"];
                    break;
                }
            }
        }
        else
        {
            CommNotic *notic = newNews[0];
            [cache setString:notic.id forKey:@"notic_old_id"];
            noticNoneSize = newNews.count;
        }
    }
    
    if(noticNoneSize > 0)
    {
        noticBadgeView = [[JSBadgeView alloc] initWithParentView:self.noticView alignment:JSBadgeViewAlignmentTopRight];
        noticBadgeView.badgeText = [NSString stringWithFormat:@"%d", noticNoneSize];
    }
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
        if(billBadgeView)
            [billBadgeView removeFromSuperview];
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
    if(noticBadgeView)
        [noticBadgeView removeFromSuperview];
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
