//
//  ResetPasswordViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface ResetPasswordViewController : TTBaseViewController

@property (copy, nonatomic) NSString *tel;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;

- (IBAction)textFieldDoneEditing:(id)sender;

@end
