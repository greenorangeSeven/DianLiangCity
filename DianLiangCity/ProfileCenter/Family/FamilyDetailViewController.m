//
//  FamilyDetailViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "FamilyDetailViewController.h"

@interface FamilyDetailViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation FamilyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    [self initFamilyDetail];
}

- (void)initFamilyDetail
{
    UserModel *userModel = [UserModel Instance];
    if (userModel.isNetworkRunning && userModel.isLogin)
    {
        NSString *url;
        
        url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%i&id=%i",api_base_url,api_my_familys_info,api_key,[userModel getUserInfo].id,self.family.id];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    self.family = [Tool readJsonStrToFamilyDetail:request.responseString];
    if(self.family)
    {
        self.nameTextField.text = self.family.member_name;
        self.telTextField.text = self.family.member_tel;
        self.invate_codeTextField.text = self.family.invite_code;
        
        if(self.family.customer_id.length > 0 && ![self.family.customer_id isEqualToString:@"0"])
        {
            self.activeTextField.text = @"已激活";
            self.sendActiveBtn.hidden = YES;
        }
        else
        {
            self.activeTextField.text = @"暂未激活";
        }
        
        self.relationTextField.text = self.family.relations;
        self.commTextField.text = self.family.comm_name;
    }
    else
    {
        [Tool showCustomHUD:@"加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
    }
}

- (IBAction)sendActiveCode:(UIButton *)sender
{
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning && userInfo)
    {
        [Tool showHUD:@"正在发送" andView:self.view andHUD:hud];
        NSString *msg_content = [NSString stringWithFormat:@"您好,您正在被邀请成为智慧社区的用户,验证码为:%@。回复TD退订【点亮城市】",self.family.invite_code];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?mobile=%@&msg_content=%@", api_base_url, api_sendSms,self.family.member_tel,msg_content];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try
                                       {
                                           hud.hidden = YES;
                                           //判断返回结果
                                           if([operation.responseString isEqualToString:@"0#1"])
                                           {
                                                [self showToast:@"发送失败"];
                                           }
                                           else
                                           {
                                               [self showToast:@"已发送"];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           hud.hidden = YES;
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}
@end
