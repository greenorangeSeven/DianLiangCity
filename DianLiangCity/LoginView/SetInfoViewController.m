//
//  SetInfoViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "SetInfoViewController.h"
#import "MainViewController.h"
@interface SetInfoViewController ()

@end

@implementation SetInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(doRegister:) title:@"提交"];
}

-(void)doRegister:(id)sender
{
    NSString *nickNameStr = self.nickNameTextField.text;
    NSString *passwordStr = self.passwordTextField.text;
    NSString *againPasswordStr = self.againPasswordTextField.text;
    
    if (nickNameStr.length <= 0)
    {
        [self showToast:@"请输入昵称"];
        return;
    }
    if (passwordStr.length <= 0)
    {
        [self showToast:@"请输入密码"];
        return;
    }
    if (againPasswordStr.length <= 0)
    {
        [self showToast:@"请输入密码确认"];
        return;
    }
    if (![passwordStr isEqualToString: againPasswordStr])
    {
        [self showToast:@"两次密码不一致，请重新输入"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_register];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:api_key forKey:@"APPKey"];
    [request setPostValue:self.phoneStr forKey:@"tel"];
    [request setPostValue:passwordStr forKey:@"pwd"];
    [request setPostValue:nickNameStr forKey:@"nickname"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在注册" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"注册失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
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
        [Tool showCustomHUD:@"注册成功" andView:self.view andImage:nil andAfterDelay:1.2];
        
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [controllers removeLastObject];
        [controllers removeLastObject];
        [self.navigationController setViewControllers:controllers animated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"注册失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
