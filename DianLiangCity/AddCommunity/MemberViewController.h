//
//  MemberViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface MemberViewController : UIViewController

@property (strong, nonatomic) Community *selectComm;
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

- (IBAction)textFieldDoneEditing:(id)sender;

@end
