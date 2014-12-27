//
//  BillsDetialViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-27.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "BillsDetialViewController.h"

@interface BillsDetialViewController ()

@end

@implementation BillsDetialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    [self initBillDetail];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initBillDetail
{
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&mobile=%@&id=%i",api_base_url,api_get_bill_info,api_key,userInfo.tel,self.bill.id];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestOK:)];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [request startAsynchronous];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"列表加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    self.billDetails = [Tool readJsonStrToBillDetail:request.responseString];
    if(self.billDetails)
    {
        self.billName.text = self.billDetails.bill_name;
        self.billPrice.text = [NSString stringWithFormat:@"￥%@",self.billDetails.amount];
        self.billTime.text = [Tool TimestampToDateStr:self.billDetails.addtime andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
        self.billDetail.text = self.billDetails.remark;
    }
    else
    {
        [Tool showCustomHUD:@"没有详情信息" andView:self.view andImage:nil andAfterDelay:1.5];
    }
}

@end
