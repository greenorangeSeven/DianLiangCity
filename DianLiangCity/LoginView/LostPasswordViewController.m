//
//  LostPasswordViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "LostPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "NSString+STRegex.h"

@interface LostPasswordViewController ()
{
    NSTimer *timer;
    int countDownTime;
    MBProgressHUD *hud;
    NSString *invate_code;
}
@end

@implementation LostPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)getActivationCode:(id)sender
{
    NSString *phoneStr = self.phoneNumberTextField.text;
    if (![phoneStr isValidPhoneNum])
    {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self sendSms:phoneStr];
}

- (void)sendSms:(NSString *)phone
{
    invate_code = [NSString stringWithFormat:@"%i",[Tool getRandomNumber:100000 to:999999]];
    NSString *msg_content = [NSString stringWithFormat:@"您好,您的验证码为:%@。回复TD退订【点亮城市】",invate_code];
    NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_sendSms];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:api_key forKey:@"APPKey"];
    [request setPostValue:phone forKey:@"mobile"];
    [request setPostValue:msg_content forKey:@"msg_content"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在发送验证码" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"验证码发送失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    //判断返回结果
    if(![request.responseString isEqualToString:@"0#1"])
    {
        [self showToast:@"验证码发送失败,请重试"];
    }
    else
    {
        //[self performSegueWithIdentifier:@"SetInfoView" sender:self];
        [self startValidateCodeCountDown];
    }
}

- (IBAction)verifyAction:(id)sender
{
    NSString *inputCodeStr = self.codeTextField.text;
    if(inputCodeStr.length == 0)
    {
        [self showToast:@"请输入验证码"];
        return;
    }
    
    if([invate_code isEqualToString:inputCodeStr])
    {
        [self performSegueWithIdentifier:@"ResetPassword" sender:self];
    }
    else
    {
        [self showToast:@"验证失败,请检查验证码"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ResetPassword"])
    {
        NSString *phoneStr = self.phoneNumberTextField.text;
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:phoneStr forKey:@"tel"];
    }
}

- (void)startValidateCodeCountDown
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    countDownTime = 60;
}

- (void)timerFunc
{
    if (countDownTime > 0) {
        self.obtainCodeBtn.enabled = NO;
        [self.obtainCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%d)" ,countDownTime] forState:UIControlStateDisabled];
        [self.obtainCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    else
    {
        self.obtainCodeBtn.enabled = YES;
        [self.obtainCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.obtainCodeBtn setTitleColor:[UIColor colorWithRed:251/255.0 green:67/255.0 blue:79/255.0 alpha:1.0] forState:UIControlStateNormal];
        [timer invalidate];
    }
    --countDownTime;
}

@end
