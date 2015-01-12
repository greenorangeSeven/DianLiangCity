//
//  ResetPasswordViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "MainViewController.h"
@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(goMainView:) title:@"提交"];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(void)goMainView:(id)sender
{
    if (self.passwordTextField.text.length <= 0)
    {
        [self showToast:@"请输入密码"];
        return;
    }
    if (![self.passwordTextField.text isEqualToString: self.againPasswordTextField.text])
    {
        [self showToast:@"两次密码不一致，请重新输入"];
        return;
    }
    
    if([[UserModel Instance] isNetworkRunning])
    {
        NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_resetPwd];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setPostValue:api_key forKey:@"APPKey"];
        
        [request setPostValue:self.tel forKey:@"tel"];
        [request setPostValue:self.passwordTextField.text forKey:@"newpwd"];
        
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestSubmit:)];
        [request startAsynchronous];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"正在修改" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"修改失败" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"已修改" andView:self.view andImage:nil andAfterDelay:1.2];
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [controllers removeLastObject];
        [controllers removeLastObject];
        [self.navigationController setViewControllers:controllers animated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"修改失败" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

@end
