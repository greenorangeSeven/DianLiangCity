//
//  NickNameViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "NickNameViewController.h"
#import "PersonInfoViewController.h"
#import "PersonInfoViewController.h"

@interface NickNameViewController ()
@end

@implementation NickNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitNickName:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.nickNameTextField.text = self.nickNameStr;
}

- (void)submitNickName:(id)sender
{
    [self.nickNameTextField resignFirstResponder];
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_edit_nickname];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:api_key forKey:@"APPKey"];
    [request setPostValue:self.nickNameTextField.text forKey:@"nickname"];
    [request setPostValue:[NSString stringWithFormat:@"%i",userInfo.id] forKey:@"id"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在修改昵称" andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"昵称修改失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
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
        userInfo.nickname = self.nickNameTextField.text;
        [[UserModel Instance] setUserInfo:userInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"昵称修改失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
@end
