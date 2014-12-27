//
//  BindThirdViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "BindThirdViewController.h"
#import "BindSetPasswordViewController.h"

@interface BindThirdViewController ()

@end

@implementation BindThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(nextAction:) title:@"完成"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

-(void)nextAction:(id)sender
{
    BindSetPasswordViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"BindSetPasswordViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
