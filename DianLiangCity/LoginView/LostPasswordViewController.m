//
//  LostPasswordViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "LostPasswordViewController.h"
#import "ResetPasswordViewController.h"

@interface LostPasswordViewController ()

@end

@implementation LostPasswordViewController

bool flag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)getActivationCode:(id)sender
{
    if (self.phoneNumberTextField.text.length != 11) {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"短信已经发出，请注意查收！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    flag = YES;
}

- (IBAction)verifyAction:(id)sender
{
    if (!flag)
    {
        [self showToast:@"请先获取激活码"];
        return;
    }
    if (self.codeTextField.text.length <= 0) {
        [self showToast:@"请输入正确的激活码"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"验证通过！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        ResetPasswordViewController *manager = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
        
        [self.navigationController pushViewController:manager animated:YES];
    }
}

@end
