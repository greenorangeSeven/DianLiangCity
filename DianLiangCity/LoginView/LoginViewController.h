//
//  LoginViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface LoginViewController : TTBaseViewController

//如果存在则代表当前正在认证的社区
@property bool isValidated;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) id delegate;
- (IBAction)textFieldDoneEditingAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
