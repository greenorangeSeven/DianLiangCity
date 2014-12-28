//
//  MemberViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MemberViewController.h"
#import "NSString+STRegex.h"
#import "LoginViewController.h"

@interface MemberViewController ()


@property (weak, nonatomic) id delegate;

@end

@implementation MemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(verifyAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.communityNameLabel.text = self.selectComm.title;
}

- (void)backAction
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)verifyAction:(id)sender
{
    [self.view resignFirstResponder];
    UserModel *userModel = [UserModel Instance];
    if(!userModel.isLogin)
    {
        [Tool showCustomHUD:@"请先登录" andView:self.view andImage:nil andAfterDelay:1.2];
        LoginViewController *manager = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        manager.isValidated = true;
        [self.navigationController pushViewController:manager animated:YES];
        return;
    }
    NSString *nameStr = self.nameTextField.text;
    NSString *telStr = self.telTextField.text;
    NSString *codeStr = self.codeTextField.text;
    if(nameStr.length <= 0)
    {
        [Tool showCustomHUD:@"请输入姓名" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(![telStr isValidPhoneNum])
    {
        [Tool showCustomHUD:@"请输入正确的手机号码" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(codeStr.length <= 0)
    {
        [Tool showCustomHUD:@"请输入邀请码" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    
    if(userModel.isNetworkRunning)
    {
        NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_valid];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
        
        [request setUseCookiePersistence:NO];
        [request setPostValue:api_key forKey:@"APPKey"];
        //2代表成员认证
        [request setPostValue:@"2" forKey:@"pro"];
        [request setPostValue:[NSString stringWithFormat:@"%i",self.selectComm.id] forKey:@"cid"];
        [request setPostValue:nameStr forKey:@"name"];
        [request setPostValue:telStr forKey:@"tel"];
        [request setPostValue:codeStr forKey:@"invite_code"];
        [request setPostValue:[NSString stringWithFormat:@"%i",[userModel getUserInfo].id] forKey:@"userid"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在提交认证数据" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    UserInfo *info = [[UserModel Instance] getUserInfo];
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSLog(@"the status:%@",request.responseString);
    if([request.responseString isEqualToString:@"success"])
    {
        self.selectComm.customer_pro = 2;
        self.selectComm.areaList = nil;
        EGOCache *cache = [EGOCache globalCache];
        NSString *name = [NSString stringWithFormat:@"mycommunity%i",info.id];
        NSMutableArray *commDatas = (NSMutableArray *)[cache objectForKey:name];
        if(!commDatas && commDatas.count <= 0)
        {
            commDatas = [[NSMutableArray alloc] init];
        }
        for(Community *comm in commDatas)
        {
            if(comm.id == self.selectComm.id && comm.customer_pro==2)
            {
                [Tool showCustomHUD:@"您已经添加了该社区,不能重复添加" andView:self.view andImage:nil andAfterDelay:1.5];
                return;
            }
        }
        [commDatas addObject:self.selectComm];
        [cache setObjectForSync:commDatas forKey:name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyComm" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"认证失败,您可能重复认证了." andView:self.view andImage:nil andAfterDelay:1.5];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
@end
