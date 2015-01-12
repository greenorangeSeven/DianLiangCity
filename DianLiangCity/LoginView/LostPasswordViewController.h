//
//  LostPasswordViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface LostPasswordViewController : TTBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *obtainCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;


- (IBAction)textFieldDoneEditing:(id)sender;

- (IBAction)getActivationCode:(id)sender;
- (IBAction)verifyAction:(id)sender;
@end
