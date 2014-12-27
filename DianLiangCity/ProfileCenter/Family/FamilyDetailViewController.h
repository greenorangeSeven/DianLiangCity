//
//  FamilyDetailViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface FamilyDetailViewController : TTBaseViewController<UIAlertViewDelegate>
@property (nonatomic, strong) Family *family;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *invate_codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UITextField *relationTextField;
@property (weak, nonatomic) IBOutlet UITextField *commTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendActiveBtn;

- (IBAction)sendActiveCode:(UIButton *)sender;

@end
