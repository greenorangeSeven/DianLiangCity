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
    MainViewController *mainView = [self.navigationController.viewControllers objectAtIndex:0];
   // mainView.rightNavagationItem = @"YES";
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
