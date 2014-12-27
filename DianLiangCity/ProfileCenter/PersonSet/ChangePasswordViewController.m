//
//  ChangePasswordViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitPWD:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    if ([self.title isEqualToString:@"修改密码"])
    {
        [self.oldPasswordTextField setPlaceholder:@"请输入密码"];
        [self.passwordTextField setPlaceholder:@"请输入新的登录密码"];
        [self.againPasswordTextField setPlaceholder:@"请再次输入新的登录密码"];
    }
}

- (void)submitPWD:(id)sender
{
    
    [self.view resignFirstResponder];
    
    NSString *oldpwdStr = self.oldPasswordTextField.text;
    NSString *pwdStr = self.passwordTextField.text;
    NSString *againpwdStr = self.againPasswordTextField.text;
    
    if(oldpwdStr.length == 0)
    {
        [Tool showCustomHUD:@"请输入旧密码" andView:self.view andImage:nil andAfterDelay:1.2];
        return;
    }
    if(pwdStr.length == 0)
    {
        [Tool showCustomHUD:@"请输入密码" andView:self.view andImage:nil andAfterDelay:1.2];
        return;
    }
    if(againpwdStr.length == 0)
    {
        [Tool showCustomHUD:@"请再次输入密码" andView:self.view andImage:nil andAfterDelay:1.2];
        return;
    }
    if(![pwdStr isEqualToString:againpwdStr])
    {
        [Tool showCustomHUD:@"两次密码不一致" andView:self.view andImage:nil andAfterDelay:1.2];
        return;
    }
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    if(![userInfo.pwd isEqualToString:oldpwdStr])
    {
        [Tool showCustomHUD:@"旧密码不正确,无法修改密码" andView:self.view andImage:nil andAfterDelay:1.2];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_changePwd];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:api_key forKey:@"APPKey"];
    [request setPostValue:self.oldPasswordTextField.text forKey:@"oldpwd"];
    [request setPostValue:self.passwordTextField.text forKey:@"newpwd"];
    [request setPostValue:userInfo.tel forKey:@"tel"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在修改密码" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"密码修改失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSLog(@"the status:%@",request.responseString);
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"修改成功" andView:self.view andImage:nil andAfterDelay:1.2];
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        [[UserModel Instance] setUserInfo:userInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"密码修改失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
