//
//  BindSetPasswordViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "BindSetPasswordViewController.h"
#import "MyAccountViewController.h"

@interface BindSetPasswordViewController ()

@end

@implementation BindSetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

-(void)submitAction:(id)sender
{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 5] animated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
