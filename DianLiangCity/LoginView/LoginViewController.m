//
//  LoginViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "NSString+STRegex.h"
@interface LoginViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (IBAction)textFieldDoneEditingAction:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)loginAction:(id)sender
{
    NSString *phoneStr = self.phoneNumberTextField.text;
    NSString *pwdStr = self.passwordTextField.text;
    if (![phoneStr isValidPhoneNum])
    {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    if (pwdStr.length <= 0)
    {
        [self showToast:@"登录密码不能为空"];
        return;
    }
    
    [self doLogin:phoneStr andPassword:pwdStr];
}

- (void)doLogin:(NSString *)user andPassword:(NSString *)pwd
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        [Tool showHUD:@"正在登录" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&pwd=%@&tel=%@", api_base_url, api_login, api_key,pwd,user];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           UserInfo *info = [Tool readJsonStrToUserInfo:operation.responseString];
                                           [self validateLogin:info];
                                       }
                                       @catch (NSException *exception)
                                       {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           [hud hide:YES];
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

//验证登录结果
-(void)validateLogin:(UserInfo *)userInfo
{
    //如果为1则代表登录成功
    if(userInfo.status == 1)
    {
        //保存用户信息
        [[UserModel Instance] saveUserInfo:userInfo];
        
        //如果存在需要验证的社区则去认证社区
        if(self.isValidated)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logined" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else
    {
        [Tool showCustomHUD:@"登录失败,请检查您的手机号码或密码是否正确" andView:self.view andImage:nil andAfterDelay:1.3];
    }

}
@end
