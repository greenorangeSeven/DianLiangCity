//
//  ChangePasswordViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface ChangePasswordViewController : TTBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;

@end
