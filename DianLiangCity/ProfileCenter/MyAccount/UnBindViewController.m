//
//  UnBindViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "UnBindViewController.h"

@interface UnBindViewController ()

@end

@implementation UnBindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

-(void)submitAction:(id)sender
{
    if (self.passwordTextField.text.length <= 0)
    {
        [self showToast:@"请输入密码"];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyBankCardsViewControllerChangeStatus" object:nil];
    [self showToast:@"解除绑定成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
