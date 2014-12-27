//
//  SetInfoViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface SetInfoViewController : TTBaseViewController

@property (nonatomic, copy) NSString *phoneStr;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;

- (IBAction)textFieldDoneEditing:(id)sender;

@end
